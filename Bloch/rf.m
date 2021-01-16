function [mout] = rf_x(min,rf,rph)

    rx= [ 1.0 0.0 0.0; %rotation matrix for pulse
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