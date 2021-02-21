%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Business Information Technology Department                             %
%  King Abdullah II School for Information Technology                     %
%  The University of Jordan                                               %
%                                                                         %
%  Developed in Matlab R2015a  (8.5.0. 196713)                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mse, rmse, mae] = get_eval_measures(actual_label, predicted_label)

label_length = length(actual_label);
diff = actual_label-predicted_label;

mse = sum(diff.^2)/label_length;
rmse = sqrt(mse);
mae  = sum(abs(diff))/label_length;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%