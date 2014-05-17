function [tmpA, tmpB] = tmp(uniqA, uniqIdx, setIdx)
  
  if size(setIdx,1) > 1
    setIdx = setIdx';
  endif  
  
  m = size(unique(uniqIdx), 1);
  n = size(setIdx, 2);
  
  tmpA = zeros(m, n + 2);
  tmpB = zeros(m, n + 2);
  
  for i=1:m
    tmpA(i,1) = i;
    tmpA(i,2) = sum(uniqIdx == i);
    tmpB(i,1) = i;
    tmpB(i,2) = sum(uniqIdx == i);
    tmpA(i,3:end) = sum(uniqA(uniqIdx == i,setIdx)) / tmpA(i,2);
    tmpB(i,3:end) = sum(exp(uniqA(uniqIdx == i,setIdx)) - ones(sum(uniqIdx == i),n));
  end
  

end 