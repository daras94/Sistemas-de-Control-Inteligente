clear;
%Creamos variables simbolicas
syms v t g angulo
%Declaramos ecuaciones
vx = v * cos(angulo);
%vy = v * sin(angulo) - g * t;
dx = vx * t;
dy = vy * t - 1/2 * g * t^2;

%Despejamos
t = -(vy - v*sin(angulo))/g;
dy = solve(dy, t);