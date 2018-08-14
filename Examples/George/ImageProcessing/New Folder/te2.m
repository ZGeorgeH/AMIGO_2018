%I1 = imread('Capture1.PNG');
%I2 = imread('Capture2.PNG');
Iall={I1,I2};
% preallocation for the final results.
Iallmasked=Iall;

for temp=1:length(Iall)
    I=Iall{temp};
    % Turn RGB into 2D images
    if (size(I,3)==3)
        I=rgb2gray(I);
    end
    figure, imshow(I),title('original image');
    % Mark the foreground
    % no particularly prefered dirrections
    se = strel('disk', 20);
    
    % Opening is an erosion followed by a dilation,
    % while opening-by-reconstruction is an erosion followed by
    % a morphological reconstruction. 
    Io = imopen(I, se);
    %figure, imshow(Io), title('Opening (Io)')
    
    Ie = imerode(Io, se);
    Iobr = imreconstruct(Ie, I);
    %figure, imshow(Iobr), title('Opening-by-reconstruction (Iobr)')
    
    Ioc = imclose(Io, se);
    %figure, imshow(Ioc), title('Opening-closing (Ioc)')
    
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    %figure, imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')
    
    % creating the mask
    bw = imbinarize(Iobrcbr);
    figure
    imshow(bw), title('Thresholded opening-closing by reconstruction (bw)')
    
    I(~bw)=0;
    Iallmasked{temp}=I;
    imshow(I);
end