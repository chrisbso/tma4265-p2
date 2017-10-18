function y = problem1a
lambda = 3;
n=175;
maxDays = 59;
b = 1000;
F = 0;
for t = 0:maxDays
    F = F + exp(n*log(lambda*t)-lambda*t-gammaln(n+1));
end

N = zeros(b,t);
for b = 1:100
    for t = 0:maxDays
        N(b,t+1) = poissrnd(lambda*t);
    end
end



t = 0:maxDays;
figure();
hold on;
for b = 1:100
    plot(t,N(b,:));
end


sum(N(:,60)>175)/60;
mean = sum(N)/b;
plot(t,mean,'LineWidth',6)

end
