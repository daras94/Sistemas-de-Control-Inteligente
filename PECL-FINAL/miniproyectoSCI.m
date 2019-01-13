function miniproyectoSCI()
    %% DECLARACIÓN DE SUBSCRIBERS
    % ========================================================================
    odom = rossubscriber('/robot0/odom');                           % Subscripción a la odometría

    % Para el robot real
    % ------------------------------------------------------------------------
    % odom  = rossubscriber('/pose');                               % Subscripci�n a la odometr�a
    laser = rossubscriber('/robot0/laser_1', rostype.sensor_msgs_LaserScan);
    %laser = rossubscriber('/robot0/scan', rostype.sensor_msgs_LaserScan);

    % Incialzacion del sonar.
    % ------------------------------------------------------------------------
    num_sonar         = 6;
    sonars{num_sonar} = {};
    for i = 1 : num_sonar
        sonar_id  = sprintf('/robot0/sonar_%d', (i - 1));
        sonars{i} = rossubscriber(sonar_id, rostype.sensor_msgs_Range);
    end

    %% DECLARACIÓN DE PUBLISHERS
    % ========================================================================
    pub = rospublisher('/robot0/cmd_vel', 'geometry_msgs/Twist');      %
    % pub_enable = rospublisher('/cmd_motor_state', 'std_msgs/Int32'); % Para el robot real 
    
    %% GENERACIÓN DE MENSAJE
    % ========================================================================
    msg = rosmessage(pub);                                             %% Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)
                                                                       %  Rellenamos los campos del mensaje para que el robot avance a 0.2 m/s
    % msg_enable_motor      = rosmessage(pub_enable);
    msg_laser                = rosmessage(laser);
    msg_sonars{1, num_sonar} = {};
    for i = 1 : num_sonar 
        msg_sonars{1, i} = rosmessage(sonars{1, i});
    end
    %% ===================================================================
    % Lectura de los controladores borrosos
    % ====================================================================
    fismat_vel = readfis('./controller/fuzzy/anfisV2_4IN.fis');              % Controlador de velocidad lineal
    fismat_ang = readfis('./controller/fuzzy/anfisWDD_4IN.fis');              % Controlador de velocidad angular

    %% Rellenamos los campos del mensaje para que el robot avance a 0.2 m/s
    %
    % Velocidades lineales en x,y y z (velocidades en y o z no se usan en 
    % robots diferenciales y entornos 2D).
    % -------------------------------------------------------------------
    msg.Linear.X = 0;
    msg.Linear.Y = 0;
    msg.Linear.Z = 0;

    % Velocidades angulares (en robots diferenciales y entornos 2D solo se 
    % utilizará el valor Z)
    % --------------------------------------------------------------------
    msg.Angular.X = 0;
    msg.Angular.Y = 0;
    msg.Angular.Z = 0;

    send(pub,msg);

    % Para el robot real
    % Activaci�n de los motores enviando enable_motor = 1
    % msg_enable_motor.Data=1;
    % send(pub_enable,msg_enable_motor);

    %% ===================================================================
    % Definimos la periodicidad del bucle (10 hz)
    % ====================================================================
    r = robotics.Rate(10);

    %% ===================================================================
    % Nos aseguramos recibir un mensaje relacionado con el robot "robot0"
    % ====================================================================
    while (strcmp(odom.LatestMessage.ChildFrameId,'robot0') ~= 1)
        % Para el robot real
        % while (strcmp(odom.LatestMessage.ChildFrameId,'base_link')~=1)
        odom.LatestMessage
    end
    
    %% ===================================================================
    % Inicializamos la primera posición (coordenadas x,y,z)
    %  ===================================================================
    initpos = odom.LatestMessage.Pose.Pose.Position;
    lastpos = initpos;

    %% -----------------------------------------------------------
    % Bucle de control infinito
    % ------------------------------------------------------------
    distance = zeros(1, num_sonar);
    while (1)
        pos = odom.LatestMessage.Pose.Pose.Position;
        % --------------------------------------------------------
        %Obtenemos la lectura de los sonares y el laser
        % --------------------------------------------------------
        msg_laser = receive(laser);       
        for j = 1 : length(sonars)
            msg_sonars{1, j} = receive(sonars{1, j});
            % ---------------------------------------------------
            % Distancia medida por el sonar i
            % ---------------------------------------------------
            distance(1, j) = double(msg_sonars{1, j}.Range_);
            if (isinf(distance(1, j)))
                if (distance(1, j) > 0)
                    distance(1, j) = 5;
                else
                    distance(1, j) = 0.1;
                end
            end
        end
        d2 = distance(1, 3);
        d3 = distance(1, 4);
        in_c1 = distance(1, 2) - distance(1, 5);
        in_c2 = distance(1, 1) - distance(1, 6);   
    
        % ------------------------------------------------------------
        % Obtencion de la velocidad lineal y angular a partir de los 
        % controladores borrosos.
        % ------------------------------------------------------------
        msg.Angular.Z = evalfis(fismat_ang, [d2, d3, in_c1, in_c2]);
        msg.Linear.X  = evalfis(fismat_vel, [d2, d3, in_c1, in_c2]);    
%         if (msg.Linear.X < 0.1)
%             msg.Linear.X = 0.05;
%         end
%         if (msg.Angular.Z > 0) && (msg.Angular.Z < 0.01)
%             msg.Angular.Z = 0.0;
%         elseif (msg.Angular.Z < 0) && (msg.Angular.Z > -0.01)
%             msg.Angular.Z = 0.0;
%         end
        disp([d2, d3, in_c1, in_c2, msg.Linear.X, msg.Angular.Z]);
        send(pub, msg);                                  % Envio de la velocidad
        waitfor(r);                                      % Temporizaci�n del bucle seg�n el par�metro establecido en r
    end
    %% DESACTIVACI�N DE LOS MOTORES
    %   Desactivar motores enviando enable_motor = 0
    %  ===================================================================
%     msg_enable_motor.Data = 0;
%     send(pub_enable,msg_enable_motor);
end