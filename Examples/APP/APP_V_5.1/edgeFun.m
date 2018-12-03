function [I,foreground]=edgeFun(filename,rforgaussion,rforclosing)
warning('off');
if ischar(filename)
    sample=(imread(filename));
else
    sample=filename;
end
%sample=imadjust(sample);
if (nargin<3)
    rforclosing=ceil(min(size(sample,1),size(sample,2))/1000);
    if (nargin<2)
        rforgaussion=1;
    end
end

% initial saddle plot
if (size(sample,3)>1)
    gsample=rgb2gray(sample);
else
    gsample=sample;
end
if (rforgaussion)
    I=double(imgaussfilt(gsample,rforgaussion));
else
    I=double(gsample);
end
Ia=I(3:end,2:end-1)+I(1:end-2,2:end-1)-I(2:end-1,1:end-2)-I(2:end-1,3:end);
Ib=I(3:end,3:end)+I(1:end-2,1:end-2)-I(1:end-2,3:end)-I(3:end,1:end-2);
Ito=(Ia.^2+Ib.^2/4).^0.5;%./(I(2:end-1,2:end-1)+1);
I([1,end],:,:)=[];
I(:,[1,end],:)=[];
Ito=I.*Ito/max(Ito(:));
Ito=uint16(Ito/max(Ito(:))*(2^16-1));
%figure, imshowpair(gsample,Ito,'montage');

% closed saddle plot

IIto=Ito;
Ito = imfill(Ito,'holes');
Ito=imopen(Ito, strel('disk', rforclosing));

Ito=imclose(Ito, strel('disk', rforclosing));
Ito=imclearborder(Ito,8);
Ito=~imbinarize(Ito);

%figure, imshowpair(~Ito,IIto,'montage');

sample([1,end],:,:)=[];
sample(:,[1,end],:)=[];

fadesample=sample;
fadesample(repmat(Ito,1,1,size(sample,3)))=0;
%figure, imshow([sample,fadesample]);

foreground=sample;
foreground(repmat(Ito,1,1,size(sample,3)))=0;
%figure, imshow([sample,foreground]);
I=~Ito;

end