function [modcompmatrix,IQmatrix] = modgeneratoronlylabels(str,M,snr)

%   modcompmatrix are the modulation components 
%   IQmatrix is the Inphase Quadrature matrix
%   str is modulation type, M is the modulation order,snr in the Signal to Noise ratio.
%   samples are the number of samples of the modulation.
    components = [];
    IQ = [];
    switch str
        case "qam"
             if M==64
% for i=1:1:samples
   x = randi([0 (63)],128,1); % generating input signals.
   y = qammod(x,64); % creating M-QAM modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
    
% end
    modcompmatrix = components;
    IQmatrix = IQ;
             end
    
       if M==32
% for i=1:1:samples
   x = randi([0 (31)],128,1); % generating input signals.
   y = qammod(x,32); % creating M-QAM modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
% end
    modcompmatrix = components;
    IQmatrix = IQ;
       end
    
     if M==16
% for i=1:1:samples
   x = randi([0 (15)],128,1); % generating input signals.
   y = qammod(x,16); % creating M-QAM modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
% end
    modcompmatrix = components;
    IQmatrix = IQ;
     end
    
    
    if M==4
% for i=1:1:samples
   x = randi([0 (3)],128,1); % generating input signals.
   y = qammod(x,4); % creating M-QAM modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
% end
    modcompmatrix = components;
    IQmatrix = IQ;
    end

    case "psk"
       if M==64
% for i=1:1:samples
   x = randi([0 (63)],128,1); % generating input signals.
   y = pskmod(x,64); % creating 64-PSK modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
% end
    modcompmatrix = components;
    IQmatrix = IQ;
       end
    
       if M==32
% for i=1:1:samples
   x = randi([0 (31)],128,1); % generating input signals.
   y = pskmod(x,32); % creating 32-PSK modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
% end
    modcompmatrix = components;
    IQmatrix = IQ;
       end
    
     if M==16
% for i=1:1:samples
   x = randi([0 (15)],128,1); % generating input signals.
   y = pskmod(x,16); % creating 16-PSK modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
% end
    modcompmatrix = components;
    IQmatrix = IQ;
     end
    
        if M==4
% for i=1:1:samples
   x = randi([0 (3)],128,1); % generating input signals.
   y = pskmod(x,4); % creating 64-PSK modulation with input signal x.
   out = awgn(y,snr,'measured'); % adding AWGN with snr dB to modulated signal y.
   components = out; % saving the transmitted noisy signal.    
    
% for i=1:1:samples
    IQ(1,:) = real(components); % saving the real part of each modulated signal.
    IQ(2,:) = imag(components); % saving the imaginary part of each modulated signal.
% end
    modcompmatrix = components;
    IQmatrix = IQ;
        end
    


    end
end

