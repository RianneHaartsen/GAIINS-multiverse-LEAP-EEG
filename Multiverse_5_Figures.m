%% EEG multiverse space: Figures for the main manuscript

% This script takes previously created data and created pretty figures for
% writing up the results. 

% created by dr. Rianne Haartsen, Birkbeck College, 06-2024
% updated 03-2025

%% Load data
load('xxx/01_CreatingSpace/Disc_groupspace_240222.mat',...
    'Y_sp','Data_groupspace')

%% Figure 2: The EEG multiverse map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Overview of the space (top of figure 2)
% coded/ informative, different gradients colour for tasks 
FullSpaceFigure = figure;
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
    
    % SNS vids
    SNS_ind = 147:1:414;
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
        elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
            Mrkr_shape = '*';
        elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
            Mrkr_shape = 'o';
        elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
            Mrkr_shape = 'pentagram';
        end
        % plot value
        plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
        'MarkerFaceColor', MrkColours_SNS(ii,:))
    end
    xlabel('Dimension 1')
    ylabel('Dimension 2')
    xlim([-1 1])
    ylim([-1 1])
    axis square
    grid off
    
    legend(Data_groupspace.EEG_names, 'Location','bestoutside','NumColumns',5)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For figure insets / zooming in at 5 different areas (bottom of figure 2)

