function inputs = PE(inputs)
    inputs2.model = inputs.model;
    inputs2.exps  = inputs.exps;
    
    inputs2.pathd.results_folder = inputs.results_folder;
    inputs2.pathd.short_name     = inputs.short_name;
    inputs2.pathd.runident       = inputs.strcat('pe');
    
    % GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)
    inputs2.PEsol.id_global_theta=inputs.model.par_names;%(param_including_vector,:);
    inputs2.PEsol.global_theta_guess=inputs.model.par';%(param_including_vector));
    inputs2.PEsol.global_theta_max=inputs.PEsol.global_theta_max;
    inputs2.PEsol.global_theta_min=inputs.PEsol.global_theta_min;
    
    % COST FUNCTION RELATED DATA
    inputs2.PEsol.PEcost_type='lsq';        % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'
    inputs2.PEsol.lsq_type='Q_expmax';
    
    % SIMULATION
    inputs2.ivpsol.ivpsolver='cvodes';
    inputs2.ivpsol.senssolver='cvodes';
    inputs2.ivpsol.rtol=1.0D-7;
    inputs2.ivpsol.atol=1.0D-7;
    
    
    % OPTIMIZATION
    inputs2.nlpsol.nlpsolver='eSS';
    inputs2.nlpsol.eSS.maxeval = 200000;
    inputs2.nlpsol.eSS.maxtime = 5000;
    inputs2.nlpsol.eSS.local.solver = 'lsqnonlin';  % nl2sol not yet installed on my mac
    inputs2.nlpsol.eSS.local.finish = 'lsqnonlin';  % nl2sol not yet installed on my mac
    inputs2.rid.conf_ntrials=500;
    
    inputs2.plotd.plotlevel='noplot';
    

    results = AMIGO_PE(inputs2);
    inputs.model.par=results.fit.thetabest;
end

