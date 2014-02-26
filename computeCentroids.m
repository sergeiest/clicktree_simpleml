function centroids = computeCentroids(X, idx, K)
%COMPUTECENTROIDS returs the new centroids by computing the means of the 
%data points assigned to each centroid.
%   centroids = COMPUTECENTROIDS(X, idx, K) returns the new centroids by 
%   computing the means of the data points assigned to each centroid. It is
%   given a dataset X where each row is a single data point, a vector
%   idx of centroid assignments (i.e. each entry in range [1..K]) for each
%   example, and K, the number of centroids.
%

% Useful variables
[m n] = size(X);

% You need to return the following variables correctly.
centroids = zeros(K, n);


idx_count = zeros(K, 1);

for j = 1:m
	idx_count(idx(j),1) = idx_count(idx(j)) + 1; 
	centroids(idx(j),:) = centroids(idx(j),:) .+ X(j,:);
end

for i = 1:n
  centroids(:,i) = centroids(:,i) ./ idx_count(:,1) ;
end

for i = 1:K
  if idx_count(i,1) == 0
    centroids(i,:) = X(randi(size(X,1),1,1)',:);
    printf(" -- there was an empty class --\n");
  endif
end


end

