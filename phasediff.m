function PhaseDiff = phasediff(Note1,Note2) %Find phase difference
    if length(Note1) < 1
        PhaseDiff = 0;
        return;
    end
    MergeVal = Note1(end);
    if Note1(end-1) < MergeVal
       growing = 1; 
    else
       growing = 0;
    end
    
    TmPhase = 0;
    Delta = 0.001;
    
    for k = 1:length(Note2)
        if (abs(MergeVal - Note2(k)) <= Delta) && k ~= size(Note2,2);
            if (Note2(k+1) > Note2(k) && growing) || (Note2(k+1) < Note2(k) && ~growing)
                TmPhase = k;
                break;
            end
        end
    end
    PhaseDiff = TmPhase;
end