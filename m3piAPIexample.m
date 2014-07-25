clear all
close all
clc

% %fclose(instrfind);
r = m3pi('/dev/ttyUSB0', 9600, ['40';'AE';'BB';'10']);

r.connect();

% r.stop();

left = 0.1;
right= -0.1;
r.sendSpeedLR(left, right);
pause(0.5)

v = .1;
w = .1;
r.sendSpeed(v, w);
pause(0.5)
r.stop();

v = .1;
w = -.1;
r.sendSpeed(v, w);
pause(0.5)
r.stop();

r.stop();

r.disconnect();
