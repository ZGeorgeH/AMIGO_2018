function test(filename,rforgaussion,rforclosing)
warning('off');
if ischar(filename)
    sample=(imread(filename));
else
    sample=filename;
end
if (nargin<3)
    rforclosing=ceil(min(size(sample,1),size(sample,2))/1000);
    if (nargin<2)
        rforgaussion=0;
    end
end

%sample=imcomplement(sample);
% initial saddle plot
if (size(sample,3)>1)
    gsample=rgb2gray(sample);
else
    gsample=sample;
end
if (rforgaussion)
    I=imgaussfilt(gsample,rforgaussion);
else
    I=gsample;
end
Ia=((I(3:end,2:end-1)+I(1:end-2,2:end-1))-(I(2:end-1,1:end-2)+I(2:end-1,3:end)))...
    +((I(2:end-1,1:end-2)+I(2:end-1,3:end))-(I(3:end,2:end-1)+I(1:end-2,2:end-1)));
Ib=(I(1:end-2,3:end)+I(3:end,1:end-2))-(I(3:end,3:end)+I(1:end-2,1:end-2))...
    +((I(2:end-1,1:end-2)+I(2:end-1,3:end))-(I(3:end,2:end-1)+I(1:end-2,2:end-1)));
Ito=double(Ia.^2+Ib.^2/4).^0.25;
Ito=Ito/max(Ito(:))*255;
figure, imshowpair(gsample,uint8(Ito),'montage');

% closed saddle plot
I([1,end],:,:)=[];
I(:,[1,end],:)=[];
Ito(~imbinarize(Ito,120))=0;
Ito = imclearborder(imclose(Ito, strel('disk', rforclosing)),4);
IIto=uint8(double(I).*((255-Ito)/255));
figure, imshowpair(Ito,IIto,'montage');

sample([1,end],:,:)=[];
sample(:,[1,end],:)=[];
bsample=imgaussfilt(sample,sqrt(rforclosing));

fadesample=uint8(double(sample).*repmat(double(255-Ito)/255,1,1,size(sample,3)));
fadebsample=uint8(double(bsample).*repmat(double(255-Ito)/255,1,1,size(sample,3)));
figure, imshow([sample,fadesample,fadebsample]);

bIto=~imbinarize(Ito);
bisample=sample;
bisample(repmat(bIto,1,1,size(sample,3)))=0;
bsample(repmat(bIto,1,1,size(sample,3)))=0;
bisample=imclearborder(bisample,4);
bsample=imclearborder(bsample,4);
figure, imshow([sample,bisample,bsample]);
end