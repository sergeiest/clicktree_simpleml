function [uniqA, A] = formatData3(rawRow, rawUserID, rawHost, rawTimestamp, rawPage, rawHTTMVerb, rawUserAgent, rawEncode, rawReferrer, rawLand, rawIp1, rawIp2, rawIp3, rawIp4, rawPort)

rawIPSum = rawIp1 * 256^3 .+ rawIp2 * 256^2 .+ rawIp3 * 256^1 .+ rawIp4;

uniqIP = unique(rawIPSum);

m0 = size(rawIp1,1);
m = size(uniqIP,1);

uniqFrequency = zeros(m,1);
uniqTimeDev = zeros(m,1);
uniqTimeAv = zeros(m,1);

%  -- Page --
splitPage = zeros(m0,3);
uniqPage = zeros(m,3);
uniqPageFrequency = zeros(m,3);
for i=1:3
  splitPage(:,i) = (rawPage(:,1) == i - 1);
end

%  -- Encode --
splitEncode = zeros(m0,4);
uniqEncode = zeros(m,4);
uniqEncodeFrequency = zeros(m,4);
for i=1:3
  splitEncode(:,i) = (rawEncode(:,1) == i - 1);
end
splitEncode(:,4) = 1 - sum(splitEncode(:,1:3),2);

%  -- Land --
splitLand = zeros(m0,5);
uniqLand = zeros(m,5);
uniqLandFrequency = zeros(m,5);
splitLand(:,1) = (rawLand(:,1) == 0);
splitLand(:,2) = (rawLand(:,1) == 1);
splitLand(:,3) = (rawLand(:,1) == 2);
splitLand(:,4) = (rawLand(:,1) == 32);
splitLand(:,5) = 1 - sum(splitLand(:,1:4),2);

%  -- User Agent --
splitUserAgent = zeros(m0,9);
uniqUserAgent = zeros(m,9);
uniqUserAgentFrequency = zeros(m,9);
splitUserAgent(:,1) = (rawUserAgent(:,1) == 0);
splitUserAgent(:,2) = (rawUserAgent(:,1) == 2);
splitUserAgent(:,3) = (rawUserAgent(:,1) == 3);
splitUserAgent(:,4) = (rawUserAgent(:,1) == 4);
splitUserAgent(:,5) = (rawUserAgent(:,1) == 6);
splitUserAgent(:,6) = (rawUserAgent(:,1) == 12);
splitUserAgent(:,7) = (rawUserAgent(:,1) == 59);
splitUserAgent(:,8) = (rawUserAgent(:,1) == 82);
splitUserAgent(:,9) = 1 - sum(splitUserAgent(:,1:8),2);

% -- Reffer --
splitReferrer = zeros(m0,5);
uniqReferrer = zeros(m,5);
uniqReferrerFrequency = zeros(m,5);
splitReferrer(:,1) = (rawReferrer(:,1) == 0);
splitReferrer(:,2) = (rawReferrer(:,1) == 1);
splitReferrer(:,3) = (rawReferrer(:,1) == 2);
splitReferrer(:,4) = (rawReferrer(:,1) == 3);
splitReferrer(:,5) = 1 - sum(splitReferrer(:,1:4),2);



for i=1:m

  thisIP = (rawIPSum(:,1) == uniqIP(i,1));
  uniqFrequency(i,1) = sum(thisIP);
  
  uniqPageFrequency(i,:) = sum(splitPage(thisIP,:) == 1);
  uniqPage(i,:) = sign(uniqPageFrequency(i,:));

  uniqEncodeFrequency(i,:) = sum(splitEncode(thisIP,:) == 1);
  uniqEncode(i,:) = sign(uniqEncodeFrequency(i,:));
  
  uniqLandFrequency(i,:) = sum(splitLand(thisIP,:) == 1);
  uniqLand(i,:) = sign(uniqLandFrequency(i,:));
    
  uniqUserAgentFrequency(i,:) = sum(splitUserAgent(thisIP,:) == 1);
  uniqUserAgent(i,:) = sign(uniqUserAgentFrequency(i,:));
  
  uniqReferrerFrequency(i,:) = sum(splitReferrer(thisIP,:) == 1);
  uniqReferrer(i,:) = sign(uniqReferrerFrequency(i,:));
  
  dateIP = rawTimestamp([thisIP(:,1) ~= 0],:);
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
%         1               2                   3                  4
tmp2 = [log(uniqPageFrequency +1), uniqPage, log(uniqEncodeFrequency + 1), uniqEncode, log(uniqLandFrequency + 1), uniqLand, log(uniqUserAgentFrequency + 1), uniqUserAgent, log(uniqReferrerFrequency + 1), uniqReferrer ]; 
%         5-7                         8-10       11-14                       15-18       19-23                        24-28     29-37                              38-46          47-51                           52-56

uniqA = [tmp1, tmp2];
 %        1-4  5-56
 
 A = [rawTimestamp, rawIPSum, rawPage, rawHTTMVerb, rawReferrer, rawIp1, rawIp2, rawIp3, rawIp4];


end