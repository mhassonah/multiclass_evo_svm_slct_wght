function fit=benchmark_func_cross(x, fobj, fitness_type, trainLabel, trainData)

[rows, ~] = size(x);
for i = 1:rows
    fit(i,:)= fobj(x(i,:), fitness_type, trainLabel,trainData);
end;

%%%%% end of file %%%%%