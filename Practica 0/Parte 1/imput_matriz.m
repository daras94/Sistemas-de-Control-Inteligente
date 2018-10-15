function MATRIZ = imput_matriz(dim)
    global M_AUX;
    [ndim_row, ndim_col] = size(dim);
    if (ndim_col <= 2) && (ndim_col > 0)  
       num_row = dim(ndim_row);
       num_col = dim(ndim_col);
       out_aux = 0;
       M_AUX   = zeros(num_row, num_col);
       for x = 1 : num_row
           y = 0;
           while (y < num_col)
               value_def  = randi([0 50],1,1);
               pront      = strcat(' - Introduce el valor de [', int2str(x), ',', int2str(y), '] = ');
               if (out_aux ~= 'r')
                   out_aux = input(pront, 's');
                   if (out_aux ~= 'r')
                       value_def = str2double(out_aux);
                   end
               end
               y          = y + 1;
               M_AUX(x,y) = value_def;
           end
       end      
    else
        disp('Error rangos 0 o menor de dos no valido')
    end 
    MATRIZ = M_AUX;
end