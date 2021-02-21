%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Business Information Technology Department                             %
%  King Abdullah II School for Information Technology                     %
%  The University of Jordan                                               %
%                                                                         %
%  Developed in Matlab R2015a  (8.5.0. 196713)                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [numberOfSelectedFeatures] = get_feature_count(individuals)

[~, D] = size(individuals);
binaryIndividuals= round(individuals);
numberOfSelectedFeatures=0;

if sum(binaryIndividuals)>=1
    for i=1:D
        if binaryIndividuals(i)==1
            numberOfSelectedFeatures = numberOfSelectedFeatures+1;
        end
    end
else
    numberOfSelectedFeatures = D;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%