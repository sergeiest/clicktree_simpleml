function [uniqA, A] = formatData(rawId, rawUserid, rawTimedate, rawClientType, rawPage, rawHttmverb, rawIp1, rawIp2, rawIp3, rawIp4, rawReferrer)

rawIPSum = rawIp1 * 256^3 .+ rawIp2 * 256^2 .+ rawIp3 * 256^1 .+ rawIp4;

uniqIP = unique(rawIPSum);

m0 = size(rawIp1,1);
m = size(uniqIP,1);

uniqFrequency = zeros(m,1);
uniqTimeDev = zeros(m,1);
uniqTimeAv = zeros(m,1);

splitPage = zeros(m0,12);
uniqPage = zeros(m,12);
uniqPageFrequency = zeros(m,12);
for i=1:10
  splitPage(:,i) = (rawPage(:,1) == i - 1);
end
splitPage(:,11) = (rawPage(:,1) == 147);
splitPage(:,12) = 1 - sum(splitPage(:,1:11),2);

n=3;
splitHttmverb = zeros(m0,n);
uniqHttmverb = zeros(m,n);
uniqHttmverbFrequency = zeros(m,n);
for i=1:n
  splitHttmverb(:,i) = (rawHttmverb(:,1) == i - 1);
end

n=5;
splitClientType = zeros(m0,n);
uniqClientType = zeros(m,n);
uniqClientTypeFrequency = zeros(m,n);
for i=1:n
  splitClientType(:,i) = (rawClientType(:,1) == i - 1);
end

n=3;
splitReferrer = zeros(m0,n);
uniqReferrer = zeros(m,n);
uniqReferrerFrequency = zeros(m,n);
splitReferrer(:,1) = (rawReferrer(:,1) == 1);
splitReferrer(:,2) = (rawReferrer(:,1) == 2);
splitReferrer(:,3) = 1 - sum(splitReferrer(:,1:2),2);

n=1;
splitUserid = zeros(m0,n);
uniqUseridCount = zeros(m,n);
uniqUserid = zeros(m,n);
splitUserid = (rawUserid(:,1) ~= -1);


for i=1:m

  thisIP = (rawIPSum(:,1) == uniqIP(i,1));
  uniqFrequency(i,1) = sum(thisIP);
  
  uniqPageFrequency(i,:) = sum(splitPage(thisIP,:) == 1);
  uniqPage(i,:) = sign(uniqPageFrequency(i,:));
  
  uniqHttmverbFrequency(i,:) = sum(splitHttmverb(thisIP,:) == 1);
  uniqHttmverb(i,:) = sign(uniqHttmverbFrequency(i,:));
  
  uniqClientTypeFrequency(i,:) = sum(splitClientType(thisIP,:) == 1);
  uniqClientType(i,:) = sign(uniqClientTypeFrequency(i,:));  

  uniqReferrerFrequency(i,:) = sum(splitReferrer(thisIP,:) == 1);
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

tmp1 = [uniqIP, log(uniqFrequency + 10), uniqTimeDev, log(uniqTimeAv + 1)];
%         1               2                          3                  4
tmp2 = [uniqPageFrequency, uniqPage, uniqHttmverbFrequency, uniqHttmverb, uniqClientTypeFrequency, uniqClientType];
%         5-16              17-28       29-31                  32-34        35-39                   40-44
tmp3 = [uniqReferrerFrequency, uniqReferrer, uniqUseridCount, uniqUserid];
%         45-47                    48-50        51              52
uniqA = [tmp1, tmp2, tmp3];
 %        1-4  5-44   45-52
 
 A = [rawTimedate, rawIPSum, rawPage, rawHttmverb, rawClientType, rawReferrer];

 end

