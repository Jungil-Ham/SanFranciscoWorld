%% ICL NUIM dataset can be downloaded from: https://www.doc.ic.ac.uk/~ahanda/VaFRIC/iclnuim.html


switch( expCase )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% Living Room Dataset  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    case 1
        datasetPath = 'G:/ICL-NUIMdataset/lr_kt0_pure';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 1508;  % number of images
        
        
    case 2
        datasetPath = 'G:/ICL-NUIMdataset/lr_kt1_pure';
        
        imInit      = 1;      % first image index, (1-based index)
        M           = 965;   % number of images
        
        
    case 3
        datasetPath = 'G:/ICL-NUIMdataset/lr_kt2_pure';
        
        imInit      = 1;      % first image index, (1-based index)
        M           = 880;   % number of images
        
        
    case 4
        datasetPath = 'G:/ICL-NUIMdataset/lr_kt3_pure';
        
        imInit      = 1;      % first image index, (1-based index)
        M           = 550;   % number of images
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%% Office Room Dataset  %%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case 5
        datasetPath = 'G:/ICL-NUIMdataset/of_kt0';
        
        imInit      = 1;      % first image index, (1-based index)
        M           = 1507; % number of images
        
        
    case 6
        datasetPath = 'G:/ICL-NUIMdataset/of_kt1';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 965;    % number of images
        
        
    case 7
        datasetPath = 'G:/ICL-NUIMdataset/of_kt2';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 880;    % number of images
        
        
    case 8
        datasetPath = 'G:/ICL-NUIMdataset/of_kt3';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 1240;  % number of images
        
        
end
