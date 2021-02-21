%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Business Information Technology Department                             %
%  King Abdullah II School for Information Technology                     %
%  The University of Jordan                                               %
%                                                                         %
%  Developed in Matlab R2015a  (8.5.0. 196713)                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [train_features, selected_features_numbers] = select_features(individuals,train_data)

[~, D] = size(train_data);

binary_individuals= round(individuals);
A= full(train_data);
count=1;
selected_features_numbers = zeros(1,D);

for i=1:D
    if sum(binary_individuals(1:D))>=1 % we check the sum from 1 to D to
                                       % avoid extra possible vector length
                                       % added by any of the evo algorithms
        if binary_individuals(:,i)==1
            train_features(:,count)= A(:,i); %#ok<AGROW>
            selected_features_numbers (: ,i) = i;
            count=count+1;
        end
    else
        train_features (:,i)= A(:,i); %#ok<AGROW>
    end
end

selected_features_numbers(end+1:D+1)=0;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%