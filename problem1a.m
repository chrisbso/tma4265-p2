function problem1a
close all;
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



mean = sum(N)/b;
h = plot(t,mean,'LineWidth',6,'DisplayName','\Sigma N(t)/(# of iterations)','Color','b');
xlabel('t'); ylabel('N(t)');
lgd = legend(h);
set(findall(gcf,'-property','FontSize'),'FontSize',14);

saveTightFigure(h,'problem1a.pdf');


end
