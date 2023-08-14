function cost = costcalc_B(child,F,D,A)

cost = 0;
for i = 1:size(child,2)
    for j = 1:size(child,2)
        if j == i
            continue
        end
        cost = cost + F(i,j)*D(child(i),child(j));
    end
end
for i = 1:size(child,2)
    cost = cost + A(i,child(i));
end

end