function newimg = resampimg(img,s1,s2)
% newimg = resamping(image,newsize1,newsize2)
% calls on updownsample to resample an image which must contain three
% layers, otherwise call on updownsample directly.
 
newimg = zeros(s1,s2,3);
for i=1:3
    newimg(:,:,i) = updownsample(img(:,:,i),s2,s1,0,1);
end
            