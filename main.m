clc;
clear;

% image = double(rgb2gray(imread('FLIR0172.jpg')));
% image_hist = imread('saliency_FLIR0172.jpg');
% 
% imhist(image);
% 
% [image_hist_row, image_hist_col] = size(image_hist);
% 
% fore = zeros(1,256);
% back = zeros(1,256);
% 
% for i = 1:image_hist_row
%     for j = 1:image_hist_col
%         if image_hist(i,j) > 110
%             fore(image(i,j) + 1) = fore(image(i,j) + 1) + 1;
%         else
%             back(image(i,j) + 1) = back(image(i,j) + 1) + 1;
%         end
%     end
% end
% 
% % plot(fore);
% % plot(back);


% syms m d r
% u = solve('(m*u + 2*(m-2)*u*ln(u))*d.^2 + r=0','u')
%  u = solve('(m*u + 2*(m-2)*u*(u-1))*d*d + r=0','u')
 
% syms d m
% r = solve(' (4*d - d*m + (d^2*m^2 - 8*d^2*m + 16*d^2 - 8*r*m + 16*r)^(1/2))/(4*(2*d - d*m)) = 1', 'r')

% syms d1 d2 m
% u = solve('(m*u + 2*(m-2)*u*(u-1))*d1*d1 - d2*d2*m = 0', 'u')
 

% image = double(rgb2gray(imread('FLIR0172.jpg')));

image = double(rgb2gray(imread('FLIR0359.jpg')));

% image = double(rgb2gray(imread('FLIR0371.jpg')));

[image_row, image_col] = size(image);

Y = image(:);

Y=mapminmax(Y',0,1);

Y = Y';

tic;

[center,U,obj_fcn] = FCMClust(Y,2); 

U_col = size(U,2);
A = zeros(1,U_col);

for i = 1:U_col
    if U(1,i) > U(2,i)
%     if U(1,i) > 0.7
        A(i) = 0;
    else
        A(i) = 1;
    end
end

toc;

B = reshape(A,image_row,image_col);

imshow(B,[]);


%imwrite(uint8(B),'FLIR0322_uv_nom.jpg');


