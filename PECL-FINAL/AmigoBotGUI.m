function varargout = AmigoBotGUI(varargin)
% AMIGOBOTGUI MATLAB code for AmigoBotGUI.fig
%      AMIGOBOTGUI, by itself, creates a new AMIGOBOTGUI or raises the existing
%      singleton*.
%
%      H = AMIGOBOTGUI returns the handle to a new AMIGOBOTGUI or the handle to
%      the existing singleton*.
%
%      AMIGOBOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AMIGOBOTGUI.M with the given input arguments.
%
%      AMIGOBOTGUI('Property','Value',...) creates a new AMIGOBOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AmigoBotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AmigoBotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AmigoBotGUI

% Last Modified by GUIDE v2.5 10-Jan-2019 11:27:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AmigoBotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AmigoBotGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AmigoBotGUI is made visible.
function AmigoBotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AmigoBotGUI (see VARARGIN)

% Choose default command line output for AmigoBotGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AmigoBotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AmigoBotGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================================================================
    set(handles.stop, 'Enable', 'on');   % Habilitamos el boton de parada.
    set(handles.start, 'Enable', 'off'); % Desabilitamos el boton de inicio.
    is_simulate = handles.simulador.Value;
    % -----------------------------------------------------------------
    %%                  DECLARACIÓN DE SUBSCRIBERS
    % -----------------------------------------------------------------
    switch is_simulate
        case 0
            o_sub_topic = '/pose';           % Topic robot real.
            l_sub_topic = '/scan';    % Topic laser robot real.
        case 1
            o_sub_topic = '/robot0/odom';    % Topic robot simulador.
            l_sub_topic = '/robot0/laser_1'; % Topic laser robot simulador.
    end
    odom  = rossubscriber(o_sub_topic);      % Subscripción a la odometría
    laser = rossubscriber(l_sub_topic, rostype.sensor_msgs_LaserScan);
    % ------------------------------------------------------------------
    % Incialzacion del sonar.
    % ------------------------------------------------------------------
    num_sonar         = 6;
    sonars{num_sonar} = {};
    robot_topic       = {'', '/robot0'};
    for i = 1 : num_sonar
        sonar_id  = sprintf('%s/sonar_%d', robot_topic{(is_simulate + 1)}, (i - 1));
        sonars{i} = rossubscriber(sonar_id, rostype.sensor_msgs_Range);
    end
    % -------------------------------------------------------------------
    %%                      DECLARACIÓN DE PUBLISHERS
    % -------------------------------------------------------------------
    topic_id  = sprintf('%s/cmd_vel', robot_topic{(is_simulate + 1)});
    pub = rospublisher(topic_id, 'geometry_msgs/Twist');
    if (is_simulate == 0)
        pub_enable = rospublisher('/cmd_motor_state', 'std_msgs/Int32'); % Para el robot real 
    end
    % -------------------------------------------------------------------
    %%                        GENERACIÓN DE MENSAJE
    % -------------------------------------------------------------------
    msg = rosmessage(pub);      % Creamos un mensaje del tipo declarado en "pub" (geometry_msgs/Twist)
    if (is_simulate == 0)
        msg_enable_motor  = rosmessage(pub_enable);
    end
    % msg_laser                = rosmessage(laser);
    msg_sonars{1, num_sonar} = {};
    for i = 1 : num_sonar 
        msg_sonars{1, i} = rosmessage(sonars{1, i});
    end
    % -------------------------------------------------------------------
    %%                  Cargamos el controladores borrosos
    % -------------------------------------------------------------------
    opc = handles.selct_ctr.Value;
    switch (opc)
        case 1
            path_ctrl_vel = './controller/fuzzy/anfisV2_4IN.fis';
            path_ctrl_ang = './controller/fuzzy/anfisWDD_4IN.fis';
        case 2
            path_ctrl_vel = './controller/neuro/vel_lin_1-4.fis';
            path_ctrl_ang = './controller/neuro/vel_angu_1-4.fis';
        case 3
            path_ctrl_vel = './controller/neuro/vel_lin_1234h.fis';
            path_ctrl_ang = './controller/neuro/vel_angu_1234h.fis';
        case 4
            path_ctrl_vel = './controller/neuro/vel_lin_0145.fis';
            path_ctrl_ang = './controller/neuro/vel_angu_0145.fis';
        case 5
            path_ctrl_vel = './controller/neuro/vel_lin_012345.fis';
            path_ctrl_ang = './controller/neuro/vel_angu_012345.fis';
    end
    fismat_vel = readfis(path_ctrl_vel);
    fismat_ang = readfis(path_ctrl_ang);
    % -------------------------------------------------------------------
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
    % --------------------------------------------------------------------
    send(pub,msg);          % Enviamos los mensajes.
    if (is_simulate == 0)
        % -----------------------------------------
        % Para el robot real activamos los motores 
        % enviando enable_motor = 1
        % -----------------------------------------
        msg_enable_motor.Data = 1;
        send(pub_enable, msg_enable_motor);
    end
    r = robotics.Rate(10);  % Definimos la periodicidad del bucle (10 hz).
    % --------------------------------------------------------------------
    % Nos aseguramos recibir un mensaje relacionado con el robot
    % --------------------------------------------------------------------
    robot_topic = {'base_link', 'robot0'};
    
    while (strcmp(odom.LatestMessage.ChildFrameId, robot_topic{(is_simulate + 1)}) ~= 1)
        odom.LatestMessage
    end
    % --------------------------------------------------------------------
    %%      Bucle de control finaliza al pulsar el botton parar.
    % --------------------------------------------------------------------
    distance   = zeros(1, num_sonar);
    aux_labels = {handles.tx_in0, handles.tx_in1, handles.tx_in2, handles.tx_in3, handles.tx_in4, handles.tx_in5};
    try 
        while (1)
            % --------------------------------------------------------
            %Obtenemos la lectura de los sonares y el laser
            % --------------------------------------------------------
            % msg_laser = receive(laser);       
            for j = 1 : length(sonars)
                msg_sonars{1, j} = receive(sonars{1, j});
                % ---------------------------------------------------
                % Distancia medida por el sonar i
                % ---------------------------------------------------
                distance(1, j) = double(msg_sonars{1, j}.Range_);
                if (isinf(distance(1, j)))
                    if (distance(1, j) > 0)
                        distance(1, j) = 5.0;
                    else
                        distance(1, j) = 0.1;
                    end
                end
            end
            d0 = distance(1, 1);
            d1 = distance(1, 2);
            d2 = distance(1, 3);
            d3 = distance(1, 4);
            d4 = distance(1, 5);
            d5 = distance(1, 6);
            switch (opc)
                case 1
                    input_dist = [d2, d3, d1 - d4, d0 - d5];
                case 2
                    input_dist = [d1, d4];
                case 3
                    input_dist = [d1, d2, d3, d4];
                case 4
                    input_dist = [d0, d1, d4, d5];
                case 5
                    input_dist = [d0, d1, d2, d3, d4, d5];
            end   
            % ------------------------------------------------------------
            % Obtencion de la velocidad lineal y angular a partir de los 
            % controladores borrosos.
            % ------------------------------------------------------------
            msg.Angular.Z = evalfis(fismat_ang, input_dist);
            msg.Linear.X  = evalfis(fismat_vel, input_dist);    
