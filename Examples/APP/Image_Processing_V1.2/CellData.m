function result= CellData(image)
% this function will read in the image, pick up the foreground and segment
% the cell images, and return the Signal to Noise Ratio and other information.
% The output structure contains the following fields:
% SNRvalues:    Signal to Noise Ratio(SNR) for each cell
% cellIm:       The image only contains the effective cells
% cellP:        Number of pixels corresponding to all the cells
% effectiveP:   Number of pixels corresponding to the effective cells
% CC:           Connected components of all the cells
% stats:        table of detailes of Cells

% edge detection based segmentation
[~,clustered]=edgeFun(imadjust(image));
image=image(2:end-1,2:end-1);
figure; imshowpair(imadjust(clustered),image,'Montage');

% clustering based segmentation
[I,clustered]=autoCluster2(clustered);
if (sum(I(:))>0.90*length(image(:)))
    I=~I;
end
figure; imshowpair(imadjust(clustered),imadjust(clustered),'Montage');

% Connected components of all the cells
CC=bwconncomp(I);
% table of detailes of Cells
s=regionprops('table',CC,'Area','Centroid','Eccentricity','Extent');

% Remove nonvalid cells based on their area, eccentricity, and extent
selected=1:CC.NumObjects;

selected(s.Eccentricity>mean(s.Eccentricity(logical(selected)))+...
    3*std(s.Eccentricity(logical(selected))))...
    =0;
selected(s.Extent<mean(s.Extent(logical(selected)))-...
    3*std(s.Extent(logical(selected))))...
    =0;
selected(s.Area>mean(s.Area(logical(selected)))+...
    3*std(s.Area(logical(selected))))...
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
 
result.fluoLevels=arrayfun(@(id) sum(double(image(CC.PixelIdxList{id}))),...
    selected);

result.cellIm=cellIm;
result.effectiveP=effectiveP/cellP;
result.CC=CC;
result.stats=s;
result.mean=mean(result.fluoLevels);
result.std=std(result.fluoLevels);
end