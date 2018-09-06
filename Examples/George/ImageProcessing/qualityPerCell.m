function result= qualityPerCell(image)
% this function will read in the image, pick up the foreground and segment
% the cell images, and return the Signal to Noise Ratio and other information.
% The output structure contains the following fields:
% SNRvalues:    Signal to Noise Ratio(SNR) for each cell
% cellIm:       The image only contains the effective cells
% cellP:        Number of pixels corresponding to all the cells
% effectiveP:   Number of pixels corresponding to the effective cells
% CC:           Connected components of all the cells
% stats:        table of detailes of Cells

% dege detection based segmentation
[~,clustered]=edgeFun(imadjust(image));
image=image(2:end-1,2:end-1);

% clustering based segmentation
[I,clustered]=autoCluster2(clustered);
if (sum(I(:))>0.95*length(image(:)))
    I=~I;
    disp('automatically flipped.');
end
%imshow(imadjust(clustered));

% Connected components of all the cells
CC=bwconncomp(I);
% table of detailes of Cells
s=regionprops('table',CC,'Area','Centroid','Eccentricity','Extent');

% Remove nonvalid cells based on their area, eccentricity, and extent
selected=1:CC.NumObjects;
selected(s.Area>mean(s.Area)+3*std(s.Area))...
    =0;
selected(s.Eccentricity>mean(s.Eccentricity)+3*std(s.Eccentricity))...
    =0;
selected(s.Extent<mean(s.Extent)-3*std(s.Extent))...
    =0;
selected(selected==0)=[];

blank=false(size(I));

% only draw the effective cells
tempI=blank;
for id=selected
    tempI(CC.PixelIdxList{id})=true;
end
cellP=sum(I(:));
effectiveP=sum(tempI(:));

%imshowpair(tempI,I);

cellIm=image;
cellIm(~tempI)=0;
%figure,imshowpair(imadjust(image),imadjust(cellIm));

% Nested Function for calcuating SNR
    function value=SNR(id)
        temp=blank;
        temp(CC.PixelIdxList{id})=true;
        temp=imdilate(temp,strel('disk',ceil(sqrt(s.Area(id)))));
        temp=temp&~I;
        %imshowpair(image,temp);
        S=double(image(CC.PixelIdxList{id}));
        N=double(image(temp));
        value=10*log10((((mean(S)-mean(N))/std(N))^2));
    end
% SNR values for all the effective cells
result.SNRvalues=arrayfun(@SNR,selected);

result.cellIm=cellIm;
result.cellP=cellP;
result.effectiveP=effectiveP;
result.CC=CC;
result.stats=s;
end