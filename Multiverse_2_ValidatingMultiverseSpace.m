%% EEG multiverse space: Validating the space

% This script validates the multiverse space by modelling responses for
% different individuals by testing how well the space predicts observed data. First, for
% values across tasks, and second, for out-of-task predictions.
% For the GPR modelling, we will use length scale = 1, and Optimisation =
% 'KernelScale'. 
% These analyses are first applied to the 2D space (dimensions 1 and 2), 
% and then the 3D space (dimensions 1, 2, and 3)

% created by dr. Rianne Haartsen, Birkbeck College, 04-2024
% updated with corrected metrics: 03-2025


% Input data: 
% DATA_EEG structure with the following fields:
%   - EEG_DATA.Subj_ID: subject identification numbers in cells (size 1-by-N)
%   - EEG_DATA.EEG_names: names of the EEG metrics (size E-by-1)
%   - EEG_DATA.data_EEGxSubj: values of the EEG metrics where each row is a
%   different metric and each column a different subject (size E-by-N)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For 2D space %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data and prepare for analyses
% add folders and paths
clear 
addpath('xxx/01_CreatingSpace')
cd xxx/01_CreatingSpace

% load EEG data metrics
    load Data_space_250227.mat
% select the other half of the sample (not used to create the space)
    rng(2201)
    RandIndices = randperm(size(DATA_EEG.Subj_ID,2), round(size(DATA_EEG.Subj_ID,2)/2));
    Ind_cur = ones(size(DATA_EEG.Subj_ID,2),1);
    Ind_cur(RandIndices,1) = 0;
    Ind_cur = find(Ind_cur == 1);
    
    Data_indivspace.data = DATA_EEG.data_EEGxSubj(:,Ind_cur);
    Data_indivspace.Subj_IDs = DATA_EEG.Subj_ID(1,Ind_cur);
    Data_indivspace.EEG_names = DATA_EEG.EEG_names;
    clear DATA_EEG RandIndices Ind_cur
    
    save('Disc_indivspace_250227.mat','Data_indivspace')

% normalise the EEG data in the sample relative to the m and sd from the
% group space
    load Disc_groupspace_250227.mat
% load the data of the individuals to validate the space with
    load Disc_indivspace_250227.mat
    DataNormB = normalize(Data_indivspace.data', "center", Data_groupspace.Normpara_C, "scale", Data_groupspace.Normpara_S);
    Data_indivspace.data_normalised = DataNormB';
    save('Disc_indivspace_250227.mat','Data_indivspace')
% get the space coordinates for the 1st and 2nd dimension
    X_spacepoints = Y_sp(:, [1 2]); 
% clear up
    clear C S Data_groupspace DataNormA DataNormB Dsq_sp eigvals_sp Y_sp
% change current folder
    cd xxx/02_ValidatingSpace
% take out the N=10 used for length scale optimisation
    rng(2302)
    RandIndices = randperm(size(Data_indivspace.Subj_IDs,2), 10);
    SelectInd = true(size(Data_indivspace.Subj_IDs,2),1);
    SelectInd(RandIndices,1) = false;
    
    EEGmetrics_SubjoI = Data_indivspace.data_normalised(:,SelectInd);
    clear SelectInd RandIndices

%% 2D A) Correlations for 50 values across tasks in rest of validation sample 

cd xxx/02_ValidatingSpace

% get rid of subjects with NaN in their data
GOODsubj = find(any(isnan(EEGmetrics_SubjoI),1)==0);
EEGmetrics_SubjoI_all = EEGmetrics_SubjoI;
EEGmetrics_SubjoI = EEGmetrics_SubjoI(:,GOODsubj);

Ntot = size(EEGmetrics_SubjoI,1);
Ntest = 50;
Ntrain = 200;
% for later analyses
Corrs_fit = zeros(4, size(EEGmetrics_SubjoI,2));
Obs_EEGvals = zeros(Ntest, size(EEGmetrics_SubjoI,2));
Pred_EEGvals = zeros(Ntest, size(EEGmetrics_SubjoI,2));
GPR_models = {};

% get indices for test and training data
rng(2302)
Rand_ind = randperm(size(EEGmetrics_SubjoI,1), Ntot);

