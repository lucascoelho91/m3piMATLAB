fclose(instrfind);
r = m3pi('/dev/ttyUSB0', 9600, ['40';'AE';'BB';'10']);

r.connect();
r.sendSpeed(0.44,0.02);
pause(0.2);
r.stop();
r.disconnect();
fclose(instrfind);


r = m3pi('/dev/ttyUSB0', 9600, ['40';'AD';'59';'34']);
r.connect();

r.sendSpeed(0.44,0.02);
pause(0.2);
r.stop();
r.disconnect();
fclose(instrfind);