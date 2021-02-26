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

function evo_svm ()

%% Metaheuristic algorithms names:
Optimizers ...
    = {'MVO','GA','PSO','DA','GOA', 'SCA', 'SSA', 'WOA', 'FA', 'BAT',...
    'CSO', 'CSO_cross', 'HHO'};

MVO = 0;
GA	= 0;
PSO	= 0;
DA = 0;
GOA = 0;
SCA = 0;
SSA = 0;
WOA = 0;
FA = 0;
BAT = 0;
CSO = 0;
CSO_cross = 0;
HHO = 1;

algorithms = [MVO GA PSO DA GOA SCA SSA WOA FA BAT CSO CSO_cross HHO];

[~, algo_count]=size(algorithms);

%% Set fitness_type: "maximization" or "minimization"
fitness_type = 'maximization';

%% Add path to the data:
dir_data = 'E:\Personal\Research\Datasets';
addpath(dir_data);

%% Add path to the libsvm toolbox:
addpath('E:\Personal\Research\Code\SVM\libsvm-3.20\matlab');

%% Adding path to all subfolders - Do not change
addpath(genpath(fileparts(which(mfilename))));

%% Parameters
run_type = 'weight'; % Fearture Selection: with / without / weight
population = 20;
max_iteration = 30;
lower_bound = 0.01;
upper_bound = 1;
num_of_runs = 10;

