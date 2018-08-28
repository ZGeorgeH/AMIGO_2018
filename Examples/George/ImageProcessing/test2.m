function test2(filename,rforgaussion,rforclosing)
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

Ito=edge(I,'log');
Ito([1,end],:,:)=[];
Ito(:,[1,end],:)=[];
figure, imshowpair(gsample,Ito,'montage');

Ito=edge(I,'Sobel');
Ito([1,end],:,:)=[];
Ito(:,[1,end],:)=[];
figure, imshowpair(gsample,Ito,'montage');

% closed saddle plot
I([1,end],:,:)=[];
I(:,[1,end],:)=[];
Ito(~Ito)=0;
Ito = imclearborder(imclose(Ito, strel('disk', rforclosing)),4);
IIto=uint8(double(I).*((255-Ito)/255));
figure, imshowpair(Ito,IIto,'montage');

sample([1,end],:,:)=[];
sample(:,[1,end],:)=[];
bsample=imgaussfilt(sample,sqrt(rforclosing));

fadesample=uint8(double(sample).*repmat(double(255-Ito)/255,1,1,size(sample,3)));
fadebsample=uint8(double(bsample).*repmat(double(255-Ito)/255,1,1,size(sample,3)));
figure, imshow([sample,fadesample,fadebsample]);

bIto=Ito;
bisample=sample;
bisample(repmat(bIto,1,1,1))=0;
bsample(repmat(bIto,1,1,1))=0;
figure, imshow([sample,bisample,bsample]);
end