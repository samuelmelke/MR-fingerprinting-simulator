function [density, T1_phantom, T2_phantom, df_phantom ] = custom_phantoms()
% Function generates customizable spherical phantoms

N = 128; % Matrix size
E = zeros(6,6); %input to matlab funtion phantom :generates a user-defined phantom
A = [1 2 3 4 5 6 ]; %the additive intensity value of the ellipse
E(:,1) = A;
a = [.2, .2, .2, .2, .2, .2]; %the length of the horizontal semi-axis of the ellipse 
E(:,2) = a;
b = [.2,.2,.2,.2,.2,.2]; %the length of the vertical semi-axis of the ellipse
E(:,3) = b;
X0 = [-.5, -.5, .0, .0, .5, .5]; %the x-coordinate of the center of the ellipse
E(:,4) = X0;
Y0 = [-.4, .4, -.4, .4, -.4, .4]; % the y-coordinate of the center of the ellipse
E(:,5) = Y0;
phi = [0 0 0 0 0 0];
% phi = [pi./2 ,pi./2,pi./2,pi./2,pi./2,pi./2]; %the angle (in degrees) between the horizontal semi-axis 
                                              %of the ellipse and the x-axis of the image    
E(:,6) = phi;
P = phantom(E,N); % generate segments of circular shape

%% Generate the phantoms based on the segments in P
 T1 = [0,2000,1545,811,530,1425,1425]; % T1 values of the seven regions
 T2 = [0, 512,83,77,77,41,41]; % T2 values of the seven regions
 pd = [0, 100,100,80,80,80,80]; % T3 values of the seven regions
 df = [0, -20, -40, -30, 50, 250, 250]; % T4 values of the seven regions

 density = zeros(N); %  
 T1_phantom = zeros(N);
 T2_phantom = zeros(N); 
 df_phantom = zeros(N);

 for i = 0:6    
     density = density+(P==i).*pd(i+1);  
     T1_phantom = T1_phantom+(P==i).*T1(i+1);          
     T2_phantom = T2_phantom+(P==i).*T2(i+1);
     df_phantom = df_phantom+(P==i).*df(i+1);
 end  
end
