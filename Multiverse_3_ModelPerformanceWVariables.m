%% GAIINS: Model preformence vs other features

% This script examines the performance of the GPR models, operationalised at
% the correlation between the predicted and observed values across the 2D
% and 3D spaces, in association with other features to ensure that the
% performance is similar across varying data quantity, age, IQ, and
% clinical features.

% created by dr. Rianne Haartsen, Birkbeck College, 04-2024
% updated on 03-2025 - supplementary analyses for differences across sites,
% sex, and diangostic groups

%% Load data for model predictions and prep
cd xxx/02_ValidatingSpace
load('Disc_Modeltesting_acrosstasks_Ntest50.mat','Corrs_fit')
D2_Across_Rhos = Corrs_fit; clear Corrs_fit
load('Disc_Modeltesting_OutofTask_TestSNSvids.mat','Corrs_fit','Obs_EEGvals_SNSvids')
D2_Out_Face2SNS = Corrs_fit; clear Corrs_fit
load('Disc_Modeltesting_OutofTask_TestFaceERP.mat','Corrs_fit','Obs_EEGvals_FaceERP')
D2_Out_SNS2Face = Corrs_fit; clear Corrs_fit

load('Disc_Modeltesting3D_acrosstasks_Ntest50.mat','Corrs_fit')
D3_Across_Rhos = Corrs_fit; clear Corrs_fit
load('Disc_Modeltesting3D_OutofTask_TestSNSvids.mat','Corrs_fit','Obs_EEGvals_SNSvids')
D3_Out_Face2SNS = Corrs_fit; clear Corrs_fit
load('Disc_Modeltesting3D_OutofTask_TestFaceERP.mat','Corrs_fit','Obs_EEGvals_FaceERP')
D3_Out_SNS2Face = Corrs_fit; clear Corrs_fit

%% Data quantity
% get Ns epochs per task
% individual data other 1/2 discovery sample
load xxx/01_CreatingSpace/Disc_indivspace_250227.mat
% take out the N=10 used for length scale optimisation
rng(2302)
RandIndices = randperm(size(Data_indivspace.Subj_IDs,2), 10);
SelectInd = true(size(Data_indivspace.Subj_IDs,2),1);
SelectInd(RandIndices,1) = false;

EEGmetrics_SubjoI = Data_indivspace.data_normalised(:,SelectInd);
IDs_SubjoI = Data_indivspace.Subj_IDs(1,SelectInd);
clear SelectInd RandIndices

% get rid of subjects with NaN in their data
GOODsubj = find(any(isnan(EEGmetrics_SubjoI),1)==0);
EEGmetrics_SubjoI_all = EEGmetrics_SubjoI;
IDs_SubjoI_all = IDs_SubjoI;
EEGmetrics_SubjoI = EEGmetrics_SubjoI(:,GOODsubj);
IDs_SubjoI = IDs_SubjoI(1,GOODsubj);

Neps_FaceERP_fu = EEGmetrics_SubjoI(1,:);
Neps_FaceERP_fi = EEGmetrics_SubjoI(2,:);
Neps_SNSvids = EEGmetrics_SubjoI(147,:);

