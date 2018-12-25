function miniproyectoSCI()
    %% DECLARACIÓN DE SUBSCRIBERS
    % ========================================================================
    odom = rossubscriber('/robot0/odom');                           % Subscripción a la odometría

    % Para el robot real
    % ------------------------------------------------------------------------
    % odom  = rossubscriber('/pose');                               % Subscripci�n a la odometr�a
    % laser = rossu
    % bscriber('/robot0/laser_1', rostype.sensor_msgs_LaserScan);
    % laser = rossubscriber('/robot0/scan', rostype.sensor_msgs_LaserScan);

    % Incialzacion del sonar.
    % ------------------------------------------------------------------------
    num_sonar         = 8;
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
    % msg_laser             = rosmessage(laser);
    msg_sonars{1, num_sonar} = {};
    for i = 1 : num_sonar 
        msg_sonars{1, i} = rosmessage(sonars{1, i});
    end
    %% ===================================================================
    % Lectura de los controladores borrosos
    % ====================================================================
    % fismatV = readfis('./controller/fuzzy/anfisV2.fix');                % Controlador de velocidad lineal
    fismatW = readfis('./controller/fuzzy/anfisWDD.fis');                 % Controlador de velocidad angular

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
        for j = 1 : length(sonars)
            msg_sonars{1, j} = receive(sonars{1, j});
            % ---------------------------------------------------
            % Distancia medida por el sonar i
            % ---------------------------------------------------
            distance(1, j) = double(msg_sonars{1, j}.Range_);
            if (isinf(distance(1, j)))
                distance(1, j) = 5.0;
            end
        end
%         d1 = distance(1, 2);
%         d4 = distance(1, 5);
        % ------------------------------------------------------------
        % Obtencion de la velocidad lineal y angular a partir de los 
        % controladores borrosos.
        % ------------------------------------------------------------
        vel_lineal = 0.2; % evalfis([d1 d4], fismatV);
        vel_ang    = evalfis(distance, fismatW);
        if (vel_lineal < 0.1)
            msg.Linear.X = 0.05;
        else
            msg.Linear.X = vel_lineal;
        end
        if (vel_ang > 0) && (vel_ang < 0.01)
            msg.Angular.Z = 0.0;
        elseif (vel_ang < 0) && (vel_ang > -0.01)
            msg.Angular.Z = 0.0;
        else
            msg.Angular.Z = vel_ang;
        end
        disp([distance, msg.Linear.X, msg.Angular.Z]);
        send(pub, msg);                                  % Envio de la velocidad
        waitfor(r);                                      % Temporizaci�n del bucle seg�n el par�metro establecido en r
    end
    %% DESACTIVACI�N DE LOS MOTORES
    %   Desactivar motores enviando enable_motor = 0
    %  ===================================================================
    % msg_enable_motor.Data = 0;
    % send(pub_enable,msg_enable_motor);
end