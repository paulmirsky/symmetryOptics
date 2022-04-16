function listFactorChain( label, sizes, types )

    sizes = sizes(:); % make sure they are column arrays
    types = types(:);
    disp(label);
    combinedArray = cat(2, flipud(sizes), flipud(types));
    disp( combinedArray );

end

