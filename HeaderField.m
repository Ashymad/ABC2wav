function Value = HeaderField(Header,Name)
    Value = NaN;
    for k = 1:size(Header,2)
        if Header{k}{1} == Name
            Value = Header{k}{2};
            break;
        end
    end