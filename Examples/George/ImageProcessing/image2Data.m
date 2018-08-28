function [meanIntensity,meanSize,cellCount]=image2Data...
    (image,setting,background)
%sdf
%asdfds
setting.rgaussion=2;
setting.rclosing=4;

%% Import the image
if ischar(image)
    image=(imread(image));
end

%% Remove background if the background image is provided
% TODO: test the performance of sum(sum(... vs (:)
if (nargin>3)
    if ischar(background)
        background=(imread(background));
    end
    background=double(background);
    rp=sum(sum(double(image).*background))/sum(background(:).^2);
    image=imadjust(uint16(image-rp*background));
end

%% Edge detection and picking the foregound
if (isfield(setting,'rgaussion'))
    rgaussion=setting.rgaussion;
else
    rgaussion=0;
end
if (isfield(setting,'rclosing'))
    [foreground,BW]=edgeDet(image,rgaussion,setting.rclosing);
else
    [foreground,BW]=edgeDet(image,rgaussion);
end


meanIntensity=foreground;
meanSize=BW;
cellCount=0;
end

function [foreground,BW]=edgeDet(image,rforgaussion,rforclosing)
warning('off');
image=imadjust(image);
if (nargin<3)
    rforclosing=ceil(min(size(image,1),size(image,2))/1000);
    if (nargin<2)
        rforgaussion=0;
    end
end

% initial saddle plot
if (size(image,3)>1)
    gsample=rgb2gray(image);
else
    gsample=image;
end
if (rforgaussion)
    I=double(imgaussfilt(gsample,rforgaussion));
else
    I=double(gsample);
end
Ia=I(3:end,2:end-1)+I(1:end-2,2:end-1)-I(2:end-1,1:end-2)-I(2:end-1,3:end);
Ib=I(3:end,3:end)+I(1:end-2,1:end-2)-I(1:end-2,3:end)-I(3:end,1:end-2);
BW=(Ia.^2+Ib.^2/4).^0.5;
I([1,end],:,:)=[];
I(:,[1,end],:)=[];
BW=I.*BW/max(BW(:));
BW=uint16(BW/max(BW(:))*(2^16-1));

% closed saddle plot
BW=imfill(BW,'holes');
BW=imopen(BW, strel('disk', rforclosing));
BW=imclose(BW, strel('disk', rforclosing));
BW=imclearborder(BW,8);
BW=imbinarize(BW);

image([1,end],:,:)=[];
image(:,[1,end],:)=[];

foreground=image;
foreground(repmat(~BW,1,1,size(image,3)))=0;
end