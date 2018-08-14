function saddleimage= saddle2(image)
figure, imshow(image);
image1=imgaussfilt(image,1);
image1=double(image1+0*(image1-imgaussfilt(image1,3)));
figure, imshow(uint8(image1));
% calculate the sign of saddle points.
Ia=(image1(2:end-1,3:end)+image1(2:end-1,1:end-2)-image1(3:end,2:end-1)-image1(1:end-2,2:end-1)).^2;
Ib=0.25*(image1(3:end,3:end)+image1(1:end-2,1:end-2)-image1(3:end,1:end-2)-image1(1:end-2,3:end)).^2;
saddleimage=(Ia+Ib).^0.5;
saddleimage=uint8(saddleimage/max(saddleimage(:))*255);

figure, imshow(saddleimage), title('significance of saddle point');
image([1,end],:)=[];
image(:,[1,end])=[];


    se = strel('disk', 10);
Io = imclose(saddleimage, se);
    figure, imshow(Io), title('Opening (Io)')
    
    Ie = imerode(Io, se);
    Iobr = imreconstruct(Ie, saddleimage);
    figure, imshow(Iobr), title('Opening-by-reconstruction (Iobr)')
    
    Ioc = imopen(Io, se);
    figure, imshow(Ioc), title('Opening-closing (Ioc)')
    
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    figure, imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')
    
    % creating the mask
    bw = imbinarize(Iobrcbr);
image(bw)=0;
figure,imshow(image);
end