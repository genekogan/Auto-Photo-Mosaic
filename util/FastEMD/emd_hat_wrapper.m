function [ emd ] = emd_hat_wrapper(im1,im2)
% emd = emd_hat_wrapper(im1,im2)
% Quick and dirty wrapper to emd_hat_max function for Earth Mover's
% Distance calculation.  Make sure im1 and im2 are images of the same size
% and you compare this emd with emd's compiled from images of the same
% size.


threshold= 10;
alpha_color= 1/2;
coordinates_transformation= 2; 

% set up a bunch of variables
im1_Y= size(im1,1);
im1_X= size(im1,2);
im1_N= im1_Y*im1_X;
im2_Y= size(im2,1);
im2_X= size(im2,2);
im2_N= im2_Y*im2_X;
P= [ ones(im1_N,1)  ;  zeros(im2_N,1) ];
Q= [ zeros(im1_N,1) ;  ones(im2_N,1)  ];

im1= double(im1)./255;
im2= double(im2)./255;
cform = makecform('srgb2lab');
im1_lab= applycform(im1, cform);
im2_lab= applycform(im2, cform);

%tic
[ground_distance_matrix]= color_spatial_EMD_ground_distance(im1_lab,im2_lab,...
                                                  alpha_color,threshold, ...
                                                  coordinates_transformation);
%fprintf(1,'computing the ground distance matrix, time in seconds: %f\n', ...
        %toc);

% In ICCV paper extra_mass_penalty did not matter as image sizes were the same.
extra_mass_penalty= -1;
flowType= 3;

[emd F]= emd_hat_mex(P,Q,ground_distance_matrix,extra_mass_penalty,flowType);
%fprintf(1,'Note that the ground distance here is not a metric.\n');
%fprintf(1,'emd_hat_mex, time in seconds: %f\n',toc);
