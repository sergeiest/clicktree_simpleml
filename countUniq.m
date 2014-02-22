function C = countUniq(X, idx)

t = unique(X(:,idx));
m = size(t,1);
if m > 250
  m = 250
endif
C = zeros(m,2);
C(:,1) = t(1:m,:) ;

for i=1:m
  C(i,2) = sum(X(:,idx) == C(i,1));
end


end