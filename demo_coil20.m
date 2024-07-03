clear
clc

addpath Data
% load and 
load COIL20.mat
X=fea';
C=20; 


[m,n] = size(X);
imgW = 32;
imgH = 32;
Angle_search = [0,40,80,120,160,200,240,280,320];    %0-360

noise = 0

noisetype = 1;
 
H = 1;
for Angle = Angle_search
    for i = 1:n 
        B = mat2gray(reshape(fea((i),:),[imgW,imgH]));
        
        if noisetype == 1  %Ω∑—Œ‘Î…˘
        B = imnoise(B,'salt & pepper',noise);
        end              
        B = imrotate(B,Angle);
        B = imresize(B,[imgW,imgH]);
        Fea_T(i,:) = reshape(B,[1,imgW*imgH]);
    end
    Fea_T = NormalizeFea(Fea_T); 
    Fea_C(:,:,H) = Fea_T;
    H = H+1;
end

sparseMatrices = {};
for j = 1:H-1
    %W(:,:,j) = full(constructW(Fea_C(:,:,j),options));
    [~, W(:,:,j), ~] = CAN(Fea_C(:,:,j)', C, 5);
    sparseMatrices(1,j) ={W(:,:,j)};
end

zeroCounts = zeros(size(cell2mat(sparseMatrices(1))));
for i = 1:numel(sparseMatrices)
    zeroCounts = zeroCounts + (sparseMatrices{i} == 0);
end

updatePositions = zeroCounts < numel(sparseMatrices) / 2;

combinedMatrix = zeros(size(cell2mat(sparseMatrices(1))));
for i = 1:numel(sparseMatrices)
    combinedMatrix(updatePositions) = max(combinedMatrix(updatePositions), sparseMatrices{i}(updatePositions));
end

combinedMatrix(~updatePositions) = 0;

Gamma_S=[100];
TTTT = [256];

for Gamma=Gamma_S
    for TTT=TTTT
        clear res
        clear j
        MaxIter = 100;
        k = C;
        d=size(X,1);
        n=size(X,2);
        U0=rand(d,k);
        V0=rand(k,n);
        
        for j=1:1
        
        [T2,U2,V2,Func2]=RNMFSMGF(Fea_C(:,:,1)',U0,V0,MaxIter,TTT,combinedMatrix,Gamma);
        
        accuracy2 = eval_clustering_accuracy(V2,gnd,C,50)  
        
        accuracy2 = cell2mat(struct2cell(accuracy2))';
        
        result2(j,:)=[accuracy2];

        end
    end
end