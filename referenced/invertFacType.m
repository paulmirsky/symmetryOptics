function flipped = invertFacType( typeTagArray )

    flipped = cell(size(typeTagArray));
    for ii = 1:numel( typeTagArray )
        if strcmp(typeTagArray{ii},'singular')
            flipped{ii} = 'plenary';
        elseif strcmp(typeTagArray{ii},'plenary')
            flipped{ii} = 'singular';
        else
            error('invalid factor type tag!');
        end            
    end

end

