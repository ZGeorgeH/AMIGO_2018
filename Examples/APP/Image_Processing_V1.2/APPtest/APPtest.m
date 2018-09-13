function APPtest(numofImages,stepLength)
rng('shuffle','simdTwister');
%pattern=randi(2,numofImages,1);
pattern=[2,1,1,2,1,2,2,1,1,1,2,2,2,1,2];
disp(pattern-1 );
tic
for ind=1:length(pattern)
    pause(stepLength-toc); % Actuator moves once every stepLength (in seconds)
    tic;
    copyfile(['image',num2str(pattern(ind)),'.nd2'],['testFile',num2str(ind),'.nd2']);
    copyfile(['testFile',num2str(ind),'.nd2'],'testFolder');
end
end