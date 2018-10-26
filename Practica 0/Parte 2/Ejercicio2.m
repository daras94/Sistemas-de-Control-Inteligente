J = 0.01;
b = 0.1;
K = 0.01;
R = 1;
L = 0.5;

syms dwdt; 
syms didt;
syms w j i;
syms V k n;
syms w(n) i(n);
f1 = J * dwdt + b * w - K * 1i;
f2 = L * didt + R * 1i - V + K * w;

% Obtencion de las ecuaciones Discretas
Ts = .01;

wd = w(n);
id = i(n);
dwdtd = (w(n) - w(n-1))/Ts;
didtd = (i(n) - i(n-1))/Ts;
f1d = subs(f1, [dwdt w 1i], [dwdtd wd id]);
f2d = subs(f2, [didt w 1i], [didtd wd id]);
disp('Las ecuaciones en tiempo discreto seran las siguientes: ');
pretty(f1d==0);
pretty(f2d==0);

% Calculamos la transformada z externamente y la añdimos
syms W I z 
disp('Calculamos la transformada z y obtenemos el par de ecuaciones: ');
tf1d = J * (W-W*z^-1)/Ts + b*W - K * I == 0;
tf2d = L * (I-I*z^-1)/Ts + R*I - V + W == 0;
pretty(tf1d);
pretty(tf2d);
t1  = solve(tf1d,I);
t2 = subs(tf2d,I,t1);
disp('Sustituimos la I en la segunda ecuacion: ');
pretty(t2);
omega = solve(t2,W);
disp('Despejamos la W de la ecuacion resultante');
pretty(W==omega);
disp('Para obtener la ganancia W/V dividimos entre V la ecuacion: ');
ganancia = omega/V;
pretty(W/V==ganancia);