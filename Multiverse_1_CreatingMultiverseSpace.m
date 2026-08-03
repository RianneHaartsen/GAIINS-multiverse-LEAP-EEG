%% EEG multiverse space: Creating the space

% This script creates the multiverse space with all the EEG metrics. 
% It takes half of the discovery sample, then culates the distances between the metrics,
% and finally applies multidimensional scaling. 

% Input data: 
% DATA_EEG structure with the following fields:
%   - EEG_DATA.Subj_ID: subject identification numbers in cells (size 1-by-N)
%   - EEG_DATA.EEG_names: names of the EEG metrics (size E-by-1)
%   - EEG_DATA.data_EEGxSubj: values of the EEG metrics where each row is a
%   different metric and each column a different subject (size E-by-N)


% created by dr. Rianne Haartsen, Birkbeck College, 01-2024

%% 1) Add folders and load the data
% add folders and paths
clear 
addpath('xxx/01_CreatingSpace')
cd xxx

% load EEG data metrics
load Data_space_250227.mat

% randomly select half of sample for building the EEG multiverse space
rng(2201)
RandIndices = randperm(size(DATA_EEG.Subj_ID,2), round(size(DATA_EEG.Subj_ID,2)/2));

Data_groupspace.data = DATA_EEG.data_EEGxSubj(:,RandIndices);
Data_groupspace.Subj_IDs = DATA_EEG.Subj_ID(1,RandIndices);
Data_groupspace.EEG_names = DATA_EEG.EEG_names;
clear DATA_EEG RandIndices

% normalise the data and save the mean and standard deviation for further
% analyses
[DataNormA,C,S] = normalize(Data_groupspace.data');
Data_groupspace.data_normalised = DataNormA';
Data_groupspace.Normpara_C = C;
Data_groupspace.Normpara_S = S;
save('Disc_groupspace_250227.mat','Data_groupspace')


%% 2) Calculate the distances between metrics and create the multiverse space
% Spearman distance matrix
D_sp = pdist(Data_groupspace.data_normalised, 'spearman');
    Dsq_sp = squareform(D_sp);
Distmat = figure; 
    imagesc(Dsq_sp)
    xtickangle(45)
    xticks(1:5:size(Dsq_sp,1))
    xticklabels(Data_groupspace.EEG_names(1:5:end,1))
    yticks(1:5:size(Dsq_sp,1))
    yticklabels(Data_groupspace.EEG_names(1:5:end,1))
    a = colorbar; a.Label.String = 'Spearman distance';
    title('Group space: FaceERP and SNS videos distance matrix')

% distance matrix spearman - normalised values
[Y_sp,eigvals_sp] = cmdscale(D_sp);
format short g
[eigvals_sp eigvals_sp/max(abs(eigvals_sp))] % check if eigenvalues are decreasing
    
% save data
save('Disc_groupspace_240222.mat','Data_groupspace', 'Dsq_sp','eigvals_sp','Y_sp')

%% 3) Visualisations of MDS space 

% 2D - dimension 1 and 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% with labels, all tasks
MDSspace_2D_d1_d2 = figure;
    MrkSize = 10; %6 default
% Face ERP task
    Face_ind = 1:1:146;
    Dim1_face = Y_sp(Face_ind,1);
    Dim2_face = Y_sp(Face_ind,2);
    Face_names = Data_groupspace.EEG_names(Face_ind,1);
    
    MrkColours_Face = colormap(bone(size(Face_ind,2)));
    % plot first point
    plot(Dim1_face(1,1),Dim2_face(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(1,:))
    text(Dim1_face(1,1)+0.01,Dim2_face(1,1),Face_names{1,1},"FontSize",14,"FontName","Arial")
    hold on
    for ii = 2:size(Dim1_face,1)
        if contains(Data_groupspace.EEG_names{ii},'tpc')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii},'Th') || contains(Data_groupspace.EEG_names{ii},'Al')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii},'ERO')
            Mrkr_shape = '^';
        else
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(ii,:))
        % add lavel
        text(Dim1_face(ii,1)+0.01,Dim2_face(ii,1),Face_names{ii,1},"FontSize",14,"FontName","Arial")
    end
