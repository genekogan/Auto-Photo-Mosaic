
addpath('util');
addpath('C:\Users\Gene\Code\Matlab\externals\FastEMD')
folder = 'C:\Users\Gene\Desktop\testemd\';
h = dir([folder '*.jpg']);

for i=1:length(h)
    disp(sprintf('%d of %d', i, length(h)))
    imtemp = imread([folder h(i).name]);
    im{i}.img15 = zeros(15,15,3);
    im{i}.img40 = zeros(40,40,3);
    for j=1:3
        im{i}.img15(:,:,j) = updownsample(imtemp(:,:,j),15,15,0,1);
        im{i}.img40(:,:,j) = updownsample(imtemp(:,:,j),40,40,0,1);
    end
end

%%
score = [];
for i=1:length(im)
    disp(sprintf('%d of %d', i, length(im)));
    for j=1:length(im)
        if i~=j
            emd = emd_hat_wrapper(im{i}.img15, im{j}.img15);
            score = [ score ; i j emd ];
        end
    end
end
help emd_hat_wrapper

%%

score = sortrows(score,-3);

for i=1:10
    subplot(1,2,1);
    imagesc(uint8(im{score(i,1)}.img40));
    subplot(1,2,2);
    imagesc(uint8(im{score(i,2)}.img40));
    pause(2)
end
pause(3)
for i=1:10
    subplot(1,2,1);
    imagesc(uint8(im{score(length(score)+1-i,1)}.img40));
    subplot(1,2,2);
    imagesc(uint8(im{score(length(score)+1-i,2)}.img40));
    pause(2)
end
pause(3)

