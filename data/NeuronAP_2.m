% Second type of AP Model

%function [V,m,h,n,t] = NeuronAP_1(I,tspan, v, mi, hi, ni,Plot)   
function [V_APs] = NeuronAP_2( No_APs=3, Tspan=3.4, mi=0.76, hi=0.14, ni=0.25 ) ;
  
Tspan = 3.4 ;
v = -65 ;
%mi = 0.76 ;        % Smaller value makes the Spike more narrow
%hi = 0.14 ;       % Smaller value makes the Spike more narrow too
%ni = 0.25 ;
  
 
I = 0.08 ;
%Tspan = 20 ;

  
  dt = 0.01;               % time step for forward euler method
  loop  = ceil(Tspan/dt);   % no. of iterations of euler
  
  
  gNa = 120;  
  eNa=115;
  gK = 36;  
  eK=-12;
  gL=0.3;  
  eL=10.6; 
  
  
 
V_APs = [];

for k = 1:No_APs ;
 

  % Initializing variable vectors
  
  t = (1:loop)*dt ;
  V = zeros(1, loop);
  m = zeros(1, loop);
  h = zeros(1, loop);
  n = zeros(1, loop);
  
  % Set initial values for the variables
  
  V(1)=v;
  m(1)=mi;
  h(1)=hi;
  n(1)=ni;
 
  
% Euler method
  
  for i=1:loop-1 
      V(i+1) = V(i) + dt*(gNa*m(i)^3*h(i)*(eNa-(V(i)+65)) + gK*n(i)^4*(eK-(V(i)+65)) + gL*(eL-(V(i)+65)) + I);
      m(i+1) = m(i) + dt*(alphaM(V(i))*(1-m(i)) - betaM(V(i))*m(i));
      h(i+1) = h(i) + dt*(alphaH(V(i))*(1-h(i)) - betaH(V(i))*h(i));
      n(i+1) = n(i) + dt*(alphaN(V(i))*(1-n(i)) - betaN(V(i))*n(i));
  end  
  

    %figure
    %plot(t,V);

  
  
noise = 0.05*rand (1, length(V));
V = V + noise ;

V_APs = [V_APs, V] ;  

end
  
endfunction





% alpha and beta functions for the gating variables 

function aM = alphaM(V)
aM = (2.5-0.1*(V+65)) ./ (exp(2.5-0.1*(V+65)) -1);
end

function bM = betaM(V)
bM = 4*exp(-(V+65)/18);
end

function aH = alphaH(V)
aH = 0.07*exp(-(V+65)/20);
end

function bH = betaH(V)
bH = 1./(exp(3.0-0.1*(V+65))+1);
end

function aN = alphaN(V)
aN = (0.1-0.01*(V+65)) ./ (exp(1-0.1*(V+65)) -1);
end

function bN = betaN(V)
bN = 0.125*exp(-(V+65)/80);
end

