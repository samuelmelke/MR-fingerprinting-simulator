function [ density, T1_phantom, T2_phantom, df_phantom ] = Brain_phantoms()
% This function generates brain phantoms
% from CoverBLIP toolbox by Mohammad Golbabaee et al, 2017
% load in MNI segmented brain phantom
% MNI segmented brain phantom is segmented into:
%(0=Background, 1=CSF, 2=Grey Matter, 3=White Matter, 4=Fat, 5=Muscle/Skin, 6=Skin, 7=Skull, 8=Glial Matter, 9=Connective)

N = 256; % Matrix size 
[imaVol,scaninfo] = loadminc('phantom_1.0mm_normal_crisp.mnc'); % volume is  217   181   181
Slice = zeros(N);
Slice(21:237,37:217) = imaVol(:,:,90); 
Slice = Slice.*(Slice<6);  % remove skull Glial matter and connective
% Tissue table chosen to match chemicals from Basics of MRI webbook:
T1 = [0,5012,1545,811,530,1425,1425];
T2 = [0, 512,83,77,77,41,41];
pd = [0, 100,100,80,80,80,80];
df = [0, -20, -40, -30, 50, 250, 250];
 
density = zeros(N);
T1_phantom = zeros(N);
T2_phantom = zeros(N);
df_phantom = zeros(N);
for i = 0:6
  
     density = density+(Slice==i).*pd(i+1);  
     T1_phantom = T1_phantom+(Slice==i).*T1(i+1);          
     T2_phantom = T2_phantom+(Slice==i).*T2(i+1);
     df_phantom = df_phantom+(Slice==i).*df(i+1);
end
end

