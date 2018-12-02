clear all; 
close all;
% =============================================================
%       Carga de datos de ejemplo disponibles en la toolbox
% =============================================================
global inputs;
global targets;
while 1
    disp('*******************************************');
    disp('* 1 - Dataset -> (simpleclass_dataset).   *');
    disp('* 2 - Dataser -> (bodyfat_dataset).       *');
    disp('*******************************************');
    op = input('Selecione el dataset a usar (EJ 1): ');
    switch op
        case 1
            [inputs, targets] = simpleclass_dataset;
            break;
        case 2
            [inputs, targets] = bodyfat_dataset;
            break;
        otherwise
            disp(' - Error opcion invalida pulse una tecla pra continuar...');
            pause;
            clc;
    end 
end
% =============================================================
% Creción de una red neuronal para el reconocimiento de patrones
% =============================================================
hiddenLayerSize = 10;
global alg_train;
while 1
    disp('***********************************************************************');
    disp('* 1 - (trainrp):  Resilient Backpropagation.                          *');
    disp('* 2 - (traingdx): Aprendizaje variable velocidad gradiente pendiente. *');
    disp('***********************************************************************');
    op = input(' - Selecione un algorimo de entrenamiento (EJ 1, pulse intro por defecto): ');
    if isempty(op)
        alg_train = 'trainlm';
        break;
    else 
       switch op
            case 1
                alg_train = 'trainrp';
                break;
            case 2
                alg_train = 'traingdx';
                break;
            otherwise
                disp(' - Error opcion invalida pulse una tecla pra continuar...');
                pause;
                clc;
        end  
    end
end
net = fitnet(hiddenLayerSize, alg_train);
% =============================================================
% División del conjunto de datos para entrenamiento, validación 
% y test
% =============================================================
while 1
    dic_conj = zeros(1, 3);
    aux_pron = [" entrenamiento: " " validacion: " " test: "];
    for x = 1:3
        pront_input = strcat(' - Introduca el % del conjunto de datos para', aux_pron(x));
        dic_conj(x) = input(pront_input);
    end
    aux_sum = dic_conj(1) + dic_conj(2) + dic_conj(3);
    if (aux_sum == 100)
        net.divideParam.trainRatio = dic_conj(1)/100; 
        net.divideParam.valRatio   = dic_conj(2)/100; 
        net.divideParam.testRatio  = dic_conj(3)/100;
        break;
    else
        disp(' - Error los % para los conjuntos de entrenamiento, validación y test tiene que formal el 100%, pulse una tecla para continuar...');
        pause;
        clc;
    end
end
% =============================================================
%                   Entrenamiento de la red
% =============================================================
[net,tr]    = train(net, inputs, targets);
% =============================================================
%                           Prueba
% =============================================================
outputs     = net(inputs);
errors      = gsubtract(targets, outputs); 
performance = perform(net, targets, outputs);
% =============================================================
%                        Visualización
% =============================================================
view(net);

