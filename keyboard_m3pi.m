% Close all existing ports (in case it was improperly closed) 

%fclose(instrfind); 

clear all
close all
clc

speedL = 0.2;
speedW = 0.2;

% %fclose(instrfind);
r = m3pi('/dev/ttyUSB1', 9600, ['40';'AE';'BB';'10']);
r2 = m3pi('/dev/ttyUSB1', 9600, ['40';'AD';'59';'34']);


r.connect();

r2.setSerialPort(r.serialPort);


%Print a command

c = 0;
while(c ~= 'p')
    c = getkey();
    if c == 'w'
        r.sendSpeed(speedL, 0);
        r2.sendSpeed(speedL, 0);
    elseif c == 'a'
        r.sendSpeed(0, speedW);
        r2.sendSpeed(0, speedW);
    elseif c == 's'
        r.sendSpeed(-speedL, 0);
        r2.sendSpeed(-speedL, 0);
    elseif c == 'd'
        r.sendSpeed(0, -speedW);
        r2.sendSpeed(0, -speedW);
    elseif c == 'x'
        r.stop();
        r2.stop();
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
        
r2.stop();
r2.disconnect();
fclose(instrfind);        