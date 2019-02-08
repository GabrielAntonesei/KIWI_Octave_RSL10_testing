load june_28_3A_ch1_500k.mat


figure(1);
plot(june_28_3A_ch1_500k);

offset = 

tmp_vect = 0-june_28_3A_ch1_500k(1+4096*0:4096*(1+7));

%for i = 1:32
%  RSpikes(i, 4096) = june_28_3A_ch1_500k(1+4096*i:4096*(i+1)); 
%endfor



%RSpikes_1 = june_28_3A_ch1_500k(1+4096*0:4096*(1+0));
%RSpikes_2 = june_28_3A_ch1_500k(1+4096*1:4096*(1+1));
%RSpikes_3 = june_28_3A_ch1_500k(1+4096*2:4096*(1+2));
%RSpikes_4 = june_28_3A_ch1_500k(1+4096*3:4096*(1+3));
%RSpikes_5 = june_28_3A_ch1_500k(1+4096*4:4096*(1+4));
%RSpikes_6 = june_28_3A_ch1_500k(1+4096*5:4096*(1+5));
%RSpikes_7 = june_28_3A_ch1_500k(1+4096*6:4096*(1+6));
%RSpikes_8 = june_28_3A_ch1_500k(1+4096*7:4096*(1+7));



RSpikes_1 = tmp_vect(1+4096*0:4096*(1+0));
RSpikes_2 = tmp_vect(1+4096*1:4096*(1+1));
RSpikes_3 = tmp_vect(1+4096*2:4096*(1+2));
RSpikes_4 = tmp_vect(1+4096*3:4096*(1+3));
RSpikes_5 = tmp_vect(1+4096*4:4096*(1+4));
RSpikes_6 = tmp_vect(1+4096*5:4096*(1+5));
RSpikes_7 = tmp_vect(1+4096*6:4096*(1+6));
RSpikes_8 = tmp_vect(1+4096*7:4096*(1+7));



%for i = 1:32
%  figure(i);
%  tmp = strcat("RSpikes_", num2str(i))
%  plot(tmp);
%endfor

figure(50);
plot(tmp_vect);


figure(1);
plot(RSpikes_1);

figure(2);
plot(RSpikes_2);

figure(3);
plot(RSpikes_3);

figure(4);
plot(RSpikes_4);




save("RSpikes_1.mat", "RSpikes_1");
save("RSpikes_2.mat", "RSpikes_2");
save("RSpikes_3.mat", "RSpikes_3");
save("RSpikes_4.mat", "RSpikes_4");
save("RSpikes_5.mat", "RSpikes_5");
save("RSpikes_6.mat", "RSpikes_6");
save("RSpikes_7.mat", "RSpikes_7");
save("RSpikes_8.mat", "RSpikes_8");








