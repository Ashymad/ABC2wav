function y = note(freq,time,samFreq,type)
if nargin < 4
    type = 'sine';
end
t=0:1/samFreq:time;
switch type
    case 'square'
        y = sign(sin(2*pi*freq*t));
    case 'sine'
        y = sin(2*pi*freq*t);
    case 'sawtooth'
        y = sawtooth(2*pi*freq*t);
    case 'triangle'
        y = sawtooth(2*pi*freq*t,0.5);
end