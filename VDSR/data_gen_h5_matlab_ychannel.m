clc;
clear all;
close all;

image_size = 41;
label_size = 41;
% scale = 3;
stride = 41;

dataset='291';
dataset_path = '/Dataset/';
data_path = strcat(dataset_path, dataset);

save_data = 'train_291_ychannels_matlab.h5';
% save_dataset_path_1 = '/train';
% save_dataset_path_2 = '/MATLAB/';
% save_dataset_path = strcat(save_dataset_path_1, save_dataset_path_2);
save_dataset_path = '../train/'
save_path = strcat(save_dataset_path, save_data);
if ~exist(save_dataset_path)
    mkdir(save_dataset_path);
end
data = zeros(1, image_size, image_size, 1);
label = zeros(1, label_size, label_size, 1);
% padding = abs(image_size - label_size)/2;
count=0;

filepath = dir(fullfile(data_path, '*.bmp'));

for i = 1: length(filepath)
    img = imread(fullfile(data_path, filepath(i).name));
    if length(size(img))~=3
      img = cat(3, img, img, img);
    end
    img = rgb2ycbcr(img);
    img = im2double(img(:,:,1));
    [h,w] = size(img);
    for scale = 2:4
        img_label = img(1:h-mod(h,scale), 1:w-mod(w,scale));
        [h1, w1] = size(img_label);
        img_input = imresize(imresize(img_label, 1/scale, 'bicubic'), [h1, w1],'bicubic');

        for x = 1:stride:h1-image_size+1
            for y = 1:stride:w1-image_size+1

                subimg_input = img_input(x:x+image_size-1, y:y+image_size-1);
                subimg_label = img_label(x:x+label_size-1, y:y+label_size-1);

%                 count = count + 1;
%                 data(1,:,:,count) = subimg_input;
%                 label(1,:,:,count) = subimg_label;
%                 count = count + 1;
%                 data(1,:,:,count) = fliplr(subimg_input);
%                 label(1,:,:,count) = fliplr(subimg_label);
%                 count = count + 1;
%                 data(1,:,:,count) = flipud(subimg_input);
%                 label(1,:,:,count) = flipud(subimg_label);
                
                for degree = 0:90:270
                    count = count + 1;
                    data(1,:,:,count) = imrotate(subimg_input, degree);
                    label(1,:,:,count) = imrotate(subimg_label,degree);
                    count = count + 1;
                    data(1,:,:,count) = fliplr(imrotate(subimg_input, degree));
                    label(1,:,:,count) = fliplr(imrotate(subimg_label, degree));
%                     count = count + 1;
%                     data(1,:,:,count) = flipud(imrotate(subimg_input, degree));
%                     label(1,:,:,count) = flipud(imrotate(subimg_label, degree));
                end
            end
        end
    end
end
order = randperm(count);
data = data(1, :, :, order);
label = label(1, :, :, order);

h5create(save_path,'/data',[1 image_size image_size count]);
h5create(save_path,'/label',[1 label_size label_size count]);
h5write(save_path,'/data',data);
h5write(save_path,'/label',label);
h5disp(save_path);
