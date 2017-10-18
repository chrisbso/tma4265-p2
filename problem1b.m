function problem1b
close all;
maxDays = 59;
bMax = 100;

%plot the inhomogenous intensity
lambdaInhom = 2 + cos(pi/182.5*[0:1:maxDays]);
figure(1);
plot([0:1:maxDays], lambdaInhom);
title('\lambda(t) = 2 + cos (t \pi /182.5)');
xlabel('t');ylabel('\lambda(t)');

%initialize variables for plotting means
meanHom = 0;
meanInhom = 0;
NtHom = zeros(1,bMax);
NtInhom = zeros(1,bMax);
figure(2);

for b = 1:bMax
    %simulate arrival times
    lambdaMax = max(lambdaInhom);
    NtHom(b) = poissrnd(lambdaMax*maxDays);
    tHom = sort(maxDays*rand(NtHom(b),1));
    
    
    %plot N(t) for homogenous intensity
    subplot(2,2,1);
    hold on;
    grid on;
    plot(tHom,[1:NtHom(b)]);

    %thinning
    count = 0;
    tInhom = [];
    for i = 1:NtHom(b)
        accRate = (2+cos(pi/182.5*tHom(i,1)))/lambdaMax;
        if accRate > rand
            count = count + 1;
            tInhom = [tInhom tHom(i,1)];
        end
    end
    NtInhom(b) = count;
    
    %plot N(t) for inhomogenous (thinned)
    subplot(2,2,3);
    hold on;
    grid on;
    plot(tInhom,[1:NtInhom(b)]);
    
end
    %set plot labels
    subplot(2,2,1);
    title( ['\lambda(t) = 3,  ' num2str(bMax) ' realizations']);
    xlabel('t');ylabel('N(t)');
    
    %set plot labels
    subplot(2,2,3);
    title(['\lambda(t) = 2 + cos (t \pi /182.5), thinned,   ' num2str(bMax) ' realizations']);
    xlabel('t');ylabel('N(t)');
    
    %plot means and set labels
    meanHom = sum(NtHom)/b;
    meanInhom = sum(NtInhom)/b;
    subplot(2,2,[2 4]);
    hold on;
    grid on;
    title('\Sigma N(t)/(# of iterations)');
    plot([0 maxDays],[0 meanHom],'LineWidth',3,'DisplayName','\lambda(t) = 3');
    plot([0 maxDays],[0 meanInhom],'LineWidth',3,'DisplayName','\lambda(t) = 2 + cos (t \pi /182.5), thinned');
    xlabel('t');ylabel('N(t)');
    legend('show');
    
    %adjust FontSize
    set(findall(gcf,'-property','FontSize'),'FontSize',14);
   

end