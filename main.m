% don't run everything at one, it'll take a while
% for online algorithm we need only 'Online k-Means' and chartData and topIPbyClass

% Prepare data for the initial k-Means

[rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer] = readCSV('data/1.csv');

[uniqATotal, ATotal] = formatData(rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer);
uniqA = uniqATotal(uniqATotal(:,2) > log(11), :);

[A_norm, mu, sigma] = featureNormalize(uniqA(:,[2:14, 25:27, 31:36, 43:46, 51]));
A_norm(:,17) = A_norm(:,17) * 10;

% k-Means for unique IP addresses

K = 9; % 10;
iterations = 30; % 30;
randomLoops = 50; % 20;

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
[pageTopIPs, dayTopIPs, hourTopIPs] = chartTopIPs(topIPs, uniqA(:,1), uniqA(:,5:13), rawIPSum, rawTimedate);

% Prepare new (hourly) data for Online k-Means

[hour_rawId, hour_rawUserid, hour_rawTimedate, hour_rawClientType, hour_rawPage, hour_rawHttmverb, hour_rawIp1, hour_rawIp2, hour_rawIp3, hour_rawIp4, hour_rawReferrer] = hourReadCSV('output_hour.csv');

hour_uniqA = hourFormatData(uniqA, hour_rawId, hour_rawUserid, hour_rawTimedate, hour_rawClientType, hour_rawPage, hour_rawHttmverb, hour_rawIp1, hour_rawIp2, hour_rawIp3, hour_rawIp4, hour_rawReferrer);

hourANorm = double(hour_uniqA(:,[2:4, 35:39, 40:44, 48:50, 51]) - ones(m,1) * mu);
hourANorm = hourANorm ./ (ones(m,1) * sigma);
hourANorm(:,4:8) = hourANorm(:,4:8) * 5;

% Online k-Means

[hourIdx, hourCentroids, hourJ] = onlineKMeans(hourANorm, A_norm, minCentroids, hour_uniqA(:,1), uniqA(:,1));

