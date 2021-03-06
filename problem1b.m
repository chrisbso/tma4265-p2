function problem1b
close all;
maxDays = 59;
bMax = 100;
n = 175;

lambdaInhom = 2 + cos(pi/182.5*[0:1:maxDays]);
lambdaMax = max(lambdaInhom);

P = 1-poisscdf(n,lambdaInhom(end)*maxDays);

%plot the inhomogenous intensity
figure(1);
plot([0:1:maxDays], lambdaInhom);
grid on;
title('\lambda(t) = 2 + cos (t \pi /182.5)');
xlabel('t');ylabel('\lambda(t)');
set(findall(gcf,'-property','FontSize'),'FontSize',14);

%initialize variables for plotting means
NtHom = zeros(1,bMax);
NtInhom = zeros(1,bMax);
N_maxDays_Inhom = zeros(1,bMax);
moreThan_n_Claims = 0;
figure(2);
for b = 1:bMax
    
    %simulate arrival times
    NtHom(b) = poissrnd(lambdaMax*maxDays);
    tHom = sort(maxDays*rand(1,NtHom(b)));
    
    
    %plot N(t) for homogenous intensity
    subplot(2,2,1);
    hold on;
    grid on;
    plot(tHom,[1:NtHom(b)]);

    %thinning
    count = 0;
    tInhom = [];
    for i = 1:NtHom(b)
        accRate = (2+cos(pi/182.5*tHom(i)))/lambdaMax;
        if accRate > rand
            count = count + 1;
            tInhom = [tInhom tHom(i)];
        end
    end
    NtInhom(b) = count;
    
    %%NOTE: this has to be included as choosing T_i = maxDays*rand() will
    %%never give T_max == maxDays
    N_maxDays_Inhom(b) = poissrnd(lambdaInhom(end)*maxDays);
    
    %plot N(t) for inhomogenous (thinned)
    subplot(2,2,3);
    hold on;
    grid on;
    plot(tInhom,[1:NtInhom(b)]);
    
    if N_maxDays_Inhom(b)>n
        moreThan_n_Claims = moreThan_n_Claims + 1;
    end
    
end
    %find percentage of realizations giving N(59)>n==175
   moreThan_n_Claims = moreThan_n_Claims/bMax;
   
    %set plot labels
    subplot(2,2,1);
    title( ['\lambda(t) = 3,  ' num2str(bMax) ' realizations']);
    xlabel('t');ylabel('N(t)');
    
    %set plot labels
    subplot(2,2,3);
    title(['\lambda(t) = 2 + cos (t \pi /182.5), thinned,   ' num2str(bMax) ' realizations']);
    xlabel('t');ylabel('N(t)');
    
    %plot means and set labels
    meanHom = sum(NtHom)/bMax;
    meanInhom = sum(NtInhom)/bMax;
    subplot(2,2,[2 4]);
    hold on;
    grid on;
    title('\Sigma N(t)/(# of iterations)');
    h1 = plot([0 maxDays],[0 meanHom],'LineWidth',3,'DisplayName','\lambda(t) = 3');
    h2 = plot([0 maxDays],[0 meanInhom],'LineWidth',3,'DisplayName','\lambda(t) = 2 + cos (t \pi /182.5), thinned');
    h3 = plot([maxDays,maxDays],[0 175],'b--');
    h4 = plot([0 maxDays], [175 175],'b--');
    legend([h1 h2]);
    xlabel('t');ylabel('N(t)');
    
    
    %adjust FontSize
    set(findall(gcf,'-property','FontSize'),'FontSize',14);
   
    fprintf('Out of %d realizations,\n',bMax);
    fprintf('N(t=59)>%d  was achieved for \n %.1f%% of realizations. For comparison, \nP([N(59)>175]) = \n %.1f%%\n',n,moreThan_n_Claims*100,P*100);

end