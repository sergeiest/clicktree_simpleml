function [rawRow, rawTimestamp, rawPage, rawReferrer, rawIp1, rawIp2, rawIp3, rawIp4] = readCSV2(fileName);

  [rawRow, rawTimestamp, rawPage, rawReferrer, rawIp1, rawIp2, rawIp3, rawIp4 ] = textread(fileName, '%f %f %f %f %f %f %f %f', 'headerlines', 1, 'delimiter', ',');
%     1        2          3         4             5       6     7         8                            1  2  3  4  5  6  7  8 
  
  
end