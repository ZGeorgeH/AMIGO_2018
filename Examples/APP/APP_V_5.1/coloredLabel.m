function coloredLabel(image,tempI)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


BW = tempI;
CC = bwconncomp(BW);
L = labelmatrix(CC);
BWoutline = bwperim(tempI); 
Lrgb = label2rgb(L, 'jet', 'k', 'shuffle');
Lrgb(repmat(BWoutline,1,1,3))=255;
figure
imshow(imadjust(image));
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
end

