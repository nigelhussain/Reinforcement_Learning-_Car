gamma = 1; %set gamma = 1; as stated in the exercise
% set up the state index
[n_rows, n_columns] = size(pi_test1); 
n_states = n_rows * n_columns;

V = zeros(1, 125); % create an arbitrary value function [array of zeros...
% that is equal to the size of the policy function


reward = zeros(1, 3); % set rewards to a zero vector

pi = 0
% set up the policy evaluation algorithm 

% v = zeros(125, 1); % set v (in the algorithm) equal to a zero vector. This will prevent v
% from becoming V(i+1), thus allowing the algorithm to keep iterating

policy_stable = true % set policy stable = true 
for s = 1:n_states
    p = 0
    b = probability_s2s(i)*(reward(i) + gamma * V(possible_s2s(i))); % calculate the value specified in the algorithm 
    p = p+b
    if b ~= p
        policy_stable = FALSE
    end
    if policy_stable == FALSE 
        break;
    else
        while delta > 0.01
        delta = 0; % set delta equal to 0
        for s = 1:n_states
            s
            a= pi_test1_stateNumbers(s);
                [possible_s2s, probability_s2s] = MDP_1.getTransitions(s,a); % return the transitions and probabilities
                % according to the equation specified in the algorithm.  
        
            reward = zeros(1, length(possible_s2s));
            % return the possible rewards
            for s2 = 1:length(possible_s2s)
                possible_s2s(s2)
                reward(s2) = MDP_1.getReward(s, possible_s2s(s2), a) % convert the rewards to a column vector
            end
       
    
            b= 0;
            % initiate the algorithm
            for i = 1:length(possible_s2s)
                v = 0; % set v equal to the initial V vector, as in the book
                b = probability_s2s(i)*(reward(i) + gamma * V(possible_s2s(i))); % calculate the value specified in the algorithm 
                v = v + b; % backup the values    
            end
            v
            delta = max(delta, abs(v - V(s))) % update delta value
            V(s) = v
        end
        end
    %V = vec2mat(V, 25) % convert to matrix form to match grid
            display(V); % display the optimal solution
    end
end


    
        
    


