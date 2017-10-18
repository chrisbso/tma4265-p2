function problem1cV2
maxDays = 59;
mu = -2;
sigma = 1;
bMax = 10;
lambda = 2 + cos(pi/182.5*[0:1:maxDays]); %inhomogenous


countingHom = zeros(1,10000);
countingInhom = zeros(1,10000);
ZHom_avg = zeros(1,10000);
ZInhom_avg = zeros(1,10000);
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
    
    for i = 1:NtHom
        for j = 1:i
            ZHom(i)     = ZHom(i)   + lognrnd(mu,sigma);
        end
        ZHom_avg(i) = ZHom_avg(i) + ZHom(i);
        countingHom(i) = countingHom(i)+1;
    end
    
    for i = 1:NtInhom
        for j = 1:i
            ZInhom(i)   = ZInhom(i) + lognrnd(mu,sigma);
        end
        ZInhom_avg(i) = ZInhom_avg(i) + ZInhom(i);
        countingInhom(i) = countingInhom(i) + 1;
    end
    
    
    
end
ZHom_avg      = transpose(nonzeros(ZHom_avg));
ZInhom_avg    = transpose(nonzeros(ZInhom_avg));
countingHom     = transpose(nonzeros(countingHom));
countingInhom   = transpose(nonzeros(countingInhom));

ZHom_avg      = ZHom_avg./countingHom;
ZInhom_avg    = ZInhom_avg./countingInhom;

close all;
figure();

subplot(2,1,1);
plot(1:length(ZHom_avg),ZHom_avg);
title('\lambda (t) = 3');
xlabel('N(t)'); ylabel('Z');
xlim([0 length(ZHom_avg)]);

subplot(2,1,2);
plot(1:length(ZInhom_avg),ZInhom_avg);
title('\lambda (t) = 2 + cos (t \pi / 182.5  )')
xlabel('N(t)'); ylabel('Z');
xlim([0 length(ZInhom_avg)]);

end