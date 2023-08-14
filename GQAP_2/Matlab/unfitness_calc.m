function [extra_cap,unfitness] = unfitness_calc(pop,C,R)
unfitness = zeros(size(pop,1),1);
extra_cap = zeros(size(pop,1),length(C));
for n = 1:size(pop,1)
    for i = 1:length(C)
        found = pop(n,:)==i;
        cap_ext = sum(R(found))-C(i);
        extra_cap(n,i) = cap_ext;
        unfitness(n) = unfitness(n) + max([cap_ext,0]);
    end
end
end