% First working version, works with SpikeDet1 from LPDSP
% Spike waveform vector sent on 64 samples buffer, but the last 4 samples are for parameters
% In this case, last location (64) is used to transmit an absolute threshold value

% The return waveform from LPDSP is a 60 samples rectangle indicating where values are bigger than threshold
% Sample 61 has the index of the threshold crossing
% Sample 62 has the mean value of the spike waveform



pkg load instrument-control
pkg load control

if (exist("serial") != 3)
    disp("No Serial Support");
endif 



%srl_close(s1)

SpikeThr = int32(567);
ThrshldMult = int32(4) ;
SpikeStep = int32(30) ;

% Instantiate the Serial Port
% Set the COM port # to match your device

s1 = serial("\\\\.\\COM5") ;  % Open the port
pause(1);                    % Optional wait for device to wake up 


% Set the port parameters
set(s1, 'baudrate', 9600);     % See List Below
set(s1, 'bytesize', 8);        % 5, 6, 7 or 8
set(s1, 'parity', 'n');        % 'n' or 'y'
set(s1, 'stopbits', 1);        % 1 or 2
set(s1, 'timeout', 123);     % 12.3 Seconds as an example here



% Optional commands, these can be 'on' or 'off'
%set(s1, 'requesttosend', 'on');      % Sets the RTS line to on
%set(s1, 'dataterminalready', 'off'); % Sets the DTR line to off



% Optional Flush input and output buffers
% srl_flush(s1);


% Neuronal parameters
m_init = 0.66 ;        % Smaller value makes the Spike more narrow
h_init = 0.14 ;       % Smaller value makes the Spike more narrow too
n_init = 0.25 ;


No_APs = 3 ; % number of Action Potentials (Spikes)
Tspan = 3.4 ;

V_APs = int32(3*240 + 9.*NeuronAP_2( No_APs, Tspan, m_init, h_init, n_init )) ;

%V_APs = int32(3*240 + 9.*NeuronAP_2( 3, 8, 0.7, 0.14, 0.25 )) ;

%length(V_APs);

V_APs = V_APs(1:256);

%figure(1);
%plot(V_APs);



%tmp1 = int32([1:SpikeStep:SpikeStep.*32]) ;
%tmp2 = int32([SpikeStep.*32: -SpikeStep: 1]) ;
%tmp = [tmp1 tmp2];




%tmp = V_APs(1:4:256);

tmp1024 = int32(zeros(1,1024));
%tmp1024(1:64) = tmp(1:64);
tmp1024(1:64) = V_APs(1:4:256);


% Neuronal parameters
m_init = 0.46 ;        % Smaller value makes the Spike more narrow
h_init = 0.14 ;       % Smaller value makes the Spike more narrow too
n_init = 0.25 ;


V_APs = int32(3*240 + 9.*NeuronAP_2( No_APs, Tspan, m_init, h_init, n_init )) ;
V_APs = V_APs(1:256);
tmp1024(101:164) = V_APs(1:4:256);





% Neuronal parameters
m_init = 0.36 ;        % Smaller value makes the Spike more narrow
h_init = 0.24 ;       % Smaller value makes the Spike more narrow too
n_init = 0.25 ;


V_APs = int32(3*240 + 9.*NeuronAP_2( No_APs, Tspan, m_init, h_init, n_init )) ;
V_APs = V_APs(1:256);
tmp1024(201:264) = V_APs(1:4:256);







% Neuronal parameters
m_init = 0.34 ;        % Smaller value makes the Spike more narrow
h_init = 0.64 ;       % Smaller value makes the Spike more narrow too
n_init = 0.15 ;


V_APs = int32(2*240 + 9.*NeuronAP_2( No_APs, Tspan, m_init, h_init, n_init )) ;
V_APs = V_APs(1:256);
tmp1024(401:464) = V_APs(1:4:256);






% Neuronal parameters
m_init = 0.32 ;        % Smaller value makes the Spike more narrow
h_init = 0.14 ;       % Smaller value makes the Spike more narrow too
n_init = 0.15 ;


V_APs = int32(3*240 + 11.*NeuronAP_2( No_APs, Tspan, m_init, h_init, n_init )) ;
V_APs = V_APs(1:256);
tmp1024(501:564) = V_APs(1:4:256);








load RealSpike2.mat
tmp1024(1:1000)=10*RealSpike2;



tmp1024(1023) = ThrshldMult ;    % This will provide the desired threshold to the LPDSP
tmp1024(1024) = SpikeThr ;    % This will provide the desired threshold to the LPDSP







figure(1);
plot(tmp1024)



Mean_value = floor(sum(tmp1024(1:1000))/1000)
dev_vect = abs(tmp1024(1:1000)-Mean_value) ;
%Std_dev_abs = floor(sum(abs(tmp(1:1000)-Mean_value))/1000);
Std_dev_abs = floor(sum(dev_vect)/1000)
Std_dev_sqr = floor(sqrt(sum(dev_vect.*dev_vect)/1000))





 
tmp_uart = typecast(tmp1024, "uint8") ;


srl_write(s1, tmp_uart);

pause(2); 
ret_uart = srl_read(s1,4*1024);

retn_uart = typecast(ret_uart, "int32");

%retn_uart = (SpikeThr*retn_uart/11);

length(retn_uart);

%retn_uart = SpikeThr*int32(ret_uart(1:4:end));

Idx1_cross_DSP = retn_uart(1001)
Idx2_cross_DSP = retn_uart(1002)
Idx3_cross_DSP = retn_uart(1003)
Idx4_cross_DSP = retn_uart(1004)
Idx5_cross_DSP = retn_uart(1005)
Idx6_cross_DSP = retn_uart(1006)
Idx7_cross_DSP = retn_uart(1007)
Idx8_cross_DSP = retn_uart(1008)
Idx9_cross_DSP = retn_uart(1009)
Idx10_cross_DSP = retn_uart(1010)


Mean_value_DSP = retn_uart(1011)
Std_dev_abs_DSP = retn_uart(1012)
Std_dev_sqr_DSP = retn_uart(1013)
IntThreshold = retn_uart(1014)


retn_uart(1001:1024) = 0 ;

tmp1024(1001:1024) = tmp1024(1000) ;

x_vect = 1:1:1024;

figure(2)
plot(x_vect, tmp1024-Mean_value, x_vect, retn_uart);
%plot(x_vect, V_APs(1:4:end), x_vect,retn_uart);

tmp1024_noDC=tmp1024-Mean_value_DSP;
figure(5);
plot(tmp1024_noDC);


% Optional Flush input and output buffers
srl_flush(s1, [2]);

srl_close(s1);
