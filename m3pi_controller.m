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

addresses = cell(n, 1);
addresses{1} = ['40';'AE';'BB';'10']; % xbee mac address
addresses{2} = ['40';'AD';'59';'34']; 

%fclose(instrfind);

goals = zeros(n, ngoals, 2);
currentGoal = ones(n, 1);

opti = readOptitrack(opti,frame);


% maybe you will need to run this >> fclose(instrfind)
figure

for i=1:n
    r(i) = m3pi('/dev/ttyUSB1', 9600, addresses(i));
    
    controller(i) = m3piController(r(i), kv, kw, d, tol);
    goals(i, :, :) = 3*rand(ngoals,2);
    controller(i).setGoal(goals(i, 1, 1), goals(i, 1, 2));
    controller(i).setPose(opti.pose(1, i), opti.pose(2, i), opti.pose(6, i));
    
    h(i) = plot(opti.pose(1, i), opti.pose(2, i),'Marker', 'o', 'MarkerSize', 15);
    hold on
    h2(i) = plot(goals(i, currentGoal(i), 1), goals(i, currentGoal(i), 2), 'Marker', '+', 'Color', 'r');
    axis([-5 5 -5 5]);
    grid on
    drawnow;
end

r(1).connect();

for i=2:n
    r(i).setSerialPort(r(1).serialPort);
end

k=0;

%% Goals Loop
while(1)
    
    opti = readOptitrack(opti,frame);
    j=0;
    %% Position Loop
    for i=1:n
        if(controller(i).goalReached())
            currentGoal(i) = currentGoal(i)+1;
            if(currentGoal(i) > ngoals)
                r(i).stop();
                j = j+1;
            else
                controller(i).setGoal(goals(i, currentGoal(i), 1), goals(i, currentGoal(i), 2));

                set(h2(i), 'XData', goals(i, currentGoal(i), 1), 'YData', goals(i, currentGoal(i), 2), 'Marker', '+', 'Color', 'r'); 
                drawnow;
            end
        end
        controller(i).controlSpeedDiff();
        controller(i).setPose(opti.pose(1, i), opti.pose(2, i),  opti.pose(6, i));

        k = k+1;
        
    end
    
    if(k>20)
            %fprintf('x: %1.2f  y: %1.2f  ang: %3.2f v: %1.2f  w: %1.2f\n', opti.pose(1, 1), opti.pose(2, 1), 180*(opti.pose(6, 1))/pi, controller.vlinear, controller.wangular);
            set(h, 'XData', opti.pose(1,i),'YData',opti.pose(2,i), 'Marker', 'o', 'MarkerSize', 15); 
            drawnow;
            k=0;
    end
    %pause(0.2);
    if(j>=n)
        break
    end
    
end

%% End 
for i=1:n
    r(i).stop();
    r(i).disconnect();
end
