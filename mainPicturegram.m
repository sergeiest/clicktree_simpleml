% don't run everything at one, it'll take a while
% for online algorithm we need only 'Online k-Means' and chartData and topIPbyClass

% Prepare data for the initial k-Means

[rawRow, rawUserID, rawHost, rawTimestamp, rawPage, rawHTTMVerb, rawUserAgent, rawEncode, rawReferrer, rawLand, rawIp1, rawIp2, rawIp3, rawIp4, rawPort] = readCSVPicturegram('outPicturegram.csv');

[uniqA, A] = formatDataPicturegram(rawRow, rawUserID, rawHost, rawTimestamp, rawPage, rawHTTMVerb, rawUserAgent, rawEncode, rawReferrer, rawLand, rawIp1, rawIp2, rawIp3, rawIp4, rawPort);

[A_norm, mu, sigma] = featureNormalize(uniqA(:,[2:54]));

% k-Means for unique IP addresses

K = 10; % 10;
iterations = 30; % 30;
randomLoops = 40; % 20;

[minCentroids, minJ, uniqIdx] = kMeansUniqIP(A_norm, K, iterations, randomLoops);

[chartData1, chartData2, chartData3, chartData4] = chartData(A_norm, minCentroids, uniqA, A, K);

topNumber = 5
topIPs = topIPbyClass(uniqA, uniqIdx, A, topNumber);



% Get idx from uniqIdx
rawIPSum = A(:,2);
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

drawChart(drawA, drawIdx, A, uniqA, addRandom, x, y, d, indexUsed);
