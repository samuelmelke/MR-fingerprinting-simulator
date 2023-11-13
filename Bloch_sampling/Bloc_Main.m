function [Mout, samples] = Bloc_Main(Min,g,rf,rph,dt,T1,T2,pd,df)
gamma = 4285 .*2 .* pi; % Hz/G 
gx = real(g);
gy = imag(g); 
dx = 0.01;
dy = 0.01;
s = numel(gx);
samples = zeros(s,1); % number of k space samples
N_pixel = size(pd,1);
xi = (-N_pixel/2+0.5 : (N_pixel/2)-0.5).*dx; % spatial locations in the image plane
%% Apply RF pulse                          
M = rf_x(Min,rf,rph); % rf pulse about x    
%% Rotate, relax and sample
for u = 1 : s    
    [X,Y]= meshgrid(gx(u).* xi,gy(u).* xi);
    beta_grad = gamma .* dt .* ( X + Y); % rotation angles due to applied gradients
    beta_Bo = df.*dt*2*pi; % rotation angles due to off resonance 
    beta = beta_grad + beta_Bo; % total rotation angles
    M = rotation_z(M,beta);
    M =  relax(M,dt,T1,T2,pd); %relax
    samples(u) = dx.*dy .* (sum( M(1,:) + 1j .* M(2,:)));
    Mout = M;
end
end