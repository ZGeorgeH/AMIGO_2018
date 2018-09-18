function [y1,u,pred] = OED(inputs,duration,y0,stepDuration)
load('demodata.mat','results');
u1=ceil(inputs.exps.n_steps{1}*stepDuration/duration)*(duration/stepDuration)+1;
u=results.oed.u{1}(u1:(u1+duration/stepDuration));
y1=results.sim.states{1}((u1+duration/stepDuration),:);
u2=(u1-1)*5;
pred=results.sim.sim_data{1}((u2+1):(u2+1+duration/1));
pause(0.75);
end