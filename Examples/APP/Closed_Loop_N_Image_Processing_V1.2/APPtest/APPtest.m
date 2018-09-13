function APPtest(numofImages,stepLength)
rng('shuffle','simdTwister');
pattern=randi(2,numofImages,1);
disp(pattern-1 );

for ind=1:numofImages
    pause(stepLength);
    copyfile(['image',num2str(pattern(ind)),'.nd2'],['testFile',num2str(ind),'.nd2']);
    copyfile(['testFile',num2str(ind),'.nd2'],'testFolder');
    
end
end