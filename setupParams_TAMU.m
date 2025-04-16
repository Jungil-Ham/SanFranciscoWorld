%% ICL NUIM dataset can be downloaded from: https://www.doc.ic.ac.uk/~ahanda/VaFRIC/iclnuim.html


switch( expCase )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% Living Room Dataset  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    case 1
        datasetPath = './TAMU_b';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 600;  % number of images
    
    case 2
        datasetPath = './asus_A';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 200;  % number of images
    case 3
        datasetPath = './astra_stair';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 1390;  % number of images
    case 4
        datasetPath = './TAMU_A';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 600;  % number of images
    case 5
        datasetPath = './PnR';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 2;  % number of images
    case 6
        datasetPath = 'D:/seq_p';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 499;  % number of images
        
end
