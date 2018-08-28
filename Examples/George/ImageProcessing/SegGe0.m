function finalim=SegGe0(filename,rforgaussion,rforclosing)
warning('off');
sample=(imread(filename));
if (nargin<3)
    rforclosing=ceil(min(size(sample,1),size(sample,2))/80);
    if (nargin<2)
        rforgaussion=false;
    end
end

% initial saddle plot (S)
gsample=rgb2gray(sample);
if (rforgaussion)
    I=double(imgaussfilt(gsample,rforgaussion));
else
    I=double(gsample);
end
Ia=I(3:end,2:end-1)+I(1:end-2,2:end-1)-I(2:end-1,1:end-2)-I(2:end-1,3:end);
Ib=I(3:end,3:end)+I(1:end-2,1:end-2)-I(1:end-2,3:end)-I(3:end,1:end-2);
S=(Ia.^2+Ib.^2/4).^0.5;
I([1,end],:,:)=[];
I(:,[1,end],:)=[];
S=uint8(I.*S/max(S(:)));
figure, imshowpair(gsample,S,'montage');

% closed saddle plot
S0=S;

S=imclose(S,strel('disk', rforclosing));
S=imadjust(S);
S=imfill(S,'holes');
%S=imclearborder(imopen(S,strel('disk', rforclosing)),4);
figure,imshow(S);
figure,plot(cumsum(histcounts(S))/length(S(:)));
S=imbinarize(S);

figure, imshowpair(S,S0,'montage');

sample([1,end],:,:)=[];
sample(:,[1,end],:)=[];
bsample=imgaussfilt(sample,sqrt(rforclosing));

fadesample=uint8(double(sample).*repmat(double(255-S)/255,1,1,3));
fadebsample=uint8(double(bsample).*repmat(double(255-S)/255,1,1,3));
figure, imshow([sample,fadesample,fadebsample]);

bIto=~imbinarize(S);
bisample=sample;
bisample(repmat(bIto,1,1,3))=0;
bsample(repmat(bIto,1,1,3))=0;
figure, imshow([sample,bisample,bsample]);
end