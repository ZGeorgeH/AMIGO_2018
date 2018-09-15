%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In silico experiment OID script - runs PE, OED, mock experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resultFileName = ['APPtest.dat'];
rng shuffle;
rngToGetSeed = rng;

totalDuration = 50*60;               % Duration in of the experiment (minutes)
numLoops=5; % Number of OID loops
duration = totalDuration/numLoops;   % Duration of each loop (in our case the number is 1)
stepDuration = 15;                % Duration of each step (minutes). Note that the value passed to the function exceeds the response time, quantified in 80 mins for MPLac,r
obsfrequency=5;


% Write the header information of the .dat file in which the results of
% PE (estimates, relative confidence intervals, residuals, relative
% residuals and the time required for computation) will be stored.
fid = fopen(resultFileName,'w');
fprintf(fid,'HEADER DATE %s\n', datestr(datetime()));
fprintf(fid,'HEADER RANDSEED %d\n',rngToGetSeed.Seed);
fclose(fid);

startTime = datenum(now);

results_folder = strcat('InduciblePromoter',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = strcat('IndProm',int2str(epccNumLoops));

% Read the model into the model variable
InduciblePromoter_load_model_optimised;

% We start with no experiments
exps.n_exp=0;


% Defining boundaries for the parameters (taken from scientific literature)
global_theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217];       % Maximum allowed values for the parameters
global_theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012];    % Minimum allowed values for the parameters
%giving the theta guess here...
global_theta_guess = [0.0164186333380725 0.291556643109224 1.71763487775568 5.14394334860864 0.229999999999978 6.63776658557266 0.00575139649497780 0.0216999999961899];

% Specify the parameters to be calibrated.
% The selection depends on the identifiability analysis preceding the
% comparison: parameters that are not identifiable will fixed to the best
% estimate available for them.
% In our case, all parameters are identifiable.
% param_including_vector = [true,true,true,true,true,true,true,true];

% Compile the model
inputs.model = model;
inputs.pathd.results_folder = results_folder;
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup';
AMIGO_Prep(inputs);

inputs.PEsol.global_theta_max=global_theta_max;
inputs.PEsol.global_theta_min=global_theta_min;
inputs.exps=exps;
inputs.exps.exp_y0{1}=InduciblePromoter_steady_state(global_theta_guess,0);

inputs.exps.n_exp = 1;
inputs.exps.n_obs{1}=1;
inputs.exps.obs_names{1}=char('Fluorescence');
inputs.exps.obs{1}= char('Fluorescence = Cit_fluo');
inputs.exps.exp_y0{1}= [y0];

inputs.exps.t_f{1}=[];
inputs.exps.n_s{1}=0;
inputs.exps.t_s{1}=[];

inputs.exps.u_interp{1}='step';
inputs.exps.n_steps{1}=0;
inputs.exps.t_con{1}=[];

inputs.exps.u{1}=[];