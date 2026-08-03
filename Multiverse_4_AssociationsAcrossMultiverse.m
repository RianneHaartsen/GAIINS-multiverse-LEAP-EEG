%% GAIINS: Associations with age for metrics in space with sample size threshold

% This script takes the metrics that the space is based on and examines if
% there are any patterns across the 2D space (dim1 vs dim2) with other variables (age,
% cognition, clinical).

% created by dr. Rianne Haartsen, Birkbeck College, 06-2024
% updated to create figures split by sex, site, and diagnosis (07-2026)

%% Prepare the paths and data

clear 
addpath(genpath('xxx'))
cd xxx
addpath xxx/fdr_bh/

% load data for the creating the space group
    load('xxx/01_CreatingSpace/Disc_groupspace_250227.mat','Data_groupspace','Y_sp')
% load data for the validation group
    load Disc_indivspace_250227.mat
    % take out the N=10 used for length scale optimisation
    rng(2302)
    RandIndices = randperm(size(Data_indivspace.Subj_IDs,2), 10);
    SelectInd = true(size(Data_indivspace.Subj_IDs,2),1);
    SelectInd(RandIndices,1) = false;
    
    EEGmetrics_SubjoI = Data_indivspace.data_normalised(:,SelectInd);
    IDs_SubjoI = Data_indivspace.Subj_IDs(1,SelectInd);
    clear SelectInd RandIndices
    
    % get rid of subjects with NaN in their data for consistency
    GOODsubj = find(any(isnan(EEGmetrics_SubjoI),1)==0);
    EEGmetrics_SubjoI = EEGmetrics_SubjoI(:,GOODsubj);
    IDs_SubjoI = IDs_SubjoI(1,GOODsubj);
    clear GOODsubj

% load clinical data
    addpath xxx
    ClinVars_t1_t2 = readtable('LEAP_t1&t2_core_08-02-19_excel.xlsx');
    % convert group data into diagnostic gropu
    Diagngrp = ClinVars_t1_t2.group;

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
    clear rr
    AUTdiagn = categorical(AUTdiagn);
    N_AUTgrp = tabulate(AUTdiagn)

    ClinVars_t1_t2.AUTdiagn = AUTdiagn;

%% Create figures and plots for the topographical associations across the space

% Age 
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'age', Y_sp);
% save the figures
cd /xxx/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_Age_A.png')
saveas(SampleB_plots,'Nmin15_Association_Age_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots


% IQ scales
% FSIQ 
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'fsiq', Y_sp);
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_FSIQ_A.png')
saveas(SampleB_plots,'Nmin15_Association_FSIQ_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots

% VIQ 
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'viq', Y_sp);
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_VIQ_A.png')
saveas(SampleB_plots,'Nmin15_Association_VIQ_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots

% PIQ 
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'piq', Y_sp);
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_PIQ_A.png')
saveas(SampleB_plots,'Nmin15_Association_PIQ_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots


% VABS scales
% Communication
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'vabsdscoresc_dss', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with VABS Communication",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with VABS Communication",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_VABScom_A.png')
saveas(SampleB_plots,'Nmin15_Association_VABScom_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots

% Daily living skills
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'vabsdscoresd_dss', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with VABS Daily Living Skills",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with VABS Daily Living Skills",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_VABSdls_A.png')
saveas(SampleB_plots,'Nmin15_Association_VABSdls_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots

% Socialization
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'vabsdscoress_dss', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with VABS Socialization",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with VABS Socialisation",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_VABSsoc_A.png')
saveas(SampleB_plots,'Nmin15_Association_VABSsoc_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots

% Adaptive Behavior Composite
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'vabsabcabc_standard', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with VABS ABC",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with VABS ABC",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_VABSabc_A.png')
saveas(SampleB_plots,'Nmin15_Association_VABSabc_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots


% Social Responsiveness Scale - Social Communication and Interaction
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'SRS_dsm5_SCI', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with SRS DSM 5 SCI scale",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with SRS DSM 5 SCI scale",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_SRSsci_A.png')
saveas(SampleB_plots,'Nmin15_Association_SRSsci_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots


% Social Responsiveness Scale - Social Communication and Interaction
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'SRS_dsm5_SCI', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with SRS DSM 5 SCI scale",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with SRS DSM 5 SCI scale",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_SRSsci_A.png')
saveas(SampleB_plots,'Nmin15_Association_SRSsci_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots


% Repetitive Behavior Scale - Revised - total scores
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'RBS_total', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with RBS_{total}",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with RBS_{total}",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_RBStot_A.png')
saveas(SampleB_plots,'Nmin15_Association_RBStot_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots


% Short Sensory Profile - total scores
[SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, 'SSP_total', Y_sp);
% correct title
figure(SampleA_plots)
sgtitle({"Topographical associations across the space with SSP_{total}",...
        "Building sample"}, 'FontSize', 12)
figure(SampleB_plots)
sgtitle({"Topographical associations across the space with SSP_{total}",...
        "Validation sample"}, 'FontSize', 12)
% save the figures
cd /Users/riannehaartsen/Documents/000_GAIINS/EEG_data_metrics/04_Associations 
saveas(SampleA_plots,'Nmin15_Association_SSPtot_A.png')
saveas(SampleB_plots,'Nmin15_Association_SSPtot_B.png')
% display min and max correlations
round(GrpA_Rholimits,2)
round(GrpB_Rholimits,2)
clear GrpA_Rholimits GrpB_Rholimits 
close(SampleA_plots); close(SampleB_plots); clear SampleA_plots SampleB_plots



%% Cleanup
clear ClinVars_t1_t2 ColourScheme_cur Data_groupspace Data_indivspace EEGmetrics_SubjoI IDs_SubjoI Y_sp
clear AUTdiagn Diagngrp N_AUTgrp
close all