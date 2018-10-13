clear;
%Creamos variables simbolicas
syms v t g angulo
%Declaramos ecuaciones
vx = v * cos(angulo);
vy = v * sin(angulo) - g * t;
dx = vx * t;
dy = vy * t - 1/2 * g * t^2;


% b) Distancia a la que alcanza maxima altura
tMaxAltura = solve(diff(dy,t),t);
dMaxAltura = subs(dx,t,tMaxAltura);
% a) Altura maxima
maxAltura = subs(dy,t,tMaxAltura);
% c) Distancia del punto de lanzamiento a la que cae el proyectil
tCaida = solve(dy,t);
%Cogemos tCaida(2) porque tCaida(1) es 0 cuando se lanza.
dCaida = subs(dx,t,tCaida(2));

% Sustitucion de variables
% a)
valorMaxAltura = subs(maxAltura, [v angulo g], [20 deg2rad(30) 9.8]);
fprintf('Altura maxima alcanzada: %s \n', eval(valorMaxAltura));

v = 20;
angulo = deg2rad(30);
g = 9.8;
% b)
fprintf('Distancia donde alcanza altura maxima: %s \n', eval(dMaxAltura));

% c)
fprintf('Distancia maxima alcanzada: %s \n', eval(dCaida));

