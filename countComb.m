function newA = countComb(uniqA, sortIdx)

if size(sortIdx, 1) == 1
  sortIdx = sortIdx';
end
l = size(sortIdx,1);
countIdx = zeros(size(sortIdx));
newA = zeros(2^l, l + 1);

for i =0:(2^l - 1)
  for j = 1:l
    if floor(i/2^(j-1)) - floor(floor(i/2^(j-1))/2)*2 == 0
      countIdx(j) = 0;
    else
      countIdx(j) = 1;
    endif
  end
  newA(i+1,1:l) = countIdx; 
  tmpA = zeros(size(uniqA,1),1);
  for j = 1:l
    if j == 1
      tmpA = uniqA(:, sortIdx(j)) == countIdx(j);
    else
      tmpA = (tmpA & uniqA(:, sortIdx(j)) == countIdx(j));
    end
  end
  newA(i+1, l+1) = sum(tmpA);
end

end