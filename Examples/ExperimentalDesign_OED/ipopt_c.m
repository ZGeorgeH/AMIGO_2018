function [c]= ipopt_f(x)
global n_fun_eval params 
[f,c]= AMIGO_OEDcost(x,params{:});
n_fun_eval=n_fun_eval+1; 
return