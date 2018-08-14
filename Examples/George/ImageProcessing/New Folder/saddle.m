function saddleimage= saddle(image)
figure, imshow(image);
image1=image;%imgaussfilt(image,3);
image1=double(image1);%+6*(image1-imgaussfilt(image1,5)));
figure, imshow(uint8(image1));
% calculate the sign of saddle points.
Ia=(image1(2:end-1,3:end)+image1(2:end-1,1:end-2)-image1(3:end,2:end-1)-image1(1:end-2,2:end-1)).^2;
Ib=0.25*(image1(3:end,3:end)+image1(1:end-2,1:end-2)-image1(3:end,1:end-2)-image1(1:end-2,3:end)).^2;
saddleimage=(Ia+Ib).^0.25;
saddleimage=uint8(saddleimage/max(saddleimage(:))*255);

figure, imshow(saddleimage), title('significance of saddle point');
image([1,end],:)=[];
image(:,[1,end])=[];

se = strel('disk',2);

Ioc = imclose(saddleimage, se);
%figure, imshow(Ioc), title('Opening-closing saddle point image');

image(imbinarize(Ioc))=0;

image=imclearborder(image,4);
figure,imshowpair(imbinarize(Ioc),image,'montage');
end