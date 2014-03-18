% don't run everything at one, it'll take a while
% for online algorithm we need only 'Online k-Means' and chartData and topIPbyClass

% Prepare data for the initial k-Means

[rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer] = readCSV('output_2.csv');

[uniqA, A] = formatData(rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer);

[A_norm, mu, sigma] = featureNormalize(uniqA(:,[2:13, 23:25, 29:34, 41:44, 49]));
A_norm(:,16) = A_norm(:,16) * 10;

% k-Means for unique IP addresses

K = 10; % 10;
iterations = 30; % 30;
randomLoops = 20; % 20;

[minCentroids, minJ, uniqIdx] = kMeansUniqIP(A_norm, K, iterations, randomLoops);

improveIter = 50;

[newCentroids, newJ, newIdx] = kMeansImprove(A_norm, K, minCentroids, improveIter);

[chartData1, chartData2, chartData3, chartData4, idx] = chartData(A_norm, minCentroids, uniqA, A, K, 0);
[chartData5, chartData6, chartData7] = tmpChartData(A_norm, minCentroids,uniqA, A, K, idx);

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

