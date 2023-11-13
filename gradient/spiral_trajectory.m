function [k_space,gradient,t,s] = spiral_trajectory(ninterleaves,alpha)
% This function generates variable density spiral trajectory in k space
% Reference:
% Dong-hyun Kim et al, Simple Analytic Variable Density Spiral Design, 2003

FOV=30; 
res=FOV/256;f_sampling= 1/1.3;R=4;gm= 4;sm=17000;
gamma = 4285 ; % Hz/G 
lambda = .5/res; % in cm^(-1) 
n = 1/(1-(1-ninterleaves*R/FOV/lambda)^(1/alpha));
w = 2*pi*n;
Tea = lambda*w/gamma/gm/(alpha+1); % in s
Tes = sqrt(lambda*w^2/sm/gamma)/(alpha/2+1); % in s
Ts2a = (Tes^((alpha+1)/(alpha/2+1))*(alpha/2+1)/Tea/(alpha+1))^(1+2/alpha); % in s

if Ts2a<Tes
    tautrans = (Ts2a/Tes).^(1/(alpha/2+1));
    tau = @(t) (t/Tes).^(1/(alpha/2+1)).*(0<=t).*(t<=Ts2a)+((t-Ts2a)/Tea + tautrans^(alpha+1)).^(1/(alpha+1)).*(t>Ts2a).*(t<=Tea).*(Tes>=Ts2a);
    Tend = Tea;
else
    tau = @(t) (t/Tes).^(1/(alpha/2+1)).*(0<=t).*(t<=Tes);
    Tend = Tes;
end
k = @(t) lambda*tau(t).^alpha.*exp(1i*w*tau(t));
dt = Tea*1e-4; % in s
Dt = dt*f_sampling/FOV/abs(k(Tea)-k(Tea-dt)); % in s
t = 0:Dt:Tend; % in s
w = k(t); % 
plot(w)
%%
g = [0, (w(2:end)-w(1:end-1))/Dt/gamma];
s = [0, (g(2:end)-g(1:end-1))/Dt];
[k_space,gradient] = plotgradinfo(g.',Dt,0);