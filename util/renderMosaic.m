function [ mainimg mosaic ] = renderMosaic(targetpath,typemosaic,score,n1,n2,s2,overlapPct,maxuses)
% [ mainimg mosaic ] = renderMosaic(targetpath,typemosaic,score,n1,n2,s2,overlapPct,maxuses)
% see main file for info on the variables.


addpath('util');

% pull up original image and size
mainimg = imread(targetpath);
[sp1 sp2 sp3] = size(mainimg);


% make list of all scores, sorted in order in one array
% [ idx1 idx2 pictureIdx score ]
disp(sprintf('Compiling all scores together and prioritizing (this may take a minute...)'));
allscores = [ ];
for i=1:n1, for j=1:n2, allscores = [ allscores ; repmat([i j],size(score{i,j},1),1) score{i,j} ]; end; end
allscores = sortrows(allscores,4);


% initialize mosaic
if strcmp(typemosaic,'prototype')
    load('myImageSet');
    images = myImageSet; clear myImageSet;
    s1 = 40;
    s2 = round((sp2/sp1)*(n1*s1)/n2);
    overlap = round(s2*overlapPct);
    mosaic = zeros(overlap + n1*(s1-overlap+1)-1,overlap + n2*(s2-overlap+1)-1,3,'single');
elseif strcmp(typemosaic,'full')
    load('myImageSetLite');
    images = myImageSetLite; clear myImageSetLite;
    s1 = round((sp1/sp2)*(n2*s2)/n1);
    overlap = round(s2*overlapPct);
    mosaic = zeros(overlap + n1*(s1-overlap+1)-1,overlap + n2*(s2-overlap+1)-1,3);
else
    error('typemosaic must be either "full" or "prototype."');
end
        
% make gradient for picture crossfading
grad = makeGrad(s1,s2,overlap);

% status of grid and image uses
grid.id = zeros(n1,n2);          % image id of occupied segment
grid.status = zeros(n1,n2);      % 1 if occupied, 0 otherwise
used = zeros(length(images),1);  % number of uses of each image


idx = 1;
while sum(grid.status(:))<n1*n2 && idx<size(allscores,1)
    if (idx>=size(allscores,1)-1), break; end
    tic, disp(sprintf('%d of %d occupied...', sum(grid.status(:))+1, n1*n2));
    found = 0;
    while found==0
        if (idx>=size(allscores,1)-1), break; end
        i = allscores(idx,1);
        j = allscores(idx,2);
        imgid = allscores(idx,3);
        if grid.status(i,j)==0          % if the mosaic segment is unoccupied, do rest
            if used(imgid)<=maxuses
                neighborhood = grid.id(max(i-4,1):min(n1,i+4),max(1,j-4):min(n2,j+4));
                if isempty(find(neighborhood(:)==imgid))      % match works
                    grid.id(i,j) = imgid;
                    grid.status(i,j) = 1;
                    used(imgid) = used(imgid) + 1;
                    found = 1;
                else
                    found = 0;
                end
            elseif used(imgid)>=maxuses                       % emergency: only if far away
                neighborhood = grid.id(max(i-10,1):min(n1,i+10),max(1,j-10):min(n2,j+10));
                if isempty(find(neighborhood(:)==imgid))      % emergency match works
                    grid.id(i,j) = imgid;
                    grid.status(i,j) = 1;
                    used(imgid) = used(imgid) + 1;
                    found = 1;
                else
                    found = 0;
                end
            else
                found = 0;
            end
        else
            found = 0;
        end
        idx = idx + 1;
    end
        
    % index of mosaic to modify
    idx1 = 1 + (i-1)*(s1-overlap+1) : overlap + i*(s1-overlap+1) - 1;
    idx2 = 1 + (j-1)*(s2-overlap+1) : overlap + j*(s2-overlap+1) - 1;

    % generate image
    switch typemosaic
        case 'full'
            %pctCut = .12;
            imgbest = imread(images{imgid}.path);        % load image
            %imgbest = cutimg(imgbest,pctCut);            % cut border from image
        case 'prototype'
            imgbest = images{imgid}.img40;               % load 40-pixel thumbnail
    end
    imgbest = trimimg(imgbest,s1,s2);                    % trim photo to correct proportion in mosaic
    d = resampimg(imgbest,s1,s2);                        % resample photo to segment size
    d = d.*grad;                                         % multiply by gradient

    % add to mosaic
    mosaic(idx1,idx2,:) = mosaic(idx1,idx2,:) + d;
    toc
    
end


% this loop only starts if all eligible scores are passed over in above
% get coordinates of empty spots
[r1 r2]=ind2sub(size(grid.status),find(grid.status==0));
idxshufflerem = randperm(length(r1));

% in random order, find best match directorly from scores
for index=1:length(idxshufflerem), disp(sprintf('index %d of %d', index, length(idxshufflerem)));
    i = r1(index); j = r2(index);
    s = score{i,j};    

    idx = 1;
    while grid.status(i,j)==0
        imgid = s(idx,1);
        neighborhood = grid.id(max(i-2,1):min(n1,i+2),max(1,j-2):min(n2,j+2));
        if isempty(find(neighborhood(:)==imgid));
            % grid status stuff
            grid.status(i,j) = 1;
            grid.id(i,j) = imgid;
            used(imgid) = used(imgid) + 1;
            
            % index of mosaic to modify
            idx1 = 1 + (i-1)*(s1-overlap+1) : overlap + i*(s1-overlap+1) - 1;
            idx2 = 1 + (j-1)*(s2-overlap+1) : overlap + j*(s2-overlap+1) - 1;

            % generate image
            switch typemosaic
                case 'full'
                    imgbest = imread(images{imgid}.path);        % load image
                case 'prototype'
                    imgbest = images{imgid}.img40;               % load 40-pixel thumbnail
            end
            imgbest = trimimg(imgbest,s1,s2);                    % trim photo to correct proportion in mosaic
            d = resampimg(imgbest,s1,s2);                        % resample photo to segment size
            d = d.*grad;                                         % multiply by gradient

            % add to mosaic
            mosaic(idx1,idx2,:) = mosaic(idx1,idx2,:) + d;
            
        end
        idx = idx + 1;
    end
end