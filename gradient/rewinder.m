function [k,g] = rewinder(k_space,gradient,time,T)
%% This function nullifies the 0th moment of a spiral trajectory
%   Input:
%       k_space: k space trajectory
%       gradient: gradient values
%       time: time for each value
%        T: sampling time
%   
%   Output:    
%       k: k space trajectory after rewinding
%       g: gradients after rewinding
%  Reference        
% Krishna S. Nayak et al, 'Spiral Balanced Steady-State Free Precession Cardiac
% Imaging' 2005 

g = gradient(:,1) + 1j.*gradient(:,2); 
s = 17000*(1./sqrt(2));% slew rate G/cm/s
theta = atan(-imag(g(end))./real(g(end))); % rotation angle
gRot = g*exp(1i*theta);
gx = (-real(gRot));
gy = (-imag(gRot));
 %%
gx0 = gx(end); 
mox = trapz(time,gx); % x 0th monent
moy = trapz(time,gy); % y 0th moment
tx1 = (gx0./s);  
tx2 = sqrt(((tx1.^2)./2)+(mox./s));
ty1 = sqrt(-(moy)./s);
 
%% rewinding gx 
m1 = ceil((tx1)./T);
m2 = ceil(tx2./T);
m22 = 2*m2;
gxr1 = zeros(1,m1);
gxr2 = zeros(1,m22);
gxr1(1) = gx0 -((s.*T))./.904;
for i = 2:m1
    gxr1(i) = gxr1(i-1) - s.*T;
end
gxr2(1) = gxr1(end);
for i = 2:m2
    gxr2(i) = gxr2(i-1) - s.*T;
end
gxr2(m2+1) = gxr2(m2);
for j = m2+2:m22 
    gxr2(j) = gxr2(j-1) + s.*T;
end
gxr = [gxr1 gxr2];
gxrr = [gx.' gxr];
gxrr(1)=0;
gxrr(end) = 0;
%% rewind y
n = ceil(ty1./T);
ny = 2*n;
gyr = zeros(1,ny-1);
gyr(1) = (s.*T)./1.06; 
for i = 2:n   
    gyr(i) = gyr(i-1) + s.*T;
end
for j = n+1:ny-2  
    gyr(j) = gyr(j-1) - s.*T;
end
gyrr = [gy.' gyr];
gyrr(1)=0;
gyrr(end) = 0;
%%
if numel(gyrr)> numel(gxrr)
   d = numel(gyrr) - numel(gxrr);
   gxrr = [gxrr zeros(1,d)]; 
else
    d = numel(gxrr) - numel(gyrr);
    gyrr = [gyrr zeros(1,d)];
end
    
gnew = [gxrr;gyrr].';
[kr,gr] = plotgradinfo(gnew,T,0);
g = gr(:,1)+1i*gr(:,2);
k = kr(:,1)+1i*kr(:,2);
