function [G, E] = makeGE

lambda = 25;
mu0 = 1;
ml0 = mu0 + lambda;
ml31 = 31 * mu0 + lambda;

%Setting up G and E
G = zeros(33);
G(1,1) = -lambda;
G(1,2) = lambda;
G(2,1) = mu0;
G(33, 32) = 32 * mu0;
G(32, 33) = lambda;
G(33, 33) = -(32 * mu0);

E = zeros(33);
E(1,2) = 1;
E(2,1) = mu0/ml0;
E(33,32) = 1;
E(32,33) = lambda/ml31;

for i = 1:33
    mu=(i-1)*mu0;
    ml=lambda + mu;
    for j = 1:33
        if i>1 && j>1 && i<33 && j<33
            if i == j
                G(i,j) = -(mu + lambda);               
            end
            if i == j+1
                G(i,j) = mu;
                E(i,j) = mu/ml;
            end
            if i == j-1
                G(i,j) = lambda;
                E(i,j) = lambda/ml;
            end
        end
    end
end






end


