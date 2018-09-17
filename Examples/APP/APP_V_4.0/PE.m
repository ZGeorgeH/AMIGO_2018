function inputs = PE(inputs)
   inputs.model.par=inputs.model.par.*random('norm',1,0.05,1,length(inputs.model.par));
   pause(0.5);
end

