%% Automatic Photo Mosaicing
%  by Gene Kogan, March 2011
%  web: http://www.genekogan.com
%  tweet: @genekogan
%  contact: kogan.gene@gmail.com
%
%  These are the usage instructions and main control method for running 
%  the photo mosaic package on your own photos.  If you encounter any
%  issues running this code, please send me an e-mail.



%% Pre-processing for image set (only needed once)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Set-up candidate imageset
%
% First build a summary file for the image collection which contains
% thumbnails, full path info, and basic color stats for the entire image
% collection.  This step needs to be done only once, and then the summary
% can be re-used for each mosaic.
% 
% The 'lite' version is the same as the first set, except that it does not
% contain the largest thumbnails (40-pixel).  This is done to reduce memory
% load for when those thumbnails are not needed.
%
% Variables:
% imagepath : full path to the directory which contains all of the
%     available pictures.
% exclusions : full paths to any directories within imagepath to be
%     excluded (optional, can just leave blank if none).
% 
% Notes:
%  - only looks for jpg photos.  Can probably work on png/gif, but untested
%  - each picture takes a few seconds, so this process should take a few
%    hours -- but only needs to be done once.  Best done overnight.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% USER VARIABLES
imagepath = '';  %  <-- path to your images goes here
exclusions = {};



addpath('util');
[ myImageSet myImageSetLite ] = makeImageSet(imagepath, exclusions);
save myImageSet myImageSet;
save myImageSetLite myImageSetLite;


%% Generate scores/replacement candidates for mosaic segments

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: Select a target image for the mosaic and analyze it to find best
% matches for replacement in mosaic.
%
% After specifying a target image and parameters, this step will segment
% the target into rectangles, and make a list of top matches (and scores)
% for each rectangle.  
%
% The mosaic itself is not yet generated.  All segments must be analyzed
% first, and the next section details how that info goes into rendering the
% mosaic.
%
% Variables:
% targetpath : full path to the image you'd like to mosaic (only tested on
%    jpg...)
% n1, n2 : the number of segments on the y and x-axes, respectively, to
%    split the target image over (default is 60x60).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% USER VARIABLES
targetpath = '';        % <-- path to the desired target for the mosaic
n1 = 56;
n2 = 56;



addpath('util');
score = analyzeTarget(targetpath,n1,n2);



%% Render mosaic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: Renders mosaic from imageset and corresponding scores from step 2
% 
% The third step renders the mosaic by optimizing selection so as to get
% every segment one of its top choices while not overusing individual
% images.  Method returns the actual mosaic as well as the original
% picture.  After that the mosaic can be viewed and saved to disk in step 4.
%
% Variales:
% typemosaic : choices are 'full' or 'prototype'.  Full makes a full-sized
%    mosaic where each segment is replaced by a relatively high-resolution
%    picture (whose size on the x-axis in pixels is specified by s2), and
%    can take one or more hours to render (due mostly to resampling).
%    Prototype uses the 40-pixel thumbnails to very quickly make a low-res
%    mosaic; good to see how it will turn out, but not high quality enough
%    for deep inspection or printing.
% s2 : number of pixels (x-axis) to use for each replacement image
% maxuses : a soft limit on the maximum number of times any one replacement
%    image can be used in the mosaic.  The algorithm does allow for an
%    image to be used more than maxuses in case it is sufficiently far
%    enough from previous uses.
% overlapPct : Percentage by which replacement images overlap and
%    Must be 0 < overapPct < .5.  Best between .1 and .2.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% USER VARIABES
typemosaic = 'full';        % 'full' or 'prototype'
s2 = 160;
maxuses = 3;
overlapPct = .15;


% render mosaic and return it along with original target image
[ mainimg mosaic ] = renderMosaic(targetpath, typemosaic, score, n1, n2, s2, overlapPct, maxuses);


%% Final step: view and save mosaic to file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 4: View and save mosaic 
% 
% Mosaic is viewed as matlab figure alongisde the original image and saved
% to disk as a jpeg file.  A user variable pctmainimage specifies whether
% or not to blend the mosaic with the original image.
%
% Variables:
% pctmainimg: A percent, 0 <= pctmainimg <= 1, which specifies what
%    percentage of the final image wll come from the original image with
%    the rest coming from the mosaic.  If 0, the rendered image is the pure
%    mosaic, whereas if 1, the final image is the original image with none
%    of the mosaic in it (trivial use-case).  In practice, between .1 and
%    .25 tends to smooth out the rough edges of the mosaic while not overly
%    tinting the individual replacement pictures (default is .2).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% USER VARIABLES
pctmainimg = .2;



% render mosaic on screen and save to file
pctmosaic = 1-pctmainimg;
figure(1);imagesc(uint8(mainimg))
title('Original image');
if pctmainimg>0
    imwrite(uint8(pctmainimg*resampimg(mainimg,size(mosaic,1),size(mosaic,2)) + pctmosaic*mosaic),'mosaic.jpg','JPEG');
    figure(2);imagesc(uint8(pctmainimg*resampimg(mainimg,size(mosaic,1),size(mosaic,2)) + pctmosaic*mosaic));
    title('Blended Mosaic');        
else
    imwrite(uint8(mosaic),'mosaic.jpg','JPEG');
    figure(2);imagesc(uint8(mosaic));
    title('Mosaic');
end
disp(sprintf('Finished saving mosaic.jpg to file'));
