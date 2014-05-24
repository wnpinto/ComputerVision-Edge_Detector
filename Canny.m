%{
    Warren Pinto - 500396119
    Krishna Motepalli - 500346743
    Feb 28, 2014
    
    Canny(im, sigma, threshold);
    **Eg Compile using Canny(imread('images\bowl_of_fruit.jpg'), 3,0.01);

    outputs the canny, non-suppression step matrix/image.
%}

function output = canny(image, sigma, threshold)
im = rgb2gray(image);
im = double(im)/255;
imshow(im); title('Input Image');

%Create a grid and make the origin in the middle by first finding the midpoint.
%this will be used to find the gaussian distribution
X = floor(25/2); %% Change the size of gaussian filter X by replacing 25
Y = floor(25/2); %% Change the size of gaussian filter Y by replacing 25
[Xmtx, Ymtx] = meshgrid(-X:X, -Y:Y);

%gaussian formula
gauss = exp(-(Xmtx.^2 + Ymtx.^2) / (2*sigma*sigma));
im = imfilter(im, gauss, 'same');

%apply gaussian derivative in x and y direction.
H = [1,0,-1];
G_dx = conv2(gauss, H, 'valid'); %apply convolution of H with gaussian to get smooth gauss derivative in x direction
figure, subplot(2,2,1), surf(G_dx); title('Guassian Derivative Y-directon');
img_dx = imfilter(im, G_dx, 'same');
H2 = [1;0;-1];
G_dy = conv2(gauss, H2, 'valid');  %apply convolution of H2 with gaussian to get smooth gauss derivative in x direction
subplot(2,2,2), surf(G_dy), title('Guassian Derivative Y-directon');
img_dy = imfilter(im, G_dy, 'same');


%output dx and dy
subplot(2,2,3), imshow(img_dx, []), title('Finite Difference:- x Axis');
subplot(2,2,4), imshow(img_dy, []),  title('Finite Difference:- y Axis');

%apply gradient magnitudes
im_gradient = sqrt(img_dx.^2 + img_dy.^2);
%output Gradient Magnitude
figure, imshow(im_gradient, []),  title('Gradient MAGNITUDE');

 %apply thresholding
im_threshold = im_gradient > threshold;
%figure, imshow(im_threshold, []),  title('Gradient Thresholding');

[row col] = size(im_threshold);
non_max_suppression = zeros(row, col);


 %apply non-max suppression
for i=2:row-1
    for j=2:col-1
        left_px = im_gradient(i,j-1);
        right_px = im_gradient(i,j+1);
        top_px = im_gradient(i-1,j);
        bottom_px = im_gradient(i+1,j);
        center_px = im_gradient(i,j);
        
        if ((center_px > right_px) && (center_px > left_px))
            non_max_suppression(i,j) = center_px;
        end
        
        if ((center_px > top_px) && (center_px > bottom_px))
            non_max_suppression(i,j) = center_px;
        end
    end
end

figure, imshow(non_max_suppression, []),  title('Non-Max Suppression');

im_thresh_low = non_max_suppression > 0.005;
im_thresh_high = non_max_suppression > 0.010;
%figure, subplot(1,2,1), imshow(im_thresh_low);
%subplot(1,2,2), imshow(im_thresh_high);

output = non_max_suppression;
end