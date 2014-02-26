function [hour_rawId, hour_rawUserid, hour_rawTimedate, hour_rawClientType, hour_rawPage, hour_rawHttmverb, hour_rawIp1, hour_rawIp2, hour_rawIp3, hour_rawIp4, hour_rawReferrer] = hourReadCSV(fileName)

  [hour_rawId, hour_rawUserid, hour_rawTimedate, hour_rawClientType, hour_rawPage, hour_rawHttmverb, hour_rawIp1, hour_rawIp2, hour_rawIp3, hour_rawIp4, hour_rawReferrer] = textread(fileName, '%f %f %f %f %f %f %f %f %f %f %f', 'headerlines', 1, 'delimiter', ',');
  
end