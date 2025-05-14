%% ICL NUIM dataset can be downloaded from: https://www.doc.ic.ac.uk/~ahanda/VaFRIC/iclnuim.html


switch( expCase )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% Living Room Dataset  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    case 1
        datasetPath = 'D:/quarter-turn-staircase';
            
        imInit      = 1;    % first image index, (1-based index)
        M           = 570;  % number of images
    case 2
        datasetPath = './SFDetection';
            
        imInit      = 1;    % first image index, (1-based index)
        M           = 1;  % number of images
        

        
end
