function [rawRow, rawUserID, rawHost, rawTimestamp, rawPage, rawHTTMVerb, rawUserAgent, rawEncode, rawReferrer, rawLand, rawIp1, rawIp2, rawIp3, rawIp4, rawPort] = readCSVPicturegram(fileName);

  [rawRow, rawUserID, rawHost, rawTimestamp, rawPage, rawHTTMVerb, rawUserAgent, rawEncode, rawReferrer, rawLand, rawIp1, rawIp2, rawIp3, rawIp4, rawPort ] = textread(fileName, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerlines', 1, 'delimiter', ',');
%     1     2         3         4             5         6            7            8           9           10        11      12      13      14      15                            1  2  3  4  5  6  7  8  9  10 11 12 13 14 15                                   
  
  
end