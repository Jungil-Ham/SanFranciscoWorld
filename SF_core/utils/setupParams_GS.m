%% ICL NUIM dataset can be downloaded from: https://www.doc.ic.ac.uk/~ahanda/VaFRIC/iclnuim.html


switch( expCase )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% Living Room Dataset  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    case 1
        datasetPath = 'D:/Rot3';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 1550;  % number of images

    case 2
        datasetPath = 'D:/15_2';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 3225;  % number of images
    
    case 3
        datasetPath = 'D:/15_3';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 2035;  % number of images
    case 4
        datasetPath = 'D:/15_4';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 2035;  % number of images
    case 5
        datasetPath = 'D:/15_5';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 3246;  % number of images
    case 6
        datasetPath = 'D:/15_L2';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 387;  % number of images
        %M           = 2982;  % number of images
    case 8
        datasetPath = 'D:/15_L1';
            
        imInit      = 1;       % first image index, (1-based index)
        %M           = 387;  % number of images
        M           = 2982;  % number of images
    case 7
        datasetPath = 'D:/15_U1';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 2035;  % number of images
    case 9
        datasetPath = 'D:/N_Rcheck';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 1495;  % number of images
        
end
