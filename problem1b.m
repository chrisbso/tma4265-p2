function problem1b
close all;
maxDays = 59;
bMax = 100;

lambdaInhom = 2 + cos(pi/182.5*[0:1:maxDays]);
figure(1);
plot([0:1:maxDays], lambdaInhom);

meanHom = 0;
meanInhom = 0;
NtHom = zeros(1,bMax);
NtInhom = zeros(1,bMax);
for b = 1:bMax
    
    lambdaMax = max(lambdaInhom);
    NtHom(b) = poissrnd(lambdaMax*maxDays);
    tHom = sort(maxDays*rand(NtHom(b),1));
    
    
    figure(2);
    subplot(2,1,1);
    hold on;
    grid on;
    plot(tHom,[1:NtHom(b)]);
    %yLimit = get(gca,'YLim');
    
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
    
    subplot(2,1,2);
    hold on;
    grid on;
    plot(tInhom,[1:NtInhom(b)]);
    
end
    meanHom = sum(NtHom)/b;
    meanInhom = sum(NtInhom)/b;
    figure();
    grid on;
    hold on;
    plot([0 maxDays],[0 meanHom],'LineWidth',3);
    plot([0 maxDays],[0 meanInhom],'LineWidth',3);
   
    
end