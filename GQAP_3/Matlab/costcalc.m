function cost = costcalc(pop,F,D,A,T)
cost = zeros(size(pop,1),1);
for n = 1:size(pop,1)
    for i = 1:size(pop,2)
        for j = 1:size(pop,2)
            if j == i
                continue
            end
            cost(n) = cost(n) + T*F(i,j)*D(pop(n,i),pop(n,j));
        end
    end
    for i = 1:size(pop,2)
        cost(n) = cost(n) + A(i,pop(n,i));
    end
end
end