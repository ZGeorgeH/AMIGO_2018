function [transformedImage, referenceInfo]=affine(img,backGround)
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.009;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;
[transformedImage, referenceInfo] = imregister(img, backGround, 'affine', optimizer, metric);
transformedImage=(transformedImage-backGround)+(backGround-transformedImage);
end