for ss = 1:size(EEGmetrics_SubjoI,2)

    disp(strcat('Subject: ', num2str(ss), '/', num2str(size(EEGmetrics_SubjoI,2))))

    % select test and train data
    Y_dataIndiv_test = EEGmetrics_SubjoI(Rand_ind(1,1:Ntest),ss);
    X_space_test = X_spacepoints(Rand_ind(1,1:Ntest),:);
    Y_dataIndiv_train = EEGmetrics_SubjoI(Rand_ind(1,(Ntest+1):(Ntrain+Ntest)),ss);
    X_space_train = X_spacepoints(Rand_ind(1,(Ntest+1):(Ntrain+Ntest)),:);

    
    % Training model
        SigmaFixed = std(Y_dataIndiv_train);
        c = cvpartition(size(Y_dataIndiv_train,1), "KFold", 10); % cross-validation parameters 
    % fit GPR model to estimate parameters
            gprMdl = fitrgp(X_space_train,Y_dataIndiv_train,...
            'BasisFunction', 'none', ...
            'KernelFunction', 'squaredexponential', ...
            'KernelParameters', [1 SigmaFixed], ...
            'Sigma', SigmaFixed, ...
            'Standardize', false, ...
            'OptimizeHyperparameters', 'KernelScale', ...
            'HyperparameterOptimizationOptions',struct('CVPartition',c,...
            'ShowPlots', false, ...
            'Verbose', 0));

    % calculate predicted values for test dataset
        [predictions_test] = predict(gprMdl, X_space_test); % Evaluate the predictions for test data
    % get correlation for predicted and observed test data
        [Rho, pval, rlb, rup] = corrcoef(predictions_test, Y_dataIndiv_test); % test how well predicted model fits

    % save the resulting output
        Corrs_fit(:,ss) = [Rho(1,2); pval(1,2); rlb(1,2); rup(1,2)];
        Obs_EEGvals(:,ss) = Y_dataIndiv_test;
        Pred_EEGvals(:,ss) = predictions_test;
        GPR_models{1,ss} = gprMdl;

    % clean up variables
        clear SigmaFixed c gprMdl predictions_test Rho pval rlb rup 
        clear Y_dataIndiv_test X_space_test Y_dataIndiv_train X_space_train 

    % interim saving
        save('Disc_Modeltesting_acrosstasks_Ntest50.mat','Corrs_fit','Obs_EEGvals','Pred_EEGvals','GPR_models')
    
end % end loop subjects


clear Corrs_fit GPR_models Ntest Ntot Ntrain Obs_EEGvals Pred_EEGvals Rand_ind ss


%% B) 2D Correlations for out-of-task values in rest of validation sample 

% get indices for EEG tasks
EEGmet_inds = zeros(length(Data_indivspace.EEG_names),1);
for ii = 1:length(Data_indivspace.EEG_names)
    if contains(Data_indivspace.EEG_names{ii},'Fu') || contains(Data_indivspace.EEG_names{ii},'Fi')
        EEGmet_inds(ii) = 1;
    elseif contains(Data_indivspace.EEG_names{ii},'SNa') || contains(Data_indivspace.EEG_names{ii},'SNs') || ...
            contains(Data_indivspace.EEG_names{ii},'SNt') || contains(Data_indivspace.EEG_names{ii},'SNd')
        EEGmet_inds(ii) = 2;
    end
end
EEGmet_inds_FaceERP = find(EEGmet_inds == 1);
EEGmet_inds_SNSvids = find(EEGmet_inds == 2);

% split data into tasks
% x and y for FaceERP
Y_dataIndiv_FaceERP = EEGmetrics_SubjoI(EEGmet_inds_FaceERP,:);
X_spacepoints_FaceERP = X_spacepoints(EEGmet_inds_FaceERP,:);
% x and y for SNS videos
Y_dataIndiv_SNSvids = EEGmetrics_SubjoI(EEGmet_inds_SNSvids,:);
X_spacepoints_SNSvids = X_spacepoints(EEGmet_inds_SNSvids,:);


% B1) Prediction SNSvids from FaceERP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for later analyses
Corrs_fit = zeros(4, size(EEGmetrics_SubjoI,2));
Obs_EEGvals_SNSvids = zeros(size(Y_dataIndiv_SNSvids,1), size(EEGmetrics_SubjoI,2));
Pred_EEGvals_SNSvids = zeros(size(Y_dataIndiv_SNSvids,1), size(EEGmetrics_SubjoI,2));
GPR_models = cell(1,size(EEGmetrics_SubjoI,2));

