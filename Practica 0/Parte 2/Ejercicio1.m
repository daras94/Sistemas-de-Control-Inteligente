syms k a;
% =========================================================================
% Ejercicio 1. Transformadas de señales.
%
%     1. Obtenga la transformada z de la siguiente función: f(k) = 2 + 5k + k.
%        Represente gráficamente las señales original y transformada.%
% =========================================================================
f1_origin = 2 + 5*k + k;                % funcion apartado 1.
fun_orig1 = sprintf('f(k) = %s', f1_origin);
p1        = ezplot(f1_origin);
hold on;
f1_transZ = ztrans(f1_origin, k);            % tranformada z funcion 1.
fun_tras1 = sprintf('F(z) = %s', f1_transZ);
p2        = ezplot(f1_transZ);
hold off;
grid on;
legend([p1 p2], {fun_orig1, fun_tras1})
disp('Pulse una tecla para continuar');
pause;
close;

% =========================================================================
%     2. Obtenga la transformada z de la siguiente función: f(k) = sen(k) ? e^-ak.
%        Represente gráficamente, de nuevo, la señales original y transformada.
% =========================================================================
f2_origin = sin(k) * exp(-a*k);      % funcion apartado 2.
fun_orig2 = sprintf('f(k) = %s', f2_origin);
p3        = ezplot(f2_origin);
hold on;
f2_transZ = ztrans(f2_origin);         % tranformada z funcion 2.
fun_tras2 = sprintf('F(z) = %s', f2_transZ);
p4        = ezplot(f2_transZ);
hold off;
grid on;
legend([p3 p4], {fun_orig2, fun_tras2})
disp('Pulse una tecla para continuar');
pause;
close;

% =========================================================================
%     3. Dada la siguiente función de transferencia discreta:
%
%                   T(Z) = (0,4^2)/(z^3 - z^2 + 0,1z + 0,02)
%
%        - Obtenga y represente la respuesta al impulso del sistema.
%        - Obtenga y represente la respuesta del sistema ante una entrada escalón.
% =========================================================================
h = tf([0.4 0 0], [1 1 0.1 0.02]);
figure(1);
subplot(1, 2, 1), impulse(h), title('La respuesta al impulso del sistema:');
subplot(1, 2, 2), step(h), title('La respuesta del sistema ante una entrada escalón:');
disp('Pulse una tecla para continuar');
pause;
close;


