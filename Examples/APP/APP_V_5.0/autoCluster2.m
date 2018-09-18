function [I,foreground]=autoCluster2(filename)

warning('off');
if ischar(filename)
    sample=(imread(filename));
else
    sample=filename;
end

% initial saddle plot
if (size(sample,3)>1)
    gsample=rgb2gray(sample);
else
    gsample=sample;
end

I=imadjust(gsample,[],[],2);
I=imgaussfilt(I,1);

im = single(I(:));
im = im - mean(im);
im = im ./ std(im);
L = kmeans(im,2,'Replicates',2);
BW = (L==2);
I = reshape(BW,size(I));

I=imopen(I, strel('disk', 5));

foreground=sample;
foreground(~repmat(I,1,1,size(sample,3)))=0;
end