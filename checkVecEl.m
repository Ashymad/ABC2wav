function TruFal = checkVecEl(a,operand,Vecb,andor) %Uses operand to compare every element of Vector Vecb with a
switch andor
    case 'and'
        TruFal = 1;
        for k = 1:size(Vecb,2)
            if ~eval(['a' operand 'Vecb(k)'])
                TruFal = 0;
                break;
            end
        end
    case 'or'
        TruFal = 0;
        for k = 1:size(Vecb,2)
            if eval(['a' operand 'Vecb(k)'])
                TruFal = 1;
                break;
            end
        end
    otherwise
        disp('Error: You must specify ''and'' or ''or''.');
end