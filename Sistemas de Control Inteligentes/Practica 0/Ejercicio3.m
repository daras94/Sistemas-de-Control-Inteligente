vtrank = zeros(1,25);
vtdet = zeros(1,25);
for i = 1:25
   m = randn(i);
   % Calculo rango
   tic;
   rank(m);
   vtrank(1,i) = toc;
   % Calculo determinante
   tic;
   det(m);
   vtdet(1,i) = toc;
end
figure(1);
plot(vtrank,'r');
hold on;
plot(vtdet,'b');
title('Tiempo de calculo rango y determinante');
xlabel('Tamaño matriz cuadrada');
ylabel('Tiempo de calculo');
legend('Rango', 'Determinante');
hold off;
clear;