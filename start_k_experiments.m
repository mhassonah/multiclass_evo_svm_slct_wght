%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  Developed in Matlab R2015a  (8.5.0. 196713)                            %
%                                                                         %
%  Developed by: Mohammad A. Hassonah, Ala' M. Al-Zoubi and Hossam Faris  %
%                                                                         %
%  e-Mails: mohammad.a.hassonah@gmail.com, alaah14@gmail.com,             %
%           7ossam@gmail.com                                              %
%                                                                         %
%  Main paper:                                                            %
%  Faris, H., Hassonah, M.A., Ala'M, A.Z., Mirjalili, S. and Aljarah, I., %
%  A multi-verse optimizer approach for feature selection and optimizing  %
%  SVM parameters based on a robust system architecture. Neural Computing %
%  and Applications, pp.1-15.                                             %
%  DOI: https://doi.org/10.1007/s00521-016-2818-2                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [all_accuracies, all_best_cost,all_best_gamma, avg_accuracy, ...
    std_accuracy, all_mse, avg_mse, ...
    std_mse, all_rmse, avg_rmse, ...
    std_rmse, all_mae, avg_mae , std_mae, ...
    all_recalls, std_recalls, avg_recalls, ...
    all_precisions, std_precisions, avg_precisions, ...
    all_f_measures, std_f_measures, avg_f_measures, ...
    all_g_means, std_g_mean, avg_g_mean, ...
    all_num_of_feats, avg_num_of_feats, std_num_of_feats, ...
    convergence_points, all_best_indiv, label_order] ...
    = start_k_experiments(dataset, ext, algo, dir_data, k, fitness_type, ...
    run_type, population, max_iteration, lower_bound, upper_bound)

%% Read the data set
% Initialization
label = zeros; inst = zeros; %#ok<NASGU>

% Specify format
if (strcmpi(ext,'') == 1)
    [label, inst] = libsvmread(fullfile(dir_data, dataset));
elseif (strcmpi(ext,'.csv') == 1) % label is in first column -
    % % % % % % % % % % % % % % % % to change: go to read_csv.m
    [label, inst] = read_csv(dir_data, dataset);
else
    return;
end

[N, D] = size(inst);
label_order = sort(unique(label));
%% making k partitions
c = cvpartition(N,'KFold',k);

%% Start k-experiments
parfor i=1:k;
    
    train_index = zeros(N,1); train_index(find(training(c,i))) = 1; %#ok<FNDSB>
    test_index = zeros(N,1); test_index(find(test(c,i))) = 1; %#ok<FNDSB>
    train_data = inst(train_index==1,:); %#ok<*PFBNS>
    train_label = label(train_index==1,:);
    test_data = inst(test_index==1,:);
    test_label = label(test_index==1,:);
    
    % Best solution and convergence for training set
    [best_solution, convergence] = init_evo(train_label,train_data,D, ...
        algo, fitness_type, population, max_iteration, lower_bound, ...
        upper_bound, run_type);
    
    % Storing convergence points
    if (strcmp(fitness_type,'maximization') == 1)
        convergence_points(i,:) = 100 - convergence; %#ok<*AGROW>
    elseif (strcmp(fitness_type,'minimization') == 1)
        convergence_points(i,:) = convergence;
    end
    
    % Separating Cost, Gamma and other individuals
    [best_cost, best_gamma, individuals] = dismantle (best_solution, D);
    
    % Adjusting range of cost and gamma
    [cost, gamma] = adjust_cost_gamma (best_cost, best_gamma);
    
    % Initialize SVM parameters
    para =strjoin(strcat('-c',{' '},num2str(cost) ,{' '},'-g',{' '}, ...
        num2str(gamma) ,' -b 0 -q -h 0' ));
    
    % Get training model
    if (strcmp(run_type, 'with'))
        [selected_train_data, ~] = select_features(individuals,train_data);
    elseif (strcmp(run_type, 'without'))
        selected_train_data = train_data;
    elseif (strcmp(run_type, 'weight'))
        selected_train_data = weight_features(individuals,train_data);
    end
    
    model = svmtrain(train_label, selected_train_data, para);
    
    display(sprintf('\n'));
    display(strcat('Testing accuracy for fold number', num2str(i), ':'));
    
    % Train SVM and get testing accuracy
    if (strcmp(run_type, 'with'))
        [selected_test_data, ~] = select_features(individuals,test_data);
    elseif (strcmp(run_type, 'without'))
        selected_test_data = test_data;
    elseif (strcmp(run_type, 'weight'))
        selected_test_data = weight_features(individuals,test_data);
    end
    
    [predicted_label, eval_measure,~] = svmpredict(test_label, ...
        selected_test_data, model, '-b 0');
    [mse, rmse, mae] = get_eval_measures(test_label, predicted_label);
    display(sprintf('\n'));
    
    % Get confusion matrix
    
    % We specify the order param here to make sure that the outcome of the 
    % confusion matrix is as expected for correct evaluation measures
    % calculations
    [confusion_mat, ~] = ...
        confusionmat(test_label, predicted_label, 'Order', sort(unique(label)));

    precisions = diag(confusion_mat)./sum(confusion_mat,2);
    recalls = diag(confusion_mat)./sum(confusion_mat,1)';
    f_measures = 2*(precisions.*recalls)./(precisions + recalls);
    g_mean = sqrt(prod(recalls));
    
    % Collecting Values
    all_accuracies(i,:)= eval_measure(1);
    all_best_cost(i,:)= cost;
    all_best_gamma(i,:)= gamma;
    all_mse(i,:) = mse;
    all_rmse(i,:) = rmse;
    all_mae(i,:) = mae;
    all_best_indiv(i,:) = individuals;
    all_recalls(i,:) = recalls * 100;
    all_precisions(i,:) = precisions * 100;
    all_f_measures(i,:) = f_measures * 100;
    all_g_means(i,:) = g_mean * 100;
    all_confusion_mats(:,:,i) = confusion_mat;
    
    if (strcmp(run_type, 'with'))
        all_num_of_feats(i,:) = get_feature_count(individuals);
    elseif (strcmp(run_type, 'without'))
        all_num_of_feats(i,:) = D;
    elseif (strcmp(run_type, 'weight'))
        all_num_of_feats(i,:) = D;
    end
    
end

all_confusion_mats %#ok<NOPRT>

%% Calculating average & std
std_accuracy = std(all_accuracies);
avg_accuracy= mean(all_accuracies);

std_num_of_feats = std(all_num_of_feats);
avg_num_of_feats = mean(all_num_of_feats);

std_mse = std(all_mse);
avg_mse= mean(all_mse);

std_rmse = std(all_rmse);
avg_rmse= mean(all_rmse);

std_mae = std(all_mae);
avg_mae= mean(all_mae);

all_recalls(isnan(all_recalls))= 0;
std_recalls = std(all_recalls);
avg_recalls = mean(all_recalls);

all_precisions(isnan(all_precisions))= 0;
std_precisions = std(all_precisions);
avg_precisions = mean(all_precisions);

all_f_measures(isnan(all_f_measures))= 0;
std_f_measures = std(all_f_measures);
avg_f_measures = mean(all_f_measures);

all_g_means(isnan(all_g_means))= 0;
std_g_mean = std(all_g_means);
avg_g_mean = mean(all_g_means);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%