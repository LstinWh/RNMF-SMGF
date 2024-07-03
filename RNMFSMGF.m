function [T, W, H, Func] = RNMFSMGF(V, W, H, MaxIter,Gamma,G,gama)
% fprintf('EWEucNMF\n')
        d=size(V,1);
        n=size(V,2);
if size(V) ~= size(W*H)
    fprintf('incorrect size of W or H\n')
end
[RowNum, ColNum] = size(V);
[ReduceDim, ~] = size(H);
D=diag(sum(G,2));

Func = zeros(MaxIter, 1);

for i = 1:MaxIter
    T = sum( (V - W * H).^2, 2 );
    T = exp( - T / Gamma );  
    T = T ./ sum(T);

    W = W .* ( V * H') ./ ( W * H * H' +eps);     
    TR = repmat(T, 1, ReduceDim);
    TW = TR .* W;
    H = H .* ( TW' * V + gama * H * G) ./ (TW' * (W * H) + gama * H * D + eps);  
    
    W=W./(repmat(sum(sqrt(sum(W.^2,2))),d,1));      
    H=H.*(repmat(sum(sqrt(sum(W.^2,2)))',1,n));
    
    Func(i) =  0.5*sum(T.*sum((V - W * H).^2, 2)) + Gamma * sum(sum(T.*log(T+eps)));
end
%     W = sum(sqrt(sum(W.^2,2)));
%     H = sum(sqrt(sum(H.^2,2)));
%     W = sqrt(sum(W.^2,2));
return;