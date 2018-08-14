%for I={I1,I2}
I=I2(:,:,1);

figure, imshow(I),title('original image');

[BW, threshold] = edge(I, 'Sobel');%'Sobel'(default),'Canny'(robust)
fudgeFactor = .5;% what is this?%0.75
BWs = edge(I,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');

se90 = strel('line', 3, 90);%*5
se0 = strel('line', 3, 0);

BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');

BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

BWnobord = imclearborder(BWdfill, 4);
figure, imshow(BWnobord), title('cleared border image');

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');

BWoutline = bwperim(BWfinal);
I(~BWfinal)=0;
%Segout(BWoutline) = 255; 
figure, imshow(I), title('masked original image');

%end