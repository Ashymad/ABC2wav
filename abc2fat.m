function [Freq,Time,Name] = abc2fat(fID) % fat stands for Freqency and Time arrays. Name is the tile of the song.

    k = 1;
    File = textscan(fID, '%s','Delimiter',{'\n','\r'},'CommentStyle','%','MultipleDelimsAsOne',1);
    while File{1}{k}(2) == ':' && isletter(File{1}{k}(1))
        Header{k}{1} = File{1}{k}(1);
        Header{k}{2} = File{1}{k}(3:size(File{1}{k},2));
        k = k + 1;
    end
    Melody = File{1}(k:size(File{1},1));
    Name = HeaderField(Header,'T');
%--------------------------------------------------------------------------

    TempoField = HeaderField(Header,'Q');
    NoteField = regexprep(HeaderField(Header,'L'),' ','');
    if isnan(NoteField)
        NoteEval = 1/8; %If no note lenght is given 1/8 is assumed
    else
        NoteEval = eval(NoteField);
    end
    if ~isnan(TempoField)
        Tempo = 0;
        k = 1;
        while TempoField(2) == '/'
            Tempo = Tempo + eval(TempoField(k:k+2));
            k = k + 3;
            if TempoField(k) == '='
                break;
            end
        end
        if Tempo == 0
            Tempo = [NoteEval eval(TempoField(1:size(TempoField,2)))];
        else
            Tempo = [Tempo eval(TempoField(k+1:size(TempoField,2)))];
        end
    else
        Tempo = [NoteEval 180]; %If no Tempo is given 180 is assumed
    end
        NoteLenght = (60/Tempo(2))*(NoteEval/Tempo(1));

%--------------------------------------------------------------------------

    Key = regexprep(HeaderField(Header,'K'),'[^\w'']','');
    Tw2 = 2^(1/12); %Twelth root of 2
    [A,B,C,D,E,F,G] = tune(Key);
    [RefA,RefB,RefC,RefD,RefE,RefF,RefG] = tune('C');
    [Refa,Refb,Refc,Refd,Refe,Reff,Refg] = tune('C',5);%Reference Notes
    [a,b,c,d,e,f,g] = tune(Key,5); %Octave higher
    [X x Z z] = deal(0); %Breaks

function [NoteFreq,NoteLen] = interplet() %Interpretes string containg note specifics
    switch NoteStr(1)
        case '^'
            NoteFreq = eval(['Ref',NoteStr(2)])*Tw2;
        case '='
            NoteFreq = eval(['Ref',NoteStr(2)]);
        case '_'
            NoteFreq = eval(['Ref',NoteStr(2)])/Tw2;
        otherwise
            NoteFreq = eval(NoteStr(1));
    end
    NoteLen = NoteLenght;
    
    StrLen = size(NoteStr,2);
    
    for Ik = 1:StrLen
        switch NoteStr(Ik)
            case ''''
                NoteFreq = NoteFreq*2;
            case ','
                NoteFreq = NoteFreq/2;
            case '/'
                if Ik < StrLen && NoteStr(Ik+1) <= abs('9') && NoteStr(Ik+1) > abs('0')
                    NoteLen = NoteLen/(eval(NoteStr(Ik+1))*eval(NoteStr(Ik+1)));
                else
                    NoteLen = NoteLen/2;
                end
            case {'1','2','3','4','5','6','7','8','9'}
                NoteLen = NoteLen * eval(NoteStr(Ik));
        end
    end
end

%--------------------------------------------------------------------------
    Time = [];
    Freq = {};
    for k = 1:size(Melody,1)
        k2 = 1;
        repeat = 0;
        stpos = 1;
        chord = 0;
        while k2 < size(Melody{k},2)+1
            %disp(Melody{k}(k2));pause(1);%Uncomment for debugging
            if isletter(Melody{k}(k2)) || checkVecEl(Melody{k}(k2),'==',['^','_','='],'or')
                NoteStr = Melody{k}(k2);
                if ~isletter(Melody{k}(k2))
                    k2 = k2 + 1;
                    NoteStr = [NoteStr Melody{k}(k2)];
                end
                k2 = k2 + 1;
                while k2 < size(Melody{k},2)+1 && ~isletter(Melody{k}(k2)) && ...
                        checkVecEl(Melody{k}(k2),'~=',[' ','_','|','^','=','[',']'],'and')
                    %disp(Melody{k}(k2));pause(1);
                    NoteStr = [NoteStr Melody{k}(k2)];
                    k2 = k2 + 1;
                end
                [TmpFreq,TmpLen] = interplet();
                if chord == 2
                    Freq{size(Freq,2)+1} = TmpFreq;
                    Time = [Time TmpLen];
                    chord = 1;
                elseif chord == 1
                    Freq{size(Freq,2)} = [Freq{size(Freq,2)} TmpFreq];
                else
                    Freq{size(Freq,2)+1} = TmpFreq;
                    Time = [Time TmpLen];
                end
            elseif k2 < size(Melody{k},2)+1
                if Melody{k}(k2) == ':' && k2 ~= size(Melody{k},2)
                    if repeat == 0
                        stpos = k2+1;
                        k2 = k2+1;
                    else
                        skipto = k2+1;
                        k2 = stpos;
                    end
                elseif Melody{k}(k2) == '['
                    if checkVecEl(Melody{k}(k2+1),'==',['^','_','='],'or') || isletter(Melody{k}(k2+1))
                        chord = 2;
                    end
                    k2 = k2 + 1;
                elseif Melody{k}(k2) == ']'
                    if checkVecEl(Melody{k}(k2-1),'~=',['|',':'],'and')
                        chord = 0;
                    end
                    k2 = k2 + 1;
                elseif abs(Melody{k}(k2)) <= abs('9') && abs(Melody{k}(k2)) > abs('0')
                    if repeat == eval(Melody{k}(k2))-1;
                        repeat = eval(Melody{k}(k2));
                        k2 = k2+1;
                    else
                        k2 = skipto;
                    end
                else
                    k2 = k2 + 1;
                end
            end
        end
    end
end
               