function [all_samples ] = MRF_sampling( T1_phantom,T2_phantom,density,df_phantom,time,g,RFpulses,TR,L)
% This function performs sampling using Bloch simulation

rf=abs(RFpulses);
rph=angle(RFpulses);
dt= time(end)-time(end-1);
s = numel(g(1,:));
%s = numel(all_gradient_values(1,:));
all_samples = zeros(s,L);% all samples for all repetitions
N_pixel = length(density);
M = zeros(N_pixel,N_pixel,3);
M(:,:,3) =  -density; % all the magnetization in the z(longitudnal) direction
M = (reshape(M,N_pixel*N_pixel,3)).'; 

for i=1:L
    i
    [M , all_samples(:,i)]= Bloc_Main(M,g(i,:),rf(i),rph(i),dt,T1_phantom,T2_phantom,density,df_phantom);
    rem_time = TR(i)- dt*s;
    beta = df_phantom.* rem_time*2*pi;
    M = rotation_z(M,beta);
    M =  relax(M,rem_time,T1_phantom,T2_phantom,density); %

end
end

