%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Implementation of a competitive swarm optimizer (CSO) for large scale optimization
%
%  See the details of CSO in the following paper
%  R. Cheng and Y. Jin, A Competitive Swarm Optimizer for Large Scale Optmization,
%  IEEE Transactions on Cybernetics, 2014
%
%  The test instances are the CEC'08 benchmark functions for large scale optimization
%
%  The source code CSO is implemented by Ran Cheng
%
%  If you have any questions about the code, please contact:
%  Ran Cheng at r.cheng@surrey.ac.uk
%  Prof. Yaochu Jin at yaochu.jin@surrey.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% begin code
function [bestever,best_individual,convergence_curve]= ...
    CSO_cross(population,max_iter,lb,ub,dim,fobj, fitness_type, fs_run_type, trainLabel,trainData)
addpath(genpath(pwd));

global initial_flag

d = dim; %d: dimensionality
maxfe = max_iter; %maxfe: maximal number of fitness evaluations
results = zeros(6,1); %maxfe: maximal number of fitness evaluations

n = d;
initial_flag = 0;
lu = [lb; ub]; % lu: define the upper and lower bounds of the variables

%phi setting (the only parameter in CSO, please SET PROPERLY)
% if(d >= 40)
%     phi = 0.3;
% elseif(d >= 30)
%     phi = 0.2;
% elseif(d >=20)
%     phi = 0.1;
% else
%     phi = 0;
% end;

phi = 0;

% population size setting
m = population;

% initialization
XRRmin = repmat(lu(1, :), m, 1);
XRRmax = repmat(lu(2, :), m, 1);
rand('seed', sum(100 * clock)); %#ok<RAND>
p = XRRmin + (XRRmax - XRRmin) .* rand(m, d);
fitness = benchmark_func_cross(p,fobj, fitness_type , fs_run_type, trainLabel,trainData);
v = zeros(m,d);
bestever = 1e200;
best_individual = p(1,:);
FES = m;
gen = 1;
convergence_curve=zeros(1,maxfe);

% main loop
while(gen <= maxfe)
    
    % generate random pairs
    rlist = randperm(m);
    rpairs = [rlist(1:ceil(m/2)); rlist(floor(m/2) + 1:m)]';
    
    % calculate the center position
    center = ones(ceil(m/2),1)*mean(p);
    
    % do pairwise competitions
    mask = (fitness(rpairs(:,1)) > fitness(rpairs(:,2)));
    losers = mask.*rpairs(:,1) + ~mask.*rpairs(:,2);
    winners = ~mask.*rpairs(:,1) + mask.*rpairs(:,2);
    
    
    %random matrix
    randco1 = rand(ceil(m/2), d);
    randco2 = rand(ceil(m/2), d);
    randco3 = rand(ceil(m/2), d);
    
    % losers learn from winners
    v(losers,:) = randco1.*v(losers,:) ...,
        + randco2.*(p(winners,:) - p(losers,:)) ...,
        + phi*randco3.*(center - p(losers,:));
    p(losers,:) = p(losers,:) + v(losers,:);
       
    % boundary control
    for i = 1:ceil(m/2)
        p(losers(i),:) = max(p(losers(i),:), lu(1,:));
        p(losers(i),:) = min(p(losers(i),:), lu(2,:));
    end
    
    fitness(losers,:) = benchmark_func_cross(p(losers,:),fobj, fitness_type, fs_run_type, trainLabel,trainData);
    [~, rank] = min(fitness);
    
    for i = 1:size(p(losers(i),:))
%         losers_mutated = MutationU(d,maxfe,p(losers(i),:),gen);
        losers_crossed = CrossOverU(d,maxfe,gen,p(losers(i),:), best_individual);
        fitness_cross = fobj(losers_crossed, fitness_type, fs_run_type, trainLabel,trainData);
        
        % fitness evaluation
        
        if (min(fitness) < bestever)
            best_individual = p(rank,:);
        end;
        
        if (fitness_cross < min(fitness) < bestever)
            best_individual = losers_crossed;
        end 
        
        bestever = min(bestever, min(fitness));
        bestever = min(bestever, fitness_cross);
    end
    
    convergence_curve(gen)= bestever;
    fprintf('Best fitness: %e\n', bestever);
    FES = FES + ceil(m/2);
    gen = gen + 1;
end;
