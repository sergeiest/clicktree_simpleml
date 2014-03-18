function [minCentroids, minJ, uniqIdx] = kMeansUniqIP(A_norm, K, iterations, randomLoops)

goAuto = input("Press '1' to coninue without stop or a letter to stop:");

minJ = 10^10;
minCentroids = zeros(K, size(A_norm,2));

for i = 1:randomLoops;
  centroids = kMeansInitCentroids(A_norm, K);
  lastJ = 10^10;
  for iter = 1:iterations
    [uniqIdx, J] = findClosestCentroids(A_norm, centroids);
    printf("step: %d - J: %d \n", iter, J);    
    if goAuto ~= 1 & goAuto ~= 2
      goAuto = input("Press '1' to coninue without stop or a letter to stop:");
    endif
    centroids = computeCentroids(A_norm, uniqIdx, K);
    
    if (lastJ - J) / lastJ < 0.0001
      break;
    endif  
    lastJ = J;  
  end
  [uniqIdx, J] = findClosestCentroids(A_norm, centroids);
  printf("-- final J: %d, for loop %d \n", J, i);
  
  if minJ > J
    minJ = J;
    minCentroids = centroids;
  endif
  if goAuto ~= 1
    goAuto = input("Press '1' to coninue without stop or a letter to stop:");
   endif
end
printf("  --- best J: %d --- \n", minJ);
[uniqIdx, J] = findClosestCentroids(A_norm, minCentroids);

end
