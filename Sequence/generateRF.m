%% RF generator 
function RFpulses = generate_RF

RFpulses = zeros(1000,1);
t1 = 1:250;
RFpulses(1:250) = 10 + sin(((2*pi)./500).*t1).*50 + 5.*rand(1,250);
RFpulses(301:550) = RFpulses(1:250)./2;
RFpulses(601:850) = 10 + sin(((2*pi)./500)*t1)*50 + 5.*rand(1,250);
RFpulses(901:end) = RFpulses(601:700)./2;

RFpulses = RFpulses*(pi/180);
n = 1:1000;
RFpulses = ((-1).^n ).* RFpulses.';
end


