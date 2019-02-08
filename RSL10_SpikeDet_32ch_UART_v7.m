% Xxxxxxx 



pkg load instrument-control
pkg load control

if (exist("serial") != 3)
    disp("No Serial Support");
endif 



%srl_close(s1)




UseRealSpikes = 1 ;     % Use real spikes from lab or simulated ones
ThrshldMultFct = int16(4) ;      % multiplication factor for the internally detected threshold
ret_uart = [];
retn_uart = [];
No_of_chunks_sent = 25 ;


% Optional commands, these can be 'on' or 'off'
%set(s1, 'requesttosend', 'on');      % Sets the RTS line to on
%set(s1, 'dataterminalready', 'off'); % Sets the DTR line to off



% Optional Flush input and output buffers
% srl_flush(s1);



% Each channel has 4096 samples in this example (about 0.125sec at 32kHz)
% Data will be sent to RSL10 in 32 chunks



chunks_vct = int16(zeros(1,4096*32));     % vector for chunks (32 interleaved channels)

channels_ON = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32];          % temp vector of 16 locations indicating channels with real samples
channels_gain = [10 10 10 10 10 10 10 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
channels_gain = [50 0 0 50 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];


load RSpikes_1.mat
load RSpikes_2.mat
load RSpikes_3.mat
load RSpikes_4.mat
load RSpikes_5.mat
load RSpikes_6.mat
load RSpikes_7.mat
load RSpikes_8.mat





Spike1 = int16(channels_gain(1)*RSpikes_1);
Spike2 = int16(channels_gain(2)*RSpikes_2);
Spike3 = int16(channels_gain(3)*RSpikes_3);
Spike4 = int16(channels_gain(4)*RSpikes_5);
Spike5 = int16(channels_gain(5)*RSpikes_5);
Spike6 = int16(channels_gain(6)*RSpikes_6);
Spike7 = int16(channels_gain(7)*RSpikes_7);
Spike8 = int16(channels_gain(8)*RSpikes_8);

Spike9 = int16(channels_gain(9)*RSpikes_1);
Spike10 = int16(channels_gain(10)*RSpikes_2);
Spike11 = int16(channels_gain(11)*RSpikes_3);
Spike12 = int16(channels_gain(12)*RSpikes_4);
Spike13 = int16(channels_gain(13)*RSpikes_5);
Spike14 = int16(channels_gain(14)*RSpikes_6);
Spike15 = int16(channels_gain(15)*RSpikes_7);
Spike16 = int16(channels_gain(16)*RSpikes_8);

Spike17 = int16(channels_gain(17)*RSpikes_1);
Spike18 = int16(channels_gain(18)*RSpikes_2);
Spike19 = int16(channels_gain(19)*RSpikes_3);
Spike20 = int16(channels_gain(20)*RSpikes_5);
Spike21 = int16(channels_gain(21)*RSpikes_5);
Spike22 = int16(channels_gain(22)*RSpikes_6);
Spike23 = int16(channels_gain(23)*RSpikes_7);
Spike24 = int16(channels_gain(24)*RSpikes_8);

Spike25 = int16(channels_gain(25)*RSpikes_1);
Spike26 = int16(channels_gain(26)*RSpikes_2);
Spike27 = int16(channels_gain(27)*RSpikes_3);
Spike28 = int16(channels_gain(28)*RSpikes_4);
Spike29 = int16(channels_gain(29)*RSpikes_5);
Spike30 = int16(channels_gain(30)*RSpikes_6);
Spike31 = int16(channels_gain(31)*RSpikes_7);
Spike32 = int16(channels_gain(32)*RSpikes_8);




chunks_vct(channels_ON(1):32:end)=Spike1;
chunks_vct(channels_ON(2):32:end)=Spike2;
chunks_vct(channels_ON(3):32:end)=Spike3;
chunks_vct(channels_ON(4):32:end)=Spike4;
chunks_vct(channels_ON(5):32:end)=Spike5;
chunks_vct(channels_ON(6):32:end)=Spike6;
chunks_vct(channels_ON(7):32:end)=Spike7;
chunks_vct(channels_ON(8):32:end)=Spike8;

chunks_vct(channels_ON(9):32:end)=Spike9;
chunks_vct(channels_ON(10):32:end)=Spike10;
chunks_vct(channels_ON(11):32:end)=Spike11;
chunks_vct(channels_ON(12):32:end)=Spike12;
chunks_vct(channels_ON(13):32:end)=Spike13;
chunks_vct(channels_ON(14):32:end)=Spike14;
chunks_vct(channels_ON(15):32:end)=Spike15;
chunks_vct(channels_ON(16):32:end)=Spike16;


chunks_vct(channels_ON(17):32:end)=Spike17;
chunks_vct(channels_ON(18):32:end)=Spike18;
chunks_vct(channels_ON(19):32:end)=Spike19;
chunks_vct(channels_ON(20):32:end)=Spike20;
chunks_vct(channels_ON(21):32:end)=Spike21;
chunks_vct(channels_ON(22):32:end)=Spike22;
chunks_vct(channels_ON(23):32:end)=Spike23;
chunks_vct(channels_ON(24):32:end)=Spike24;

chunks_vct(channels_ON(25):32:end)=Spike25;
chunks_vct(channels_ON(26):32:end)=Spike26;
chunks_vct(channels_ON(27):32:end)=Spike27;
chunks_vct(channels_ON(28):32:end)=Spike28;
chunks_vct(channels_ON(29):32:end)=Spike29;
chunks_vct(channels_ON(30):32:end)=Spike30;
chunks_vct(channels_ON(31):32:end)=Spike31;
chunks_vct(channels_ON(32):32:end)=Spike32;



% Predetection of Spikes  

for i = 1:32
  
  Mean_value(i) = round(sum(chunks_vct(i:32:end))/4096);
  
  dev_vect = abs(chunks_vct(i:32:end)-Mean_value(i)) ;
  Std_dev_abs(i) = round(sum(dev_vect)/4096);
  Std_dev_sqr(i) = round(sqrt(sum(dev_vect.*dev_vect)/4096));
  STDsignal(i) = std(chunks_vct(i:32:end));
  IntThreshold(i) = ThrshldMultFct*Std_dev_abs(i);  
  
endfor


% Detect Spikes above threshold (to be replaced with for loop later)
SpikeDet1 = IntThreshold(1)*((chunks_vct(1:32 :end)-Mean_value(1)) > IntThreshold(1)) ;
SpikeDet2 = IntThreshold(2)*((chunks_vct(2:32 :end)-Mean_value(2)) > IntThreshold(2)) ;  
SpikeDet3 = IntThreshold(3)*((chunks_vct(3:32 :end)-Mean_value(3)) > IntThreshold(3)) ;  
SpikeDet4 = IntThreshold(4)*((chunks_vct(4:32 :end)-Mean_value(4)) > IntThreshold(4)) ;  
SpikeDet5 = IntThreshold(5)*((chunks_vct(5:32 :end)-Mean_value(5)) > IntThreshold(5)) ;  
SpikeDet6 = IntThreshold(6)*((chunks_vct(6:32 :end)-Mean_value(6)) > IntThreshold(6)) ;  
SpikeDet7 = IntThreshold(7)*((chunks_vct(7:32 :end)-Mean_value(7)) > IntThreshold(7)) ;  
SpikeDet8 = IntThreshold(8)*((chunks_vct(8:32 :end)-Mean_value(8)) > IntThreshold(8)) ;  
SpikeDet9 = IntThreshold(9)*((chunks_vct(9:32 :end)-Mean_value(9)) > IntThreshold(9)) ;
SpikeDet10 = IntThreshold(10)*((chunks_vct(10:32 :end)-Mean_value(10)) > IntThreshold(10)) ;  
SpikeDet11 = IntThreshold(11)*((chunks_vct(11:32 :end)-Mean_value(11)) > IntThreshold(11)) ;  
SpikeDet12 = IntThreshold(12)*((chunks_vct(12:32 :end)-Mean_value(12)) > IntThreshold(12)) ;  
SpikeDet13 = IntThreshold(13)*((chunks_vct(13:32 :end)-Mean_value(13)) > IntThreshold(13)) ;  
SpikeDet14 = IntThreshold(14)*((chunks_vct(14:32 :end)-Mean_value(14)) > IntThreshold(14)) ;  
SpikeDet15 = IntThreshold(15)*((chunks_vct(15:32 :end)-Mean_value(15)) > IntThreshold(15)) ;  
SpikeDet16 = IntThreshold(16)*((chunks_vct(16:32 :end)-Mean_value(16)) > IntThreshold(16)) ;  

SpikeDet17 = IntThreshold(17)*((chunks_vct(17:32 :end)-Mean_value(17)) > IntThreshold(17)) ;
SpikeDet18 = IntThreshold(18)*((chunks_vct(18:32 :end)-Mean_value(18)) > IntThreshold(18)) ;  
SpikeDet19 = IntThreshold(19)*((chunks_vct(19:32 :end)-Mean_value(19)) > IntThreshold(19)) ;  
SpikeDet20 = IntThreshold(20)*((chunks_vct(20:32 :end)-Mean_value(20)) > IntThreshold(20)) ;  
SpikeDet21 = IntThreshold(21)*((chunks_vct(21:32 :end)-Mean_value(21)) > IntThreshold(21)) ;  
SpikeDet22 = IntThreshold(22)*((chunks_vct(22:32 :end)-Mean_value(22)) > IntThreshold(22)) ;  
SpikeDet23 = IntThreshold(23)*((chunks_vct(23:32 :end)-Mean_value(23)) > IntThreshold(23)) ;  
SpikeDet24 = IntThreshold(24)*((chunks_vct(24:32 :end)-Mean_value(24)) > IntThreshold(24)) ;  
SpikeDet25 = IntThreshold(25)*((chunks_vct(25:32 :end)-Mean_value(25)) > IntThreshold(25)) ;
SpikeDet26 = IntThreshold(26)*((chunks_vct(26:32 :end)-Mean_value(26)) > IntThreshold(26)) ;  
SpikeDet27 = IntThreshold(27)*((chunks_vct(27:32 :end)-Mean_value(27)) > IntThreshold(27)) ;  
SpikeDet28 = IntThreshold(28)*((chunks_vct(28:32 :end)-Mean_value(28)) > IntThreshold(28)) ;  
SpikeDet29 = IntThreshold(29)*((chunks_vct(29:32 :end)-Mean_value(29)) > IntThreshold(29)) ;  
SpikeDet30 = IntThreshold(30)*((chunks_vct(30:32 :end)-Mean_value(30)) > IntThreshold(30)) ;  
SpikeDet31 = IntThreshold(31)*((chunks_vct(31:32 :end)-Mean_value(31)) > IntThreshold(31)) ;  
SpikeDet32 = IntThreshold(32)*((chunks_vct(32:32 :end)-Mean_value(32)) > IntThreshold(32)) ; 

x_vect = 1:1:4096;


figure(11);
plot(x_vect, Spike1-Mean_value(1), x_vect, SpikeDet1);

figure(12);
plot(x_vect, Spike2-Mean_value(2), x_vect, SpikeDet2);

figure(13);
plot(x_vect, Spike3-Mean_value(3), x_vect, SpikeDet3);

figure(14);
plot(x_vect, Spike4-Mean_value(4), x_vect, SpikeDet4);

figure(15);
plot(x_vect, Spike5-Mean_value(5), x_vect, SpikeDet5);

figure(16);
plot(x_vect, Spike6-Mean_value(6), x_vect, SpikeDet6);

figure(17);
plot(x_vect, Spike7-Mean_value(7), x_vect, SpikeDet7);

figure(18);
plot(x_vect, Spike8-Mean_value(8), x_vect, SpikeDet8);



% Instantiate the Serial Port, Set the COM port # to match your device

s1 = serial("\\\\.\\COM5") ;  % Open the port
%pause(1);                    % Optional wait for device to wake up 



%set(s1, 'baudrate', 12*9600);     % See List Below
set(s1, 'baudrate', 1000000);     % See List Below
set(s1, 'bytesize', 8);        % 5, 6, 7 or 8
set(s1, 'parity', 'n');        % 'n' or 'y'
set(s1, 'stopbits', 1);        % 1 or 2
set(s1, 'timeout', 10);     % 12.3 Seconds as an example here





% Send 32 chunks of data through UART

saved_uart = [] ;



Mean_value = int16(zeros(1,32));

idx_det_spikes = 0;         % index for detected spikes
idx_det_spike_mtlb = 0 ;    % index of detected spikes in Matlab


IntThresholdHist = [] ;
IntThresholdHist1 = [] ;
IntThresholdHist2 = [] ;
IntThreshold1 = zeros(1, 32) ;
IntThreshold2 = zeros(1, 32) ;





for idx_chunks = 1:No_of_chunks_sent
 
tmp4096 =  chunks_vct(1+4096*(idx_chunks-1):4096*(idx_chunks));


      % Octave computations for the first 16 channels
      for i = 1:16
        
        chunk_channel_vct = tmp4096(i:32:end) ;
        Mean_value(i) = round( ((sum(tmp4096(i:32:end))/128) + Mean_value(i))/2);
        
        dev_vect = abs(tmp4096(i:32:end)-Mean_value(i)) ;
        Std_dev_abs(i) = round(sum(dev_vect)/128);
        %Std_dev_sqr(i) = round(sqrt(sum(dev_vect.*dev_vect)/4096));
        STDsignal(i) = std(chunks_vct(i:32:end));
        IntThreshold(i) = round( (ThrshldMultFct*Std_dev_abs(i) + IntThreshold(i))/2);  
        % detection of spikes in the current chunk
        SpikeDet128 = IntThreshold(i)*((chunk_channel_vct-Mean_value(i)) > IntThreshold(i)) ;
        % display the detected spike if it is found
        
        
        #{
        if ( sum(SpikeDet128) > 5 )    % a spike with width of at least 5 samples
          idx_det_spike_mtlb = idx_det_spike_mtlb + 1 ;
          x_vect = 1:1:128;
          figure(200+idx_det_spike_mtlb);
          plot(x_vect, (chunk_channel_vct - Mean_value(i)), x_vect, SpikeDet128);
        endif
        #}
        
      endfor


IntThresholdHist1(idx_chunks) = IntThreshold(1);
IntThresholdHist2(idx_chunks) = IntThreshold(2);


 
chunk_vct_uart = typecast(tmp4096, "uint8"); 

length(chunk_vct_uart);
%pause(1);

srl_write(s1, chunk_vct_uart);
 
pause(0.5);       % place a pause here of at least 2 or 3 sec, otherwise there are errors on TX_UART from RSL


ret_uart = srl_read(s1,2*4096);     % receive 8192 bytes or 4096 samples (2 bytes each)



if(length(ret_uart)>0)
  retn_uart = typecast(ret_uart, "int16");
  %saved_uart = [saved_uart retn_uart(1:8)] 


     if(ret_uart(2) == 192)       % hex2dex("C0")= 192
     
        x_vect = 1:1:64;
        chunk_no = int16(ret_uart(1))             
        No_of_spikes_in_chunk = (length(ret_uart)-2)/130
        
        % Do a for loop to extract all the spikes detected in this chunk
        for idx_spikes_in_chunk = 1: No_of_spikes_in_chunk
    
            idx_det_spikes = idx_det_spikes + 1 ; 

            ChannelID = mod(retn_uart(2+65*(idx_spikes_in_chunk-1)), 32) + 1
            CrossIdx0 = ( retn_uart(2+65*(idx_spikes_in_chunk-1)) - mod(retn_uart(2), 32) )/32
            CrossIdx = ( chunk_no*128 + (retn_uart(2+65*(idx_spikes_in_chunk-1))/32) )
            
            
            
            % The following to be replaced with a for loop later on, after having a more stable architecture, communication and protocol    
           if(ChannelID==1)
              figure(100+idx_det_spikes);
              plot(x_vect, ( (Spike1((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(1) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(1) ));
            endif
            
            if(ChannelID==2)
              figure(200+idx_det_spikes);
              plot(x_vect, ( (Spike2((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(2) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(2) ));          
            endif    
            
           if(ChannelID==3)
              figure(300+idx_det_spikes);
              plot(x_vect, ( (Spike3((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(3) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(3) ));          
            endif             

           if(ChannelID==4)
              figure(400+idx_det_spikes);
              plot(x_vect, ( (Spike4((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(4) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(4) ));          
            endif    
            
           if(ChannelID==5)
              figure(500+idx_det_spikes);
              plot(x_vect, ( (Spike5((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(5) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(5) ));          
            endif  

           if(ChannelID==6)
              figure(600+idx_det_spikes);
              plot(x_vect, ( (Spike6((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(6) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(6) ));          
            endif  

           if(ChannelID==7)
              figure(700+idx_det_spikes);
              plot(x_vect, ( (Spike7((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(7) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(7) ));          
            endif              

           if(ChannelID==8)
              figure(800+idx_det_spikes);
              plot(x_vect, ( (Spike8((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(8) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(8) ));          
            endif   
  

           if(ChannelID==9)
              figure(900+idx_det_spikes);
              plot(x_vect, ( (Spike9((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(9) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(9) ));
            endif
            
            if(ChannelID==10)
              figure(1000+idx_det_spikes);
              plot(x_vect, ( (Spike10((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(10) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(10) ));          
            endif    
            
           if(ChannelID==11)
              figure(1100+idx_det_spikes);
              plot(x_vect, ( (Spike11((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(11) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(11) ));          
            endif             

           if(ChannelID==12)
              figure(1200+idx_det_spikes);
              plot(x_vect, ( (Spike12((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(12) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(12) ));          
            endif    
            
           if(ChannelID==13)
              figure(1300+idx_det_spikes);
              plot(x_vect, ( (Spike13((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(13) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(13) ));          
            endif  

           if(ChannelID==14)
              figure(1400+idx_det_spikes);
              plot(x_vect, ( (Spike14((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(14) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(14) ));          
            endif  

           if(ChannelID==15)
              figure(1500+idx_det_spikes);
              plot(x_vect, ( (Spike15((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(15) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(15) ));          
            endif              

           if(ChannelID==16)
              figure(1600+idx_det_spikes);
              plot(x_vect, ( (Spike16((CrossIdx-31):(CrossIdx+32))+20) - Mean_value(16) ), x_vect, ( retn_uart( (3+65*(idx_spikes_in_chunk-1)) : (3+63+65*(idx_spikes_in_chunk-1)) ) - Mean_value(16) ));          
            endif   
  

  
        endfor
  
        
     endif
 
 endif    % endif for length(ret_uart)>0
 

 
 
% Sometimes there could be multiple detected Spikes in the same chunk and channel 
 
pause(0.5);       % place a pause here of at least 2 or 3 sec, otherwise there are errors on TX_UART from RSL


%srl_flush(s1, [2]);       % Optional Flush input and output buffers
 
endfor



% Optional Flush input and output buffers
srl_flush(s1, [2]);

srl_close(s1);


