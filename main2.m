% don't run everything at one, it'll take a while
% for online algorithm we need only 'Online k-Means' and chartData and topIPbyClass

% Prepare data for the initial k-Means

[rawRow, rawTimestamp, rawPage, rawReferrer, rawIp1, rawIp2, rawIp3, rawIp4] = readCSV2('data/2.csv');

[uniqATotal, ATotal] = formatData2(rawRow, rawTimestamp, rawPage, rawReferrer, rawIp1, rawIp2, rawIp3, rawIp4);
uniqA = uniqATotal(uniqATotal(:,2) > log(11), :);


[A_norm, mu, sigma] = featureNormalize(uniqA(:,2:end));

% k-Means for unique IP addresses

K = 9; % 10;
iterations = 30; % 30;
randomLoops = 40; % 20;

[minCentroids, minJ, uniqIdx] = kMeansUniqIP(A_norm, K, iterations, randomLoops);

improveIter = 50;

[minCentroids, minJ, uniqIdx] = kMeansImprove(A_norm, K, minCentroids, improveIter);

[idxTotal, uniqIdxTotal] = assignIdx(uniqA, uniqATotal, ATotal, uniqIdx);
idx = idxTotal;
uniqIdx = uniqIdxTotal;
A = ATotal;
uniqA = uniqATotal;


[chartData1, chartData2, chartData3, chartData4, idx] = chartData(uniqA, A, uniqIdx, idx, K + 1);
[chartData5, chartData6, chartData7] = tmpChartData(uniqA, A, uniqIdx, idx, K + 1);

rawIPSum = bitshift(rawIp4,0) + bitshift(rawIp3,8) + bitshift(rawIp2,16) + bitshift(rawIp1,24);
topNumber = 20;
topIPs = topIPbyClass(uniqA, uniqIdx, A, topNumber);
[pageTopIPs, dayTopIPs, hourTopIPs] = chartTopIPs(topIPs, uniqA(:,1), uniqA(:,5:9), rawIPSum, rawTimestamp);


% Defult values for drawChart
drawA = A;
drawIdx = idx;
addRandom = 0;
x = 1;
y = 2;
d = 0;
indexUsed =0;

indexToDraw = drawChart(drawA, drawIdx, A, uniqA, uniqIdx, addRandom, x, y, d, 0);