% SNS vids
    SNS_ind = 147:1:382;
    Dim1_sns = Y_sp(SNS_ind,1);
    Dim2_sns = Y_sp(SNS_ind,2);
    SNS_names = Data_groupspace.EEG_names(SNS_ind,1);
    MrkColours_SNS = colormap(pink(size(SNS_ind,2)));
    % plot first point
    plot(Dim1_sns(1,1),Dim2_sns(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(1,:))
    hold on
    for ii = 2:size(Dim1_sns,1)
        if contains(Data_groupspace.EEG_names{ii+146},'SNs N')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii+146},'clp') 
            Mrkr_shape = '<';
        elseif contains(Data_groupspace.EEG_names{ii+146},'ilp')
            Mrkr_shape = '>';
        elseif contains(Data_groupspace.EEG_names{ii+146},'crp')
            Mrkr_shape = '^';
        elseif contains(Data_groupspace.EEG_names{ii+146},'cap')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc dbWPLI')
            Mrkr_shape = 'pentagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc WPLI')
            Mrkr_shape = 'o';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc PLI')
            Mrkr_shape = 'hexagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc ubPLI')
            Mrkr_shape = 'diamond';
        elseif contains(Data_groupspace.EEG_names{ii+146},'1f')
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(ii,:))
        % add label
        text(Dim1_sns(ii,1)+0.01,Dim2_sns(ii,1),SNS_names{ii,1},"FontSize",14,"FontName","Arial")
    end
    
    legend(Data_groupspace.EEG_names, 'Location','bestoutside','NumColumns',5)
    xlabel('Dimension 1')
    ylabel('Dimension 2')
    xlim([-1 1])
    ylim([-1 1])
   
    title('Group space: EEG space for FaceERP and SNS videos - LEAP subsample; N = 120')

% 2D - dimension 1 and 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Face ERP task only
MDSspace_2D_d1_d2_FaceERP = figure;
    MrkSize = 10; %6 default
    Face_ind = 1:1:146;
    Dim1_face = Y_sp(Face_ind,1);
    Dim2_face = Y_sp(Face_ind,2);
    % Face ERP task
    MrkColours_Face = colormap(bone(size(Face_ind,2)));
    % plot first point
    plot(Dim1_face(1,1),Dim2_face(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(1,:))
    hold on
    for ii = 2:size(Dim1_face,1)
        if contains(Data_groupspace.EEG_names{ii},'tpc')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii},'Th') || contains(Data_groupspace.EEG_names{ii},'Al')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii},'ERO')
            Mrkr_shape = '^';
        else
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(ii,:))
    end
    legend(Data_groupspace.EEG_names, 'Location','bestoutside','NumColumns',5)
    xlabel('Dimension 1')
    ylabel('Dimension 2')
    xlim([(min(Y_sp(:,1))-.1),(max(Y_sp(:,1))+.1)])
    ylim([(min(Y_sp(:,2))-.1),(max(Y_sp(:,2))+.1)])
    title('Group space: EEG space for FaceERP - LEAP subsample; N = 120')

% 2D - dimension 1 and 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Social - Non-social videos only
MDSspace_2D_d1_d2_SNS = figure;
    MrkSize = 10; %6 default
    SNS_ind = 147:1:382;
    Dim1_sns = Y_sp(SNS_ind,1);
    Dim2_sns = Y_sp(SNS_ind,2);
    MrkColours_SNS = colormap(pink(size(SNS_ind,2)));
    % plot first point
    plot(Dim1_sns(1,1),Dim2_sns(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(1,:))
    hold on
    for ii = 2:size(Dim1_sns,1)
        if contains(Data_groupspace.EEG_names{ii+146},'SNs N')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii+146},'clp') 
            Mrkr_shape = '<';
        elseif contains(Data_groupspace.EEG_names{ii+146},'ilp')
            Mrkr_shape = '>';
        elseif contains(Data_groupspace.EEG_names{ii+146},'crp')
            Mrkr_shape = '^';
        elseif contains(Data_groupspace.EEG_names{ii+146},'cap')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc dbWPLI')
            Mrkr_shape = 'pentagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc WPLI')
            Mrkr_shape = 'o';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc PLI')
            Mrkr_shape = 'hexagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc ubPLI')
            Mrkr_shape = 'diamond';
        elseif contains(Data_groupspace.EEG_names{ii+146},'1f')
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(ii,:))
    end
    legend(Data_groupspace.EEG_names{147:382}, 'Location','bestoutside','NumColumns',5)
    xlabel('Dimension 1')
    ylabel('Dimension 2')
    xlim([(min(Y_sp(:,1))-.1),(max(Y_sp(:,1))+.1)])
    ylim([(min(Y_sp(:,2))-.1),(max(Y_sp(:,2))+.1)])
    title('Group space: EEG space for SNS videos - LEAP subsample; N = 120')

