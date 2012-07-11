function [ images imagesLite ] = makeImageSet(scandir,excludeDir,pctCut)
% images = makeImageSet(scandir,excludeDir,pctCut)
%    returns cell containing analysis of each image in directory scandir
%    contains RGB mean and stdev, 2 and 4-component GMMs, and thumbnails for efficient
%    color processing (40, 15, and 5 rows), and full path to the original image.
%    optional excludeDir is a cell containing full path of any directories to
%    exclude from search of scandir.  pctCut specifies to cut a percentage
%    off the borders of every image

if nargin<3
    pctCut = 0;
end
if nargin<2
    excludeDir = {};
end
% set downsampling: size of axis 1
s1 = 120;

% generate list of all image files
fileList = getAllFiles(scandir,'jpg',excludeDir);

% loop for each image analysis
idx2 = 1;
for idx = 1:length(fileList)

    % load image
    filename = fileList{idx};
    imgtemp = double(imread(filename));
    
    
    if ndims(imgtemp)~=3             % make sure only RGB images pass through
        disp(sprintf(' Image does not contain three channels... skipped'));
    else
        % check that none of the three channels are identical
        bwcheck1 = imgtemp(:,:,1); bwcheck2 = imgtemp(:,:,2); bwcheck3 = imgtemp(:,:,3); 
        identicallayers = 0;
        if mean(bwcheck1(:)==bwcheck2(:))>0.97 | mean(bwcheck1(:)==bwcheck3(:))>0.97 | mean(bwcheck2(:)==bwcheck3(:))>0.97, identicallayers = 1; end 
        if identicallayers, disp(sprintf(' Image has identical channels... skipped'));
        else, tic;   % proceed if no identicallayers

        % cut pctCut of border of image, if pctCut>0
        if pctCut > 0, imgtemp = cutimg(imgtemp,pctCut); end
            
        % downsample (s1 rows) for faster analysis
        img = zeros(s1,round(s1*size(imgtemp,2)/size(imgtemp,1)),3);
        for dimidx=1:3, img(:,:,dimidx) = updownsample(imgtemp(:,:,dimidx),round(s1*size(imgtemp,2)/size(imgtemp,1)),s1,0,1); end
        
        
        % generate thumbnail (40 rows)
        images{idx2}.img40 = zeros(40,round(40*size(img,2)/size(img,1)),3,'single');
        for i=1:3, images{idx2}.img40(:,:,i) = updownsample(img(:,:,i),round(40*size(img,2)/size(img,1)),40,0,1); end
        % generate thumbnail (15 rows)
        images{idx2}.img15 = zeros(15,round(15*size(img,2)/size(img,1)),3,'single');
        for i=1:3, images{idx2}.img15(:,:,i) = updownsample(img(:,:,i),round(15*size(img,2)/size(img,1)),15,0,1); end
        % generate thumbnail (5 rows)
        images{idx2}.img5 = zeros(5,round(5*size(img,2)/size(img,1)),3,'single');
        for i=1:3, images{idx2}.img5(:,:,i) = updownsample(img(:,:,i),round(5*size(img,2)/size(img,1)),5,0,1); end
        
        
        % set RGB into N pixels by 3 columns        
        img = img(:);
        img = [img(1:size(img,1)/3) img(1+size(img,1)/3:2*size(img,1)/3) img(1+2*size(img,1)/3:3*size(img,1)/3) ];
        
        
        % full path and RGB mean
        images{idx2}.path = filename;
        images{idx2}.mean = mean(img,1);
        
        
        % copy all but 40-pixel to imagesLite
        imagesLite{idx2}.img15 = images{idx2}.img15;
        imagesLite{idx2}.img5 = images{idx2}.img5;
        imagesLite{idx2}.path = images{idx2}.path;
        imagesLite{idx2}.mean = images{idx2}.mean;
        
        idx2 = idx2 + 1;
        
    
        disp(sprintf('Finished image %d of %d in %g sec: %s', idx, length(fileList), toc, filename));  
        end
    end
end

end
