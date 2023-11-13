function [ Nufft_image ] = Nufft_recon(kspace,data,N_pixel)
% addpath './NUFFT';
% addpath './NUFFT/nufft/table';

kspace = kspace / (max(abs(kspace)) * 5);%Normalization 
wi = col(l2_norm(kspace,1)); % density compensation
wi(squeeze(max(abs(kspace(:,1,:)), abs(kspace(:,2,:)))) > pi) = 0;
% k_x=real(kspace);
% k_y=imag(kspace);
% gx = real(g(:));
% gy =  imag(g(:));
% gnew = gx + 1i .* gy;
% knew = k_x + 1i .* k_y;
% wi = vecdcf(gnew,knew);
phase = 1;
imSize = [N_pixel,N_pixel];
shift = [0,0];
FT = NUFFT(kspace,wi,phase,shift,imSize,2);
im = FT'*data;
Nufft_image=transpose(im);

% 		figure, imshow(abs(Nufft_image),[]);

end