% 2D - dimension 2 and 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% both tasks
MDSspace2D_2vs3 = figure;
    MrkSize = 10; %6 default
% Face ERP task
    Face_ind = 1:1:146;
    Dim1_face = Y_sp(Face_ind,2);
    Dim2_face = Y_sp(Face_ind,3);
    MrkColours_Face = colormap(bone(size(Face_ind,2)));
    % plot first point
    plot(Dim1_face(1,1),Dim2_face(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(1,:))
    hold on
    for ii = 2:size(Dim1_face,1)
        if contains(Data_groupspace.EEG_names{ii},'tpc')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii},'Th') || contains(Data_groupspace.EEG_names{ii},'Al')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii},'ERO')
            Mrkr_shape = '^';
        else
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(ii,:))
    end
% SNS vids
    SNS_ind = 147:1:382;
    Dim1_sns = Y_sp(SNS_ind,2);
    Dim2_sns = Y_sp(SNS_ind,3);
    MrkColours_SNS = colormap(pink(size(SNS_ind,2)));
    % plot first point
    plot(Dim1_sns(1,1),Dim2_sns(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(1,:))
    hold on
    for ii = 2:size(Dim1_sns,1)
        if contains(Data_groupspace.EEG_names{ii+146},'SNs N')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii+146},'clp') 
            Mrkr_shape = '<';
        elseif contains(Data_groupspace.EEG_names{ii+146},'ilp')
            Mrkr_shape = '>';
        elseif contains(Data_groupspace.EEG_names{ii+146},'crp')
            Mrkr_shape = '^';
        elseif contains(Data_groupspace.EEG_names{ii+146},'cap')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc dbWPLI')
            Mrkr_shape = 'pentagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc WPLI')
            Mrkr_shape = 'o';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc PLI')
            Mrkr_shape = 'hexagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc ubPLI')
            Mrkr_shape = 'diamond';
        elseif contains(Data_groupspace.EEG_names{ii+146},'1f')
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(ii,:))
    end
    legend(Data_groupspace.EEG_names, 'Location','bestoutside','NumColumns',5)
    xlabel('Dimension 2')
    ylabel('Dimension 3')
    xlim([(min(Y_sp(:,2))-.1),(max(Y_sp(:,2))+.1)])
    ylim([(min(Y_sp(:,3))-.1),(max(Y_sp(:,3))+.1)])
    title('Group space: EEG space for FaceERP and SNS videos - LEAP subsample; N = 120')


% 2D - dimension 1 and 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% both tasks
MDSspace2D_1vs3 = figure;
    MrkSize = 10; %6 default
% Face ERP task
    Face_ind = 1:1:146;
    Dim1_face = Y_sp(Face_ind,1);
    Dim2_face = Y_sp(Face_ind,3);
    MrkColours_Face = colormap(bone(size(Face_ind,2)));
    % plot first point
    plot(Dim1_face(1,1),Dim2_face(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(1,:))
    hold on
    for ii = 2:size(Dim1_face,1)
        if contains(Data_groupspace.EEG_names{ii},'tpc')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii},'Th') || contains(Data_groupspace.EEG_names{ii},'Al')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii},'ERO')
            Mrkr_shape = '^';
        else
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(ii,:))
    end
% SNS vids
    SNS_ind = 147:1:382;
    Dim1_sns = Y_sp(SNS_ind,1);
    Dim2_sns = Y_sp(SNS_ind,3);
    MrkColours_SNS = colormap(pink(size(SNS_ind,2)));
    % plot first point
    plot(Dim1_sns(1,1),Dim2_sns(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(1,:))
    hold on
    for ii = 2:size(Dim1_sns,1)
        if contains(Data_groupspace.EEG_names{ii+146},'SNs N')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii+146},'clp') 
            Mrkr_shape = '<';
        elseif contains(Data_groupspace.EEG_names{ii+146},'ilp')
            Mrkr_shape = '>';
        elseif contains(Data_groupspace.EEG_names{ii+146},'crp')
            Mrkr_shape = '^';
        elseif contains(Data_groupspace.EEG_names{ii+146},'cap')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc dbWPLI')
            Mrkr_shape = 'pentagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc WPLI')
            Mrkr_shape = 'o';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc PLI')
            Mrkr_shape = 'hexagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc ubPLI')
            Mrkr_shape = 'diamond';
        elseif contains(Data_groupspace.EEG_names{ii+146},'1f')
            Mrkr_shape = 'o';
        end
        % plot value
        plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(ii,:))
    end
    legend(Data_groupspace.EEG_names, 'Location','bestoutside','NumColumns',5)
    xlabel('Dimension 1')
    ylabel('Dimension 3')
    xlim([(min(Y_sp(:,1))-.1),(max(Y_sp(:,1))+.1)])
    ylim([(min(Y_sp(:,3))-.1),(max(Y_sp(:,3))+.1)])
    title('Group space: EEG space for FaceERP and SNS videos - LEAP subsample; N = 120')


