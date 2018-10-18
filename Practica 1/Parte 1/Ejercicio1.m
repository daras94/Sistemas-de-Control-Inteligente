x1 = [0.1 0.7 0.8 0.8 1.0 0.3 0.0 -0.3 -0.5 -1.5;      % Entrada x0 
      1.2 1.8 1.6 0.6 0.8 0.5 0.2  0.8 -1.5 -1.3];     % Entrada x1
t1 = [1 1 1 0 0 1 1 1 0 0;                             % clases definidas 4. 
      0 0 0 0 0 0 1 1 1 1];                            % 0 = [0 0], 1 = [0 1], 2 = [1 0] y 3 = [1 1].
% -------------------------------------------------------------------------
% --------------- Añadiendo el dato [0.0 -1.5] clase 3 --------------------
% -------------------------------------------------------------------------
x2 = [0.1 0.7 0.8 0.8 1.0 0.3 0.0 -0.3 -0.5 -1.5  0.0; % Entrada x0 
     1.2 1.8 1.6 0.6 0.8 0.5 0.2  0.8 -1.5 -1.3 -1.5]; % Entrada x1
t2 = [1 1 1 0 0 1 1 1 0 0 1;                           % clases definidas 4. 
     0 0 0 0 0 0 1 1 1 1 1];                           % 0 = [0 0], 1 = [0 1], 2 = [1 0] y 3 = [1 1].
% =========================================================================
net1 = perceptron;
net2 = perceptron;
% ----------------------------------------------------
% Establecemos como se segmenta el cojunto del dataset.
% ----------------------------------------------------
net1.divideParam.trainRatio = 70/100; % Conjunto de trait x1.
net1.divideParam.valRatio   = 15/100; % Conjunto de validacion x1.
net1.divideParam.testRatio  = 15/100; % Conjunto de test x1.

net2.divideParam.trainRatio = 70/100; % Conjunto de trait x2.
net2.divideParam.valRatio   = 15/100; % Conjunto de validacion x2.
net2.divideParam.testRatio  = 15/100; % Conjunto de test x2.

% ----------------------------------------------------
% Entrenamos el perceptron.
% ----------------------------------------------------
[net1, tr1] = train(net1, x1, t1);
[net2, tr2] = train(net2, x2, t2);

% ----------------------------------------------------
% Mostramos la grafica del conjunto de entrenamiento.
% ----------------------------------------------------
figure;
hold on;
subplot(1, 2, 1), plotpv(x1, t1), plotpc(net1.IW{1}, net1.b{1}), title('Vector de clasificacion (origin date)');
subplot(1, 2, 2), plotpv(x2, t2), plotpc(net2.IW{1}, net2.b{1}), title('Vector de clasificacion (add date)');
hold off;
disp('pulse una tecla para continuar...');
pause;
close;
clear;
clc;