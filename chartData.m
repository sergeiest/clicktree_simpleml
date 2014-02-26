function [chartData1, chartData2, chartData3, chartData4] = chartData(A_norm, minCentroids,uniqA, A, K)

rawIPSum = A(:,2);
rawPage = A(:,3);
rawTimedate = A(:,1);

% Get uniqIdx from minCentroids
[uniqIdx, J] = findClosestCentroids(A_norm, minCentroids);

% Get idx from uniqIdx
m = size(rawIPSum,1);
idx = zeros(m,1);
for i=1:m
  idx(i,1) = (uniqIdx(uniqA(:,1) == rawIPSum(i,1),1));
end


% Defult values for drawChart

drawA = A;
drawIdx = idx;
addRandom = 0;
x = 1;
y = 2;
d = 0;
indexUsed =0;

% ------- Datatable for Dashboard --------

m = size(A,1);

% Request per class for top URLs
tmpData = zeros(m,K);

for i = 1:m
  tmpData(i,idx(i,1)) = rawPage(i,1);
end

listPage = unique(rawPage);
m0 = size(listPage,1);
chartData1 = zeros(m0, K + 2);
chartData1(:,1) = listPage;

for i = 1:m0
  for j =1:K
    chartData1(i,j+1) = sum(tmpData(tmpData(:,j) == listPage(i,1),j));
  end 
end
chartData1(:,K+2) = sum(chartData1(:,2:K+1),2);

% Everage number of requests per class
chartData2 = zeros(K,4);

chartData2(:,1) = unique(idx);

for i = 1:K
  chartData2(i,2) = sum(idx(:,1) == i,1); 
  chartData2(i,3) = sum(uniqIdx(:,1) == i,1);
  chartData2(i,4) = chartData2(i,2) / chartData2(i,3);
end

% Requests by day / by hour for each class
tmpData = zeros(m, 3 + K);
tmpData(:, 1) = rawTimedate(:,1);
tmpData(:, 2) = ceil((rawTimedate(:,1) - 1388534400)/(60*60*24));
tmpData(:, 3) = ceil((rawTimedate(:,1) - 1388534400 - tmpData(:, 2)*60*60*24)/(60*60));

for i = 1:m
  tmpData(i,idx(i,1) + 3) = 1;
end

listDays = unique(tmpData(:, 2));
m0 = size(listDays,1);
chartData3 = zeros(m0, 1 + K + 1);

chartData3(:,1) = listDays;

for i = 1:m0
  chartData3(i,2:K+1) = sum(tmpData(tmpData(:,2) == listDays(i,1),4:K+3));
end
chartData3(:,K+2) = sum(chartData3(:,2:K+1),2);

listHours = unique(tmpData(:, 3));
m0 = size(listHours,1);
chartData4 = zeros(m0, 1 + K + 1);

chartData4(:,1) = listHours;

for i = 1:m0
  chartData4(i,2:K+1) = sum(tmpData(tmpData(:,3) == listHours(i,1),4:K+3));
end
chartData4(:,K+2) = sum(chartData4(:,2:K+1),2);