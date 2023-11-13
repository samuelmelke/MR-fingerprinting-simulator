%  function [m] = rf_x(m,rf,rph)
%   This function applies rotation about x on a spin with magnetizatin x, y
%   and z componets.  
%   Input:
%       mIn: magnetization( [mx my mz].' )
%       rf: magnitude of rf pulse 
%       rph: phase of rf pulse
%   
%   Output:     
%       mOut: magnetization components in the x,y and z after rotation about x
% 
function [mout] = rf_x(min,rf,rph)

    rx= [ 1.0 0.0 0.0; 
          0.0 cos(rf) sin(rf);
          0.0 -sin(rf) cos(rf)];

    rdzp= [ cos(rph) sin(rph) 0.0; %RF phase
           -sin(rph) cos(rph) 0.0;
            0.0 0.0 1.0];

    rdzm= [ cos(-rph) sin(-rph) 0.0;
           -sin(-rph) cos(-rph) 0.0;
            0.0 0.0 1.0];

    mout = rdzp*rx*rdzm*min; % do RF pulse
end
