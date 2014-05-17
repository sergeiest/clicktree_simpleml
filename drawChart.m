function indexToDraw = drawChart(drawA, drawIdx, A, uniqA, uniqIdx, addRandom, x, y, d, indexUsed)

K = size(unique(drawIdx),1);
drawA1 = drawA(:,x);
drawA2 = drawA(:,y);

if size(drawA,1) == size(A,1)
  if indexUsed == 0
    if d != 0
      indexUsed = (uniqIdx(:,1) == d);
    else
      indexUsed = (rand(size(uniqA,1),1) < 10000/size(uniqA,1));
    endif
    tmpA = uniqA(indexUsed,:);
    indexToDraw = zeros(size(A,1),1);
    for i = 1:sum(indexUsed,1)
      indexToDraw = indexToDraw + (A(:,2) == tmpA(i,1));
    end
  else 
    indexToDraw = indexUsed;
  endif
    
  if d > 0
    B = [drawA1((drawIdx(:,1) == d .* indexToDraw) == 1,1), drawA2((drawIdx(:,1) == d .* indexToDraw) == 1,1)];  
    idxB = drawIdx((drawIdx(:,1) == d .* indexToDraw) == 1,1);
  else 
    B = [drawA1(indexToDraw == 1,1), drawA2(indexToDraw == 1,1)] .+ addRandom * unifrnd(-0.1,0.1,sum(indexToDraw == 1 ,1),2);
    idxB = drawIdx(indexToDraw == 1,:);
  endif

else

  if size(uniqA,1) ~= size(indexUsed,1)
    indexUsed = rand(size(uniqA,1),1) < 1000/size(uniqA,1);   
  end

  if d > 0
    B = [drawA1((drawIdx(:,1) == d .* indexUsed) == 1 ,1), drawA2((drawIdx(:,1) == d .* indexUsed) == 1 ,1)];  
    idxB = drawIdx((drawIdx(:,1) == d .* indexUsed) == 1,1);
  else 
    B = [drawA1(indexUsed,1),drawA2(indexUsed,1)] .+ addRandom * unifrnd(-0.1,0.1,sum(indexUsed ,1),2);
    idxB = drawIdx(indexUsed,:);
  endif
  
  indexToDraw = indexUsed;

endif

plotDataPoints(B, idxB, K);

% plotDataPoints(log(B), idxB,1), K);

end