for ss = 1:size(EEGmetrics_SubjoI,2)

    disp(strcat('Subject: ', num2str(ss), '/', num2str(size(EEGmetrics_SubjoI,2))))

    % select test and train data; SNSvids - FaceERP resp.
    Y_dataIndiv_test = Y_dataIndiv_SNSvids(:,ss);
    X_space_test = X_spacepoints_SNSvids;
    Y_dataIndiv_train = Y_dataIndiv_FaceERP(:,ss);
    X_space_train = X_spacepoints_FaceERP;

    
    % Training model
        SigmaFixed = std(Y_dataIndiv_train);
        c = cvpartition(size(Y_dataIndiv_train,1), "KFold", 10); % cross-validation parameters 
    % fit GPR model to estimate parameters
            gprMdl = fitrgp(X_space_train,Y_dataIndiv_train,...
            'BasisFunction', 'none', ...
            'KernelFunction', 'squaredexponential', ...
            'KernelParameters', [1 SigmaFixed], ...
            'Sigma', SigmaFixed, ...
            'Standardize', false, ...
            'OptimizeHyperparameters', 'KernelScale', ...
            'HyperparameterOptimizationOptions',struct('CVPartition',c,...
            'ShowPlots', false, ...
            'Verbose', 0));

    % calculate predicted values for test dataset
        [predictions_test] = predict(gprMdl, X_space_test); % Evaluate the predictions for test data
    % get correlation for predicted and observed test data
        [Rho, pval, rlb, rup] = corrcoef(predictions_test, Y_dataIndiv_test); % how well predicted model fits

    % save the resulting output
        Corrs_fit(:,ss) = [Rho(1,2); pval(1,2); rlb(1,2); rup(1,2)];
        Obs_EEGvals_SNSvids(:,ss) = Y_dataIndiv_test;
        Pred_EEGvals_SNSvids(:,ss) = predictions_test;
        GPR_models{1,ss} = gprMdl;

    % clean up variables
        clear SigmaFixed c gprMdl predictions_test Rho pval rlb rup 
        clear Y_dataIndiv_test X_space_test Y_dataIndiv_train X_space_train 

    % interim saving
        save('Disc_Modeltesting_OutofTask_TestSNSvids.mat','Corrs_fit','Obs_EEGvals_SNSvids','Pred_EEGvals_SNSvids','GPR_models')
    
end % end loop subjects


clear Corrs_fit GPR_models Obs_EEGvals_SNSvids Pred_EEGvals_SNSvids ss




% B2) Prediction FaceERP from SNSvids %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for later analyses
Corrs_fit = zeros(4, size(EEGmetrics_SubjoI,2));
Obs_EEGvals_FaceERP = zeros(size(Y_dataIndiv_FaceERP,1), size(EEGmetrics_SubjoI,2));
Pred_EEGvals_FaceERP = zeros(size(Y_dataIndiv_FaceERP,1), size(EEGmetrics_SubjoI,2));
GPR_models = cell(1,size(EEGmetrics_SubjoI,2));

