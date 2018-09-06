function result = valueArray(imageCell)
results=cellfun(@qualityPerCell,imageCell,'UniformOutput',false);
result=cell2mat(cellfun(@(x) x.SNRvalues,results,'UniformOutput',false)');
end