%             if (msg.Linear.X < 0.1)
%                 msg.Linear.X = 0.05;
%             end
%             if (msg.Angular.Z > 0) && (msg.Angular.Z < 0.01)
%                 msg.Angular.Z = 0.0;
%             elseif (msg.Angular.Z < 0) && (msg.Angular.Z > -0.01)
%                 msg.Angular.Z = 0.0;
%             end
            send(pub, msg);         % Envio de la velocidad angular y lineal
            if isappdata(handles.figure1,'stop_bot')
                msg.Linear.X  = 0;
                msg.Angular.Z = 0;
                send(pub, msg);     % Envio de la velocidad angular y lineal
                break
            else
                disp([input_dist, msg.Linear.X, msg.Angular.Z]);
                for i = 1 : length(input_dist)
                    set(aux_labels{i},  'String', num2str(input_dist(i), 4));
                end
                set(handles.tx_vl,  'String', num2str(msg.Linear.X));
                set(handles.tx_va,  'String', num2str(msg.Angular.Z));
                waitfor(r);         % Temporizacion del bucle segun el valor de r 
            end
        end
        % --------------------------------------------------------------------
        %%                      DESACTIVACION DE LOS MOTORES 
        % --------------------------------------------------------------------
        if (is_simulate == 0)
            % -----------------------------------------
            % Para el robot real desactivamos los moto-
            % res enviando enable_motor = 0.
            % -----------------------------------------
            msg_enable_motor.Data = 1;
            send(pub_enable, msg_enable_motor);
        end
    catch
        hist_items = handles.hist.String;
        msg_stop   = " - Se Perdio la conexion con el Robot.";   
        if ~isempty(hist_items)
            hist_items = cat(1, hist_items, {msg_stop});
        else
            hist_items = {msg_stop};
        end
        set(handles.hist, "String", hist_items);  
    end
    set(handles.start, 'Enable', 'on');    % Habilitamos el boton de inicio.
    set(handles.stop, 'Enable', 'off');    % Desabilitamos el boton de parada.
    rmappdata(handles.figure1,'stop_bot'); % Borramos el atributo de parada   
    guidata(hObject, handles);             % Update handles structure
% ========================================================================

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================================================================
    hist_items = handles.hist.String;
    msg_stop   = " - Paradado la ejecucion del Robot.";
    setappdata(handles.figure1,'stop_bot',1);    
    if ~isempty(hist_items)
        hist_items = cat(1, hist_items, {msg_stop});
    else
        hist_items = {msg_stop};
    end
    set(handles.hist, "String", hist_items); 
    guidata(hObject, handles);                % Update handles structure
% ========================================================================

