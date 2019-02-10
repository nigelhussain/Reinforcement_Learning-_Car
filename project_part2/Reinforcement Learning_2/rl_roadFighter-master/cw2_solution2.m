% This is the control algorithm

%% ACTION CONSTANTS:
UP_LEFT = 1 ;
UP = 2 ;
UP_RIGHT = 3 ;


%% PROBLEM SPECIFICATION:

blockSize = 5 ; % This will function as the dimension of the road basis 
% images (blockSize x blockSize), as well as the view range, in rows of
% your car (including the current row).

n_MiniMapBlocksPerMap = 5 ; % determines the size of the test instance. 
% Test instances are essentially road bases stacked one on top of the
% other.

basisEpsisodeLength = blockSize - 1 ; % The agent moves forward at constant speed and
% the upper row of the map functions as a set of terminal states. So 5 rows
% -> 4 actions.

episodeLength = blockSize*n_MiniMapBlocksPerMap - 1 ;% Similarly for a complete
% scenario created from joining road basis grid maps in a line.

%discountFactor_gamma = 1 ; % if needed

rewards = [ 1, -1, -20 ] ; % the rewards are state-based. In order: paved 
% square, non-paved square, and car collision. Agents can occupy the same
% square as another car, and the collision does not end the instance, but
% there is a significant reward penalty.

probabilityOfUniformlyRandomDirectionTaken = 0.15 ; % Noisy driver actions.
% An action will not always have the desired effect. This is the
% probability that the selected action is ignored and the car uniformly 
% transitions into one of the above 3 states. If one of those states would 
% be outside the map, the next state will be the one above the current one.

roadBasisGridMaps = generateMiniMaps ; % Generates the 8 road basis grid 
% maps, complete with an initial location for your agent. (Also see the 
% GridMap class).

noCarOnRowProbability = 0.8 ; % the probability that there is no car 
% spawned for each row

seed = 1234;
rng(seed); % setting the seed for the random nunber generator

% Call this whenever starting a new episode:
MDP = generateMap( roadBasisGridMaps, n_MiniMapBlocksPerMap, blockSize, ...
    noCarOnRowProbability, probabilityOfUniformlyRandomDirectionTaken, ...
    rewards );


%% Initialising the state observation (state features) and setting up the 
% exercise approximate Q-function:
stateFeatures = ones( 4, 5 );
action_values = zeros(1, 3);

Q_test1 = ones(4, 5, 3);
Q_test1(:,:,1) = 100;
Q_test1(:,:,3) = 100;% obviously this is not a correctly computed Q-function; it does imply a policy however: Always go Up! (though on a clear road it will default to the first indexed action: go left)


% Monte Carlo Method
episode = 0;
weights = zeros(size(Q_test1)); % set weights

for x = 1:500
    episode = episode + 1;
    % generate MDP for episode
    MDP = generateMap( roadBasisGridMaps, n_MiniMapBlocksPerMap, ...
        blockSize, noCarOnRowProbability, ...
        probabilityOfUniformlyRandomDirectionTaken, rewards );
    currentMap = MDP ;

    % set state = starting state for the MDP
    realAgentLocation = currentMap.Start ;
    startingLocation = agentLocation ; % Keeping record of initial location.
    notAbsorbingState = 1;
    
    reward_history = zeros(1, 24);
    action_history = zeros(1, 24);
    currentTimeStep = 0;
    
    % return the specific values
    while(notAbsorbingState)
        x;
        currentTimeStep;
        % set state vector description
        stateFeatures = MDP.getStateFeatures(realAgentLocation) % dimensions are 4rows x 5columns
        % pick an action accorrding to policy:
        for action = 1:3
            action_values(action) = ...
                sum ( sum( Q_test1(:,:,action) .* stateFeatures ) );
        end 
        % evaluate a Q(s,a) function for the weights in Qtest_1
        % argmax_a {Q(s, a)}
        [~, actionTaken] = max(action_values);
       actionTaken;
        % Do that action -> next state id, reward
        [ agentRewardSignal, realAgentLocation, currentTimeStep, ...
            agentMovementHistory ] = ...
            actionMoveAgent( actionTaken, realAgentLocation, MDP, ...
            currentTimeStep, agentMovementHistory, ...
            probabilityOfUniformlyRandomDirectionTaken ) ;
        % check if this is an absorbing state
        notAbsorbingState = 1 - currentMap.IS_TERMINAL_STATE(realAgentLocation);
        reward_history(currentTimeStep) = agentRewardSignal;
        action_history(currentTimeStep) = actionTaken;
        
    end
    
    % update estimation of the weights in Q function
    agentMovementHistory; % vector of states
    actionTaken; % action value
    agentRewardSignal; % reward value
    
    % update weights in the Q-function (according to formula defined by the
    % book/lecture 
    for i = 1:24
        % calculate return (this is the average according to the book)
        Return = mean2(reward_history(i:end));
        % calculate features and weights
        stateFeatures1 = MDP.getStateFeatures(agentMovementHistory(i));
        action = action_history(i);
        % update weight (using TD weight formula from lecture/book)
        weights(:,:,action) =  weights(:,:,action) + 10^(-5)*(Return + weights(:,:,action) .* stateFeatures1) .* (stateFeatures1);
    end
    
    % greedy algorithm
    if probability = 1-.6
        for i = 1:3
            Q(:,:,i) = sum(weights(:,:,i))
            [~, action] = max(Q(:,:,i));
        end
       action;
       
    end
    
    % else select random number
    else
        pos = randi(length(actionTaken))
        a = actionTaken(position)
        e = 0
    
        
end
disp(weights)



