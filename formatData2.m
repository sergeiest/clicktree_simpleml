function [uniqA, A] = formatData2(rawRow, rawTimestamp, rawPage, rawReferrer, rawIp1, rawIp2, rawIp3, rawIp4)

rawIPSum = bitshift(rawIp4,0) + bitshift(rawIp3,8) + bitshift(rawIp2,16) + bitshift(rawIp1,24);

uniqIP = unique(rawIPSum);

m0 = size(rawIp1,1);
m = size(uniqIP,1);

uniqFrequency = zeros(m,1);
uniqTimeDev = zeros(m,1);
uniqTimeAv = zeros(m,1);

%  -- Page --
n=5;
splitPage = zeros(m0,n);
uniqPage = zeros(m,n);
uniqPageFrequency = zeros(m,n);
splitPage(:,1) = (rawPage(:,1) == 0);
splitPage(:,2) = (rawPage(:,1) == 1);
splitPage(:,3) = (rawPage(:,1) == 10);
splitPage(:,4) = (rawPage(:,1) == 28);
splitPage(:,n) = 1 - sum(splitPage(:,1:n-1),2);

% -- Reffer --
n=5;
splitReferrer = zeros(m0,n);
uniqReferrer = zeros(m,n);
uniqReferrerFrequency = zeros(m,n);
for i=1:n-1
  splitReferrer(:,i) = (rawReferrer(:,1) == i-1);
end
splitReferrer(:,n) = 1 - sum(splitReferrer(:,1:n-1),2);


for i=1:m

  thisIP = (rawIPSum(:,1) == uniqIP(i,1));
  uniqFrequency(i,1) = sum(thisIP);
  
  uniqPageFrequency(i,:) = sum(splitPage(thisIP,:) == 1, 1);
  uniqPage(i,:) = sign(uniqPageFrequency(i,:));

  uniqReferrerFrequency(i,:) = sum(splitReferrer(thisIP,:) == 1, 1);
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
tmp2 = [log(uniqPageFrequency +1), uniqPage, log(uniqReferrerFrequency + 1), uniqReferrer ]; 
%         5-9                         10-14       15-19                       20-24

uniqA = [tmp1, tmp2];
 %        1-4  5-24
 
 A = [rawTimestamp, rawIPSum, rawPage, rawReferrer, rawIp1, rawIp2, rawIp3, rawIp4];


end