for ss = 1:size(EEGmetrics_SubjoI,2)

    disp(strcat('Subject: ', num2str(ss), '/', num2str(size(EEGmetrics_SubjoI,2))))

    % select test and train data; FaceERP - SNSvids resp.
    Y_dataIndiv_test = Y_dataIndiv_FaceERP(:,ss);
    X_space_test = X_spacepoints_FaceERP;
    Y_dataIndiv_train = Y_dataIndiv_SNSvids(:,ss);
    X_space_train = X_spacepoints_SNSvids;

    
    % Training model
        SigmaFixed = std(Y_dataIndiv_train);
        c = cvpartition(size(Y_dataIndiv_train,1), "KFold", 10); % cross-validation parameters 
    % fit GPR model to estimate parameters
            gprMdl = fitrgp(X_space_train,Y_dataIndiv_train,...
            'BasisFunction', 'none', ...
            'KernelFunction', 'squaredexponential', ...
            'KernelParameters', [1 SigmaFixed], ...
            'Sigma', SigmaFixed, ...
            'Standardize', false, ...
            'OptimizeHyperparameters', 'KernelScale', ...
            'HyperparameterOptimizationOptions',struct('CVPartition',c,...
            'ShowPlots', false, ...
            'Verbose', 0));

    % calculate predicted values for test dataset
        [predictions_test] = predict(gprMdl, X_space_test); % Evaluate the predictions for test data
    % get correlation for predicted and observed test data
        [Rho, pval, rlb, rup] = corrcoef(predictions_test, Y_dataIndiv_test); % how well predicted model fits

    % save the resulting output
        Corrs_fit(:,ss) = [Rho(1,2); pval(1,2); rlb(1,2); rup(1,2)];
        Obs_EEGvals_FaceERP(:,ss) = Y_dataIndiv_test;
        Pred_EEGvals_FaceERP(:,ss) = predictions_test;
        GPR_models{1,ss} = gprMdl;

    % clean up variables
        clear SigmaFixed c gprMdl predictions_test Rho pval rlb rup 
        clear Y_dataIndiv_test X_space_test Y_dataIndiv_train X_space_train 

    % interim saving
        save('Disc_Modeltesting_OutofTask_TestFaceERP.mat','Corrs_fit','Obs_EEGvals_FaceERP','Pred_EEGvals_FaceERP','GPR_models')
    
end % end loop subjects


clear Corrs_fit GPR_models Obs_EEGvals_FaceERP Pred_EEGvals_FaceERP ss

clear EEGmetrics_SubjoI EEGmet_inds EEGmet_inds_SNSvids EEGmet_inds_FaceERP
clear X_spacepoints_SNSvids X_spacepoints_FaceERP X_spacepoints 
clear Y_dataIndiv_SNSvids Y_dataIndiv_FaceERP Data_indivspace




%% Test if correlations between predicted and observed values are above 0
cd xxx/02_ValidatingSpace

load('Disc_Modeltesting_acrosstasks_Ntest50.mat','Corrs_fit')
A_corrs = Corrs_fit; clear Corrs_fit
load('Disc_Modeltesting_OutofTask_TestSNSvids.mat','Corrs_fit','Obs_EEGvals_SNSvids')
B1_corrs = Corrs_fit; clear Corrs_fit
B1_ntest = size(Obs_EEGvals_SNSvids,1); clear Obs_EEGvals_SNSvids
load('Disc_Modeltesting_OutofTask_TestFaceERP.mat','Corrs_fit','Obs_EEGvals_FaceERP')
B2_corrs = Corrs_fit; clear Corrs_fit
B2_ntest = size(Obs_EEGvals_FaceERP,1); clear Obs_EEGvals_FaceERP

