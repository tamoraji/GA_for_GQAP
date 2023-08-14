
function [child, fit_child,unfitness_child] = beasly_unfit(child,C,R,F,D,A,T)
[extra_cap_child,unfitness_child] = unfitness_calc(child,C,R);
if unfitness_child >0
    disp('there are unfitness in solutions')
    over_used_loc = find(extra_cap_child(:)>0);
    under_used_loc = find(extra_cap_child(:)<0);
    num_overused = size(over_used_loc,1);
    for k=1:num_overused
        %find all the m/c's that is assigned to the overused loc
        mc = find(child(:) == over_used_loc(k)); 
        choose = mc(randperm(numel(mc),1)); %Randomly choose one of them
        if ~isempty(under_used_loc)
            extra = min(extra_cap_child(under_used_loc));
            if -extra<R(choose)
                continue
            else
                inde = find(extra_cap_child==extra,1);
                child(choose) =inde; %assign the m/c to an underused loc
            end 
        end
        [extra_cap_child,~] = unfitness_calc(child,C,R);
        under_used_loc = find(extra_cap_child(:)<0);

    end
    fit_child = costcalc_B(child,F,D,A,T);
    [~,unfitness_child]= unfitness_calc(child,C,R);
    disp('The new child is:')
    disp(child)
    disp('the new child unfitness is:')
    disp(unfitness_child)
else
    disp('no unfitness')
    fit_child = costcalc(child,F,D,A,T);
end
end