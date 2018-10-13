x = -5:0.25:5;
y = x;
[X, Y] = meshgrid(x);
Z = Y.*sin(pi.*(X/10))+5.*cos((X.^2+y.^2)/8)+cos(X + Y).*cos(3.*X-Y);
figure(1);
subplot(2,1,1);
title('Grafica de la superfice');
surf(X,Y,Z);
ylabel('Eje y');
xlabel('Eje x');
subplot(2,1,2);
title("Graficas forma de malla y contorno")
mesh(X,Y,Z);
hold on;
contourf(X,Y,Z);
ylabel('Eje y');
xlabel('Eje x');
colorbar
hold off;