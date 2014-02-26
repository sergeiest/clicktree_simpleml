function [idx, J] = findClosestCentroids(X, centroids)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
%

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);
[m, n] = size(X);


min_a = zeros(size(X,1), 1);
a = zeros(size(X,1), 1);
J = 0;

a = sum(((X - ones(m,1) * centroids(1,:)) .^ 2)')';
min_a = a;
idx = ones(m, 1);

for i = 2:K
	a = sum(((X - ones(m,1) * centroids(i,:)) .^ 2)')';
  b = sign(sign(min_a - a) - 1) + 1;
  idx = idx .* (1 - b) + ones(m, 1) .* (b) * i;
  min_a = min_a .* (1-b) + a .* (b); 
end


for i=1:m
  J = J + sum((X(i,:) - centroids(idx(i),:)) .^ 2);
end


end

