%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                   APROXIMACIÓN DE FUNCIONES : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; 
close all;
% =============================================================
%       DEFINICIÓN DE LOS VECTORES DE ENTRADA-SALIDA 
% =============================================================
t = -3 : 0.1 : 3; % eje de tiempo
F = sinc(t) + 0.001 * randn(size(t)); % función que se desea aproximar

% =============================================================
%                   DISEÑO DE LA RED 
% =============================================================
hiddenLayerSize = input('Introduca el numero de neuronas de la capa oculta :');
global alg_train;
while 1
    disp('***********************************************************************');
    disp('* 1 - (trainrp):  Resilient Backpropagation.                          *');
    disp('* 2 - (traingd):  Descenso por el gradiente.                          *');
    disp('* 3 - (traingdm): Descenso por el gradiente con inercia.              *');
    disp('* 4 - (traingdx): Aprendizaje variable velocidad gradiente pendiente. *');
    disp('***********************************************************************');
    op = input('Selecione un algorimo de entrenamiento (EJ 1): ');
    switch op
        case 1
            alg_train = 'trainrp';
            break;
        case 2
            alg_train = 'traingd';
            break
        case 3
            alg_train = 'traingdm';
            break;
        case 4
            alg_train = 'traingdx';
            break;
        otherwise
            disp(' - Error opcion invalida pulse una tecla pra continuar...');
            pause;
            clc;
    end 
end
net                        = fitnet(hiddenLayerSize, alg_train);
net.divideParam.trainRatio = 70/100; 
net.divideParam.valRatio   = 15/100; 
net.divideParam.testRatio  = 15/100;
net                        = train(net, t, F); 
Y                          = net(t);
% =============================================================
%                   Representacion grafica. 
% =============================================================
plot(t, F, '+'), title('Vectores de entrenamiento'); 
xlabel('Vector de entrada P'); 
ylabel('Vector Tsrget T');
plot(t,F,'+'); 
hold on; 
plot(t,Y,'-r'); 
hold off; 
title('Vectores de entrenamiento'); 
xlabel('Vector de entrada P'); 
ylabel('Vector Target T');