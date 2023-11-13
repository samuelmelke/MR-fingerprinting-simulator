function [T1_map,T2_map,pd_map,df_map] = fast_matching(D,X,LUT,T1_phantom,T2_phantom,density,df_phantom)
% This function perfroms MRF pattern matching using inner product
% Inputs:
%		D: dictionary of expected signal evolutions  
%`		X: acquired images through Bloch simulation 
%		LUT: lookup table 
%       T1_phantom: ground truth T1 map
%       T2_phantom: ground truth T2 map
%       density: ground truth proton density map
%       df_phantom: ground truth off resonance map
%
% Outputs:
%		T1_map: resultant T1 map after pattern matching
%         T2_map: resultant T2 map after pattern matching
%         pd_map: resultant proton density map after pattern matching
%         df_map: resultant off resonance map after pattern matching
%
[M,N,L]=size(X);
D = transpose(D);
dict_norm = sqrt(sum(abs(D).^2,1));
D1 = D./( ones(size(D,1),1)*dict_norm );
%D1 = transpose(D1);
X = transpose(reshape(X,N*M,[]));
x_norm = sqrt(sum(abs(X).^2,1));
X1 = X./( ones(size(X,1),1)*x_norm );

match = zeros(1,N*M);
indx=match;
for I = 1:N
    I
    [match(1+(I-1)*M:I*M), indx(1+(I-1)*M:I*M)] = max(abs((ctranspose(D1) * X(:,1+(I-1)*M:I*M))), [], 1);
end
match = max(0, match);
image = D(:,indx(:));
% proton density (M0) of each pixel was calculated as the scaling factor between the
% measured signal and the simulated time course from the dictionary. 

image = image.*repmat(match,[size(image,1),1]);% scale up image
image = reshape(transpose(image), N, M, []);
ind = reshape(indx, N, M);
pd = reshape(match, N, M)./(dict_norm(ind));
T1 = LUT(ind(:),1); T1= reshape(T1, N, M);
T2 = LUT(ind(:),2); T2= reshape(T2, N, M);
if (size(LUT,2)==3)
 df = LUT(indx(:),3); df= reshape(df, N,M);
end
%% post processing
T1_map = T1.*(T1_phantom~=0); 
T2_map = T2.*(T2_phantom~=0);     
pd_map = pd.*(density~=0);
if (size(LUT,2)==3)
 df_map = df.*(df_phantom~=0);%
end
end
