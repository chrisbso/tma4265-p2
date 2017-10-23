function pi = p2ex2a

%Function gives the probability distribution of the 33 states i
%Input: None
%Output:
    %pi: vector of 33 elements of equilibrium probability of system being
    %in state i.
    
    %Set given values of mu and lambda.
    mu = 0:32;
    lambda = 25*ones(1,33);
    
    %Initialize L_i vector, vector of L for state i.
    L_i = zeros(1, 33);
    
    %Iterate through the states, calculate the prod(lambda)/prod(mu) ratios
    %and store in L_i vector.
    for i = 1:33
        mui = mu(2:i);
        lambdai = lambda(1:(i-1));
        L_i(i) = prod(lambdai)/prod(mui);
    end
    
    %Sum to retrieve L value for the process.
    L = sum(L_i);
    
    %Divide L_i vector by L to retrieve probability distribution.
    pi = L_i ./ L;
    
    %Plot distribution 
    clf;
    plot([0:32], pi);
    grid on;
    xlabel('State n');
    ylabel('Probability P(n)');
    
end