% --- Executes on button press in shutdown.
function shutdown_Callback(hObject, eventdata, handles)
% hObject    handle to shutdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================================================================
    rosshutdown;
    set(handles.start,    'Enable', 'off');
    set(handles.shutdown, 'Enable', 'off');
    disable_elem = {handles.connect, handles.ip_host, handles.ip_bot};
    for i = 1 : length(disable_elem)
        set(disable_elem{i}, 'Enable', 'on');
    end
    msg_shut   = " - Se cerro la conexion con ROS.";
    hist_items = handles.hist.String;
    if ~isempty(hist_items)
        hist_items = cat(1, hist_items, {msg_shut});
    else
        hist_items = {msg_shut};
    end
    set(handles.hist, "String", hist_items); 
% ========================================================================

% --- Executes during object creation, after setting all properties.
function hist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%% ========================================================================
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
% ========================================================================


function ip_host_Callback(hObject, eventdata, handles)
% hObject    handle to ip_host (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================================================================
    contents = get(hObject,'String'); % returns contents of ip_host as text
    if (~isempty(contents))
        index   = handles.ip_host.Value;
        ip_host = contents{index};
        setenv('ROS_IP', ip_host);      % La IP HOST.
    end
% ========================================================================

% --- Executes during object creation, after setting all properties.
function ip_host_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ip_host (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%% ========================================================================
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    if ismac  || isunix
        [~, result]  = system('ifconfig | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"');
    elseif ispc
        [~, result]  = system('ipconfig | findstr /r "IPv4.*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"');
		result       = replace(result,'   Direcci\u00F3n IPv4. . . . . . . . . . . . . . : ','');
    else
        disp('Platform not supported')
    end
    match_carrie = cat(2, [0], regexp(result, '[\n]'));
    lenght_ip    = length(match_carrie);
    if  (lenght_ip > 1)
        ip_host{lenght_ip - 1} = {};
        for i = 1 : (length(match_carrie) - 1)
            ip_host{i} = extractBetween(string(result), match_carrie(i) + 1, (match_carrie(i + 1) - 1));
        end
        set(hObject,"String", ip_host);
    end
% ========================================================================

function ip_bot_Callback(hObject, eventdata, handles)
% hObject    handle to ip_bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================================================================
    ip_bot = get(hObject,'String'); % returns contents of ip_bot as text
    if (length(ip_bot) ~= 0) 
        url_bot = sprintf("http://%s:11311", ip_bot);
        setenv('ROS_MASTER_URI', url_bot); % La IP MV.
    end 
% ========================================================================

% --- Executes during object creation, after setting all properties.
function ip_bot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ip_bot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%% ========================================================================
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
% ========================================================================


% --- Executes on button press in ed_ctrl.
function ed_ctrl_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ctrl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================================================================
    opc = handles.selct_ctr.Value;
    switch (opc)
        case 1
            fuzzy ./controller/fuzzy/anfisWDD_4IN.fis;
            fuzzy ./controller/fuzzy/anfisV2_4IN.fis;
        case 2
            anfisedit ./controller/neuro/vel_lin_1-4.fis;
            anfisedit ./controller/neuro/vel_angu_1-4.fis;
        case 3
            anfisedit ./controller/neuro/vel_lin_1234h.fis;
            anfisedit ./controller/neuro/vel_angu_1234h.fis;
        case 4
            anfisedit ./controller/neuro/vel_lin_0145.fis;
            anfisedit ./controller/neuro/vel_angu_0145.fis;
        case 5
            anfisedit ./controller/neuro/vel_lin_012345.fis;
            anfisedit ./controller/neuro/vel_angu_012345.fis;
    end
% ========================================================================

% --- Executes during object creation, after setting all properties.
function selct_ctr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selct_ctr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%% =======================================================================
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    select_ctrl = {"Mandani 4 IN {S2, S3, S1 - S4, S0 - S5}", "Sugeno 2 IN {S1, S4}", "Sugeno 4 IN {S1 al S4}", "Sugeno 4 IN {S0, S1, S4 y S3}", "Sugeno 6 IN {S0 al S5}"};
    set(hObject,"String", select_ctrl);
% ========================================================================

% --- Executes on button press in connect.
function connect_Callback(hObject, eventdata, handles)
% hObject    handle to connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ========================================================================
    hist_items = handles.hist.String;
    global msg_com;
    try
        rosinit();  % Inicializacion de ROS en la IP correspondiente
        set(handles.shutdown,'Enable','on');
        set(handles.start,   'Enable','on');
        disable_elem = {handles.connect, handles.ip_host, handles.ip_bot};
        for i = 1 : length(disable_elem)
            set(disable_elem{i}, 'Enable', 'off');
        end
        msg_com = ' - Conexion establecida con ROS.';
    catch ex
        shutdown_Callback(hObject, eventdata, handles);
        if (strcmp(ex.identifier,'robotics:ros:node:GlobalNodeRunningError'))
            connect_Callback(hObject, eventdata, handles);
        else
            msg_com = ' - Error al establecer la Conexion con ROS.';
            rethrow(ex); 
        end
    end
    if ~isempty(hist_items)
        hist_items = cat(1, hist_items, {msg_com});
    else
        hist_items = {msg_com};
    end
    set(handles.hist, "String", hist_items); 
% ========================================================================
