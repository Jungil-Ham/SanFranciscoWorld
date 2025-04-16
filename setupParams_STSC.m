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
        datasetPath = './PnR';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 1;  % number of images
    
    case 3
        datasetPath = './corridor3';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 200;  % number of images

    case 4
        datasetPath = './same';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 10;  % number of images
    
    case 5
        datasetPath = './oryong3';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 200;  % number of images

    case 6
        datasetPath = './stairScene';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 775;  % number of images

    case 7
        datasetPath = './me_stair1';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 2000;  % number of images

    case 8
        datasetPath = '/me_stair2';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 200;  % number of images
        
    case 9
        datasetPath = './LStair2';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 1000;  % number of images
    case 10
        datasetPath = './cof_ban';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 450;  % number of images
    case 11
        datasetPath = 'D:/N_Rcheck';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 1495;  % number of images
    case 12
        datasetPath = 'D:/L_careful';
            
        imInit      = 1;       % first image index, (1-based index)
        M           = 945;  % number of images
        
end
