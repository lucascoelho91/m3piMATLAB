%% test controller
clear all; close all; clc
%% simulated robot
timestep = 0.01;

r = simm3pi(0, 0, 0, timestep, 0.05);

%% Create controller instance
kv = 0.5;
kw = 0.21;
d = 0.1;
tol = 0.1;

controller = m3piController(r, kv, kw, d, tol);

%% List of goals
goals = [[ 1, 2 ]; [2, -4]; [-2, 3]; [1, 4]; [0, 4]];

controller.setGoal(goals(1, 1), goals(1, 2));
ngoals = size(goals);
ngoals = ngoals(1);

%opti = readOptitrack(opti,frame);
p = r.getPose();
controller.setPose(p(1), p(2), p(3));

figure
h = plot(p(1), p(2),'Marker', 'o', 'MarkerSize', 15);
hold on
h2 = plot(goals(1, 1), goals(1, 2), 'Marker', '+', 'Color', 'r');
axis([-5 5 -5 5]);
grid on
drawnow;

%% Goals Loop
for i=1:ngoals
    controller.setGoal(goals(i, 1), goals(i, 2));
    set(h2, 'XData', goals(i, 1), 'YData', goals(i, 2)); 
    drawnow;
    %% Position Loop
    while(controller.goalReached() == 0)
        controller.controlSpeedDiff();
        %opti = readOptitrack(opti,frame);
        p = r.getPose();
        controller.setPose(p(1), p(2), p(3));
        
        set(h, 'XData', p(1),'YData',p(2)); 
        drawnow;
        pause(timestep)
    end
    
end