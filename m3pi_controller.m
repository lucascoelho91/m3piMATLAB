%% m3pi + optitrack + controller

clear all; close all; clc;
%% Set optitrack
frame = 'XYZ+ Plane';
opti = optiTrackSetup(3000);
%fclose(instrfind);
%% create robot instance
r = m3pi('/dev/ttyUSB0', 9600, ['40';'AE';'BB';'10']);

% maybe you will need to run this >> fclose(instrfind)
%r.connect();

%% Create controller instance
kv = 0.4;
kw = 0.005;
d = 0.05;
tol = 0.1;

controller = m3piController(r, kv, kw, d, tol);

%% List of goals
goals = [[ 0.5, 0.7 ]; [0.3, 0.4]; [0.7, 0.6]; [0.1, 0.1]];

controller.setGoal(goals(1, 1), goals(1, 2));
ngoals = size(goals);
ngoals = ngoals(1);

opti = readOptitrack(opti,frame);

controller.setPose(opti.pose(1, 1), opti.pose(2, 1), opti.pose(6, 1));

figure
h = plot(opti.pose(1, 1), opti.pose(2, 1),'Marker', 'o', 'MarkerSize', 15);
hold on
h2 = plot(goals(1, 1), goals(1, 2), 'Marker', '+', 'Color', 'r');
axis([-5 5 -5 5]);
grid on
drawnow;
j=0;
%% Goals Loop
for i=1:ngoals
    controller.setGoal(goals(i, 1), goals(i, 2));
    set(h2, 'XData', goals(i, 1), 'YData', goals(i, 2)); 
    drawnow;
    %% Position Loop
    while(controller.goalReached() == 0)
        
        controller.controlSpeed();
        opti = readOptitrack(opti,frame);
        controller.setPose(opti.pose(1, 1), opti.pose(2, 1),  opti.pose(6,1));
        
        j = j+1;
        
        if(j>20)
            fprintf('x: %1.2f  y: %1.2f  ang: %3.2f v: %1.2f  w: %1.2f\n', opti.pose(1, 1), opti.pose(2, 1), wrapToPi(opti.pose(6, 1)), controller.vlinear, controller.wangular);
            set(h, 'XData', opti.pose(1,1),'YData',opti.pose(2,1)); 
            drawnow;
            j=0;
        end
    end
end

%% End 
r.stop();
r.disconnect();