% across tasks
[p,h,stats] = signrank(A_corrs(1,:)',0,'tail','right'); % test if correlations are larger than 0
A_median = median(A_corrs(1,:),2);
% out of task
[p,h,stats] = signrank(B1_corrs(1,:)',0,'tail','right'); % test if correlations are larger than 0
B1_median = median(B1_corrs(1,:),2);
[p,h,stats] = signrank(B2_corrs(1,:)',0,'tail','right'); % test if correlations are larger than 0
B2_median = median(B2_corrs(1,:),2);










%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For 3D space %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data and prep
    cd xxx/01_CreatingSpace
% normalise the EEG data in the sample relative to the m and sd from the
% group space with 1/2 discovery sample
    load Disc_groupspace_250227.mat
% individual data other 1/2 discovery sample
    load Disc_indivspace_250227.mat
% get the space coordinates (dimensions 1, 2, and 3)
    X_spacepoints_3D = Y_sp(:, [1 2 3]);
% clear up
    clear C S Data_groupspace DataNormA DataNormB Dsq_sp eigvals_sp Y_sp
% take out the N=10 used for length scale optimisation
    rng(2302)
    RandIndices = randperm(size(Data_indivspace.Subj_IDs,2), 10);
    SelectInd = true(size(Data_indivspace.Subj_IDs,2),1);
    SelectInd(RandIndices,1) = false;
    EEGmetrics_SubjoI = Data_indivspace.data_normalised(:,SelectInd);
    clear SelectInd RandIndices
% change path again
    cd xxx/02_ValidatingSpace

%% 3D A) Correlations for 50 values across tasks in rest of validation sample 
cd xxx/02_ValidatingSpace

% get rid of subjects with NaN in their data
GOODsubj = find(any(isnan(EEGmetrics_SubjoI),1)==0);
EEGmetrics_SubjoI_all = EEGmetrics_SubjoI;
EEGmetrics_SubjoI = EEGmetrics_SubjoI(:,GOODsubj);

Ntot = size(EEGmetrics_SubjoI,1);
Ntest = 50;
Ntrain = 200;
% for later analyses
Corrs_fit = zeros(4, size(EEGmetrics_SubjoI,2));
Obs_EEGvals = zeros(Ntest, size(EEGmetrics_SubjoI,2));
Pred_EEGvals = zeros(Ntest, size(EEGmetrics_SubjoI,2));
GPR_models = {};

% get indices for test and training data
rng(2302)
Rand_ind = randperm(size(EEGmetrics_SubjoI,1), Ntot);

for ss = 1:size(EEGmetrics_SubjoI,2)

    disp(strcat('Subject: ', num2str(ss), '/', num2str(size(EEGmetrics_SubjoI,2))))

    % select test and train data
    Y_dataIndiv_test = EEGmetrics_SubjoI(Rand_ind(1,1:Ntest),ss);
    X_space_test = X_spacepoints_3D(Rand_ind(1,1:Ntest),:);
    Y_dataIndiv_train = EEGmetrics_SubjoI(Rand_ind(1,(Ntest+1):(Ntrain+Ntest)),ss);
    X_space_train = X_spacepoints_3D(Rand_ind(1,(Ntest+1):(Ntrain+Ntest)),:);

    % Training model
        SigmaFixed = std(Y_dataIndiv_train);
        c = cvpartition(size(Y_dataIndiv_train,1), "KFold", 10); % cross-validation parameters 
    % fit GPR model to estimate parameters
            gprMdl = fitrgp(X_space_train,Y_dataIndiv_train,...
            'BasisFunction', 'none', ...
            'KernelFunction', 'squaredexponential', ...
            'KernelParameters', [1 SigmaFixed], ...
            'Sigma', SigmaFixed, ...
            'Standardize', false, ...
            'OptimizeHyperparameters', 'KernelScale', ...
            'HyperparameterOptimizationOptions',struct('CVPartition',c,...
            'ShowPlots', false, ...
            'Verbose', 0));

    % calculate predicted values for test dataset
        [predictions_test] = predict(gprMdl, X_space_test); % Evaluate the predictions for test data
    % get correlation for predicted and observed test data
        [Rho, pval, rlb, rup] = corrcoef(predictions_test, Y_dataIndiv_test); % how well predicted model fits

    % save the resulting output
        Corrs_fit(:,ss) = [Rho(1,2); pval(1,2); rlb(1,2); rup(1,2)];
        Obs_EEGvals(:,ss) = Y_dataIndiv_test;
        Pred_EEGvals(:,ss) = predictions_test;
        GPR_models{1,ss} = gprMdl;

    % clean up variables
        clear SigmaFixed c gprMdl predictions_test Rho pval rlb rup 
        clear Y_dataIndiv_test X_space_test Y_dataIndiv_train X_space_train 

    % interim saving
        save('Disc_Modeltesting3D_acrosstasks_Ntest50.mat','Corrs_fit','Obs_EEGvals','Pred_EEGvals','GPR_models')
    
end % end loop subjects


clear Corrs_fit GPR_models Ntest Ntot Ntrain Obs_EEGvals Pred_EEGvals Rand_ind ss


%% 3D B) Correlations for out-of-task values in rest of validation sample 

% get indices for EEG tasks
EEGmet_inds = zeros(length(Data_indivspace.EEG_names),1);
for ii = 1:length(Data_indivspace.EEG_names)
    if contains(Data_indivspace.EEG_names{ii},'Fu') || contains(Data_indivspace.EEG_names{ii},'Fi')
        EEGmet_inds(ii) = 1;
    elseif contains(Data_indivspace.EEG_names{ii},'SNa') || contains(Data_indivspace.EEG_names{ii},'SNs') || ...
            contains(Data_indivspace.EEG_names{ii},'SNt') || contains(Data_indivspace.EEG_names{ii},'SNd')
        EEGmet_inds(ii) = 2;
    end
end
EEGmet_inds_FaceERP = find(EEGmet_inds == 1);
EEGmet_inds_SNSvids = find(EEGmet_inds == 2);

% split data into tasks
% x and y for FaceERP
Y_dataIndiv_FaceERP = EEGmetrics_SubjoI(EEGmet_inds_FaceERP,:);
X_spacepoints_FaceERP = X_spacepoints_3D(EEGmet_inds_FaceERP,:);
% x and y for SNS videos
Y_dataIndiv_SNSvids = EEGmetrics_SubjoI(EEGmet_inds_SNSvids,:);
X_spacepoints_SNSvids = X_spacepoints_3D(EEGmet_inds_SNSvids,:);


% B1) Prediction SNSvids from FaceERP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for later analyses
Corrs_fit = zeros(4, size(EEGmetrics_SubjoI,2));
Obs_EEGvals_SNSvids = zeros(size(Y_dataIndiv_SNSvids,1), size(EEGmetrics_SubjoI,2));
Pred_EEGvals_SNSvids = zeros(size(Y_dataIndiv_SNSvids,1), size(EEGmetrics_SubjoI,2));
GPR_models = cell(1,size(EEGmetrics_SubjoI,2));