% Figure of the multiverse in the middle:
    FullSpaceFigure2 = figure;
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
        
        % SNS vids
            SNS_ind = 147:1:414;
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                % plot value
                plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                'MarkerFaceColor', MrkColours_SNS(ii,:))
            end
        xlabel('Dimension 1')
        ylabel('Dimension 2')
        xlim([-1 1])
        ylim([-1 1])
        axis square
        grid off
        
        % add in rectangles
        %A3) empty space top left: [x y w h]:x = -.70:-.18, y = .29:.72
        rectangle('Position',[-.70 .29 (.72-.18) (.72-.29)]) 
        %B4) SNS and FERP mix top right: x = .24:.51, y = .25:.405
        rectangle('Position',[.24 .25 (.51-.24) (.405-.25)])
        %C1) centre: [x y w h]: x = -.26:-.12, y = -.085:-.02
        rectangle('Position',[-.26 -.085 (.26-.12) (.085-.02)]) 
        %D2) cluster SNS bottom: [x y w h]: x = -.14:.063, y = -.62:-.555
        rectangle('Position',[-0.14 -.62 (.063+.14) (.62-.555)]) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inset A) empty space top left: [x y w h]:x = -.70:-.18, y = .29:.72
    ValXmin = -.70; ValXmax = -.18;
    ValYmin = .29; ValYmax = .72;

    % with labels
    ZoomIn_A = figure;
        MrkSize = 10; %6 default
        Face_ind = 1:1:146;
        Face_names = Data_groupspace.EEG_names(1:146,1);
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                     text(Dim1_face(ii,1)+0.01,Dim2_face(ii,1),Face_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
            SNS_names = Data_groupspace.EEG_names(SNS_ind,1);
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                    text(Dim1_sns(ii,1)+0.01,Dim2_sns(ii,1),SNS_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])

    % without labels
    ZoomIn_Ab = figure;
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inset B) SNS and FaceERP mix top right: x = .24:.51, y = .25:.405
    ValXmin = .24; ValXmax = .51;
    ValYmin = .25; ValYmax = .405;
    
    % with labels
    ZoomIn_B = figure;
        MrkSize = 10; %6 default
        Face_ind = 1:1:146;
        Face_names = Data_groupspace.EEG_names(1:146,1);
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                     text(Dim1_face(ii,1)+0.01,Dim2_face(ii,1),Face_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
            SNS_names = Data_groupspace.EEG_names(SNS_ind,1);
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                    text(Dim1_sns(ii,1)+0.01,Dim2_sns(ii,1),SNS_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])

    % without labels
    ZoomIn_Bb = figure;
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
% Inset C) mix SNS and FaceERP: [x y w h]: x = -.26:-.12, y = -.085:-.02
    ValXmin = -.26; ValXmax = -.12;
    ValYmin = -.085; ValYmax = -.02;

    % with labels
    ZoomIn_C = figure;
        MrkSize = 10; %6 default
        Face_ind = 1:1:146;
        Face_names = Data_groupspace.EEG_names(1:146,1);
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                     text(Dim1_face(ii,1)+0.01,Dim2_face(ii,1),Face_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
            SNS_names = Data_groupspace.EEG_names(SNS_ind,1);
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                    text(Dim1_sns(ii,1)+0.01,Dim2_sns(ii,1),SNS_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])

    % without labels
    ZoomIn_Cb = figure;
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inset D) cluster SNS bottom: [x y w h]: x = -.14:.063, y = -.62:-.555
    ValXmin = -.14; ValXmax = .063;
    ValYmin = -.62; ValYmax = -.555;

    % with labels
    ZoomIn_D = figure;
        MrkSize = 10; %6 default
        Face_ind = 1:1:146;
        Face_names = Data_groupspace.EEG_names(1:146,1);
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                     text(Dim1_face(ii,1)+0.01,Dim2_face(ii,1),Face_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
            SNS_names = Data_groupspace.EEG_names(SNS_ind,1);
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                    text(Dim1_sns(ii,1)+0.01,Dim2_sns(ii,1),SNS_names{ii,1},"FontSize",14,"FontName","Arial")
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])

    % without labels
    ZoomIn_Db = figure;
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
                if Dim1_face(ii,1) < ValXmax && Dim1_face(ii,1) > ValXmin && ...
                        Dim2_face(ii,1) < ValYmax && Dim2_face(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_face(ii,1),Dim2_face(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_Face(73,:),...
                    'MarkerFaceColor', MrkColours_Face(ii,:))
                end
            end
        % SNS vids
            SNS_ind = 147:1:414;
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
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f int')
                    Mrkr_shape = '*';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f sl')
                    Mrkr_shape = 'o';
                elseif contains(Data_groupspace.EEG_names{ii+146},'1/f IAP')
                    Mrkr_shape = 'pentagram';
                end
                if Dim1_sns(ii,1) < ValXmax && Dim1_sns(ii,1) > ValXmin && ...
                        Dim2_sns(ii,1) < ValYmax && Dim2_sns(ii,1) > ValYmin
                    % plot value
                    plot(Dim1_sns(ii,1),Dim2_sns(ii,1),'Marker',Mrkr_shape,'MarkerSize', MrkSize,'Color',MrkColours_SNS(118,:),...
                    'MarkerFaceColor', MrkColours_SNS(ii,:))
                end
            end
        xlim([ValXmin ValXmax]); ylim([ValYmin ValYmax])




%% SI Figure 1: Space with labels

MDSspace_labels = figure;
plot(Y_sp(:,1),Y_sp(:,2),'.')
text(Y_sp(:,1)+0.001,Y_sp(:,2),Data_groupspace.EEG_names')
xlabel('Dimension 1')
ylabel('Dimension 2')
title('Group space: MDS space from Spearman distance matrix for FaceERP and SNS videos')





%% Figure 3. Examples of individualised models for 6 participants 

% Exploration of fitting to pick out images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd xxx/02_ValidatingSpace 
% extract predictions across 2D space for across tasks  
load('Disc_Modeltesting_acrosstasks_Ntest50.mat','GPR_models','Corrs_fit')

% create grid for predictions
    x1 = linspace(-1, 1, 100); % 100 points along the x-axis
    x2 = linspace(-1, 1, 100); % 100 points along the y-axis
    [X1, X2] = meshgrid(x1, x2);
    gridPoints = [X1(:), X2(:)]; % Combine the grid points
    clear x1 x2 X1 X2
% get the model and plot the predicted images
    for ii = 1:length(GPR_models)
        % get current GPR model
        gprMdl_cur = GPR_models{1,ii};
        % calculate predicted values across the space 
        [predictions, ~] = predict(gprMdl_cur, gridPoints); % Evaluate the predictions
    
        % plot data
        FigurePredictions = figure('Menubar','none', 'ToolBar','none', 'Position', [1107 625 342 292]);
        scatter(gridPoints(:, 1), gridPoints(:, 2), [], predictions, 'filled');
        colormap("jet")
        colorbar; xlabel('X'); ylabel('Y'); 
        subtitle(strcat('Model - Ind:', num2str(ii), ' r=', num2str(Corrs_fit(1,ii))))
        % save the figure
        cd xxx/02_ValidatingSpace/Individual_ModelPredictions
        saveas(FigurePredictions, strcat('AcrossTasks_Ind', num2str(ii),'.png'))
        close(FigurePredictions)
    
        % clean up
        clear gprMdl_cur predictions FigurePredictions
    end
    
    clear GPR_models ii Corrs_fit


% Final images for figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% panel with model, panel with model + EEG metrics

% Load data for test and training of model
% normalise the EEG data in the sample relative to the m and sd from the
% group space with 1/2 discovery sample
cd xxx/01_CreatingSpace
load('Disc_groupspace_250227.mat','Y_sp')
% individual data other 1/f discovery sample
load Disc_indivspace_250227.mat

    % get the space coordinates
    X_spacepoints = Y_sp(:, [1 2]);
    % clear up
    clear C S Data_groupspace DataNormA DataNormB Dsq_sp eigvals_sp Y_sp
    
    % take out the N=10 used for length scale optimisation
    rng(2302)
    RandIndices = randperm(size(Data_indivspace.Subj_IDs,2), 10);
    SelectInd = true(size(Data_indivspace.Subj_IDs,2),1);
    SelectInd(RandIndices,1) = false;
    EEGmetrics_SubjoI = Data_indivspace.data_normalised(:,SelectInd);
    EEGmetrics_SubjoI_IDs = Data_indivspace.Subj_IDs(:,SelectInd);
    clear SelectInd RandIndices
    % and take out individual with NaNs
    GOODsubj = find(any(isnan(EEGmetrics_SubjoI),1)==0);
    EEGmetrics_SubjoI_all = EEGmetrics_SubjoI;
    EEGmetrics_SubjoI = EEGmetrics_SubjoI(:,GOODsubj);
   
    % get indices for test and training data
    Ntot = size(EEGmetrics_SubjoI,1); Ntest = 50; Ntrain = 200;
    rng(2302)
    Rand_ind = randperm(size(EEGmetrics_SubjoI,1), Ntot);


for ii = [4, 10, 35, 45, 77, 89, 94, 96, 97] 

    disp(strcat('Subject: ', num2str(ii)))

    % select test and train data for later plotting
    Y_dataIndiv_test = EEGmetrics_SubjoI(Rand_ind(1,1:Ntest),ii);
    X_space_test = X_spacepoints(Rand_ind(1,1:Ntest),:);
    Y_dataIndiv_train = EEGmetrics_SubjoI(Rand_ind(1,(Ntest+1):(Ntrain+Ntest)),ii);
    X_space_train = X_spacepoints(Rand_ind(1,(Ntest+1):(Ntrain+Ntest)),:);

    
    % get current GPR model
    gprMdl_cur = GPR_models{1,ii};
    % calculate predicted values across the space 
    [predictions, ~] = predict(gprMdl_cur, gridPoints); % Evaluate the predictions

    % plot data
    FigurePredictions = figure('Menubar','none', 'ToolBar','none', 'Position', [165 581 791 290]);
    
    subplot(1,2,1) % model of metrics across space
    scatter(gridPoints(:, 1), gridPoints(:, 2), [], predictions, 'filled');
    colormap('parula')
    c = colorbar; c.Label.String = 'Normalised EEG metric value';
    xlabel('Dimension 1'); ylabel('Dimension 2'); 
    xticks(-1:1:1); yticks(-1:1:1);

    subplot(1,2,2) % model of metrics across space with train and test values
    scatter(gridPoints(:, 1), gridPoints(:, 2), [], predictions, 'filled');
    hold on
    scatter(X_space_train(:,1),X_space_train(:,2),[],Y_dataIndiv_train,'filled','o','MarkerEdgeColor','w') % train data
    scatter(X_space_test(:,1),X_space_test(:,2),[],Y_dataIndiv_test,'filled','o','MarkerEdgeColor','k') % test data
    hold off
    colormap('parula')
    c = colorbar; c.Label.String = 'Normalised EEG metric value';
    xlabel('Dimension 1'); ylabel('Dimension 2'); 
    xticks(-1:1:1); yticks(-1:1:1);


    sgtitle(strcat('Model - Ind:', num2str(ii), ' r=', num2str(Corrs_fit(1,ii))))

    % save the figure
    cd /Users/riannehaartsen/Documents/000_GAIINS/FiguresPaper/Sources
    print(FigurePredictions,strcat('AcrossTasks_Ind', num2str(ii)), '-dtiffn', '-r300');
    close(FigurePredictions)

    % clean up
    clear gprMdl_cur predictions FigurePredictions c 
    clear Y_dataIndiv_test X_space_test Y_dataIndiv_train X_space_train 

end % end loop subjects

clear Corrs_fit GPR_models Ntest Ntot Ntrain Obs_EEGvals Pred_EEGvals Rand_ind ii
clear gridPoints Data_indivspace EEGmetrics_SubjoI X_spacepoints






%% Figure 4. Model performance to validate the space.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This figure is made using raincloud plots. The code for this can be found
% at:
% Allen, M., Poggiali, D., Whitaker, K., Marshall, T. R., van Langen, J., & Kievit, R. A.
%     Raincloud plots: a multi-platform tool for robust data visualization [version 2; peer review: 2 approved] 
%     Wellcome Open Research 2021, 4:63. https://doi.org/10.12688/wellcomeopenres.15191.2

% add path for raincloud plots
addpath xxx/RainCloudPlots-master/tutorial_matlab

% load data
    cd xxx/02_ValidatingSpace/
    % 2D
    load('Disc_Modeltesting_acrosstasks_Ntest50.mat','Corrs_fit')
    AcrossTasks_Rhos = Corrs_fit(1,:); clear Corrs_fit
    load('Disc_Modeltesting_OutofTask_TestFaceERP.mat','Corrs_fit')
    TestFaceERP_Rhos = Corrs_fit(1,:); clear Corrs_fit
    load('Disc_Modeltesting_OutofTask_TestSNSvids.mat','Corrs_fit')
    TestSNSvids_Rhos = Corrs_fit(1,:); clear Corrs_fit
    % 3D
    load('Disc_Modeltesting3D_acrosstasks_Ntest50.mat','Corrs_fit')
    AcrossTasks_Rhos3D = Corrs_fit(1,:); clear Corrs_fit
    
    load('Disc_Modeltesting3D_OutofTask_TestFaceERP.mat','Corrs_fit')
    TestFaceERP_Rhos3D = Corrs_fit(1,:); clear Corrs_fit
    
    load('Disc_Modeltesting3D_OutofTask_TestSNSvids.mat','Corrs_fit')
    TestSNSvids_Rhos3D = Corrs_fit(1,:); clear Corrs_fit

% Plot the data
ModelPerformance = figure('Position',[-1272 655 1252 756],'Toolbar','none');
% 2D
s1 = subplot(3,2,1) % across tasks
    h1 = raincloud_plot(AcrossTasks_Rhos, 'box_on', 1, 'color', [.3, .6, .9], 'alpha', 0.5,...
         'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
         'box_col_match', 0,'line_width',1);
    % set(gca, 'YLim', [-1 2.5]); set(gca, 'Xlim', [-1 1]);
    xlabel('Correlation'); ylabel('Density')
    xline(0)
    box off 
    title('Across tasks 2D')

s3 = subplot(3,2,3) % predictiong FaceERP
    h2 = raincloud_plot(TestFaceERP_Rhos, 'box_on', 1, 'color', [.3, .6, .9], 'alpha', 0.5,...
         'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
         'box_col_match', 0,'line_width',1);
    % set(gca, 'YLim', [-1 2.5]); set(gca, 'Xlim', [-1 1]);
    xlabel('Correlation'); ylabel('Density')
    xline(0)
    box off 
    title('Test FaceERP 2D')

s5 = subplot(3,2,5) % predicting SNSvids
    h3 = raincloud_plot(TestSNSvids_Rhos, 'box_on', 1, 'color', [.3, .6, .9], 'alpha', 0.5,...
         'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
         'box_col_match', 0,'line_width',1);
    % set(gca, 'YLim', [-1 2.5]); set(gca, 'Xlim', [-1 1]);
    xlabel('Correlation'); ylabel('Density')
    xline(0)
    box off 
    title('Test SNSvids 2D')

% 3D
s2 = subplot(3,2,2) % across tasks
    h1 = raincloud_plot(AcrossTasks_Rhos3D, 'box_on', 1, 'color', [.3, .6, .9], 'alpha', 0.5,...
         'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
         'box_col_match', 0,'line_width',1);
    % set(gca, 'YLim', [-1.5 4]); set(gca, 'Xlim', [-1 1]);
    xlabel('Correlation'); ylabel('Density')
    xline(0)
    box off 
    title('Across tasks 3D')

s4 = subplot(3,2,4) % predictiong FaceERP
    h2 = raincloud_plot(TestFaceERP_Rhos3D, 'box_on', 1, 'color', [.3, .6, .9], 'alpha', 0.5,...
         'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
         'box_col_match', 0,'line_width',1);
    % set(gca, 'YLim', [-1 2.5]); set(gca, 'Xlim', [-1 1]);
    xlabel('Correlation'); ylabel('Density')
    xline(0)
    box off 
    title('Test FaceERP 3D')

s6 = subplot(3,2,6) % predicting SNSvids
    h3 = raincloud_plot(TestSNSvids_Rhos3D, 'box_on', 1, 'color', [.3, .6, .9], 'alpha', 0.5,...
         'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
         'box_col_match', 0,'line_width',1);
    % set(gca, 'YLim', [-1 2.5]); ;
    xlabel('Correlation'); ylabel('Density')
    xline(0)
    box off 
    title('Test SNSvids 3D')
set(gca, 'Xlim', [-1 1])
linkaxes([s1, s2, s3, s4, s5, s6])
xlim([-1 1]); ylim([-1 3.2])

cd xxx
print(ModelPerformance, 'ModelPerformance', '-dtiffn', '-r300');
close(ModelPerformance)

% clean up
clear h1 h2 h3 s1 s2 s3 s4 s5 s6 TestSNSvids_Rhos3D TestSNSvids_Rhos TestFaceERP_Rhos3D TestFaceERP_Rhos
clear ModelPerformance

%% Figure 5: Associations normalised EEG and age %%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
addpath('xxx')
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
% colourscheme for the figures
    ColourScheme_cur = 'parula';
    

% For data in the creating space group
    % find indices for Disc participants in ClinVars
    Disc_grp_Ind = zeros(length(Data_groupspace.Subj_IDs),1);
    for ii = 1:length(Data_groupspace.Subj_IDs)
        Cur_subj = Data_groupspace.Subj_IDs{1,ii};
        for ss = 1:height(ClinVars_t1_t2)
            if strcmp(Cur_subj, num2str(ClinVars_t1_t2.subjects(ss)))
                Disc_grp_Ind(ii) =  ss;
            end
        end
        clear ss Cur_subj
    end
    clear ii
    Disc_grp_Ind = Disc_grp_Ind(Disc_grp_Ind ~= 0);
    % Get ClinVars for current sample
    Disc_grp_Sample_clinvars = ClinVars_t1_t2(Disc_grp_Ind,:);
    % Age
    Age_grp = table2array(Disc_grp_Sample_clinvars(:,{'age'}));
    Age_grp(Age_grp == 999) = NaN;
    N_curr_grpA = sum(~isnan(Age_grp),1);
    % Calculate the correlation between each metric and age
    Corrs_all_grpspace_data = zeros(size(Data_groupspace.data_normalised,1),1);
    for rr = 1:size(Data_groupspace.data_normalised,1)
        Mat = [Data_groupspace.data_normalised(rr,:)',Age_grp];
        Mat_clean = Mat(all(~isnan(Mat),2),:);
        [Curr_corr, ~] = corr(Mat_clean,'type','Spearman','tail','both');
        Corrs_all_grpspace_data(rr,1) = Curr_corr(1,2);
        clear Curr_corr Mat Mat_clean
    end
    clear rr

% For data in the individual variability group
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
    % Get ClinVars for current sample
    DiscSample_clinvars = ClinVars_t1_t2(Disc_Ind,:);
    % Age
    Age = table2array(DiscSample_clinvars(:,{'age'}));
    Age(Age == 999) = NaN;
    N_curr_grpB = sum(~isnan(Age),1);
    % Calculate the correlation between each metric and age
    Corrs_all = zeros(size(EEGmetrics_SubjoI,1),1);
    for rr = 1:size(EEGmetrics_SubjoI,1)
        Mat = [EEGmetrics_SubjoI(rr,:)',Age];
        Mat_clean = Mat(all(~isnan(Mat),2),:);
        [Curr_corr, ~] = corr(Mat_clean,'type','Spearman','tail','both');
        Corrs_all(rr,1) = Curr_corr(1,2);
        clear Curr_corr Mat Mat_clean
    end
    clear rr
        

% Visualise the findings
    VisualiseAge = figure('Position',[155 463 918 370],'ToolBar','none');
    subplot(1,2,1) % group space individuals
        scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs_all_grpspace_data, 'filled'); % 36 is the marker size, 'filled' makes the markers solid
        colormap(ColourScheme_cur); % You can replace 'jet' with any other colormap like 'parula', 'hsv', etc.
        a = colorbar; a.Label.String = 'Correlation'; clim([-1, 1])
        xlim([-1, 1]); ylim([-1, 1]);
        xticks(-1:.2:1); yticks(-1:.2:1);
        xlabel('Dimension 1') 
        ylabel('Dimension 2')
        title(strcat('In group A (creating space), N = ', num2str(N_curr_grpA)))
    subplot(1,2,2) % validation individuals
        scatter(Y_sp(:,1),Y_sp(:,2), 15, Corrs_all, 'filled'); % 36 is the marker size, 'filled' makes the markers solid
        colormap(ColourScheme_cur); % You can replace 'jet' with any other colormap like 'parula', 'hsv', etc.
        a = colorbar; a.Label.String = 'Correlation'; clim([-1, 1])
        xlim([-1, 1]); ylim([-1, 1]); 
        xticks(-1:.2:1); yticks(-1:.2:1);
        xlabel('Dimension 1') 
        ylabel('Dimension 2')
        title(strcat('In group B (variability), N = ', num2str(N_curr_grpB)))
    sgtitle('Associations between normalised EEG metrics and age')

% save the figure
cd /Users/riannehaartsen/Documents/000_GAIINS/FiguresPaper/Sources
print(VisualiseAge, 'Association_Age', '-dtiffn', '-r300');
close(VisualiseAge)

% clean up
clear Age Age_grp Corrs_all_grpspace_data Corrs_all DiscSample_clinvars Disc_grp_Sample_clinvars 
clear Disc_Ind Disc_grp_Ind a ans GrpA_Rholimits GrpB_Rholimits N_curr_grpA N_curr_grpB
