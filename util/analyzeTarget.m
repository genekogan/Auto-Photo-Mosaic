function score = analyzeTarget(targetpath, n1, n2)
% score = analyzeTarget(targetpath, n1, n2)
%   returns n1 x n2 cell, where each cell score{i,j} has two columns:
%   the first column contains the indexes of the top 200 repacement
%   candidates in myImageSet and the right column has the corresponding EMD
%   for that image.


% setup path for important programs
addpath('util');
addpath('util\FastEMD')
addpath('util\FastEMD\demo_FastEMD4');

% select target image
mainimg = double(imread(targetpath));

% load lite set of images
load('myImageSetLite');


% main analysis loop
% 1) shallow search
%    - extract mean RGB
%    - narrow down search to top 20% of low distance from mean RGB
% 2) deep search
%    - narrow down further to colors which have similar color disributions
%      using EMD


% set up mosaic dimensions
[sp1 sp2 sp3] = size(mainimg);

for i = 1:n1
    for j = 1:n2, tic
        
        % main image pixel index
        d11 = round(1 + (i-1)*sp1/n1);
        d12 = round(1 + (j-1)*sp2/n2);
        d21 = round(i*sp1/n1);
        d22 = round(j*sp2/n2);

        % retrieve sample, downsample for analysis
        subimg = mainimg(d11:d21,d12:d22,:);
        subimg5 = resampimg(subimg,5,5);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SHALLOW SEARCH                                   %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        meanimg = subimg(:);
        meanimg = [meanimg(1:size(meanimg,1)/3) meanimg(1+size(meanimg,1)/3:2*size(meanimg,1)/3) meanimg(1+2*size(meanimg,1)/3:3*size(meanimg,1)/3) ];
        meanrgb = mean(meanimg);
        score{i,j} = [];
        for k=1:length(myImageSetLite)
            score{i,j} = [ score{i,j} ; k sum((myImageSetLite{k}.mean-meanrgb).^2) ];    
        end
        score{i,j} = sortrows(score{i,j},2);
        list2 = score{i,j}(1:ceil(0.2*length(score{i,j})));
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % DEEP SEARCH                                      %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        score{i,j} = [];
        for k=1:length(list2)
            candidate = resampimg(myImageSetLite{list2(k)}.img15,5,5);            
            score{i,j} = [ score{i,j} ; list2(k) emd_hat_wrapper(subimg5,candidate) ]; 
        end
        score{i,j} = sortrows(score{i,j},2);
        score{i,j} = score{i,j}(1:min(300,length(score{i,j})),:);                       % if stopping after deep search    
            
        
        disp(sprintf('Calculated scores for segment %d of %d in %g seconds.', (i-1)*n2 + j, n1*n2, toc));
    end
end