clear all;
close all;
clc;
% Adds translation of beta pixels to the corresponding dataset
% author Lisongtao 2021.3.11
load('PIE_pose27.mat');
    
faceW = 32;
faceH = 64;
numPerLine = 1;
ShowLine = 1;
beta = 2;   % 1 2 3 4
[mfea,nfea] = size(fea);
Nfea = [];

for p = 1:mfea
    
    Y = zeros(faceH*ShowLine,faceW*numPerLine);
    Y = reshape(fea(p,:),[faceH,faceW]);
    A = imresize(Y, (64-beta)/64,'bilinear');
    B = zeros(64);
   
    [rA,cA]=size(A);
    [rB,cB]=size(B);

    C=zeros(max(rA,rB),max(cA,cB));
    X = unidrnd(beta);

    C(1+X:rA+X,1+X:cA+X)=A;
    C(1:rB,1:cB)=C(1:rB,1:cB)+B;
    C(find(C==0)) = 0;

    C = reshape(C,1,rB*cB);

    Nfea(p,:)=C;
    
end

