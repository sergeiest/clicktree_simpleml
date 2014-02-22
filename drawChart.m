% d - cluster
% x - index for Axis x
% y - index for Axis y
% addRandom - add random numbers
% drawA - A or uniqA
% drawIdx - A or uniqA

if size(drawA) == size (A)

  if size(uniqA,1) ~= size(indexUsed,1)
    indexUsed = (rand(size(uniqA,1),1) < 100000/size(uniqA,1));
    indexToDraw = zeros(size(A,1),1);
    for i = 1:size(uniqA(indexUsed,1),1)
      indexToDraw = (indexToDraw + (A(:,2) == uniqA(indexUsed,1)(i,1)));
    end  
  endif

  if d > 0
    B = drawA((drawIdx(:,1) == d .* indexToDraw) == 1,[x,y]);  
    idxB = drawIdx((drawIdx(:,1) == d .* indexToDraw) == 1,1);
  else 
    B = drawA(indexToDraw == 1,[x,y]) .+ addRandom * unifrnd(-0.1,0.1,sum(indexToDraw == 1 ,1),2);
    idxB = drawIdx(indexToDraw == 1,:);
  endif

else

  if size(uniqA,1) ~= size(indexUsed,1)
    indexUsed = rand(size(uniqA,1),1) < 100000/size(uniqA,1);   
  end

  if d > 0
    B = drawA((drawIdx(:,1) == d .* indexUsed) == 1 ,[x,y]);  
    idxB = drawIdx((drawIdx(:,1) == d .* indexUsed) == 1,1);
  else 
    B = drawA(indexUsed,[x,y]) .+ addRandom * unifrnd(-0.1,0.1,sum(indexUsed ,1),2);
    idxB = drawIdx(indexUsed,:);
  endif

endif

plotDataPoints(B, idxB, K);

% plotDataPoints(log(B), idxB,1), K);