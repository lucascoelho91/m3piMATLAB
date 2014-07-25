classdef m3piController < handle
    properties 
        m3pi   % m3pi robot class
        goalx  % x coordinate of the goal
        goaly  % y coordinate of the goal
        errx   % error in x
        erry   % error in y
        posex  % positon in x of the robot
        posey  % position in y of the robot
        theta  % orientation of the robot in radians
        
        vlinear  % linear speed
        wangular % angular speed
        
        kv   % linear speed constant for the speed controller
        kw   % angular speed constant for the speed controller 
        d    % d distance for the feedback linearization controller
        tol  % minimum distance to the goal for considering that the goal was reached
    end
        methods
            
            function robot = m3piController(m3, kvel, kwg, dp, tolp)
                if nargin < 5 
                    tolp = 0.1;
                end
                if nargin < 4
                    dp = 0.1;
                end
                if nargin < 3
                    kwg = 1;
                end
                if nargin < 2
                    kvel = 1;
                end    
                robot.kw = kwg;
                robot.kv = kvel;
                robot.m3pi = m3;
                robot.d = dp;
                robot.tol = tolp;
            end
            
            function setPose(robot, x, y, t)
                robot.posex = x;
                robot.posey = y;
                robot.theta = t;
                robot.errx = robot.goalx - robot.posex;
                robot.erry = robot.goaly - robot.posey;
            end
            
            function setGoal(robot, x, y)
                robot.goalx = x;
                robot.goaly = y;
                robot.errx = robot.goalx - robot.posex;
                robot.erry = robot.goaly - robot.posey;
            end
            
            function controlSpeed(robot)
                %% Feedback Linearization Controller
                v = robot.kv*(cos(robot.theta)*robot.errx + sin(robot.theta)*robot.erry);
                w = robot.kw*(-sin(robot.theta)*robot.errx/robot.d + cos(robot.theta)*robot.erry/robot.d);
                
                if abs(v) > 0.5
                    v = 0.5 * v/abs(v);
                end
                if abs(w) > 0.5
                    w = 0.5 * w/abs(w);
                end
                %robot.m3pi.sendSpeed(v, w);
                robot.vlinear = v;
                robot.wangular = w;
            end
            
            function answer = goalReached(robot)
                if norm([robot.errx, robot.erry]) < robot.tol
                    answer = 1;
                else
                    answer = 0;
                end
            end
            
        end
        
end