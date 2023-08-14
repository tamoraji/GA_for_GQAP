
function C=CX_beasly(pop)

parent1 =pop(1,:);
parent2 = pop(2,:);

l = length(parent1);
j=randi([1 l-1]);
C1=[parent1(1:j) parent2(j+1:end)];
C2=[parent2(1:j) parent1(j+1:end)];

r = randi([1, 2], 1);
if r==1
    C=C1;
else
    C=C2;
end

end


