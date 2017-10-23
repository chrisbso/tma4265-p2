function problem1a
close all;
lambda = 3;
n=175;
maxDays = 59;
bMax = 100;
P = 0;
for i = 0:n
    P = P + exp(i*log(lambda*maxDays)-lambda*maxDays-gammaln(i+1));
end

N = zeros(bMax,maxDays);
for b = 1:bMax
    for t = 0:maxDays
        N(b,t+1) = poissrnd(lambda*t);
    end
end
moreThan175Claims = sum(N(:,end)>175)/bMax;



t = 0:maxDays;
figure();
hold on;
for b = 1:bMax
    plot(t,N(b,:));
end

fprintf('Out of %d realizations,\n',bMax);
fprintf('N(t=59)>175 was achieved for \n %.1f%% of realizations. For comparison, \nP([N(59)>175]) = \n %.1f%%\n',moreThan175Claims*100,(1-P)*100);

mean = sum(N)/bMax;
h = plot(t,mean,'LineWidth',6,'DisplayName','\Sigma N(t)/(# of iterations)','Color','b');
xlabel('t'); ylabel('N(t)');
lgd = legend(h);
set(findall(gcf,'-property','FontSize'),'FontSize',14);

%saveTightFigure(h,'problem1a.pdf');


end
