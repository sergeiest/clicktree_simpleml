function [idx, centroids, J] = onlineKMeans(X, XOriginal, centroids, uniqIP, uniqIPOriginal)

  [m, n] = size(X);
  [m0, n0] = size(XOriginal);
  K = size(centroids,1);
  
  [idxOriginal, J] = findClosestCentroids(XOriginal, centroids);
  
  nVetrix = zeros(K, 1);
  J = zeros(m,1);
  
  for i=1:K
    nVetrix(i,1) = sum(idxOriginal == i);
  end
  
  idx = zeros(m,1);
  
  for i=1:m
  
    lastIP = uniqIPOriginal(:,1) == uniqIP(i,1);
    thisK = findClosestCentroids(X(i,:), centroids); 
    
    if sum(lastIP) == 1
      thisK = idxOriginal(lastIP,1);
      centroids(thisK,:) = centroids(thisK,:) - (centroids(thisK,:) - XOriginal(lastIP,:)) ./ nVetrix(thisK,1);
      nVetrix(thisK,1) -= 1;      
    endif
   
    nVetrix(thisK,1) += 1;
    centroids(thisK,:) = centroids(thisK,:) + (centroids(thisK,:) - X(i,:)) ./ nVetrix(thisK,1);             
    idx(i,1) = thisK;
    
    m1 = size(XOriginal,1);
    if sum(lastIP) == 1
      XOriginal(lastIP,:) = X(i,:);
      idxOriginal(lastIP,:) = thisK;
    else
      uniqIPOriginal(m1 + 1,:) = uniqIP(i,1);
      idxOriginal(m1 + 1,:) = thisK;
      XOriginal(m1 + 1,:) = X(i,:);
    endif
    
    %J(i,2) = m1;
    %J(i,1) = 0;
    %for j=1:size(XOriginal,1)
    %  J(i,1) += sum((XOriginal(j,:) - centroids(idxOriginal(j),:)) .^ 2);
    %end
    
    
  end

end