% 3D - dimensions 1, 2, and 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% both tasks
MDSspace3D = figure;
    MrkSize = 10; %6 default
% Face ERP task
    Face_ind = 1:1:146;
    Dim1_face = Y_sp(Face_ind,1);
    Dim2_face = Y_sp(Face_ind,2);
    Dim3_face = Y_sp(Face_ind,3);
    MrkColours_Face = colormap(bone(size(Face_ind,2)));
    % plot first point
    plot3(Dim1_face(1,1), Dim2_face(1,1), Dim3_face(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(1,:))
    hold on
    for ii = 2:size(Dim1_face,1)
        if contains(Data_groupspace.EEG_names{ii},'tpc')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii},'Th') || contains(Data_groupspace.EEG_names{ii},'Al')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii},'ERO')
            Mrkr_shape = '^';
        else
            Mrkr_shape = 'o';
        end
        % plot value
        plot3(Dim1_face(ii,1),Dim2_face(ii,1), Dim3_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
        'MarkerFaceColor', MrkColours_Face(ii,:))
    end
% SNS vids
    SNS_ind = 147:1:382;
    Dim1_sns = Y_sp(SNS_ind,1);
    Dim2_sns = Y_sp(SNS_ind,2);
    Dim3_sns = Y_sp(SNS_ind,3);
    MrkColours_SNS = colormap(pink(size(SNS_ind,2)));
    % plot first point
    plot3(Dim1_sns(1,1), Dim2_sns(1,1), Dim3_sns(1,1), 'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(1,:))
    hold on
    for ii = 2:size(Dim1_sns,1)
        if contains(Data_groupspace.EEG_names{ii+146},'SNs N')
            Mrkr_shape = 'square';
        elseif contains(Data_groupspace.EEG_names{ii+146},'clp') 
            Mrkr_shape = '<';
        elseif contains(Data_groupspace.EEG_names{ii+146},'ilp')
            Mrkr_shape = '>';
        elseif contains(Data_groupspace.EEG_names{ii+146},'crp')
            Mrkr_shape = '^';
        elseif contains(Data_groupspace.EEG_names{ii+146},'cap')
            Mrkr_shape = 'v';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc dbWPLI')
            Mrkr_shape = 'pentagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc WPLI')
            Mrkr_shape = 'o';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc PLI')
            Mrkr_shape = 'hexagram';
        elseif contains(Data_groupspace.EEG_names{ii+146},'fc ubPLI')
            Mrkr_shape = 'diamond';
        elseif contains(Data_groupspace.EEG_names{ii+146},'1f')
            Mrkr_shape = 'o';
        end
        % plot value
        plot3(Dim1_sns(ii,1), Dim2_sns(ii,1), Dim3_sns(ii,1), 'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(ii,:))
    end
    legend(Data_groupspace.EEG_names, 'Location','bestoutside','NumColumns',5)
    xlabel('Dimension 1')
    ylabel('Dimension 2')
    zlabel('Dimension 3')
    xlim([(min(Y_sp(:,1))-.1),(max(Y_sp(:,1))+.1)])
    ylim([(min(Y_sp(:,2))-.1),(max(Y_sp(:,2))+.1)])
    zlim([(min(Y_sp(:,3))-.1),(max(Y_sp(:,3))+.1)])
    grid on
    title('Group space: EEG space for FaceERP and SNS videos - LEAP subsample; N = 120')

%% Movie of 3D plot rotating
% Define time points
t = linspace(0, 2*pi, 100);

% Create VideoWriter object
v = VideoWriter('Disc_groupspace_3D_240229_video.mp4','MPEG-4'); % Specify the name of the output video file
v.FrameRate = 10; % Set the frame rate (frames per second)
open(v); % Open the VideoWriter object

% Figure parameters
    MrkSize = 10; %6 default
    % Face ERP task
    Face_ind = 1:1:146;
    Dim1_face = Y_sp(Face_ind,1);
    Dim2_face = Y_sp(Face_ind,2);
    Dim3_face = Y_sp(Face_ind,3);
    MrkColours_Face = colormap(bone(size(Face_ind,2)));
    % Soc/ nsoc videos
    SNS_ind = 147:1:382;
    Dim1_sns = Y_sp(SNS_ind,1);
    Dim2_sns = Y_sp(SNS_ind,2);
    Dim3_sns = Y_sp(SNS_ind,3);
    MrkColours_SNS = colormap(pink(size(SNS_ind,2)));

% Create and capture frames of the 3D plot
for i = 1:length(t)
    % Generate your 3D plot here
    figure('Position',[342 149 1045 711]);
        % FaceERP
            plot3(Dim1_face(1,1), Dim2_face(1,1), Dim3_face(1,1),'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_Face(73,:),...
                'MarkerFaceColor', MrkColours_Face(1,:))
            hold on
            for ii = 2:size(Dim1_face,1)
                if contains(Data_groupspace.EEG_names{ii},'tpc')
                    Mrkr_shape = 'square';
                elseif contains(Data_groupspace.EEG_names{ii},'Th') || contains(Data_groupspace.EEG_names{ii},'Al')
                    Mrkr_shape = 'v';
                elseif contains(Data_groupspace.EEG_names{ii},'ERO')
                    Mrkr_shape = '^';
                else
                    Mrkr_shape = 'o';
                end
                % plot value
                plot3(Dim1_face(ii,1),Dim2_face(ii,1), Dim3_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                'MarkerFaceColor', MrkColours_Face(ii,:))
            end
        % SNS vids
            plot3(Dim1_sns(1,1), Dim2_sns(1,1), Dim3_sns(1,1), 'Marker','square','MarkerSize', MrkSize,'Color', MrkColours_SNS(118,:),...
                'MarkerFaceColor', MrkColours_SNS(1,:))
            hold on
            for ii = 2:size(Dim1_sns,1)
                if contains(Data_groupspace.EEG_names{ii+146},'SNs N')
                    Mrkr_shape = 'square';
                elseif contains(Data_groupspace.EEG_names{ii+146},'clp') 
                    Mrkr_shape = '<';
                elseif contains(Data_groupspace.EEG_names{ii+146},'ilp')
                    Mrkr_shape = '>';
                elseif contains(Data_groupspace.EEG_names{ii+146},'crp')
                    Mrkr_shape = '^';
                elseif contains(Data_groupspace.EEG_names{ii+146},'cap')
                    Mrkr_shape = 'v';
                elseif contains(Data_groupspace.EEG_names{ii+146},'fc dbWPLI')
                    Mrkr_shape = 'pentagram';
                elseif contains(Data_groupspace.EEG_names{ii+146},'fc WPLI')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'fc PLI')
                    Mrkr_shape = 'hexagram';
                elseif contains(Data_groupspace.EEG_names{ii+146},'fc ubPLI')
                    Mrkr_shape = 'diamond';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1f')
                    Mrkr_shape = 'o';
                end
                % plot value
                plot3(Dim1_sns(ii,1), Dim2_sns(ii,1), Dim3_sns(ii,1), 'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                'MarkerFaceColor', MrkColours_SNS(ii,:))
            end
        xlabel('Dimension 1')
        ylabel('Dimension 2')
        zlabel('Dimension 3')
        xlim([(min(Y_sp(:,1))-.1),(max(Y_sp(:,1))+.1)])
        ylim([(min(Y_sp(:,2))-.1),(max(Y_sp(:,2))+.1)])
        zlim([(min(Y_sp(:,3))-.1),(max(Y_sp(:,3))+.1)])
        grid on
        title('Group space: rotating 3D plot')
    % Rotate the view
        view(30+i, 30+i); 
    % Capture the frame and write it to the video
        frame = getframe(gcf);
        writeVideo(v, frame);
    % Close the current figure to avoid clutter
    close(gcf);
end

% Close the VideoWriter object
close(v);


