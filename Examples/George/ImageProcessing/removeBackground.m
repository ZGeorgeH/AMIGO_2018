function [foreground,rp] = removeBackground(image,background)
image=double(image);
background=double(background);
rp=sum(sum(image.*background))/sum(background(:).^2);
foreground=imadjust(uint16(image-rp*background));
end

