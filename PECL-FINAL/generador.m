%Generate neuroboroso entradas
%vel_lin(:,1) = training(:,3);
%vel_lin(:,2) = training(:,4);
%vel_lin(:,3) = training(:,2) - training(:,5);
%vel_lin(:,4) = training(:,1) - training(:,6);
%vel_lin(:,5) = training(:,9);
training_data

vel_lin(:,1) = training(:,1);
vel_lin(:,2) = training(:,2);
vel_lin(:,3) = training(:,3);
vel_lin(:,4) = training(:,4);
vel_lin(:,5) = training(:,5);
vel_lin(:,6) = training(:,6);
%vel_lin(:,7) = training(:,7);
%vel_lin(:,8) = training(:,8);
vel_lin(:,7) = training(:,9);

vel_angu(:,1) = training(:,1);
vel_angu(:,2) = training(:,2);
vel_angu(:,3) = training(:,3);
vel_angu(:,4) = training(:,4);
vel_angu(:,5) = training(:,5);
vel_angu(:,6) = training(:,6);
%vel_angu(:,7) = training(:,7);
%vel_angu(:,8) = training(:,8);
vel_angu(:,7) = training(:,10);
%vel_angu(:,1) = vel_lin(:,1);
%vel_angu(:,2) = vel_lin(:,2);
%vel_angu(:,3) = vel_lin(:,3);
%vel_angu(:,4) = vel_lin(:,4);
%vel_angu(:,5) = training(:,10);