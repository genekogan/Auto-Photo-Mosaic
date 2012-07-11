function img = cutimg(img,pctCut)
% img = cutimg(img,pctCut)
% cut borders around an image.  
% 0<pctCut<1 is the percentage to cut off, e.g. remove 15% from the picture
% on all sides (30% in total).

border1 = round(pctCut*size(img,1));
border2 = round(pctCut*size(img,2));
img = img(border1+1:size(img,1)-border1,border2+1:size(img,2)-border2,:);