%% Files Names Initialization
str=strtrim(cellstr(num2str(fix(clock)'))');
strs_spaces = sprintf('-%s' ,str{:});
filename=strcat('Experiments ',strtrim(strs_spaces));

filename_all_results= strcat(filename,' All Results.csv');
filename_convergences= strcat(filename,' Convergences.csv');
filename_average_convergences= strcat(filename,' Average Convergences.csv');
filename_best_individuals= strcat(filename,' Best Individual.csv');
filename_summary= strcat(filename,' Summary.csv');
filename_parameters= strcat(filename,' Parameters.csv');
            
%% Datasets Names:
datasets = {
    'English.csv'
    'English-3.csv'
%     'final_mhs_information.csv'
%     'sleep.csv'
%     'Dataset.csv'
%     'TF100_1_Genes.csv'
%     'umnia'
%     'churn'
%     'wick.csv'
%     'spectft'
%     'parkinsons'
%     'mushrooms'
%     'australian'
%     'ionosphere'
%     'sonar'
%     'german'
%     'vehicle'
%     'breast_cancer'
    'wine'
%     'vowel'
%     'cleveland'
%     'colon_cancer'
%     'diabetes'
%     'glass'
%     'iris'
%     'libras'
%     'liver_disorders'
%     'tae'
    };

[ds_count, ~]=size(datasets);

%%
for algo=1:algo_count
    
    if(algorithms(algo)==1)
        algorithm_name = cell(num_of_runs, 1);
        algorithm_name(:) = Optimizers(algo);
    
        for d_set = 1 : ds_count
            [~, name, ext] = fileparts(datasets{d_set});
            dataset_name = cell(num_of_runs, 1);
            dataset_name(:) = {name};
            
            [all_accuracies, all_best_cost,all_best_gamma, ...
                avg_accuracy, std_accuracy, all_mse, avg_mse, std_mse, ...
                all_rmse, avg_rmse, std_rmse, all_mae, avg_mae ,std_mae, ...
                all_recall, std_recall, avg_recall, ...
                all_precision, std_precision, ...
                avg_precision, ...
                all_f_measure, std_f_measure, avg_f_measure, ...
                all_g_mean, std_g_mean, avg_g_mean, ...
                all_num_of_feats, avg_num_of_feats, std_num_of_feats, ...
                convergence, all_best_individual, ...
                order] ...
                ...
                = start_k_experiments(datasets{d_set}, ext, algo ,  ...
                dir_data, num_of_runs, fitness_type, run_type, ...
                population, max_iteration, lower_bound, upper_bound);
            
            header_all_results = {'Algorithm','Dataset', 'Accuracy', ...
                'Num Of Feats', 'MSE', 'RMSE', 'MAE', 'Cost', 'Gamma', ...
                'G-Mean'};
            for k = 1 : length(order)
                header_all_results{end+1} = strcat('Recall_', num2str(order(k))); %#ok<*AGROW>
            end
            for k = 1 : length(order)
                header_all_results{end+1} = strcat('Precision_', num2str(order(k))); %#ok<*AGROW>
            end
            for k = 1 : length(order)
                header_all_results{end+1} = strcat('F-Measure_', num2str(order(k))); %#ok<*AGROW>
            end

            header_summary = {'Algorithm','Dataset','Accuracy', 'STD Accuracy', ...
                'Num Of Feats', 'STD Num Of Feats' , 'MSE','STD MSE', 'RMSE', ...
                'STD RMSE', 'MAE', 'STD MAE', 'G-Mean', 'STD G-Mean'};
            for k = 1 : length(order)
                header_summary{end+1} = strcat('Recall_', num2str(order(k))); %#ok<*AGROW>
            end
            for k = 1 : length(order)
                header_summary{end+1} = strcat('STD Recalls_', num2str(order(k))); %#ok<*AGROW>
            end
            for k = 1 : length(order)
                header_summary{end+1} = strcat('Precision_', num2str(order(k))); %#ok<*AGROW>
            end
            for k = 1 : length(order)
                header_summary{end+1} = strcat('STD Precisions_', num2str(order(k))); %#ok<*AGROW>
            end
            for k = 1 : length(order)
                header_summary{end+1} = strcat('F-Measure_', num2str(order(k))); %#ok<*AGROW>
            end
            for k = 1 : length(order)
                header_summary{end+1} = strcat('STD F-Measure_', num2str(order(k))); %#ok<*AGROW>
            end
                        
            header_parameters = {'Population', 'Max Iteration', 'Num Of Runs', ...
                'Upper Bound', 'Lower Bound'};

            dlmcell(filename_all_results, header_all_results, ',', '-a')
            dlmcell(filename_summary, header_summary, ',', '-a')
            dlmcell(filename_parameters, header_parameters, ',', '-a');
            dlmcell(filename_parameters, [ num2cell(run_type) num2cell(population) ...
                num2cell(max_iteration) num2cell(num_of_runs) num2cell(upper_bound) ...
                num2cell(lower_bound)], ',', '-a');
            
            % Organizing the data for Excel sheet
            folds_results = [all_accuracies all_num_of_feats all_mse ...
                all_rmse all_mae all_best_cost all_best_gamma all_g_mean ...                
                all_recall all_precision all_f_measure];
            
            summary_results = [ avg_accuracy std_accuracy avg_num_of_feats ...
                std_num_of_feats avg_mse std_mse avg_rmse std_rmse ...
                avg_mae std_mae avg_g_mean std_g_mean avg_recall std_recall ...
                avg_precision std_precision avg_f_measure std_f_measure];
            
            % Writing the results in csv files
            all_results = ...
                [algorithm_name dataset_name num2cell(folds_results)];
            
            dlmcell(filename_all_results, all_results, ',' , '-a');
            
            summary_of_results = ...
                [Optimizers(algo) name num2cell(summary_results)];
            
            dlmcell(filename_summary, summary_of_results, ',' , '-a');
            
            convergence_results = ...
                [algorithm_name dataset_name num2cell(convergence)];
            dlmcell(filename_convergences, convergence_results, ',' , '-a');
            
            average_convergence_results = ...
                [Optimizers(algo) name  num2cell(mean(convergence,1))];
            dlmcell(filename_average_convergences, ...
                average_convergence_results, ',' , '-a');
            
            best_individual_results = ...
                [algorithm_name dataset_name num2cell(all_best_individual)];
            dlmcell(filename_best_individuals, best_individual_results, ...
                ',' , '-a');
            
        end
    end
end

display('##################EVO SVM HAS FINISHED RUNNING##################');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%