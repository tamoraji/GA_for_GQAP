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
R = [17,30,53,94,17,70,22,49,12,8,38,27,36,98,53,76,64,76,78,82,15,62,31,34,91,51,40,60,78,93,86,86,67,75,58,38,35,20,82,41,46,97,12,21,95,73,40,78,75,95];
% Capacity of each location
C = [279,367,540,347,470,256,622,390,266,163];

M = length(R);
Best_sol = [4   7   2   9   4   3   3   1   2   2   4   5   7   9   1   2   4   4   7   2   4   1   7   2   7  10   1   2   4   5   7   7   5   6   3   9   1   1   7   2   5   5   1   5   7   5   4  10   3   6];
%Best_sol = load('best_sol_run_1_2.mat');
%Best_sol = Best_sol.BEST_SOL;
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
disp(Z_best);
