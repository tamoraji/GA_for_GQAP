%% Problem Data

% Distance matrix between location k & l
D = importdata("D.txt");

% Material flow matrix between machine i and j
F = importdata("F.txt");
% transportation cost
T = 2; 

% Installation cost matrix for machine j and loc k
A = importdata("A.txt");

% Space requirement for each machine
R = [17      30      53      94      17      70      22      49      12       8      38      27      36      98      53      76      64      76      78      82];
% Capacity of each location
C = [102     198     140     126     260     174     148     202     228     256     250     236     206     221     110];

M = length(R);

%Best_sol = load('best_sol.mat');
%Best_sol = Best_sol.BEST_SOL;
Best_sol = [1  13  13  15  13   5  13  13   9  13   9  13   9   6   9   5   8   5   1   9];
Z_best = costcalc_B(Best_sol,F,D,A,T);
%%Steepest descend neighbeirhood search
improvement = 1;
iter = 0;
while improvement
    iter = iter + 1;
    i = 0;
    NBH_child = steep_desc(Best_sol,C,R);
    cost_NBH = costcalc(NBH_child,F,D,A,T);
    [~,unfit_NBH] = unfitness_calc(NBH_child,C,R);
    final = [NBH_child int64(cost_NBH) unfit_NBH];
    found = find(unfit_NBH==0);
    fitted = final(found,:);
    [mincost, minind] = min(fitted(:,M+1));
    
    if mincost < Z_best
        disp('a better sol found')
        Best_sol = fitted(minind,1:M);
        disp(Best_sol)
        Z_best = mincost;
        disp(Z_best)
    else
        improvement = 0;
    end
end
disp(Best_sol);
disp(Z_best)