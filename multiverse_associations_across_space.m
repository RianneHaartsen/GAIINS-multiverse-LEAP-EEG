function [SampleA_plots, SampleB_plots, GrpA_Rholimits, GrpB_Rholimits] = multiverse_associations_across_space(Data_groupspace, IDs_SubjoI, EEGmetrics_SubjoI, ClinVars_t1_t2, VariableofInterest, Y_sp)
% This function calculates the topographical associations between the
% values in the multiverse and 1 external variable (VariableofInterest).
% Figures are created for each sample (sample for building (A) and
% validating (B) the multiverse. 

% created by dr. Rianne Haartsen, Birkbeck College, 07-2026 

% colourscheme for the figures
    ColourScheme_cur = 'parula';

% Get relevant variables from clinical table
    All_RelVars = ClinVars_t1_t2(:,{'subjects',VariableofInterest,'sex','site','AUTdiagn'});

% Minimal sample size to run the correlation
N_min = 15;

%% A) For data in the creating space group
    % find indices for participants in ClinVars
    Disc_grp_Ind = zeros(length(Data_groupspace.Subj_IDs),1);
    for ii = 1:length(Data_groupspace.Subj_IDs)
        Cur_subj = Data_groupspace.Subj_IDs{1,ii};
        for ss = 1:height(All_RelVars)
            if strcmp(Cur_subj, num2str(All_RelVars.subjects(ss)))
                Disc_grp_Ind(ii) =  ss;
            end
        end
        clear ss Cur_subj
    end
    clear ii
    % Create table with Rel variables in the order of the EEG data
    All_RelVals_ordered = All_RelVars(Disc_grp_Ind(1),:);
    for ir = 2:length(Disc_grp_Ind)
        All_RelVals_ordered(ir,:) = All_RelVars(Disc_grp_Ind(ir),:);
    end
    clear ir

    % find indices for those with valid data for the variables of interest
    VoI_valid = table2array(All_RelVals_ordered(:,2));
    VoI_valid(VoI_valid == 999 | VoI_valid == 777 | VoI_valid == 888) = NaN; 
    VoI_valid_Ind = find(~isnan(VoI_valid));
    % clean up datasets
    Multiverse_normvals = Data_groupspace.data_normalised(:,VoI_valid_Ind);
    Other_Vars = All_RelVals_ordered(VoI_valid_Ind, :);

    % Calculate the correlation between each metric and Variable of
    % interest and plot the graph
    SampleA_plots = figure('Position', [793 5 698 860]);

    % A) all
    Corrs = zeros(size(Multiverse_normvals,1),1);
    for rr = 1:size(Multiverse_normvals,1)
        [Curr_corr, ~] = corr([Multiverse_normvals(rr,:)', Other_Vars{:,VariableofInterest}],'type','Spearman','tail','both');
        Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
    end
    % plot 
    subplot(4,3,1)
        scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
        colormap(ColourScheme_cur); 
        clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
        xticks([-1 0 1]); yticks([-1 0 1])
        title(strcat("N_{all} = ", num2str(size(Other_Vars,1))))
    % min and max correlations observed    
        GrpA_Rholimits(1,[1 2 3]) = [size(Other_Vars,1) min(Corrs,[],'all') max(Corrs,[],'all')];
    % clean up 
    clear Corrs rr

    % B) Females
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.sex,'Female')); 
    VoI = Other_Vars(strcmp(Other_Vars.sex,'Female'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,2)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{female} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,2)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{female} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % C) Males
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.sex,'Male')); 
    VoI = Other_Vars(strcmp(Other_Vars.sex,'Male'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,3)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{male} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(3,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,3)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{male} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % D) KCL
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'KCL')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'KCL'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,4)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{KCL} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(4,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,4)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{KCL} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % E) CIMH
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Mannheim')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Mannheim'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,5)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{CIMH} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(5,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,5)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{CIMH} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % F) Nijmegen
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Nijmegen')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Nijmegen'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,6)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{RUMC} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(6,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,6)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{RUMC} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % G) Rome
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Rome')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Rome'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,7)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UCBM} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(7,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,7)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UCBM} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % H) Utrecht
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Utrecht')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Utrecht'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,8)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UMCU} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(8,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,8)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UMCU} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % I) Autism diagnosis
    EEG = Multiverse_normvals(:, Other_Vars.AUTdiagn == 'AUT'); 
    VoI = Other_Vars(Other_Vars.AUTdiagn == 'AUT', :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,10)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled');
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{Autism} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(9,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,10)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{Autism} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % J) No Autism diagnosis
    EEG = Multiverse_normvals(:, Other_Vars.AUTdiagn == 'NoAUT'); 
    VoI = Other_Vars(Other_Vars.AUTdiagn == 'NoAUT', :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,11)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{No Autism} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpA_Rholimits(10,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,11)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{No Autism} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end


    % K) Legend
    % plot 
    subplot(4,3,12)
        scatter(-1:.01:1,-1:.01:1, 15, [-1:.01:1]', 'filled'); 
        colormap(ColourScheme_cur); 
        clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
        a = colorbar; a.Label.String = 'Correlation'; clim([-1, 1])
        xticks([-1 0 1]); yticks([-1 0 1])
        xlabel('Dimension 1'); ylabel('Dimension 2')
        title("Legend")

    % add overall title
    sgtitle({strcat("Topographical associations across the space with ", VariableofInterest),...
        "Building sample"}, 'FontSize', 12)

    clear Disc_grp_Ind All_RelVals_ordered VoI_valid VoI_valid_Ind Multiverse_normvals Other_Vars




%% B) For data in the individuals group
    % find indices for participants in ClinVars
    Disc_ind_Ind = zeros(length(IDs_SubjoI),1);
    for ii = 1:length(IDs_SubjoI)
        Cur_subj = IDs_SubjoI{1,ii};
        for ss = 1:height(ClinVars_t1_t2)
            if strcmp(Cur_subj, num2str(ClinVars_t1_t2.subjects(ss)))
                Disc_ind_Ind(ii) =  ss;
            end
        end
        clear ss Cur_subj
    end
    clear ii
    % Create table with Rel variables in the order of the EEG data
    All_RelVals_ordered = All_RelVars(Disc_ind_Ind(1),:);
    for ir = 2:length(Disc_ind_Ind)
        All_RelVals_ordered(ir,:) = All_RelVars(Disc_ind_Ind(ir),:);
    end
    clear ir

    % find indices for those with valid data for the variables of interest
    VoI_valid = table2array(All_RelVals_ordered(:,2));
    VoI_valid(VoI_valid == 999 | VoI_valid == 777 | VoI_valid == 888) = NaN; 
    VoI_valid_Ind = find(~isnan(VoI_valid));
    % clean up datasets
    Multiverse_normvals = EEGmetrics_SubjoI(:,VoI_valid_Ind);
    Other_Vars = All_RelVals_ordered(VoI_valid_Ind, :);

    % Calculate the correlation between each metric and Variable of
    % interest and plot the graph
    SampleB_plots = figure('Position', [793 5 698 860]);

    % A) all
    Corrs = zeros(size(Multiverse_normvals,1),1);
    for rr = 1:size(Multiverse_normvals,1)
        [Curr_corr, ~] = corr([Multiverse_normvals(rr,:)', Other_Vars{:,VariableofInterest}],'type','Spearman','tail','both');
        Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
    end
    % plot 
    subplot(4,3,1)
        scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
        colormap(ColourScheme_cur); 
        clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
        xticks([-1 0 1]); yticks([-1 0 1])
        title(strcat("N_{all} = ", num2str(size(Other_Vars,1))))
    % min and max correlations observed    
        GrpB_Rholimits(1,[1 2 3]) = [size(Other_Vars,1) min(Corrs,[],'all') max(Corrs,[],'all')];
    % clean up 
    clear Corrs rr

    % B) Females
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.sex,'Female')); 
    VoI = Other_Vars(strcmp(Other_Vars.sex,'Female'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,2)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{female} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(2,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,2)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{female} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % C) Males
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.sex,'Male')); 
    VoI = Other_Vars(strcmp(Other_Vars.sex,'Male'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,3)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{male} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(3,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,3)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{male} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end


    % D) KCL
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'KCL')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'KCL'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,4)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{KCL} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(4,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,4)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{KCL} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % E) CIMH
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Mannheim')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Mannheim'), :);
    if isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,5)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{CIMH} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(5,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,5)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{CIMH} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % F) Nijmegen
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Nijmegen')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Nijmegen'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,6)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{RUMC} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(6,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,6)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{RUMC} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % G) Rome
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Rome')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Rome'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,7)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UCBM} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(7,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,7)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UCBM} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % H) Utrecht
    EEG = Multiverse_normvals(:, strcmp(Other_Vars.site,'Utrecht')); 
    VoI = Other_Vars(strcmp(Other_Vars.site,'Utrecht'), :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,8)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UMCU} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(8,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,8)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{UMCU} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end  

    % I) Autism diagnosis
    EEG = Multiverse_normvals(:, Other_Vars.AUTdiagn == 'AUT'); 
    VoI = Other_Vars(Other_Vars.AUTdiagn == 'AUT', :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,10)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled');
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{Autism} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(9,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,10)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{Autism} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [0 NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end

    % J) No Autism diagnosis
    EEG = Multiverse_normvals(:, Other_Vars.AUTdiagn == 'NoAUT'); 
    VoI = Other_Vars(Other_Vars.AUTdiagn == 'NoAUT', :);
    if ~isempty(VoI) && size(VoI,1) >= N_min % if there is enough data to run correlation
        Corrs = zeros(size(EEG,1),1);
        for rr = 1:size(EEG,1)
            [Curr_corr, ~] = corr([EEG(rr,:)', VoI{:,VariableofInterest}],'type','Spearman','tail','both');
            Corrs(rr,1) = Curr_corr(1,2); clear Curr_corr
        end
        % plot 
        subplot(4,3,11)
            scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs, 'filled'); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{No Autism} = ", num2str(size(VoI,1))))
        % min and max correlations observed    
            GrpB_Rholimits(10,[1 2 3]) = [size(VoI,1) min(Corrs,[],'all') max(Corrs,[],'all')];
        % clean up 
        clear Corrs rr EEG VoI
    else % not enough data
        % plot 
        Corrs = 0;
        if isempty(VoI)
            Ncur = 0;
        else
            Ncur = size(VoI,1);
        end
        subplot(4,3,11)
            scatter(0, 0, 20, Corrs); 
            colormap(ColourScheme_cur); 
            clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
            xticks([-1 0 1]); yticks([-1 0 1])
            title(strcat("N_{No Autism} = ", num2str(Ncur)))
        % min and max correlations observed    
            GrpA_Rholimits(2,[1 2 3]) = [Ncur NaN NaN];
        % clean up 
        clear Corrs EEG VoI Ncur
    end  

    % K) Legend
    % plot 
    subplot(4,3,12)
        scatter(-1:.01:1,-1:.01:1, 15, [-1:.01:1]', 'filled'); 
        colormap(ColourScheme_cur); 
        clim([-1, 1]); xlim([-1, 1]); ylim([-1, 1]); 
        a = colorbar; a.Label.String = 'Correlation'; clim([-1, 1])
        xticks([-1 0 1]); yticks([-1 0 1])
        xlabel('Dimension 1'); ylabel('Dimension 2')
        title("Legend")

    % add overall title
    sgtitle({strcat("Topographical associations across the space with ", VariableofInterest),...
        "Validation sample"}, 'FontSize', 12)

    clear Disc_ind_Ind All_RelVals_ordered VoI_valid VoI_valid_Ind Multiverse_normvals Other_Vars

end
