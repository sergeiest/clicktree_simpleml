[sortUniqA, sortIdx] = sort(uniqA(:, 2));
sortUniqA = uniqA(sortIdx,:);
sortUniqIdx = uniqIdx (sortIdx,:);

topNumber = 50;

firstRaw = 1;

topIPs = 0; 

for i=1:K
  endRaw = min(sum(sortUniqIdx(:,1) == i), topNumber) - 1;
  topIPs(firstRaw:firstRaw+endRaw,[2,3]) = sortUniqA(sortUniqIdx(:,1) == i,[1,2])(end - endRaw:end, :);
  topIPs(firstRaw:firstRaw+endRaw,1) = i;
  firstRaw += endRaw + 1;
end

for i=1:size(topIPs,1)
  thisIP = (rawIPSum(:,1)==topIPs(i,2));
  topIPs(i,4) = rawIp1(thisIP,1)(1,1);
  topIPs(i,5) = rawIp2(thisIP,1)(1,1);
  topIPs(i,6) = rawIp3(thisIP,1)(1,1);
  topIPs(i,7) = rawIp4(thisIP,1)(1,1);
end

topIPs(:,3) = round(exp(topIPs(:,3)) - 10);
topIPs(:,2) = round(topIPs(:,2) / 10^5); 