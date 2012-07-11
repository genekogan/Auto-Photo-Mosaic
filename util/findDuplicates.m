%% look for duplicates (nearly identical pictures)

% setup path for important programs
addpath('util');
addpath('util\FastEMD')
addpath('util\FastEMD\demo_FastEMD4');

% sort image pairs by lowest EMD
emd_summary = [];
for i=1:length(myImageSet)
    folder = regexp(myImageSet{i}.path,'\\','split');
    folder = folder{end-1};

    for j=i+1:i+12 %length(myImageSet)

        folder2 = regexp(myImageSet{j}.path,'\\','split');
        folder2 = folder2{end-1};

        if strcmp(folder,folder2)     % images in same folder, do analysis
            newimg = resampimg(myImageSet{j}.img5, size(myImageSet{i}.img5,1), size(myImageSet{i}.img5,2) );
            emd = emd_hat_wrapper(myImageSet{i}.img5,newimg);
            emd_summary = [ emd_summary ; i j emd ];
            disp(sprintf('%d %d %g', i, j, emd));
        end
    end 
end


%%

emd_summary = sortrows(emd_summary,3);

exclude = [];
for i=1:500
    subplot(1,2,1);
    %imagesc(uint8(imread(myImageSet{emd_summary(i,1)}.path)));
    imagesc(uint8(myImageSet{emd_summary(i,1)}.img40));
    title(sprintf('index %d, img %d', i, emd_summary(i,1)));
    subplot(1,2,2);
    %imagesc(uint8(imread(myImageSet{emd_summary(i,2)}.path)));
    imagesc(uint8(myImageSet{emd_summary(i,2)}.img40));
    title(sprintf('index %d, img %d', i, emd_summary(i,2)));
    
    choice = input('1 to exclude, 0 to skip: ');
    
    if choice==1
        exclude = [ exclude emd_summary(i,2) ];
    end
end

%% remove exclusions

load('myImageSet.mat');
myImageSet = myImageSet(find(~ismember([1:length(myImageSet)],exclude)));
save myImageSet myImageSet
load('myImageSetLite.mat');
myImageSet = myImageSetLite(find(~ismember([1:length(myImageSetLite)],exclude)));
save myImageSetLite myImageSetLite