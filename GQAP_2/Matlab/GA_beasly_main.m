%% Genetic Algorithm based on Beasly paper
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

%% GA parameteres to change

n_pop = 75; % Number of chromosomes in populations

maxiter=100000; % max of iteration
max_k = 700; %max number of consecutive iterations without improvement


%% GA parameters

N = length(C); % Number of locations
M = length(R); % Number of Machines

%% initialization

tic
%rng('default')
P0 = randi(N,n_pop,M);
fitness_P0 = costcalc(P0,F, D,A,T);
[extra_cap_P0,unfitness_P0] = unfitness_calc(P0,C,R);
final_P0 = [P0 int64(fitness_P0) unfitness_P0];
disp(final_P0)
%% Find the best_sol P0 & initial z_best

found = find(unfitness_P0==0);
if isempty(found)
    [~,ind] = min(unfitness_P0);
    best_sol = P0(ind,:);
    z_best = 999999999999;
else
    fitted = final_P0(found,:);
    [~,ind] = min(fitted(:,M+1));
    best_sol = fitted(ind,1:M);
    z_best = fitted(ind,M+1);
end
%% Main loop

BEST_SOL= best_sol;
Z_BEST = z_best;
K_iter = 0;

for iter = 1:maxiter
    disp('Iteration Number:')
    disp(iter)

    % Generate the mating pool with the tournoment scheme   
    M_pool = zeros(2,M);
    choose = randperm(size(P0,1),2); %Choose 2 random solutions
    if fitness_P0(choose(1)) <= fitness_P0(choose(2)) %compare the fitness values
        M_pool(1,:) = P0(choose(1),:);
    else
        M_pool(1,:) = P0(choose(2),:);
    end
    ii=1;
    while ii < 2
        choose = randperm(size(P0,1),2); %Choose 2 random solutions
        if fitness_P0(choose(1)) <= fitness_P0(choose(2)) %compare the fitness values
            if P0(choose(1),:) == M_pool(1,:)
                continue
            end
            M_pool(2,:) = P0(choose(1),:);
            ii = 2;
        else
            if P0(choose(2),:) == M_pool(1,:)
                continue
            end
            M_pool(2,:) = P0(choose(2),:);
            ii = 2;
        end
        if ~isempty(find(M_pool(2,:), 1))
            break
        end
    end

    disp('The mating pool is:')
    disp(M_pool)
    
    % Crossover Operation
    child = CX_beasly(M_pool);
    
    %Mutation
    child = mutation_beasly(child);
    
    % Handle unfitness and genereate the new child
    [child, fit_child, unfitness_child] =beasly_unfit(child,C,R,F,D,A,T);
    
    % current solution scores
    fitness_P0 = costcalc(P0,F, D,A,T);
    disp('overal fitness of previous generation is:')
    disp(sum(fitness_P0))
    [~,unfitness_P0] = unfitness_calc(P0,C,R);
    disp('overal unfitness of previous generation is:')
    disp(sum(unfitness_P0))
    final_P0 = [P0 int64(fitness_P0) unfitness_P0];
    disp('previous generation is:')
    disp(final_P0)

    P1=P0;
    check_duplicate = all(ismember(child,P1,'rows')==1);
    if check_duplicate
        disp('generated child exist in the solution, duplicate solution')
        continue
    else
        %check if there is unfitness in the solution
        check = ~isempty(find(unfitness_P0, 1));
        if check==0
            if unfitness_child==0
                disp('no unfitness remained, exchange the new child with the max fitness')
                [highest_fit, ind] = max(fitness_P0);
                P1(ind,:) = child;
            end
        else
            disp('exchange the new child with max unfitness')
            [highest_unfit, ind] = max(unfitness_P0);
            P1(ind,:) = child;
        end
    
        % new solution scores
        fitness_P1 = costcalc(P1,F, D,A,T);
        disp('new overal fitness is:')
        disp(sum(fitness_P1))
        [~,unfitness_P1] = unfitness_calc(P1,C,R);
        disp('new overal unfitness is')
        disp(sum(unfitness_P1))
        final_P1 = [P1 int64(fitness_P1) unfitness_P1];
        disp('new generation is:')
        disp(final_P1)

        % finding the new best solution
        found = find(unfitness_P1==0);
        if isempty(found)
            [~,ind] = min(unfitness_P1);
            best_sol_P1 = P1(ind,:);
            z_best_P1 = 9999999;
        else
            fitted = final_P1(found,:);
            [~,ind] = min(fitted(:,M+1));
            best_sol_P1 = fitted(ind,1:M);
            z_best_P1 = fitted(ind,M+1);
        end
        % Update number of iterations without improvement
        if z_best_P1 < z_best
            BEST_SOL = best_sol_P1;
            disp('new best sol is:')
            disp(BEST_SOL)
            Z_BEST = z_best_P1;
            disp('new Z is:')
            disp(Z_BEST)
        else
            K_iter = K_iter+1;
        end  
        P0 = P1;
    
    end
    if K_iter > max_k
        break
    end
end
toc
%% Display the best found solution from GA

disp(' ')
disp([ ' Best sol = '  num2str(BEST_SOL)])
disp([ ' Best fitness = '  num2str(Z_BEST)])
disp([ ' Time = '  num2str(toc)])