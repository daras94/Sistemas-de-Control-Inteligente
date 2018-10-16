J = 0.01;
b = 0.1;
K = 0.01;
R = 1;
L = 0.5;
syms dwdt; 
syms didt;
syms w i;
syms V k;
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
pretty(f1d);
pretty(f2d);

% Obtencion de las transformada z

tf1d = ztrans(f1d);
tf2d = ztrans(f2d);
disp('Las ecuaciones en transformada z seran:');
pretty(tf1d);
pretty(tf2d);