%% ICL NUIM dataset can be downloaded from: https://www.doc.ic.ac.uk/~ahanda/VaFRIC/iclnuim.html


switch( expCase )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% Living Room Dataset  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    case 1
        datasetPath = './ASTRA';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 2;  % number of images
    case 2
        datasetPath = './ASTRA/Tracking';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 2;  % number of images
    case 3
        datasetPath = './ASTRA/Tracking/Track/221';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 50;  % number of images
    case 4
        datasetPath = './ASTRA/Tracking/Track/826';
        
        imInit      = 1;       % first image index, (1-based index)
        M           = 50;  % number of images
   
end
