clear all; %Example use
clc;
%page_output_immediately ()
more off;
fID = fopen('FurElise.abc');
[f,t,n] = abc2fat(fID);
fs = 44100; %Sample Frequency
y = fatread(f,t,fs);
pl = audioplayer(y,fs);
audiowrite('FurElise.wav',y,fs);
disp(['Playing: ',n]);
play(pl);