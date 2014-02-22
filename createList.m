function [outData, outList] = createList(rawData)

m = size(rawData, 1);
outData = zeros(m,1);
outList = {};

for i = 1:m
  oneStr = rawData{i,1};
  if sum(strcmp (oneStr, outList)) == 0
    outList = [outList; oneStr];
  endif
  outData(i,1) = find(strcmp (oneStr, outList));
end

end