function problem1c
maxDays = 59; %sets Tmax
mu = -2;
sigma = 1;
bMax = 10; %maximum # of realizations
lambda = 2 + cos(pi/182.5*[0:1:maxDays]); %inhomogenous


countingHom = zeros(1,10000); %% since each realization has different lengths, one must account for this
countingInhom = zeros(1,10000);
ZHom_avg = zeros(1,10000); %%for calucalating average ZHom;
ZInhom_avg = zeros(1,10000); %% for calculating average ZInhom;
for b = 1:bMax
    %sample from max rate process
    lambdaMax   = max(lambda);
    NtHom       = poissrnd(lambdaMax*maxDays);
    tHom        = sort(maxDays*rand(NtHom,1)); %simulate arrival times
    
    
    %thinning, with requirement rand() < lambda(T_i)/lambdaMax, 0 < rand() < 1
    tInhom  = [];
    count   = 0;
    for i = 1:NtHom
        accRate = (2 + cos(pi/182.5*tHom(i,1)))/lambdaMax;
        if rand < accRate
            count   = count + 1;
            tInhom  = [tInhom tHom(i,1)]; %%choose (poisson-randomly) which events to keep
        end
    end
    NtInhom = count;
    
    ZHom    = zeros(1,NtHom);
    ZInhom  = zeros(1,NtInhom);
    
    %caluclate Z and Z_avg for homogenous case
    for i = 1:NtHom
        for j = 1:i
            ZHom(i)     = ZHom(i)   + lognrnd(mu,sigma);
        end
        ZHom_avg(i) = ZHom_avg(i) + ZHom(i);
        countingHom(i) = countingHom(i)+1;
    end
    
    %calculate Z and Z_avg for inhomogenous case
    for i = 1:NtInhom
        for j = 1:i
            ZInhom(i)   = ZInhom(i) + lognrnd(mu,sigma);
        end
        ZInhom_avg(i) = ZInhom_avg(i) + ZInhom(i);
        countingInhom(i) = countingInhom(i) + 1;
    end
    
    
    
end
%fixing the matrices, removing all nonzero elements
ZHom_avg      = transpose(nonzeros(ZHom_avg));
ZInhom_avg    = transpose(nonzeros(ZInhom_avg));
countingHom     = transpose(nonzeros(countingHom));
countingInhom   = transpose(nonzeros(countingInhom));

%now that the sums are complete, we average them over # of iterations
ZHom_avg      = ZHom_avg./countingHom;
ZInhom_avg    = ZInhom_avg./countingInhom;

%we comupte the best linear fit for ZHom_avg to find E[Z(N(t))]
linearReg_ZHom      = transpose(1:length(ZHom_avg))    \transpose(ZHom_avg)
linearReg_ZInhom    = transpose(1:length(ZInhom_avg))    \transpose(ZInhom_avg)

close all;
figure();

%plot Z_avg and its linear fit for homogenous case
subplot(2,1,1);
hold on;
grid on;
plot(1:length(ZHom_avg),ZHom_avg);
plot(1:length(ZHom_avg),[1:length(ZHom_avg)]*linearReg_ZHom);
title( ['\lambda(t) = 3,  averaged over ' num2str(bMax) ' realizations']);
xlabel('N(t)'); ylabel('Z');
legend('Z(N(t)) averaged over all realizations',['Simulated expected value E[Z(N(t))] = ' num2str(linearReg_ZHom,'%.3f') '\cdot N(t)']);
xlim([0 length(ZHom_avg)]);

%plot Z_avg and its linear fit for inhomogenous case
subplot(2,1,2);
hold on;
grid on;
plot(1:length(ZInhom_avg),ZInhom_avg);
plot(1:length(ZInhom_avg),[1:length(ZInhom_avg)]*linearReg_ZInhom);
title(['\lambda(t) = 2 + cos (t \pi /182.5), thinned,   averaged over ' num2str(bMax) ' realizations']);
legend('Z(N(t)) averaged over all realizations',['Simulated expected value E[Z(N(t))] = ' num2str(linearReg_ZInhom,'%.3f') '\cdot N(t)']);
xlabel('N(t)'); ylabel('Z');
xlim([0 length(ZInhom_avg)]);

%adjust FontSize
set(findall(gcf,'-property','FontSize'),'FontSize',14);
end