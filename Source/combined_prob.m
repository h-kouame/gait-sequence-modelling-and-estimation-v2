function a_i = combined_prob(src, dest, A)
    src = dec2bin(src-1);
    dest = dec2bin(dest-1);
    sym_num = size(A, 2);
    %make number of bits equal to number of symbols
    if length(src) < sym_num
        for i = 1:sym_num - length(src)
            src = strcat('0', src);
        end
    end
    if length(dest) < sym_num
        for i = 1:sym_num - length(dest)
            dest = strcat('0', dest);
        end
    end
    a_i = 1;
    for i = 1:sym_num
        row = -1;
        if src(i) == '0'
            row = 1;
        else
            row = 2;
        end
        if dest(i) == '0'
            col = 1;
        else
            col = 2;
        end
        a_i = a_i*A{i}(row, col);
    end
        
end
