function [pageTopIPs, dayTopIPs, hourTopIPs] = chartTopIPs(topIPs, uniqIP, uniqPages, rawIPSum, rawTimedate)

% Top pages
 
pageNumber = size(uniqPages,2);
pagesTopIPs = zeros(size(topIPs,1) * pageNumber, 4);

for i=1:size(topIPs,1)
  pageTopIPs((pageNumber * (i-1) + 1):(pageNumber*i), 1) = topIPs(i,1);
  pageTopIPs((pageNumber * (i-1) + 1):(pageNumber*i), 2) = topIPs(i,2);
  for j = 1:pageNumber
    pageTopIPs(pageNumber * (i-1) + j, 3) = j;
    pageTopIPs(pageNumber * (i-1) + j, 4) = exp(uniqPages(uniqIP == topIPs(i,2),j))-1;
  end
end




% Requests by day / by hour for each class
n= size(topIPs, 1);
m =size(rawIPSum,1);
tmpData = zeros(m, 3 + n);
tmpData(:, 1) = rawTimedate(:,1);
tmpData(:, 2) = ceil((rawTimedate(:,1) - 1388534400)/(60*60*24));
tmpData(:, 3) = ceil((rawTimedate(:,1) - 1388534400 - tmpData(:, 2)*60*60*24)/(60*60));

for i = 1:m
  if sum(topIPs(:,2) == rawIPSum(i)) > 0
    tmpData(i,find(topIPs(:,2) == rawIPSum(i), 2) + 3) = 1;
  end
end

listDays = unique(tmpData(:, 2));
m0 = size(listDays,1);
dayTopIPs = zeros(m0, 1 + n + 1);

dayTopIPs(:,1) = listDays;

for i = 1:m0
  dayTopIPs(i,2:n+1) = sum(tmpData(tmpData(:,2) == listDays(i,1),4:n+3));
end
dayTopIPs(:,n+2) = sum(dayTopIPs(:,2:n+1),2);

listHours = unique(tmpData(:, 3));
m0 = size(listHours,1);
hourTopIPs = zeros(m0, 1 + n + 1);

hourTopIPs(:,1) = listHours;

for i = 1:m0
  hourTopIPs(i,2:n+1) = sum(tmpData(tmpData(:,3) == listHours(i,1),4:n+3));
end
hourTopIPs(:,n+2) = sum(hourTopIPs(:,2:n+1),2);

end