for ss = 1:size(EEGmetrics_SubjoI,2)

    disp(strcat('Subject: ', num2str(ss), '/', num2str(size(EEGmetrics_SubjoI,2))))

    % select test and train data; SNSvids - FaceERP resp.
    Y_dataIndiv_test = Y_dataIndiv_SNSvids(:,ss);
    X_space_test = X_spacepoints_SNSvids;
    Y_dataIndiv_train = Y_dataIndiv_FaceERP(:,ss);
    X_space_train = X_spacepoints_FaceERP;

    
    % Training model
        SigmaFixed = std(Y_dataIndiv_train);
        c = cvpartition(size(Y_dataIndiv_train,1), "KFold", 10); % cross-validation parameters 
    % fit GPR model to estimate parameters
            gprMdl = fitrgp(X_space_train,Y_dataIndiv_train,...
            'BasisFunction', 'none', ...
            'KernelFunction', 'squaredexponential', ...
            'KernelParameters', [1 SigmaFixed], ...
            'Sigma', SigmaFixed, ...
            'Standardize', false, ...
            'OptimizeHyperparameters', 'KernelScale', ...
            'HyperparameterOptimizationOptions',struct('CVPartition',c,...
            'ShowPlots', false, ...
            'Verbose', 0));

    % calculate predicted values for test dataset
        [predictions_test] = predict(gprMdl, X_space_test); % Evaluate the predictions for test data
    % get correlation for predicted and observed test data
        [Rho, pval, rlb, rup] = corrcoef(predictions_test, Y_dataIndiv_test); % how well predicted model fits

    % save the resulting output
        Corrs_fit(:,ss) = [Rho(1,2); pval(1,2); rlb(1,2); rup(1,2)];
        Obs_EEGvals_SNSvids(:,ss) = Y_dataIndiv_test;
        Pred_EEGvals_SNSvids(:,ss) = predictions_test;
        GPR_models{1,ss} = gprMdl;

    % clean up variables
        clear SigmaFixed c gprMdl predictions_test Rho pval rlb rup 
        clear Y_dataIndiv_test X_space_test Y_dataIndiv_train X_space_train 

    % interim saving
        save('Disc_Modeltesting3D_OutofTask_TestSNSvids.mat','Corrs_fit','Obs_EEGvals_SNSvids','Pred_EEGvals_SNSvids','GPR_models')
    
end % end loop subjects

clear Corrs_fit GPR_models Obs_EEGvals_SNSvids Pred_EEGvals_SNSvids ss


% B2) Prediction FaceERP from SNSvids %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for later analyses
Corrs_fit = zeros(4, size(EEGmetrics_SubjoI,2));
Obs_EEGvals_FaceERP = zeros(size(Y_dataIndiv_FaceERP,1), size(EEGmetrics_SubjoI,2));
Pred_EEGvals_FaceERP = zeros(size(Y_dataIndiv_FaceERP,1), size(EEGmetrics_SubjoI,2));
GPR_models = cell(1,size(EEGmetrics_SubjoI,2));

