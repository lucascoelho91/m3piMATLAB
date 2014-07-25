% Close all existing ports (in case it was improperly closed) 

%fclose(instrfind); 

clear all
close all
clc

speedL = 0.2;
speedW = 0.2;

% %fclose(instrfind);
r = m3pi('/dev/ttyUSB0', 9600, ['40';'AE';'BB';'10']);

r.connect();
%Print a command

c = 0;
while(c ~= 'p')
    c = getkey();
    if c == 'w'
        r.sendSpeed(speedL, 0);
    elseif c == 'a'
        r.sendSpeed(0, speedW);
    elseif c == 's'
        r.sendSpeed(-speedL, 0);
    elseif c == 'd'
        r.sendSpeed(0, -speedW);
    elseif c == 'x'
        r.stop();
    elseif c == 't'
        speedL = speedL*1.1
    elseif c == 'g'
        speedL = speedL*0.9
    elseif c == 'c'
        speedW = speedW*1.1
    elseif c == 'v'
        speedW = speedW*0.9
    end
end
        
r.stop();
r.disconnect();
fclose(instrfind);        