function checkResults(origthumb, images, subscore, subsetsize,numbest,numworst)
% helper function to check visualize algorithms choices for thumbnail
% replacement.


% original thumbnail to replace
subplot(1,2,1);
title('original thumbnail')
imagesc(uint8(origthumb));

% sort scores
subscore = sortrows(subscore,6);

for k=1:numbest
    % load image
    newimg = trimimg(imread(images{subscore(k,1)}.path),size(origthumb,1),size(origthumb,2));

    % find correct subset of the image
    ws1 = subsetsize(subscore(k,2))*size(newimg,1);
    ws2 = subsetsize(subscore(k,2))*size(newimg,2);
    numwin = subscore(k,3);
    if numwin == 1
        inc1 = 0; inc2 = 0;
    else
        inc1 = floor((size(newimg,1)-ws1)/(numwin-1));
        inc2 = floor((size(newimg,2)-ws2)/(numwin-1));
    end
    win11 = 1 + (subscore(k,4)-1)*inc1;
    win12 = 1 + (subscore(k,5)-1)*inc2;
    win21 = ws1 + (subscore(k,4)-1)*inc1;
    win22 = ws2 + (subscore(k,5)-1)*inc2;

    % display candidate
    subplot(1,2,2);
    title(sprintf('top image %d',k));
    imagesc(uint8(newimg(win11:win21,win12:win22,:)));
    if k<4, pause(2.5); else, pause(0.5); end
end
pause(3)

% sort scores from bottom
subscore = sortrows(subscore,-6);

for k=1:numworst
    % load image
    newimg = trimimg(imread(images{subscore(k,1)}.path),size(origthumb,1),size(origthumb,2));

    % find correct subset of the image
    ws1 = subsetsize(subscore(k,2))*size(newimg,1);
    ws2 = subsetsize(subscore(k,2))*size(newimg,2);
    numwin = subscore(k,3);
    if numwin == 1
        inc1 = 0; inc2 = 0;
    else
        inc1 = floor((size(newimg,1)-ws1)/(numwin-1));
        inc2 = floor((size(newimg,2)-ws2)/(numwin-1));
    end
    win11 = 1 + (subscore(k,4)-1)*inc1;
    win12 = 1 + (subscore(k,5)-1)*inc2;
    win21 = ws1 + (subscore(k,4)-1)*inc1;
    win22 = ws2 + (subscore(k,5)-1)*inc2;

    % display candidate
    subplot(1,2,2);
    title(sprintf('bottom image %d',k));
    imagesc(uint8(newimg(win11:win21,win12:win22,:)));
    if k<2, pause(2.5); else, pause(0.5); end

end
