function [newCentroids, newJ, newIdx] = kMeansImprove(A_norm, K, centroids, improveIter)

goAuto = input("Press '1' to coninue without stop or a letter to stop:");

for iter = 1:improveIter
  [uniqIdx, J] = findClosestCentroids(A_norm, centroids);
  printf("step: %d - J: %d \n", iter, J);    
  if goAuto ~= 1 & goAuto ~= 2
    goAuto = input("Press '1' to coninue without stop or a letter to stop:");
  endif
  centroids = computeCentroids(A_norm, uniqIdx, K);  
end

[newIdx, newJ] = findClosestCentroids(A_norm, centroids);
printf("-- final J: %d, for loop %d \n", J, i);

newCentroids = centroids;

end