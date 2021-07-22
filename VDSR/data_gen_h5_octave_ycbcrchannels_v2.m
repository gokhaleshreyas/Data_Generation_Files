clc;
clear all;
close all;

pkg load image

image_size = 33;
label_size = 21;
scale = 3;
stride = 14;

dataset='91';
dataset_path = 'C:\Shreyas\Programming\Python\Neural_Networks\Data\Dataset\';
data_path = strcat(dataset_path, dataset);

save_data = 'train_91_ycbcrchannels_octave_v2.h5';
save_dataset_path_1 = 'C:\Shreyas\Programming\Python\Neural_Networks\SRCNN\Data';
save_dataset_path_2 = '\RGB2YCBCR_OCTAVE\';
save_dataset_path = strcat(save_dataset_path_1, save_dataset_path_2);
save_path = strcat(save_dataset_path, save_data);
if ~exist(save_dataset_path)
    mkdir(save_dataset_path);
end
data = zeros(1, image_size, image_size, 1);
label = zeros(1, label_size, label_size, 1);
padding = abs(image_size - label_size)/2;
count = 0;

filepath = dir(fullfile(data_path, '*.bmp'));

for i = 1: length(filepath)
    img = imread(fullfile(data_path, filepath(i).name));
    if length(size(img))!=3
      img = cat(3, img, img, img);
    end
    img = rgb2ycbcr(img);
    img_y = im2double(img(:,:,1));
    img_cb = im2double(img(:,:,2));
    img_cr = im2double(img(:,:,3));
    [h,w] = size(img_y);
    for scale=2:4
        img_y_label = img_y(1:h-mod(h,scale), 1:w-mod(w,scale));
        [h1, w1] = size(img_y_label);
        img_y_input = imresize(imresize(img_y_label, 1/scale, 'bicubic'), [h1, w1],'bicubic');
        img_cb_label = img_cb(1:h-mod(h,scale), 1:w-mod(w,scale));
        % [h1, w1] = size(img_cb_label);
        img_cb_input = imresize(imresize(img_cb_label, 1/scale, 'bicubic'), [h1, w1],'bicubic');
        img_cr_label = img_cr(1:h-mod(h,scale), 1:w-mod(w,scale));
        % [h1, w1] = size(img_cr_label);
        img_cr_input = imresize(imresize(img_cr_label, 1/scale, 'bicubic'), [h1, w1],'bicubic');
        % [h1, w1] = size(img_y_label);

        for x = 1:stride:h1-image_size+1
            for y = 1:stride:w1-image_size+1

                subimg_y_input = img_y_input(x:x+image_size-1, y:y+image_size-1);
                subimg_y_label = img_y_label(x+padding:x+padding+label_size-1, y+padding:y+padding+label_size-1);
                subimg_cb_input = img_cb_input(x:x+image_size-1, y:y+image_size-1);
                subimg_cb_label = img_cb_label(x+padding:x+padding+label_size-1, y+padding:y+padding+label_size-1);
                subimg_cr_input = img_cr_input(x:x+image_size-1, y:y+image_size-1);
                subimg_cr_label = img_cr_label(x+padding:x+padding+label_size-1, y+padding:y+padding+label_size-1);

%                 count = count + 1;
%                 data(1,:,:,count) = subimg_r_input;
%                 label(1,:,:,count) = subimg_r_label;
%                 data(2,:,:,count) = subimg_g_input;
%                 label(2,:,:,count) = subimg_g_label;
%                 data(3,:,:,count) = subimg_b_input;
%                 label(3,:,:,count) = subimg_b_label;
%                 count = count + 1;
%                 data(1,:,:,count) = fliplr(subimg_r_input);
%                 label(1,:,:,count) = fliplr(subimg_r_label);
%                 data(2,:,:,count) = fliplr(subimg_g_input);
%                 label(2,:,:,count) = fliplr(subimg_g_label);
%                 data(3,:,:,count) = fliplr(subimg_b_input);
%                 label(3,:,:,count) = fliplr(subimg_b_label);
%                 count = count + 1;
%                 data(1,:,:,count) = flipud(subimg_r_input);
%                 label(1,:,:,count) = flipud(subimg_r_label;
%                 data(2,:,:,count) = flipud(subimg_g_input);
%                 label(2,:,:,count) = flipud(subimg_g_label);
%                 data(3,:,:,count) = flipud(subimg_b_input);
%                 label(3,:,:,count) = flipud(subimg_b_label);
                for degree=0:90:270
                    count = count + 1;
                    data(1,:,:,count) = subimg_r_input;
                    label(1,:,:,count) = subimg_r_label;
                    data(2,:,:,count) = subimg_g_input;
                    label(2,:,:,count) = subimg_g_label;
                    data(3,:,:,count) = subimg_b_input;
                    label(3,:,:,count) = subimg_b_label;
                    count = count + 1;
                    data(1,:,:,count) = imrotate(fliplr(subimg_r_input),degree);
                    label(1,:,:,count) = imrotate(fliplr(subimg_r_label),degree);
                    data(2,:,:,count) = imrotate(fliplr(subimg_g_input),degree);
                    label(2,:,:,count) = imrotate(fliplr(subimg_g_label),degree);
                    data(3,:,:,count) = imrotate(fliplr(subimg_b_input),degree);
                    label(3,:,:,count) = imrotate(fliplr(subimg_b_label),degree);
%                     count = count + 1;
%                     data(1,:,:,count) = imrotate(flipud(subimg_r_input),degree);
%                     label(1,:,:,count) = imrotate(flipud(subimg_r_label),degree);
%                     data(2,:,:,count) = imrotate(flipud(subimg_g_input),degree);
%                     label(2,:,:,count) = imrotate(flipud(subimg_g_label),degree);
%                     data(3,:,:,count) = imrotate(flipud(subimg_b_input),degree);
%                     label(3,:,:,count) = imrotate(flipud(subimg_b_label),degree);
                end
            end
        end
    end
end
order = randperm(count);
data = data(:, :, :, order);
label = label(:, :, :, order);

save('-hdf5', save_path, 'data', 'label');