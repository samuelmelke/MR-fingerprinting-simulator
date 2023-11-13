%   function [m] = rotation_z(mInput,beta)
%   This function rotates magnetization about z with the angle beta
%   Input:
%       m - magnetization( [mx my mz].' )
%       beta - rotation angle(rad)
%
%   Output:
%       mInput: magnetization components in the x,y and z after relaxation
%       
%   rbeta= [ cos(beta) sin(beta) 0.0; % rotation matrix
%                 -sin(beta) cos(beta) 0.0;
%                  0.0 0.0 1.0];      
%   mOutput=rbeta*mInput;        
% end
function [moutput] = rotation_z(minput,beta)
    N_b = numel(beta);
    minput = repelem(minput,3,1);
    rbeta = zeros(9,N_b);
    rbeta(1,:) = cos(beta(:));
    rbeta(2,:) = -sin(beta(:));
    rbeta(4,:) = sin(beta(:));
    rbeta(5,:) = cos(beta(:));
    rbeta(9,:) = 1;
    minput = rbeta .* minput;
    minput(1,:) = minput(1,:) + minput(4,:) + minput(7,:);
    minput(2,:) = minput(2,:) + minput(5,:) + minput(8,:);
    minput(3,:) = minput(3,:) + minput(6,:) + minput(9,:);
    moutput = minput(1:3,:);
end