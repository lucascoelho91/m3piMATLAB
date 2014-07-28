%% m3pi + optitrack + controller

clear all; close all; clc;
%% Set optitrack
frame = 'XYZ+ Plane';
opti = optiTrackSetup(3000);


%% constants
n = 2;         % number of robots
ngoals = 4;    % number of goals

kv = 0.4;      % linear constant
kw = 0.005;    % angular constant
d = 0.05;      % distance for the point offset controller
tol = 0.2;     % minimal distance to the point

%fclose(instrfind);

goals = zeros(ngoals, 2);

opti = readOptitrack(opti,frame);

% maybe you will need to run this >> fclose(instrfind)


r = m3pi('/dev/ttyUSB0', 9600, ['40';'AE';'BB';'10']);

r.connect();


controller = m3piController(r, kv, kw, d, tol);
goals(:, :) = 3*rand(ngoals,2);
controller.setGoal(goals(1, 1), goals(1, 2));
controller.setPose(opti.pose(1, 1), opti.pose(2, 1), opti.pose(6, 1));

figure
h = plot(opti.pose(1, 1), opti.pose(2, 1),'Marker', 'o', 'MarkerSize', 15);
hold on
h2 = plot(goals(1, 1), goals(1, 2), 'Marker', '+', 'Color', 'r');
axis([-1 4 -1 4]);
grid on
drawnow;

k=0;

%% Goals Loop
for i=1:ngoals
    j=0;
    controller.setGoal( goals(i, 1), goals(i, 2));
    set(h2, 'XData', goals(1, 1), 'YData', goals(1, 2), 'Marker', '+', 'Color', 'r');
    drawnow;
    %% Position Loop
    while(controller.goalReached() == 0)
%         opti = readOptitrack(opti,frame);
% 
%         controller.setPose(opti.pose(1, 1), opti.pose(2, 1),  opti.pose(6, 1));
%         controller.controlSpeed();
        controller.controlSpeed();
        opti = readOptitrack(opti,frame);
        controller.setPose(opti.pose(1, 1), opti.pose(2, 1),  opti.pose(6,1));
        
        j = j+1;
        if j>20
            fprintf('id: %f x: %1.2f  y: %1.2f  ang: %3.2f v: %1.2f  w: %1.2f\n', i, opti.pose(1, 1), opti.pose(2, 1), 180*(opti.pose(6, 1))/pi, controller.vlinear, controller.wangular);
            set(h, 'XData', opti.pose(1,1),'YData',opti.pose(2,1), 'Marker', 'o', 'MarkerSize', 15); 
            drawnow;
        end
        
        
        pause(0.1);
        
    end
    
end

%% End 
r.stop;
r.disconnect();

