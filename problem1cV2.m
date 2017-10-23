function problem1c
maxDays = 59; %sets Tmax
mu = -2;
sigma = 1;
bMax = 10000; %maximum # of realizations
lambda = 2 + cos(pi/182.5*[0,maxDays]); %inhomogenous
maxLambda = max(lambda);

ZHom = zeros(1,bMax);
ZInhom = zeros(1,bMax);
for b = 1:bMax
    NtHom = poissrnd(maxLambda*maxDays);
    
    for i = 1:NtHom
       ZHom(b) = ZHom(b) + lognrnd(mu,sigma);
    end
    
    NtInhom = poissrnd(lambda(end)*maxDays);
    
    for i = 1:NtInhom
        ZInhom(b) = ZInhom(b) + lognrnd(mu,sigma);
    end
    %thinning, with requirement rand() < lambda(T_i)/lambdaMax, 0 < rand() < 1
    
end
ZHom_avg = sum(ZHom)/bMax
ZHom_var = 1/(bMax-1)*sum((ZHom-ZHom_avg).^2)


ZInhom_avg = sum(ZInhom)/bMax
ZInhom_var = 1/(bMax-1)*sum((ZInhom-ZInhom_avg).^2)
fprintf('For %d iterations,\n\nIn the homogenous case:\nE[Z(t=59)] \t\t= %.2f mill. kr.,\nVar[Z(t=59)] \t= %.2f mill. kr.\n\n',bMax,ZHom_avg,ZHom_var);
fprintf('In the inhomogenous case:\nE[Z(t=59)] \t\t= %.2f mill. kr.,\nVar[Z(t=59)] \t= %.2f mill. kr.\n',ZInhom_avg,ZInhom_var);

end