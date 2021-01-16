function[mOut] = rotateRelax(mInput,beta,t,T1r,T2r,density,N_pixel)
  if t < 0
      disp('Cant relax by negative time');
      return;
  else
    mR = rotation_z(mInput,beta);
    mOut = relax(mR,t,T1r,T2r,density,N_pixel);
  end         
end

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

   
function [moutput] = relax(minput,t,T1r,T2r,density,N_pixel)
    E1 = exp(-t./T1r(:)');
    E2 = exp(-t./T2r(:)');
    moutput = [E2;E2;E1].* minput + repmat(1-E1,3,1).*[zeros(1,N_pixel*N_pixel); zeros(1,N_pixel*N_pixel); density(:)'];
end
