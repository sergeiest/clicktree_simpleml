function [rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer] = readCSV(fileName);

  [rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer] = textread(fileName, '%f %f %f %f %f %f %f %f %f %f %f', 'headerlines', 1, 'delimiter', ',');

end