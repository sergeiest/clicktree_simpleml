function [idxTotal, uniqIdxTotal] = assignIdx(uniqA, uniqATotal, ATotal, uniqIdx)

m = size(ATotal, 1);
m0 = size(uniqATotal, 1);


uniqIdxTotal = zeros(m0,1);
for i=1:m0
  k = (find(uniqA(:,1) == uniqATotal(i,1), 2));
  if k > 0
    uniqIdxTotal(i,1) = uniqIdx(k,1);
  else
    uniqIdxTotal(i,1) = 10;
  endif
end

idxTotal = zeros(m,1);
for i=1:m
  idxTotal(i,1) = (uniqIdxTotal(uniqATotal(:,1) == ATotal(i,2), 1));
end

end