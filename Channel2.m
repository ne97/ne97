%
% EDI042 - Error Control Coding (Kodningsteknik)
% Lund University
%
% Created by Michael Lentmaier, 2015-12-01
%
% Project 2: 
% simulate the iterative decoding performance of an LDPC code
load('H_1024_3_6.mat');
disp('Simulation running ...');
N=size(H,2); K=N-size(H,1);  R=K/N;
EbN0dB=[2.0, 2.5]; Pb=[]; ErrVec=[]; 
EbN0=10.^(EbN0dB./10);
sigma2=1./(2*R*EbN0);
sigmaVec=sqrt(sigma2);
NumIterations=20;
numsim=1000; 
for i=1:length(sigmaVec),  % different noise values
  
  err=0; 
  for k=1:numsim, % blocks to simulate
    
    
    % encoder: assume all-zero sequence sent
    v=zeros(1,N);                  
    
    % modulation to +1/-1
    x=1-2*v;        
    % AWGN channel
    r=x+sigmaVec(i).*randn(1,N);      
    
    Lch = 2/sigma2(i) .* r;
        
    Lout = SumProduct(NumIterations, N, K, H, Lch); % this function you should 
implement yourself
    
    % count errors
    err=err+sum(Lout<0); 
    
  end;
  
  % bit error rate
  Pb(i)=err/(N*numsim); 
  ErrVec(i)=err;
  
  disp(['SNR ',num2str(EbN0dB)]);
  disp(['Pb  ',num2str(Pb)]);
  save 'ResultSimLDPCTest.mat' EbN0dB Pb ErrVec
end;