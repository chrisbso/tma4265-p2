function problem1d
maxDays = 365;
alpha = 0.001;
mu = -2;
sigma = 1;
bMax = 200; %maximum # of realizations
lambda = 2 + cos(pi/182.5*[0:1:maxDays]); %inhomogenous

ZHom_avg = 0;           %%for calucalating average ZHom;
ZInhom_avg = 0;         %% for calculating average ZInhom;
for b = 1:bMax
    %sample from max rate process
    lambdaMax   = max(lambda);
    N365Hom     = poissrnd(lambdaMax*maxDays);
    tHom        = sort(maxDays*rand(N365Hom,1)); %simulate arrival times
    
    
    %thinning, with requirement rand() < lambda(T_i)/lambdaMax, 0 < rand() < 1
    tInhom  = [];
    count   = 0;
    for i = 1:N365Hom
        accRate = (2 + cos(pi/182.5*tHom(i,1)))/lambdaMax;
        if rand < accRate
            count   = count + 1;
            tInhom  = [tInhom tHom(i,1)]; %%choose (poisson-randomly) which events to keep
        end
    end
    N365Inhom = count;
    
    ZHom    = 0;
    ZInhom  = 0;
    
    %caluclate Z and Z_avg for homogenous case
    for i = 1:N365Hom
        ZHom     = ZHom   + exp(-alpha*tHom(i))*lognrnd(mu,sigma);
    end
    ZHom_avg = ZHom_avg + ZHom;
    
    %calculate Z and Z_avg for inhomogenous case
    for i = 1:N365Inhom
        ZInhom   = ZInhom + exp(-alpha*tInhom(i))*lognrnd(mu,sigma);
    end
    ZInhom_avg = ZInhom_avg + ZInhom;
    
    
end

%now that the sums are complete, we average them over # of iterations
ZHom_avg      = ZHom_avg/bMax;
ZInhom_avg    = ZInhom_avg/bMax;

fprintf('The expected value of Z_disc is');
fprintf('\n %.3f mill. kr. \t for the homogenous case, and\n %.3f mill. kr.\t for the inhomogenous case\n',ZHom_avg, ZInhom_avg);



end