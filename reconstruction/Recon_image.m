% Function reconstructs images from samples 
% using Jeffrey Fessler's nufft toolbox 
% Inputs:
%		k - normalized kspace  
%`		N_pixel: number of pixel for reconstructed image 
%		data - sampled data 
%
% Outputs:
%		reconstructed images 

function [image]=Recon_image(all_k_values,all_samples,N_pixel,L)
image= zeros(N_pixel,N_pixel,L);
for i=1:L
kspace =all_k_values(i,1:1992); 
data=all_samples(1:1992,i);
Nufft_image  = Nufft_recon(kspace,data,N_pixel);
image(:,:,i) =Nufft_image;
end
end
