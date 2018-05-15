clc;
clear;

image = double(rgb2gray(imread('FLIR0172.jpg')));

% image = double(rgb2gray(imread('FLIR0322.jpg')));

[image_row, image_col] = size(image);

Y=mapminmax(image,0,1);

Y = Y(:);

tic;

[center,U,obj_fcn] = FCMClust(Y,2); 

U_col = size(U,2);
A = zeros(1,U_col);

for i = 1:U_col
    if U(1,i) > U(2,i)
        A(i) = 0;
    else
        A(i) = 1;
    end
end

toc;

B = reshape(A,image_row,image_col);

imshow(B,[]); 


