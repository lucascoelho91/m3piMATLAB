fclose(instrfind);
r = m3pi('/dev/ttyUSB0', 9600, ['40';'AE';'BB';'10']);

r.connect();

r.stop();
r.disconnect();
fclose(instrfind);
