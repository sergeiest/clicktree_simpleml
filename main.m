% don't run everything at one, it'll take a while
% for online algorithm we need only 'Online k-Means' and chartData and topIPbyClass

% Prepare data for the initial k-Means

[rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer] = readCSV('output.csv');

[uniqA, A] = formatData(rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer);

[A_norm, mu, sigma] = featureNormalize(uniqA(:,[2:4, 35:39, 40:44, 48:50, 51]));
A_norm(:,4:8) = A_norm(:,4:8) * 5;

% k-Means for unique IP addresses

K = 2; % 10;
iterations = 3; % 30;
randomLoops = 2; % 20;

[minCentroids, minJ, uniqIdx] = kMeansUniqIP(A_norm, K, iterations, randomLoops);

[chartData1, chartData2, chartData3, chartData4] = chartData(A_norm, minCentroids, uniqA, A, K);

topNumber = 5
topIPs = topIPbyClass(uniqA, uniqIdx, A, topNumber);

% Prepare new (hourly) data for Online k-Means

[hour_rawId, hour_rawUserid, hour_rawTimedate, hour_rawClientType, hour_rawPage, hour_rawHttmverb, hour_rawIp1, hour_rawIp2, hour_rawIp3, hour_rawIp4, hour_rawReferrer] = hourReadCSV('output_hour.csv');

hour_uniqA = hourFormatData(uniqA, hour_rawId, hour_rawUserid, hour_rawTimedate, hour_rawClientType, hour_rawPage, hour_rawHttmverb, hour_rawIp1, hour_rawIp2, hour_rawIp3, hour_rawIp4, hour_rawReferrer);

hourANorm = double(hour_uniqA(:,[2:4, 35:39, 40:44, 48:50, 51]) - ones(m,1) * mu);
hourANorm = hourANorm ./ (ones(m,1) * sigma);
hourANorm(:,4:8) = hourANorm(:,4:8) * 5;

% Online k-Means

[hourIdx, hourCentroids, hourJ] = onlineKMeans(hourANorm, A_norm, minCentroids, hour_uniqA(:,1), uniqA(:,1));

