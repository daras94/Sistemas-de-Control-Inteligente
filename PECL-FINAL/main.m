clear all;
while 1
    disp('*******************************************************');
    disp('* 1 - Start MiniProyectoSCI                           *');
    disp('* 2 - Open Fuzzy Designed (Velocidad Angular).        *');
    disp('* 3 - Open Fuzzy Designed (Velocidad Lineal).         *');
    disp('*******************************************************');
    op = input(' - Selecione una opcion o pulse 0 para salir: ');
    switch op
        case 1
            while 1
               try
                    %% ==================================================
                    %              { INICIALIZACIÓN DE ROS }
                    %  ==================================================
                    setenv('ROS_MASTER_URI','http://192.168.1.132:11311'); % La IP MV.
                    setenv('ROS_IP','192.168.1.128');                      % La IP HOST.
                    rosinit();                                             % Iniciamos ROS.                          
                                                                           % Inicializacion de ROS en la IP correspondiente
                    miniproyectoSCI();
               catch ex
                   if (strcmp(ex.identifier,'robotics:ros:node:GlobalNodeRunningError'))
                       miniproyectoSCI() 
                   else
                       %% ==============================================
                       %               { DESCONEXIÓN DE ROS }
                       %  ==============================================
                       rosshutdown;
                       %%
                       rethrow(ex);
                       break;
                   end
               end
            end
        case 2
            fuzzy ./controller/fuzzy/anfisWDD_4IN.fis;
        case 3
            fuzzy ./controller/fuzzy/anfisV2_4IN.fis;
        otherwise
            if (op == 0)
                break;
            else 
                disp(' - Error opcion invalida pulse una tecla para continuar...');
                pause;
            end
            clc;
    end 
end
disp('Salistes del del la apliaccion de forma normal y no a lo vestia.');