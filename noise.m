clear
clc


load real_data_samson.mat;

B = r_cube(:,:,2);

% 
% C = 0.05;
% 
% B = imnoise(B,'salt & pepper',C);

imshow(B);