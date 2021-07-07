% This loads all parameters for the simulink model

% ms = 1;
% fc = 3.045e6;
% fs = 26e6;
% Len = ms*fs/1000;
% freq_vector= 2*pi*[(fc - 10e3):1e3:(fc+10e3)];

ms = 1;
fc = 4130400;
fs = 16367600;
Len = ceil(ms*fs/1000);
freq_vector= 2*pi*[(fc - 10e3):1e3:(fc+10e3)];
bits = nextpow2(Len);
fs_fft = 2^bits*1e3;
Len_fft = fs_fft*ms/1000;
switch_time = 8*Len/fs; %Doing acquisition for only 8ms