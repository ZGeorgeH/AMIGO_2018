% figure,imshow(I1,[]), title('raw image1');
% figure,imshow(I2,[]), title('raw image2');
% figure,imshowpair(I1,I2,'Scaling','joint'), title('misaligned images');
% figure,imshowpair(I1,movingRegistered,'Scaling','joint'), title('registered images');
figure,imshow(imabsdiff(I2,I1c),[]), title('Difference between Raw Images');
figure,imshow(movingRegistered-I1c,[]), title('Difference between Registered Images');