function  mutated = mutation_beasly(child)

mutated = child;
nvar = length(child);

j1=randi([1 nvar-1]);
j2=randi([j1+1 nvar]);

nj1=mutated(j1);
nj2=mutated(j2);

mutated(j1)=nj2;
mutated(j2)=nj1;

if child == mutated
    disp('No Mutation happened')
else
    disp('mutation happened')
end
end
