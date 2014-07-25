% Close all existing ports (in case it was improperly closed) 

%fclose(instrfind); 

clear all
close all
clc

speedL = 0.1;
speedW = 0.2;

% %fclose(instrfind);
r = m3pi('/dev/ttyUSB0', 9600, ['40';'AE';'BB';'10']);

r.connect();
%Print a command

while (1)
    v = input('v: ');
    if isempty(v)
        break
    end
    w = input('w: ');
    if isempty(w)
        break
    end
    v
    w
    r.sendSpeed(v, w);
end


r.stop();
r.disconnect();
fclose(instrfind);  