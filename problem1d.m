function problem1d
maxDays = 365;
alpha = 0.001;
mu = -2;
sigma = 1;
bMax = 100; %maximum # of realizations
lambda = 2 + cos(pi/182.5*[0:1:maxDays]); %inhomogenous

ZHom_avg = 0;          %%for calucalating average ZHom;
ZInhom_avg = 0;         %% for calculating average ZInhom;
cHom = zeros(1,bMax);
cInhom = zeros(1,bMax);
ZHom = zeros(1,bMax);
ZInhom = zeros(1,bMax);
for b = 1:bMax
    %sample from max rate process
    lambdaMax   = max(lambda);
    N_maxDays_Hom     = poissrnd(lambdaMax*maxDays);
    tHom        = sort(maxDays*rand(N_maxDays_Hom,1)); %simulate arrival times
    
    
    %thinning, with requirement rand() < lambda(T_i)/lambdaMax, 0 < rand() < 1
    tInhom  = [];
    count   = 0;
    for i = 1:N_maxDays_Hom
        accRate = (2 + cos(pi/182.5*tHom(i,1)))/lambdaMax;
        if rand < accRate
            count   = count + 1;
            tInhom  = [tInhom tHom(i,1)]; %%choose (poisson-randomly) which events to keep
        end
    end
    N_maxDays_Inhom = count;
    
    
    %caluclate Z and Z_avg for homogenous case
    for i = 1:N_maxDays_Hom
        ZHom(b)     = ZHom(b)   + exp(-alpha*tHom(i))*lognrnd(mu,sigma);
    end
    ZHom_avg = ZHom_avg + ZHom(b);
    
    %calculate Z and Z_avg for inhomogenous case
    for i = 1:N_maxDays_Inhom
        ZInhom(b)   = ZInhom(b) + exp(-alpha*tInhom(i))*lognrnd(mu,sigma);
    end
    ZInhom_avg = ZInhom_avg + ZInhom(b);
    
    cHom(b) = ZHom;
    cInhom(b) = ZInhom;
    
end
ZHom = sort(ZHom);
ZInhom = sort(ZInhom);

close all;
%now that the sums are complete, we average them over # of iterations
ZHom_avg      = sum(ZHom_avg)/bMax;
ZInhom_avg    = sum(ZInhom_avg)/bMax;

fprintf('The expected value of Z_disc is');
fprintf('\n %.3f mill. kr. \t for the homogenous case, and\n %.3f mill. kr.\t for the inhomogenous case\n',ZHom_avg, ZInhom_avg);

cHom=max(sort(cHom(1:end-(bMax*0.05))));
cInhom=max(sort(cInhom(1:end-(bMax*0.05))));

fprintf('The capital needed to cover claims with 95 percent certainty');
fprintf('\n %.3f mill. kr. \t for the homogenous case \n %.3f mill. kr.\t for the inhomogenous case\n',cHom, cInhom);

end