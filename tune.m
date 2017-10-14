function [A,B,C,D,E,F,G] = tune(key,octave,scale)

if nargin < 3
    scale = 'major';
    if nargin < 2
        octave = 4;
    end
end

fr = 2^(1/12);   % frequency ratio between neighboring keys
A = 440*2^(octave-4);        % reference note for others
B = A*fr^2;
C = A*fr^(-9);
D = A*fr^(-7);
E = A*fr^(-5);
F = A*fr^(-4);
G = A*fr^(-2);

function movenote()
    dis = key - 'C';
    if dis < 0
        dis = dis + 7;
    end
    tmp = [C D E F G A B];
    tmpn = ['C' 'D' 'E' 'F' 'G' 'A' 'B'];
    for k = 1:size(tmp,2)
        if k-dis < 1
            eval([tmpn(k) '=tmp(k-dis+7)/2;']);
        else
            eval([tmpn(k) '=tmp(k-dis);']);
        end
    end
end

A = eval(key)*fr^9;

sc = upper(scale(1:3));

switch sc
    case {'MAJ','ION'} %Major (Ionian) scale
        B = A*fr^2;
        C = A*fr^(-9);
        D = A*fr^(-7);
        E = A*fr^(-5);
        F = A*fr^(-4);
        G = A*fr^(-2);
        movenote();
end

end
        