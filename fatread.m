function y = fatread(Freq,Time,Fs)%generates sound from Freq and Time arrays using note(...)
y = zeros(1, floor(sum(Time)*Fs));
pos = 3;
Delta = 0.01;

for k =1:size(Freq,2)
    Notes = 0;
    printf("Reading fat: %f\r",100*k/size(Freq,2));
    for k2 = 1:size(Freq{k},2)
        Notes = Notes + note(Freq{k}(k2),5*Time(k),Fs);
    end
    NotesSize = floor(length(Notes)/5);
    if abs(max(Notes)) ~= 0
        Notes = Notes./abs(max(Notes));
        pdiff = find(abs(Notes - y(pos-1)) <= Delta,1);
        %ph = sign((y(pos-1) - y(pos-2))*(Notes(2) - Notes(1)));
        %if ph == -1
        %    Notes = Notes(pdiff(2):pdiff(2)+NotesSize-1);
        %else
            Notes = Notes(pdiff(1):pdiff(1)+NotesSize-1);
        %end
        if k+1 > size(Freq,2) || Freq{k+1}(1) == 0
            x = 1:floor(size(Notes,2)/2);
            Quieter = [ones(1,size(Notes,2) - size(x,2)) cos((x*pi/2)./size(x,2))];
            Notes = Notes.*Quieter;
        end
    else
        Notes = Notes(1:NotesSize);
    end

    y(pos:pos+NotesSize-1) = Notes;
    pos = pos+NotesSize;
end

