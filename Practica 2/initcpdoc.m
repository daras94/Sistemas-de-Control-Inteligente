% INITCPDC Initialize variables in the demo pendinvdoc.slx
%   Copyright 1994-2000 The MathWorks, Inc. 
%       $Revision: 1.8 $
clear all;
global AnimCpFigH;
global AnimCpAxisH;
winName = bdroot(gcs);
fprintf('Initializing ''fismatrix'' in %s...\n', winName);
penduloinvdoc = readfis('penduloinvdoc.fis');
fismatrix = penduloinvdoc;
fprintf('Done with initialization.\n');
