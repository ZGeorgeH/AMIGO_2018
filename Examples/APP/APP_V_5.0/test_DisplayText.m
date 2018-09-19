%% Load model
n_st=3;                                                                           % Number of states      
n_par=8;                                                                          % Number of model parameters 
n_stimulus=1;                                                                     % Number of inputs, stimuli or control variables   
st_names=char('Cit_mrna','Cit_foldedP','Cit_fluo');                       % Names of the states                                        
par_names=char('alpha1','Vm1','h1','Km1','d1',...
                            'alpha2','d2','Kf');                                        % Names of the parameters                     
stimulus_names=char('IPTG');                                                      % Names of the stimuli, inputs or controls                      
eqns=...                                                                          % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dCit_mrna=alpha1+Vm1*(IPTG^h1/(Km1^h1+IPTG^h1))-d1*Cit_mrna',...
                    'dCit_foldedP=alpha2*Cit_mrna-(d2+Kf)*Cit_foldedP',...
                    'dCit_fluo=Kf*Cit_foldedP-d2*Cit_fluo');   

%% Set Style                
stateStyle='mathit'; % Yellow
parStyle='mathrm'; % Green
stimStyle='mathit'; % Blue
obsStyle='mathit'; % Orange

%% Generate Text
%sym text
eqs=str2sym(eqns);

%generate the parameter lists for replacement (two syms for one state because of the dstate)
states=[str2sym(st_names);str2sym([repmat('d',n_st,1),st_names])];
statesSub=[str2sym([repmat('modelStateNumber^',n_st,1),num2str((2:n_st+1)')]);...
    str2sym([repmat('dmodelStateNumber^',n_st,1),num2str((2:n_st+1)')])];
pars=str2sym(par_names);
parsSub=str2sym([repmat('modelParNumber^',n_par,1),num2str((2:n_par+1)')]);
% obs=str2sym(obs_names);
% obsSub=str2sym([repmat('modelObsNumber^',n_obs,1),num2str((2:n_obs+1)')]);
stims=str2sym(stimulus_names);
stimsSub=str2sym([repmat('modelStimNumber^',n_stimulus,1),num2str((2:n_stimulus+1)')]);

%replace all the parameters with their markers (prepare for the style change)
eqs=subs(eqs,[states;pars;stims],[statesSub;parsSub;stimsSub]);

%generate latex code
eqs=latex(eqs);
%for more than one ODEs, there is an extra bracket, should be removed.
eqs=eqs(7:end-7);
%get all ODEs Left aligned, and change 'd' into 'd/dt'
eqs=strrep(eqs,'\begin{array}{c} {\mathrm{d','\begin{array}{l} \frac{d}{dt}{\mathrm{');
eqs=strrep(eqs,'\\ {\mathrm{d','\\ \frac{d}{dt}{\mathrm{');

%replace the markers with the true name in the right form
states=arrayfun(@latex,states,'UniformOutput',false);
states=cellfun(@(text) strrep(text,'\mathrm{','{'),states,'UniformOutput',false);
for ind=1:n_st
eqs = strrep(eqs,['{\mathrm{modelStateNumber}}^',num2str(ind+1)],...
    ['{\',stateStyle,'{',states{ind},'}}']);
end
% 
pars=arrayfun(@latex,pars,'UniformOutput',false);
pars=cellfun(@(text) strrep(text,'\mathrm{','{'),pars,'UniformOutput',false);
for ind=1:n_par
eqs = strrep(eqs,['{\mathrm{modelParNumber}}^',num2str(ind+1)],...
    ['{\',parStyle,'{',pars{ind},'}}']);
end

stims=arrayfun(@latex,stims,'UniformOutput',false);
stims=cellfun(@(text) strrep(text,'\mathrm{','{'),stims,'UniformOutput',false);
for ind=1:n_stimulus
eqs = strrep(eqs,['{\mathrm{modelStimNumber}}^',num2str(ind+1)],...
    ['{\',stimStyle,'{',stims{ind},'}}']);
end

%% Show Text
disp(eqs);
figure();
t=text(0.01,1,['$$\renewcommand{\arraystretch}{1.5}',eqs,'$$'],...
    'FontSize',20,'interpreter','latex','VerticalAlignment','top');