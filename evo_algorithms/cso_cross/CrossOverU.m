function RA = CrossOverU(dim, max_iter, current_iter, RA, RE)
r = rand(1,dim);
r = r >= (current_iter / max_iter);

for i = 1 : size(RA)
    if (r(i) == 1)
        RA(i) = RE(i);
    end
end