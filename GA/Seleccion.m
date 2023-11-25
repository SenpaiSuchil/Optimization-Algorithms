function n = Seleccion (aptitud)


    aptitud_total = sum(aptitud);
    N = numel(aptitud);
    
    r = rand;
    p_sum = 0;
    
    for i=1:N
        p_sum = p_sum + aptitud(i)/aptitud_total;
        
        if p_sum >= r 
            n = i;
            return 
        end
    end
    
    n = N;
end