function [uniqA, A] = formatData(rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer)

rawIPSum = rawIp1 * 256^3 .+ rawIp2 * 256^2 .+ rawIp3 * 256^1 .+ rawIp4;
% rawIPSum = bitshift(rawIp4,0) + bitshift(rawIp3,8) + bitshift(rawIp2,16) + bitshift(rawIp1,24);
% [bitand(bitshift(ip,-8*3),256-1), bitand(bitshift(ip,-8*2),256-1), bitand(bitshift(ip,-8*1),256-1), bitand(bitshift(ip,-8*0),256-1)] 


uniqIP = unique(rawIPSum);

m0 = size(rawIp1,1);
m = size(uniqIP,1);

uniqFrequency = zeros(m,1);
uniqTimeDev = zeros(m,1);
uniqTimeAv = zeros(m,1);

n=10;
splitPage = zeros(m0,n);
uniqPage = zeros(m,n);
uniqPageFrequency = zeros(m,n);
for i=1:9
  splitPage(:,i) = (rawPage(:,1) == i - 1);
end
splitPage(:,n) = 1 - sum(splitPage(:,1:(n-1)),2);

n=3;
splitHttmverb = zeros(m0,n);
uniqHttmverb = zeros(m,n);
uniqHttmverbFrequency = zeros(m,n);
for i=1:n
  splitHttmverb(:,i) = (rawHttmverb(:,1) == i - 1);
end

n=6;
splitClientType = zeros(m0,n);
uniqClientType = zeros(m,n);
uniqClientTypeFrequency = zeros(m,n);
for i=1:n
  splitClientType(:,i) = (rawClientType(:,1) == i - 1);
end

n=4;
splitReferrer = zeros(m0,n);
uniqReferrer = zeros(m,n);
uniqReferrerFrequency = zeros(m,n);
splitReferrer(:,1) = (rawReferrer(:,1) == 0);
splitReferrer(:,2) = (rawReferrer(:,1) == 1);
splitReferrer(:,3) = (rawReferrer(:,1) == 2);
splitReferrer(:,n) = 1 - sum(splitReferrer(:,1:3),2);

n=1;
splitUserid = zeros(m0,n);
uniqUseridCount = zeros(m,n);
uniqUserid = zeros(m,n);
splitUserid = (rawUserid(:,1) ~= -1);

for i=1:m

  thisIP = (rawIPSum(:,1) == uniqIP(i,1));
  uniqFrequency(i,1) = sum(thisIP);
  
  uniqPageFrequency(i,:) = sum(splitPage(thisIP,:) == 1,1);
  uniqPage(i,:) = sign(uniqPageFrequency(i,:));
  
  uniqHttmverbFrequency(i,:) = sum(splitHttmverb(thisIP,:) == 1,1);
  uniqHttmverb(i,:) = sign(uniqHttmverbFrequency(i,:));
  
  uniqClientTypeFrequency(i,:) = sum(splitClientType(thisIP,:) == 1,1);
  uniqClientType(i,:) = sign(uniqClientTypeFrequency(i,:));  

  uniqReferrerFrequency(i,:) = sum(splitReferrer(thisIP,:) == 1,1);
  uniqReferrer(i,:) = sign(uniqReferrerFrequency(i,:)); 

  uniqUseridCount(i,:) = size(unique(rawUserid(thisIP,1)),1);
  uniqUserid(i,:) = sign(sum(splitUserid(thisIP,:) == 1));
  
  dateIP = rawTimedate([thisIP(:,1) ~= 0],:);
  dateDelta = dateIP(2:size(dateIP,1),:) - dateIP(1:size(dateIP,1)-1,:);
  if size(dateDelta,1) == 0
    uniqTimeDev(i,1) = 24*60*60*30;
    uniqTimeAv(i,1) = 24*60*60*30;
  else
    uniqTimeDev(i,1) = std (dateDelta);
    uniqTimeAv(i,1) = sum (dateDelta) / size(dateDelta,1);
  endif
   
end

tmp1 = [uniqIP, log(uniqFrequency + 1), log(uniqTimeDev + 1), log(uniqTimeAv + 1)];
%         1               2                          3                  4
tmp2 = [log(uniqPageFrequency + 1), uniqPage, log(uniqHttmverbFrequency + 1), uniqHttmverb, log(uniqClientTypeFrequency + 1), uniqClientType];
%         5-14                      15-24       25-27                            28-30        31-36                             35-40
tmp3 = [log(uniqReferrerFrequency + 1), uniqReferrer, log(uniqUseridCount + 1), uniqUserid];
%          43-46                          47-50        51                          52
uniqA = [tmp1, tmp2, tmp3];
 %        1-4  5-40   41-50
 
 A = [rawTimedate, rawIPSum, rawPage, rawHttmverb, rawClientType, rawReferrer];

 end

