%function[sol, reales, complejas] = raices(poli_1, poli_2)
function [solucion, reales, complejas] = Ejercicio7(poli_1, poli_2)
reales = 0;
complejas = 0;
switch nargin
    case 2
        apli = input('A quien se le aplica la solucion (p1, p2 o pp): ', 's');
    case 1
        apli = 'p1';
end
switch apli
    case 'p1'
        polinomio = poli_1;
    case 'p2'
        polinomio = poli_2;
    case 'pp'
        polinomio = conv(poli_1, poli_2);
end
    %Obtener raices polinomio
    
    solucion = roots(polinomio);
    for i = 1:length(solucion)
       if isreal(solucion(i))
           reales = reales + 1;
       else
           complejas = complejas + 1;
       end
    end
end