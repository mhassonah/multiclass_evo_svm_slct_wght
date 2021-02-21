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

function o = cost(x, fitness_type, run_type, trainLabel, trainData)

% Extract the training individual from the whole individual
training_indv = x(3:end);

if (strcmp(run_type, 'with'))
    performance_value = ...
    svm_train(x,trainLabel, select_features(training_indv, trainData)); 
elseif (strcmp(run_type, 'without'))
    performance_value = ...
    svm_train(x,trainLabel, trainData);
elseif (strcmp(run_type, 'weight'))
    performance_value = ...
    svm_train(x,trainLabel, weight_features(training_indv, trainData));
else
    'none';
end


if (strcmp(fitness_type,'maximization') == 1)
    o = 100-performance_value;
elseif (strcmp(fitness_type,'minimization') == 1)
    o = performance_value;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%