hour_rawIPSum = hour_rawIp1 * 256^3 .+ hour_rawIp2 * 256^2 .+ hour_rawIp3 * 256^1 .+ hour_rawIp4;

hour_uniqIP = unique(hour_rawIPSum);

m0 = size(hour_rawIp1,1);
m = size(hour_uniqIP,1);

hour_uniqFrequency = zeros(m,1);
hour_uniqTimeDev = zeros(m,1);
hour_uniqTimeAv = zeros(m,1);

hour_splitPage = zeros(m0,12);
hour_uniqPage = zeros(m,12);
hour_uniqPageFrequency = zeros(m,12);
for i=1:10
  hour_splitPage(:,i) = (hour_rawPage(:,1) == i - 1);
end
hour_splitPage(:,11) = (hour_rawPage(:,1) == 147);
hour_splitPage(:,12) = 1 - sum(hour_splitPage(:,1:11),2);

n=3;
hour_splitHttmverb = zeros(m0,n);
hour_uniqHttmverb = zeros(m,n);
hour_uniqHttmverbFrequency = zeros(m,n);
for i=1:n
  hour_splitHttmverb(:,i) = (hour_rawHttmverb(:,1) == i - 1);
end

n=5;
hour_splitClientType = zeros(m0,n);
hour_uniqClientType = zeros(m,n);
hour_uniqClientTypeFrequency = zeros(m,n);
for i=1:n
  hour_splitClientType(:,i) = (hour_rawClientType(:,1) == i - 1);
end

n=3;
hour_splitReferrer = zeros(m0,n);
hour_uniqReferrer = zeros(m,n);
hour_uniqReferrerFrequency = zeros(m,n);
hour_splitReferrer(:,1) = (hour_rawReferrer(:,1) == 1);
hour_splitReferrer(:,2) = (hour_rawReferrer(:,1) == 2);
hour_splitReferrer(:,3) = 1 - sum(hour_splitReferrer(:,1:2),2);

n=1;
hour_splitUserid = zeros(m0,n);
hour_uniqUseridCount = zeros(m,n);
hour_uniqUserid = zeros(m,n);
%n niq = (hour_rawUserid(:,1) ~= -1);


for i=1:m

  thisIP = (rawIPSum(:,1) == hour_uniqIP(i,1));
  hour_uniqFrequency(i,1) = sum(thisIP);
  
  hour_uniqPageFrequency(i,:) = sum(splitPage(thisIP,:) == 1);
  hour_uniqPage(i,:) = sign(hour_uniqPageFrequency(i,:));
  
  hour_uniqHttmverbFrequency(i,:) = sum(splitHttmverb(thisIP,:) == 1);
  hour_uniqHttmverb(i,:) = sign(hour_uniqHttmverbFrequency(i,:));
  
  hour_uniqClientTypeFrequency(i,:) = sum(splitClientType(thisIP,:) == 1);
  hour_uniqClientType(i,:) = sign(hour_uniqClientTypeFrequency(i,:));  

  hour_uniqReferrerFrequency(i,:) = sum(splitReferrer(thisIP,:) == 1);
  hour_uniqReferrer(i,:) = sign(hour_uniqReferrerFrequency(i,:)); 

  hour_uniqUseridCount(i,:) = size(unique(rawUserid(thisIP,1)),1);
  hour_uniqUserid(i,:) = sign(sum(splitUserid(thisIP,:) == 1));
  
  dateIP = rawTimedate([thisIP(:,1) ~= 0],:);
  dateDelta = dateIP(2:size(dateIP,1),:) - dateIP(1:size(dateIP,1)-1,:);
  if size(dateDelta,1) == 0
    hour_uniqTimeDev(i,1) = 24*60*60*30;
    hour_uniqTimeAv(i,1) = 24*60*60*30;
  else
    hour_uniqTimeDev(i,1) = std (dateDelta);
    hour_uniqTimeAv(i,1) = sum (dateDelta) / size(dateDelta,1);
  endif
   
end

hour_tmp1 = [hour_uniqIP, log(hour_uniqFrequency + 10), hour_uniqTimeDev, log(hour_uniqTimeAv + 1)];
%         1               2                          3                  4
hour_tmp2 = [hour_uniqPageFrequency, hour_uniqPage, hour_uniqHttmverbFrequency, hour_uniqHttmverb, hour_uniqClientTypeFrequency, hour_uniqClientType];
%         5-16              17-28       29-31                  32-34        35-39                   40-44
hour_tmp3 = [hour_uniqReferrerFrequency, hour_uniqReferrer, hour_uniqUseridCount, hour_uniqUserid];
%         45-47                    48-50        51              52
hour_uniqA = [hour_tmp1, hour_tmp2, hour_tmp3];
 %        1-4  5-44   45-52
 
 
hour_uniqA2 = hour_uniqA(:,[2:4, 35:39, 40:44, 48:50, 51]);
hourANorm = double(hour_uniqA2 - ones(m,1) * mu);
hourANorm = hourANorm ./ (ones(m,1) * sigma);
hourANorm(:,4:8) = hourANorm(:,4:8) * 5;

