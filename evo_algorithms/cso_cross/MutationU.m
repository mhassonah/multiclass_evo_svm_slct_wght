    function inp = MutationU(dim, max_iter, inp, current_iter)
r = rand(1,dim);
r = r >= (current_iter / max_iter);

for i = 1 : size(inp)
    if (r(i) == 0)
        inp(i) = 0.99.*(rand() * inp(i)) + 0.01;
    end
end


