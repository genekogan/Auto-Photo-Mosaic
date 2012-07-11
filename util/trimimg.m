function newimg = trimimg(currimg, s1, s2)
% newimg = trimimg(currimg, s1, s2)
% function will trim an image so that its dimensions are proportional to s1
% and s2.  the new image does not come out that size, but with dimensions
% which are proportional.

if (size(currimg,2)/size(currimg,1))>(s2/s1)       % trim left/right
    margin = round((size(currimg,2) - size(currimg,1)*(s2/s1))/2);
    newimg = currimg(:,margin+1:size(currimg,2)-margin,:);
elseif (size(currimg,2)/size(currimg,1))<(s2/s1)   % trim top/bottom
    margin = round((size(currimg,1) - size(currimg,2)*(s1/s2))/2);
    newimg = currimg(margin+1:size(currimg,1)-margin,:,:);
else
    newimg = currimg;
end
