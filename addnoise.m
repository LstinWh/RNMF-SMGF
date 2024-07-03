clear
clc

B = rgb2gray(imread('SYALE.png'));
[j , k] = size(B);
%noise = 0.3;
%B = imnoise(B,'salt & pepper',noise);


%blockSize = 64; % 替换为所需的块大小2*2 4*4 6*6 平移噪声
%[rows, cols] = size(B);
%randRow = randi(rows - blockSize + 1);
%randCol = randi(cols - blockSize + 1);
%B(randRow:randRow+blockSize-1, randCol:randCol+blockSize-1) = 0;   

beta = 40; 
A = imresize(B, (k-beta)/k,'bilinear');

Q = zeros(j,k);
   
[rA,cA]=size(A);
[rB,cB]=size(Q);

 C=zeros(max(rA,rB),max(cA,cB));
 X = unidrnd(beta);

 C(1+X:rA+X,1+X:cA+X)=A;
 C(1:rB,1:cB)=C(1:rB,1:cB)+Q;
 C(find(C==0)) = 0;
 C = uint8(C);
 %C = reshape(C,1,rB*cB);


imshow(C);