function [chartData5, chartData6, chartData7] = tmpChartData(A_norm, minCentroids,uniqA, A, K, idx)

rawTimedate = A(:,1);
rawIPSum = A(:,2);
rawPage = A(:,3);
rawHttmverb = A(:,4);
rawClientType = A(:,5);
rawReferrer = A(:,6);

% Get uniqIdx from minCentroids
[uniqIdx, J] = findClosestCentroids(A_norm, minCentroids);

% Get idx from uniqIdx
m = size(rawIPSum,1);
if idx == 0
  idx = zeros(m,1);
  for i=1:m
    idx(i,1) = (uniqIdx(uniqA(:,1) == rawIPSum(i,1),1));
  end
endif


% ------- Datatable for Dashboard --------

m = size(A,1);

% Httmverb per class for top URLs
tmpData = zeros(m,K) - 1;

for i = 1:m
  tmpData(i,idx(i,1)) = rawHttmverb(i,1);
end

listData = unique(rawHttmverb);
m0 = size(listData,1);
chartData5 = zeros(m0, K + 2);
chartData5(:,1) = listData;

for i = 1:m0
  for j =1:K
    chartData5(i,j+1) = sum(tmpData(:,j) == listData(i,1));
  end 
end
chartData5(:,K+2) = sum(chartData5(:,2:K+1),2);


% ClientType per class for top URLs
tmpData = zeros(m,K) - 1;

for i = 1:m
  tmpData(i,idx(i,1)) = rawClientType(i,1);
end

listData = unique(rawClientType);
m0 = size(listData,1);
chartData6 = zeros(m0, K + 2);
chartData6(:,1) = listData;

for i = 1:m0
  for j =1:K
    chartData6(i,j+1) = sum(tmpData(:,j) == listData(i,1));
  end 
end
chartData6(:,K+2) = sum(chartData6(:,2:K+1),2);

% Referrer per class for top URLs
tmpData = zeros(m,K) - 1;

for i = 1:m
  tmpData(i,idx(i,1)) = rawReferrer(i,1);
end

listData = unique(rawReferrer);
m0 = size(listData,1);
chartData7 = zeros(m0, K + 2);
chartData7(:,1) = listData;

for i = 1:m0
  for j =1:K
    chartData7(i,j+1) = sum(tmpData(:,j) == listData(i,1));
  end 
end
chartData7(:,K+2) = sum(chartData7(:,2:K+1),2);

end


