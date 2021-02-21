%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Business Information Technology Department                             %
%  King Abdullah II School for Information Technology                     %
%  The University of Jordan                                               %
%                                                                         %
%  Developed in Matlab R2015a  (8.5.0. 196713)                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [labels, features] =  read_csv(dir_data, dataset_name)

path = strcat(dir_data, '\', dataset_name);
data = csvread(path); % read a csv file
labels = data(:, 1); % labels from the first column
features = data(:, 2:end); % features from all columns except the first one

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%