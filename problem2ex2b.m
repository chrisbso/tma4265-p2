function [long_term_pi, ave_forw] = p2ex2b(t_time, it)

%Input:
    %t_time: Total time until end of process.
    %it: Number of iterations

%Output:
    %long_term_pi: Probability distribution as calculated from the it
        %simulations of the process.
    %ave_forw: Average number of jobs forwarded to the other server in the
        %iterations.
        
    %Initializing parameters:
    
    lambda = 1/25; %Mean of exponential arrival times.
    vmu = [0, ones(1,32)./(1:32)]; %Mean of exponential completion times.
    
    %Pre-allocating vectors:
    
    forw = zeros(1, it); %Jobs forwarded to next server.
    pi = zeros(33, it); %Probabilities of 33 states for it iterations.
    long_term_pi = zeros(1, 33); %Probabilities of 33 states for each iteration.
    
    %Performing (it) simulations of the process
    
    for n = 1:it
        
        %Initialize state vector and time vector
        
        state = zeros(1, 10);
        time = zeros(1,10);
        
        %Start at vector element 1
        i = 1;
        
        %While condition for time.
        
        while sum(time) < t_time
        
            s = state(i);
            mu = vmu(s+1); %Extract mu for current state from vmu vector.
            
            %Sample birth and death time from exponential distribution.
            birth = exprnd(lambda); 
            death = exprnd(mu); 
            
            if s > 0 && s < 32 %None of the extreme states
            
                if birth <= death %Birth occurs before death
                    state(i+1) = s + 1; %State moves up
                    time(i+1) = birth; %Time recorded in time vector
                end %if
                
                if death < birth %Death occurs before birth
                    state(i+1) = s - 1; %State moves down
                    time(i+1) = death; %Time recorded in time vector
                end %if
       
            end %if
        
            %Final state, death no matter what. One more job forwarded to
            %the other server if birth occurs before death.
            
            if s == 32
                state(i+1) = s - 1;
                if birth < death
                    forw(n) = forw(n) + 1; %Job forwarded to other server
                end
                time(i+1) = death; %Death time recorded in time vector
            end %if
        
            %Initial state, birth no matter what.
            
            if s == 0
                state(i+1) = s + 1; %State moves up
                time(i+1) = birth; %Time recorded in time vector
            end %if
        
            %Calculate mean state for states up to i. Used to evaluate time
            %until equilibrium. Create cumulative time vector to plot
            %against.
            
            mean_state(n,i) = mean(state(1:i));
            ctime(i) = sum(time(1:i));
            
            i = i + 1; %Next state change.
            
        end %while
        
        %Pre-allocate vector of time spent in each state.
        spent_t = zeros(1, 33);
        
        for k = 1:33
            
            %Sum times from time vector for state k.
            spent_t(k) = sum(time((state+1)==k)); 
            
            %Long term probabilities for the 33 states are taken as the 
            %relative time spent in each state.
            pi(k, n) = spent_t(k)/t_time;
            
        end %for

    end %for
    
    %Probabilities for states i are  averaged over the it iterations.
    
    for j = 1:33
        long_term_pi(j) = sum(pi(j,:))/it;
    end
    
    %Amount of jobs forwarded is averaged over the iterations and the 
    %(24*7) hours.
    
    ave_forw = round(sum(forw)/(24*7*it), 2);
    
    %Extract the theoretical probabilities of the states from task 2a.
    
    pi_theor = p2ex2a;
    
    %Plot the simulated probabilities together with the theoretical ones.
    
    figure(1);
    clf;
    hold on
    plot(0:32, pi_theor);
    plot(0:32, long_term_pi);
    xlabel('State n');
    ylabel('Probability P(n)');
    grid on;
    
    %Plot the mean state for the final iteration against the cumulative
    %time vector
    
    figure(2);
    hold on
    plot(ctime, mean_state(it,:));
    xlabel('Time [h]');
    ylabel('Mean state n(bar)');
    grid on;
    
end %function
    
    
    
 
        
        