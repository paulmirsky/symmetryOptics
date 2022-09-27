function output = doFT( input, type )

    output = fftshift(fft(ifftshift(input )));

    if strcmp(type,'angle')
        if (isItEven(numel(input)))
            output = circshift(output,-1);
        end    
    end

end

