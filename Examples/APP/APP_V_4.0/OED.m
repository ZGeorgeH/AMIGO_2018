function [y1,u] = OED(inputs,duration,y0,stepDuration)
    
    format long g
        
    % Add new experiment that is to be designed
    inputs.exps.n_exp = inputs.exps.n_exp + 1;                     % Number of experiments
    iexp = inputs.exps.n_exp;                                       % Index of the experiment
    inputs.exps.exp_type{iexp}='od';                                % Specify the type of experiment: 'od' optimally designed
    inputs.exps.n_obs{iexp}=1;                                      % Number of observables in the experiment
    inputs.exps.obs_names{iexp}=char('Fluorescence');               % Name of the observables in the experiment
    inputs.exps.obs{iexp}=char('Fluorescence = Cit_fluo');          % Observation function
        
    % Fixed parts of the experiment
    inputs.exps.exp_y0{iexp}=y0;                                % Initial conditions
    inputs.exps.t_f{iexp}=duration;                                 % Duration of the experiment (minutes)
    inputs.exps.n_s{iexp}=duration/5+1;                             % Number of sampling times - sample every 5 min
    
    % OED of the input
    inputs.exps.u_type{iexp}='od';
    inputs.exps.u_interp{iexp}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
    inputs.exps.n_steps{iexp}=round(duration/stepDuration);         % Number of steps in the input
    inputs.exps.t_con{iexp}=0:stepDuration:(duration);            % Switching times
    inputs.exps.u_min{iexp}=0*ones(1,inputs.exps.n_steps{iexp});    % Lower boundary for the input value
    inputs.exps.u_max{iexp}=1000*ones(1,inputs.exps.n_steps{iexp}); % Upper boundary for the input value
    
    inputs.PEsol.id_global_theta=inputs.model.par_names;%(param_including_vector,:);
    inputs.PEsol.global_theta_guess=inputs.model.par';%(param_including_vector,:);
    inputs.PEsol.global_theta_max=inputs.PEsol.global_theta_max;  % Maximum allowed values for the parameters
    inputs.PEsol.global_theta_min=inputs.PEsol.global_theta_min;  % Minimum allowed values for the parameters
    
    
    inputs.exps.noise_type='homo_var';           % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default)
    inputs.exps.std_dev{iexp}=0.05;
    inputs.OEDsol.OEDcost_type='Dopt';
    
%     
%     % final time constraint
%     for iexp=1:inputs.exps.n_exp
%         inputs.exps.n_const_ineq_tf{iexp}=1;
%         inputs.exps.const_ineq_tf{iexp}=char('cviol');     % c<=0
%     end
%     inputs.exps.ineq_const_max_viol=1.0e-5;
    
    
    % SIMULATION
    inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
    inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes'(default, C)| 'sensmat'(matlab)|'fdsens2'|'fdsens5'
    inputs.ivpsol.rtol=1.0D-8;                            % [] IVP solver integration tolerances
    inputs.ivpsol.atol=1.0D-8;
    
    % OPTIMIZATION
    %oidDuration=600;
    inputs.nlpsol.nlpsolver='eSS';
    inputs.nlpsol.eSS.maxeval = 5e4;
    inputs.nlpsol.eSS.maxtime = 6e3;
    inputs.nlpsol.eSS.local.solver = 'fmincon'; % note that, in order to handle constraints, an SQP approach is required (e.g. fminsearch cannot be used).
    inputs.nlpsol.eSS.local.finish = 'fmincon';%fmincon';
    
    inputs.nlpsol.eSS.local.nl2sol.maxiter  =     300;     % max number of iteration
    inputs.nlpsol.eSS.local.nl2sol.maxfeval =     500;     % max number of function evaluation
    inputs.nlpsol.eSS.log_var=1:inputs.exps.n_steps{iexp};
    inputs.plotd.plotlevel='noplot';
    
    inputs.pathd.results_folder = inputs.pathd.results_folder;
    inputs.pathd.short_name     = inputs.pathd.short_name;
    inputs.pathd.runident       = strcat('oed');
    
    results = AMIGO_OED(inputs);
        
    % the initial state for the next loop
    y1=results.sim.states{1}(end,:);
    u=results.oed.u{1};    
end