%   function [mOutput] = relax(mInput,t,T1r,T2r,density) 
%   This function applies relaxation on spins with magnetizatin components x,y 
%   and z.
%   Input:
%       mInput: initial magnetization( [mx my mz].' )
%       t: time 
%       T1r: T1 of the spins
%       T2r: T2 of the spins
%       density: proton density of the spins 
%
%   Output:
%       mOutput: magnetization components in the x,y and z after relaxation
%    
%   E1 = exp(-t./T1);	
%   E2 = exp(-t./T2);
%     
%  end   
function [moutput] = relax(minput,t,T1r,T2r,density)
    N_pixel = size(density,1); 
    E1 = exp(-t./T1r(:)');
    E2 = exp(-t./T2r(:)');
    moutput = [E2;E2;E1].* minput + repmat(1-E1,3,1).*[zeros(1,N_pixel*N_pixel); zeros(1,N_pixel*N_pixel); density(:)'];
end