for ss = 1:size(EEGmetrics_SubjoI,2)

    disp(strcat('Subject: ', num2str(ss), '/', num2str(size(EEGmetrics_SubjoI,2))))

    % select test and train data; FaceERP - SNSvids resp.
    Y_dataIndiv_test = Y_dataIndiv_FaceERP(:,ss);
    X_space_test = X_spacepoints_FaceERP;
    Y_dataIndiv_train = Y_dataIndiv_SNSvids(:,ss);
    X_space_train = X_spacepoints_SNSvids;

    
    % Training model
        SigmaFixed = std(Y_dataIndiv_train);
        c = cvpartition(size(Y_dataIndiv_train,1), "KFold", 10); % cross-validation parameters 
    % fit GPR model to estimate parameters
            gprMdl = fitrgp(X_space_train,Y_dataIndiv_train,...
            'BasisFunction', 'none', ...
            'KernelFunction', 'squaredexponential', ...
            'KernelParameters', [1 SigmaFixed], ...
            'Sigma', SigmaFixed, ...
            'Standardize', false, ...
            'OptimizeHyperparameters', 'KernelScale', ...
            'HyperparameterOptimizationOptions',struct('CVPartition',c,...
            'ShowPlots', false, ...
            'Verbose', 0));

    % calculate predicted values for test dataset
        [predictions_test] = predict(gprMdl, X_space_test); % Evaluate the predictions for test data
    % get correlation for predicted and observed test data
        [Rho, pval, rlb, rup] = corrcoef(predictions_test, Y_dataIndiv_test); % how well predicted model fits

    % save the resulting output
        Corrs_fit(:,ss) = [Rho(1,2); pval(1,2); rlb(1,2); rup(1,2)];
        Obs_EEGvals_FaceERP(:,ss) = Y_dataIndiv_test;
        Pred_EEGvals_FaceERP(:,ss) = predictions_test;
        GPR_models{1,ss} = gprMdl;

    % clean up variables
        clear SigmaFixed c gprMdl predictions_test Rho pval rlb rup 
        clear Y_dataIndiv_test X_space_test Y_dataIndiv_train X_space_train 

    % interim saving
        save('Disc_Modeltesting3D_OutofTask_TestFaceERP.mat','Corrs_fit','Obs_EEGvals_FaceERP','Pred_EEGvals_FaceERP','GPR_models')
    
end % end loop subjects


clear Corrs_fit GPR_models Obs_EEGvals_FaceERP Pred_EEGvals_FaceERP ss

clear EEGmetrics_SubjoI EEGmet_inds EEGmet_inds_SNSvids EEGmet_inds_FaceERP
clear X_spacepoints_SNSvids X_spacepoints_FaceERP X_spacepoints_3D
clear Y_dataIndiv_SNSvids Y_dataIndiv_FaceERP Data_indivspace







%% Test if correlations are above 0
cd xxx/02_ValidatingSpace

load('Disc_Modeltesting3D_acrosstasks_Ntest50.mat','Corrs_fit')
A_corrs = Corrs_fit; clear Corrs_fit
load('Disc_Modeltesting3D_OutofTask_TestSNSvids.mat','Corrs_fit','Obs_EEGvals_SNSvids')
B1_corrs = Corrs_fit; clear Corrs_fit
B1_ntest = size(Obs_EEGvals_SNSvids,1); clear Obs_EEGvals_SNSvids
load('Disc_Modeltesting3D_OutofTask_TestFaceERP.mat','Corrs_fit','Obs_EEGvals_FaceERP')
B2_corrs = Corrs_fit; clear Corrs_fit
B2_ntest = size(Obs_EEGvals_FaceERP,1); clear Obs_EEGvals_FaceERP

% across tasks
[p,h,stats] = signrank(A_corrs(1,:)',0,'tail','right'); % test if correlations are larger than 0
A_median = median(A_corrs(1,:),2);
% out of task
[p,h,stats] = signrank(B1_corrs(1,:)',0,'tail','right'); % test if correlations are larger than 0
B1_median = median(B1_corrs(1,:),2);
[p,h,stats] = signrank(B2_corrs(1,:)',0,'tail','right'); % test if correlations are larger than 0
B2_median = median(B2_corrs(1,:),2);

