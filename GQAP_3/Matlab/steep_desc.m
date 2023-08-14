function NBH_S = steep_desc(S0,C,R)

    N = length(C); % Number of locations
    M = length(R); % Number of Machines
    N_sol = M*(N-1);
    disp('number of nbh solutions')
    disp(N_sol)
    NBH_S = zeros(N_sol,M);
    i = 0;
    for p = 1:M
        for q= 1:N
            NS=S0;
            if q==NS(p)
                continue
            else
                i = i+1;
                NS(p)=q;
                NBH_S(i,:)=NS;
            end
        end
    end
end