function Ejercicio1_part1()
    global A;
    global B;
    global C;
    pront = ' - Introduca la dimension de la matrix en el formato "[row col]": ';
    for x = 1:2
        dim = input(pront);
        AUX = imput_matriz(dim);
        if (x == 1)
            A = AUX;
        else
            B = AUX;
        end
        [r, c] = size(AUX);
        str_o  = sprintf(' - MATRIZ "%s" de %iX%i generada:', (x + 64), r, c);
        disp('==========================================');
        disp(strcat(str_o));
        disp('==========================================');
        disp(AUX);
        [row, col] = size(AUX);
        if (row == col)
            disp('- Su transpuesta es:');
            disp('  =======================================');
            disp(AUX.');
            disp('- Su inversa es: ');
            disp('  =======================================');
            disp(pinv(AUX));
            str_det  = sprintf(' - El determinate de "%s" es = %i', (x + 64), det(AUX));
            disp(strcat(str_det));
        else
            str_er  = sprintf(' - ERROR: La MATRIZ "%s" no es cuadrada no se puede calcular su transpuesta ni su inversa ni el determinante:', (x + 64));
            disp(strcat(str_er));
        end
        str_rang = sprintf(' - El rango de "%s" es = %i', (x + 64), rank(AUX));
        disp(strcat(str_rang));
        disp('==========================================');
        clearvars AUX;
    end  
    disp('');
    disp(' El producto de matrices de AxB es:');
    disp('==========================================');
    [row_a, col_a] = size(A);
    [row_b, col_b] = size(B);
    C = zeros(row_a, col_b);
    if (col_a == row_b)
        for i = 1 : row_a
            for j = 1: col_b
                C(i,j) = A(i,:) * B(:,j);
            end
        end
        disp(C);
    else
        disp(' - ERROR el producto de matrices no se pude calacular ya que el numero de columnas de "A" no es igual al numero de filas de "B".');
    end
    disp('');
    disp(' El vector concatenado de la primera fila de las matrices A y B');
    disp('=================================================================');
    disp([A(1,:) B(1,:)]);
    disp('');
    disp(' El vector concatenado de la primera columna de las matrices A y B');
    disp('==================================================================');
    disp([A(:,1); B(:,1)]);
end