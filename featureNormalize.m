function [X_norm, mu, sigma] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. 

X_norm = X;
mu = zeros(1, size(X, 2));
sigma = zeros(1, size(X, 2));

m = size (X,1);
n = size (X,2);
mu =  double(sum (X)) / m;
X_norm = double(X - ones(m,1) * mu);
sigma = (sum(X_norm .^ 2) / m) .^ 0.5;
X_norm = X_norm ./ (ones(m,1) * sigma);



end
