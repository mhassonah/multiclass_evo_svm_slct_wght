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

function [weighted_features] = weight_features(individuals,train_data)

for i=1:size(train_data, 2)
    weighted_features(:,i)= individuals(i) * train_data(:, i);%#ok<*AGROW>
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%