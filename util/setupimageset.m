%% set up images

path = 'C:\Users\Gene\Desktop\grace photos\';
pctCut = .12;
imagesGrace = makeImageSet(path,{},pctCut);

%% find duplicates using findDuplicates.m

% resave set
idxkeep = find(~ismember([1:length(imagesGrace)]',exclude));
imagesGrace = imagesGrace(idxkeep);
save imagesGrace2 imagesGrace pctCut;

%% make lite set without 4-pixel thumbnails (for faster processing)

clear imagesGraceLite
for i=1:length(imagesGrace)
    imagesGraceLite{i}.path = imagesGrace{i}.path;
    imagesGraceLite{i}.img5 = imagesGrace{i}.img5;
    imagesGraceLite{i}.img15 = imagesGrace{i}.img15;
    imagesGraceLite{i}.mean = imagesGrace{i}.mean;
    imagesGraceLite{i}.std = imagesGrace{i}.std;
end
save imagesGraceLite2 imagesGraceLite pctCut;

