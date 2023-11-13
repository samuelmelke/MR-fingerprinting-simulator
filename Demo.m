clc;clear;close all;clear path
addpath(genpath(pwd));

%% Set parametrs
RFpulses = generate_RF;
L = 1000; % number of repetitions for MRF series
TR = generate_TR(L);

%% Generate gradients,rewind and rotate 
[k_space,g,time] = spiral_trajectory(3,5); % interleaved spiral trajectory
[kr,gr] = rewinder(k_space,g,time,time(end)-time(end-1)); % nullifying the 0th moment of the gradients 
[all_gradient_values, all_k_values] = generate_all_trajectories(gr,kr);%rotate the spiral 

%% genarate phantom
% phantomString = 'custom';
phantomString = 'brain';
switch (phantomString)
case 'brain'
[density, T1_phantom, T2_phantom, df_phantom ] = Brain_phantoms;
case 'custom'
[density, T1_phantom, T2_phantom, df_phantom ] = custom_phantoms;
end

%% Data acquisition 
% data undersampling using Bloch simulations via the application of gradients  
[all_samples ] = MRF_sampling( T1_phantom,T2_phantom,density,df_phantom,time,all_gradient_values,RFpulses,TR,L); 

%% Reconstruct the acquired data
[images]=Recon_image(all_k_values,all_samples,128,L);

%% Generate dictionary using bloch simulation 
disp('generating dictionary...');
[dict, dict_norm, lut] = dict_true(RFpulses, TR);%build the MRF_dictionary and its matching look up table
dict = single(dict);

%% Pattern matching using inner product
[T1_map,T2_map,pd_map,df_map]=fast_matching(dict,images,lut,T1_phantom,T2_phantom,density,df_phantom );

%% Plotting the resultant maps
figure
subplot(2,4,1);imagesc(T1_map,[0 5000]),title('T1 Map');drawnow;colorbar;
subplot(2,4,2);imagesc(T2_map,[0 400]),title('T2 Map');drawnow;colorbar;
if (size(lut,2)==3)
subplot(2,4,4);imagesc(df_map,[-0.05 0.05]),title('Off Resonance Map');drawnow;colorbar;
end
subplot(2,4,3);imagesc(pd_map,[0 100]),title('PD Map');drawnow;colorbar;
subplot(2,4,5);imagesc(T1_phantom,[0 5000]),title('T1 Phantom');drawnow;colorbar;
subplot(2,4,6);imagesc(T2_phantom,[0 400]),title('T2 Phantom');drawnow;colorbar;
subplot(2,4,7);imagesc(density,[0 100]),title('Proton Density');drawnow;colorbar;
if (size(lut,2)==3)
    subplot(2,4,8);imagesc(df_phantom,[-0.05 0.05]),title('Off Resonance Phantom');drawnow;colorbar;
end