% Calculate the correlation
[Rho_vals, p_vals] = corr([Neps_FaceERP_fu', Neps_FaceERP_fi', Neps_SNSvids', ...
    D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
    D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'], 'type','Spearman','tail','both');
% visualise the results
figure
    imagesc(Rho_vals)
    xtickangle(45)
    xticks(1:1:9)
    xticklabels({'Neps Fu', 'Neps Fi', 'Neps SNSvids', ...
        'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
        'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
    yticks(1:1:9)
    yticklabels({'Neps Fu', 'Neps Fi', 'Neps SNSvids', ...
        'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
        'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
    a = colorbar; a.Label.String = 'Correlation'; a.Limits = [-1 1];
    title('Model performance and data quantity')

%% Get age, fsiq, viq, piq, etc
% clinical data
addpath xxx/LEAP_Info
ClinVars_t1_t2 = readtable('LEAP_t1&t2_core_08-02-19_excel.xlsx');

% find indices for Disc participants in ClinVars
Disc_Ind = zeros(length(IDs_SubjoI),1);
for ii = 1:length(IDs_SubjoI)
    Cur_subj = IDs_SubjoI{1,ii};
    for ss = 1:height(ClinVars_t1_t2)
        if strcmp(Cur_subj, num2str(ClinVars_t1_t2.subjects(ss)))
            Disc_Ind(ii) =  ss;
        end
    end
    clear ss Cur_subj
end
clear ii
Disc_Ind = Disc_Ind(Disc_Ind ~= 0);

% Get ClinVars for discovery sample
ClinVars_t1_t2 = readtable('LEAP_t1&t2_core_08-02-19_excel.xlsx');
DiscSample_clinvars = ClinVars_t1_t2(Disc_Ind,:);

%% Age 
Age = table2array(DiscSample_clinvars(:,{'age'}));
Age(Age == 999) = NaN; Age(Age == 777) = NaN;
Mat = [Age,...
    D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
    D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];
Mat_clean = Mat(all(~isnan(Mat),2),:);
% Calculate the correlation
[Rho_vals2, p_vals2] = corr(Mat_clean, 'type','Spearman','tail','both');
% visualise the results
figure
    imagesc(Rho_vals2)
    xtickangle(45)
    xticks(1:1:10)
    xticklabels({'Age',...
        'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
        'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
    yticks(1:1:10)
    yticklabels({'Age', ...
        'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
        'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
    a = colorbar; a.Label.String = 'Correlation'; a.Limits = [-1 1];
    xline(4.5, 'LineWidth',2); yline(4.5, 'LineWidth',2)
    title(strcat('Model performance and age (N=', num2str(size(Mat_clean,1)),')'))

    clear Mat_clean

%% IQ
IQ = table2array(DiscSample_clinvars(:,{'viq','piq','fsiq'}));
IQ(IQ == 999) = NaN; IQ(IQ == 777) = NaN; IQ(IQ == 888) = NaN;
Mat = [IQ, ...
    D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
    D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];
Mat_clean = Mat(all(~isnan(Mat),2),:);
% Calculate the correlation
[Rho_vals3, p_vals3] = corr(Mat_clean, 'type','Spearman','tail','both');
% visualise the results
figure
    imagesc(Rho_vals3)
    xtickangle(45)
    xticks(1:1:10)
    xticklabels({'VIQ', 'PIQ', 'FSIQ',...
        'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
        'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
    yticks(1:1:10)
    yticklabels({'VIQ', 'PIQ', 'FSIQ',...
        'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
        'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
    a = colorbar; a.Label.String = 'Correlation'; a.Limits = [-1 1];
    xline(4.5, 'LineWidth',2); yline(4.5, 'LineWidth',2)
    title(strcat('Model performance and IQ (N=', num2str(size(Mat_clean,1)),')'))

    clear Mat_clean


%% Clinical variables

% VABS
    VABS = table2array(DiscSample_clinvars(:,{'vabsdscoresc_dss','vabsdscoresd_dss','vabsdscoress_dss','vabsabcabc_standard'}));
    VABS(VABS == 999) = NaN; VABS(VABS == 777) = NaN; VABS(VABS == 888) = NaN;
    Mat = [VABS, ...
        D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
        D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];
    Mat_clean = Mat(all(~isnan(Mat),2),:);
    % Calculate the correlation
    [Rho_vals4, p_vals4] = corr(Mat_clean, 'type','Spearman','tail','both');
    % visualise the results
    figure
        imagesc(Rho_vals4)
        xtickangle(45)
        xticks(1:1:10)
        xticklabels({'VABS Communication', 'VABS Daily Living', 'VABS Socialisation', 'VABS ABC',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        yticks(1:1:10)
        yticklabels({'VABS Communication', 'VABS Daily Living', 'VABS Socialisation', 'VABS ABC',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        a = colorbar; a.Label.String = 'Correlation'; a.Limits = [-1 1];
        xline(4.5, 'LineWidth',2); yline(4.5, 'LineWidth',2)
        title(strcat('Model performance and VABS (N=', num2str(size(Mat_clean,1)),')'))
        clear Mat_clean
% SRS Sci
    SRS = table2array(DiscSample_clinvars(:,{'SRS_dsm5_SCI'}));
    SRS(SRS == 999) = NaN; SRS(SRS == 777) = NaN; SRS(SRS == 888) = NaN;
    Mat = [SRS, ...
        D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
        D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];
    Mat_clean = Mat(all(~isnan(Mat),2),:);
    % Calculate the correlation
    [Rho_vals5, p_vals5] = corr(Mat_clean, 'type','Spearman','tail','both');
    % visualise the results
    figure
        imagesc(Rho_vals5)
        xtickangle(45)
        xticks(1:1:7)
        xticklabels({'SRS dsm5 SCI domain',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        yticks(1:1:7)
        yticklabels({'SRS dsm5 SCI domain',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        a = colorbar; a.Label.String = 'Correlation'; a.Limits = [-1 1];
        xline(1.5, 'LineWidth',2); yline(1.5, 'LineWidth',2)
        title(strcat('Model performance and SRS (N=', num2str(size(Mat_clean,1)),')'))
        clear Mat_clean
% RBS
    RBS = table2array(DiscSample_clinvars(:,{'RBS_total'}));
    RBS(RBS == 999) = NaN; RBS(RBS == 777) = NaN; RBS(RBS == 888) = NaN;
    Mat = [RBS, ...
        D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
        D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];
    Mat_clean = Mat(all(~isnan(Mat),2),:);
    % Calculate the correlation
    [Rho_vals6, p_vals6] = corr(Mat_clean, 'type','Spearman','tail','both');
    % visualise the results
    figure
        imagesc(Rho_vals6)
        xtickangle(45)
        xticks(1:1:7)
        xticklabels({'RBS total',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        yticks(1:1:7)
        yticklabels({'SRS total',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        a = colorbar; a.Label.String = 'Correlation'; a.Limits = [-1 1];
        xline(1.5, 'LineWidth',2); yline(1.5, 'LineWidth',2)
        title(strcat('Model performance and RBS (N=', num2str(size(Mat_clean,1)),')'))
        clear Mat_clean

% SSP
    SSP = table2array(DiscSample_clinvars(:,{'SSP_total'}));
    SSP(SSP == 999) = NaN; SSP(SSP == 777) = NaN; SSP(SSP == 888) = NaN;
    Mat = [SSP, ...
        D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
        D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];
    Mat_clean = Mat(all(~isnan(Mat),2),:);
    % Calculate the correlation
    [Rho_vals7, p_vals7] = corr(Mat_clean, 'type','Spearman','tail','both');
    % visualise the results
    figure
        imagesc(Rho_vals7)
        xtickangle(45)
        xticks(1:1:7)
        xticklabels({'SSP total',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        yticks(1:1:7)
        yticklabels({'SSP total',...
            'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
            'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'})
        a = colorbar; a.Label.String = 'Correlation'; a.Limits = [-1 1];
        xline(1.5, 'LineWidth',2); yline(1.5, 'LineWidth',2)
        title(strcat('Model performance and SSP (N=', num2str(size(Mat_clean,1)),')'))
        clear Mat_clean        

%% Collate rhos and pvals for report

Rhos_all = round([Rho_vals2(1,2:end); Rho_vals(1:3,4:end);...
    Rho_vals3(1:3,4:end); Rho_vals4(1:4,5:end);...
    Rho_vals5(1,2:end); Rho_vals6(1,2:end); Rho_vals7(1,2:end)],2);

Pvals_all = round([p_vals2(1,2:end); p_vals(1:3,4:end);...
    p_vals3(1:3,4:end); p_vals4(1:4,5:end);...
    p_vals5(1,2:end); p_vals6(1,2:end); p_vals7(1,2:end)],3);

% apply MCP correction: FDR adjusted p-values per variable across model
% performances
addpath xxx/MATLAB/fdr_bh

Pvals_FDRadj_row = zeros(size(Pvals_all,1), size(Pvals_all,2));
h_curr = zeros(size(Pvals_all,1), size(Pvals_all,2));
for rr = 1: size(Pvals_all,1)
    pvals_curr = Pvals_all(rr,:);
    [h, ~, ~, adj_p]=fdr_bh(pvals_curr, 0.05, 'pdep', 'yes');
    h_curr(rr,:) = h;
    Pvals_FDRadj_row(rr,:) = adj_p;
    clear h adj_p pvals_curr
end

% Visualation age with model performances 
Age = table2array(DiscSample_clinvars(:,{'age'}));
Age(Age == 999) = NaN;
Mat = [Age,...
    D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
    D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];
Mat_clean = Mat(all(~isnan(Mat),2),:);

figure
Variables = ({'Age',...
        'D2 across', 'D2 Face2SNSvids', 'D2 SNSvids2Face', ...
        'D3 across', 'D3 Face2SNSvids', 'D3 SNSvids2Face'});
for ss = 1:6
    subplot(2,3,ss)
    scatter(Mat_clean(:,1), Mat_clean(:,(1+ss)))
    xlabel(Variables{1,1}); ylabel(Variables{1,1+ss})
    title(strcat("Rho =  ", num2str(Rhos_all(1,ss)), " p-val =  ", num2str(Pvals_FDRadj_row(1,ss))))
end

% values for reporting in text
ps2 = reshape(Pvals_FDRadj_row, [], 1); rhos2 = reshape(Rhos_all, [], 1); 
both = [rhos2, ps2];
ordered = sortrows(both);
clear ps2 rhos2 both ordered
clear p_vals p_vals2 p_vals3 p_vals4 p_vals5 p_vals6
clear Rho_vals Rho_vals2 Rho_vals3 Rho_vals4 Rho_vals5 Rho_vals6
clear ss rr Rhos_all Pvals_FDRadj_row h_curr Variables

%% Site differences
Site = table2array(DiscSample_clinvars(:,{'site'}));
Site = categorical(Site);
N_site = tabulate(Site) % check number for each site

ModelPerf = [D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
    D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];

% 2D across
ModVals = ModelPerf(:,1);
% Descriptives per site: N, median, IQR
Descripts = table(categories(Site), N_site(:,2), round(grpstats(ModVals, Site, 'median'),2), round(grpstats(ModVals, Site, 'iqr'),2), ...
    'VariableNames', {'Site','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, tbl, stats]  = kruskalwallis(ModVals, Site, 'on');
% Effect size eta sq H
n = numel(Site); H  = tbl{2,5};
eta_sq_H = (H - length(unique(Site)) + 1) / (n - length(unique(Site)))
clear ModVals Descripts n eta_sq_H p tbl stats

% 2D face2sns
ModVals = ModelPerf(:,2);
% Descriptives per site: N, median, IQR
Descripts = table(categories(Site), N_site(:,2), round(grpstats(ModVals, Site, 'median'),2), round(grpstats(ModVals, Site, 'iqr'),2), ...
    'VariableNames', {'Site','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, tbl, stats]  = kruskalwallis(ModVals, Site, 'on');
% Effect size eta sq H
n = numel(Site); H  = tbl{2,5};
eta_sq_H = (H - length(unique(Site)) + 1) / (n - length(unique(Site)))
clear ModVals Descripts n eta_sq_H p tbl stats

% 2D sns2face
ModVals = ModelPerf(:,3);
% Descriptives per site: N, median, IQR
Descripts = table(categories(Site), N_site(:,2), round(grpstats(ModVals, Site, 'median'),2), round(grpstats(ModVals, Site, 'iqr'),2), ...
    'VariableNames', {'Site','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, tbl, stats]  = kruskalwallis(ModVals, Site, 'on');
% Effect size eta sq H
n = numel(Site); H  = tbl{2,5};
eta_sq_H = (H - length(unique(Site)) + 1) / (n - length(unique(Site)))
clear ModVals Descripts n eta_sq_H p tbl stats

% 3D across
ModVals = ModelPerf(:,4);
% Descriptives per site: N, median, IQR
Descripts = table(categories(Site), N_site(:,2), round(grpstats(ModVals, Site, 'median'),2), round(grpstats(ModVals, Site, 'iqr'),2), ...
    'VariableNames', {'Site','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, tbl, stats]  = kruskalwallis(ModVals, Site, 'on');
% Effect size eta sq H
n = numel(Site); H  = tbl{2,5};
eta_sq_H = (H - length(unique(Site)) + 1) / (n - length(unique(Site)))
clear ModVals Descripts n eta_sq_H p tbl stats

% 3D face2sns
ModVals = ModelPerf(:,5);
% Descriptives per site: N, median, IQR
Descripts = table(categories(Site), N_site(:,2), round(grpstats(ModVals, Site, 'median'),2), round(grpstats(ModVals, Site, 'iqr'),2), ...
    'VariableNames', {'Site','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, tbl, stats]  = kruskalwallis(ModVals, Site, 'on');
% Effect size eta sq H
n = numel(Site); H  = tbl{2,5};
eta_sq_H = (H - length(unique(Site)) + 1) / (n - length(unique(Site)))
clear ModVals Descripts n eta_sq_H p tbl stats

% 3D sns2face
ModVals = ModelPerf(:,6);
% Descriptives per site: N, median, IQR
Descripts = table(categories(Site), N_site(:,2), round(grpstats(ModVals, Site, 'median'),2), round(grpstats(ModVals, Site, 'iqr'),2), ...
    'VariableNames', {'Site','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, tbl, stats]  = kruskalwallis(ModVals, Site, 'on');
% Effect size eta sq H
n = numel(Site); H  = tbl{2,5};
eta_sq_H = (H - length(unique(Site)) + 1) / (n - length(unique(Site)))
clear ModVals Descripts n eta_sq_H p tbl stats

clear N_site Site

%% Sex differences

Sex = table2array(DiscSample_clinvars(:,{'sex'}));
Sex = categorical(Sex);
N_sex = tabulate(Sex) % check number for each sex

ModelPerf = [D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
    D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];


% 2D across
ModVals = ModelPerf(:,1);
% Descriptives per sex: N, median, IQR
Descripts = table(categories(Sex), N_sex(:,2), round(grpstats(ModVals, Sex, 'median'),2), round(grpstats(ModVals, Sex, 'iqr'),2), ...
    'VariableNames', {'Sex','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(Sex == 'Female', 1), ModVals(Sex == 'Male', 1))
clear ModVals Descripts p h stats

% 2D face2sns
ModVals = ModelPerf(:,2);
% Descriptives per sex: N, median, IQR
Descripts = table(categories(Sex), N_sex(:,2), round(grpstats(ModVals, Sex, 'median'),2), round(grpstats(ModVals, Sex, 'iqr'),2), ...
    'VariableNames', {'Sex','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(Sex == 'Female', 1), ModVals(Sex == 'Male', 1))
clear ModVals Descripts p h stats

% 2D sns2face
ModVals = ModelPerf(:,3);
% Descriptives per sex: N, median, IQR
Descripts = table(categories(Sex), N_sex(:,2), round(grpstats(ModVals, Sex, 'median'),2), round(grpstats(ModVals, Sex, 'iqr'),2), ...
    'VariableNames', {'Sex','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(Sex == 'Female', 1), ModVals(Sex == 'Male', 1))
clear ModVals Descripts p h stats

% 3D across
ModVals = ModelPerf(:,4);
% Descriptives per sex: N, median, IQR
Descripts = table(categories(Sex), N_sex(:,2), round(grpstats(ModVals, Sex, 'median'),2), round(grpstats(ModVals, Sex, 'iqr'),2), ...
    'VariableNames', {'Sex','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(Sex == 'Female', 1), ModVals(Sex == 'Male', 1))
clear ModVals Descripts p h stats

% 3D face2sns
ModVals = ModelPerf(:,5);
% Descriptives per sex: N, median, IQR
Descripts = table(categories(Sex), N_sex(:,2), round(grpstats(ModVals, Sex, 'median'),2), round(grpstats(ModVals, Sex, 'iqr'),2), ...
    'VariableNames', {'Sex','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(Sex == 'Female', 1), ModVals(Sex == 'Male', 1))
clear ModVals Descripts p h stats

% 3D sns2face
ModVals = ModelPerf(:,6);
% Descriptives per sex: N, median, IQR
Descripts = table(categories(Sex), N_sex(:,2), round(grpstats(ModVals, Sex, 'median'),2), round(grpstats(ModVals, Sex, 'iqr'),2), ...
    'VariableNames', {'Sex','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(Sex == 'Female', 1), ModVals(Sex == 'Male', 1))
clear ModVals Descripts p h stats

clear N_sex Sex

%% Diagnostic group differences

Diagngrp = table2array(DiscSample_clinvars(:,{'group'}));

AUTdiagn = Diagngrp;
for rr = 1:numel(Diagngrp)
    switch Diagngrp{rr, 1}
        case 'ASD'
            AUTdiagn{rr,1} = 'AUT';
        case 'ID-ASD'
            AUTdiagn{rr,1} = 'AUT';
        case 'ID-control'
            AUTdiagn{rr,1} = 'NoAUT';
        case 'TD'
            AUTdiagn{rr,1} = 'NoAUT';
    end
end
AUTdiagn = categorical(AUTdiagn);
N_AUTgrp = tabulate(AUTdiagn) % check number for each diagnostic group


ModelPerf = [D2_Across_Rhos(1,:)', D2_Out_Face2SNS(1,:)', D2_Out_SNS2Face(1,:)', ...
    D3_Across_Rhos(1,:)', D3_Out_Face2SNS(1,:)', D3_Out_SNS2Face(1,:)'];


% 2D across
ModVals = ModelPerf(:,1);
% Descriptives per diagnosis (autism vs no autism: N, median, IQR
Descripts = table(categories(AUTdiagn), N_AUTgrp(:,2), round(grpstats(ModVals, AUTdiagn, 'median'),2), round(grpstats(ModVals, AUTdiagn, 'iqr'),2), ...
    'VariableNames', {'Diagn','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(AUTdiagn == 'AUT', 1), ModVals(AUTdiagn == 'NoAUT', 1))
clear ModVals Descripts p h stats

% 2D face2sns
ModVals = ModelPerf(:,2);
% Descriptives per diagnosis (autism vs no autism: N, median, IQR
Descripts = table(categories(AUTdiagn), N_AUTgrp(:,2), round(grpstats(ModVals, AUTdiagn, 'median'),2), round(grpstats(ModVals, AUTdiagn, 'iqr'),2), ...
    'VariableNames', {'Diagn','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(AUTdiagn == 'AUT', 1), ModVals(AUTdiagn == 'NoAUT', 1))
clear ModVals Descripts p h stats

% 2D sns2face
ModVals = ModelPerf(:,3);
% Descriptives per diagnosis (autism vs no autism: N, median, IQR
Descripts = table(categories(AUTdiagn), N_AUTgrp(:,2), round(grpstats(ModVals, AUTdiagn, 'median'),2), round(grpstats(ModVals, AUTdiagn, 'iqr'),2), ...
    'VariableNames', {'Diagn','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(AUTdiagn == 'AUT', 1), ModVals(AUTdiagn == 'NoAUT', 1))
clear ModVals Descripts p h stats

% 3D across
ModVals = ModelPerf(:,4);
% Descriptives per diagnosis (autism vs no autism: N, median, IQR
Descripts = table(categories(AUTdiagn), N_AUTgrp(:,2), round(grpstats(ModVals, AUTdiagn, 'median'),2), round(grpstats(ModVals, AUTdiagn, 'iqr'),2), ...
    'VariableNames', {'Diagn','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(AUTdiagn == 'AUT', 1), ModVals(AUTdiagn == 'NoAUT', 1))
clear ModVals Descripts p h stats

% 3D face2sns
ModVals = ModelPerf(:,5);
% Descriptives per diagnosis (autism vs no autism: N, median, IQR
Descripts = table(categories(AUTdiagn), N_AUTgrp(:,2), round(grpstats(ModVals, AUTdiagn, 'median'),2), round(grpstats(ModVals, AUTdiagn, 'iqr'),2), ...
    'VariableNames', {'Diagn','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(AUTdiagn == 'AUT', 1), ModVals(AUTdiagn == 'NoAUT', 1))
clear ModVals Descripts p h stats

% 3D sns2face
ModVals = ModelPerf(:,6);
% Descriptives per diagnosis (autism vs no autism: N, median, IQR
Descripts = table(categories(AUTdiagn), N_AUTgrp(:,2), round(grpstats(ModVals, AUTdiagn, 'median'),2), round(grpstats(ModVals, AUTdiagn, 'iqr'),2), ...
    'VariableNames', {'Diagn','N', 'Median','IQR'})
% Kruskal Wallis test 
[p, h, stats] = ranksum(ModVals(AUTdiagn == 'AUT', 1), ModVals(AUTdiagn == 'NoAUT', 1))
clear ModVals Descripts p h stats

clear N_AUTgrp AUTdiagn Diagngrp






