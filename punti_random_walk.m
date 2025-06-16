%{
Creates a random walk data set.

The points get initialised at random locations from [0,1] in each of the
x,y,z dimensions.

The trajectories are random walks with a pull to the origin.

Potential use case:
Investigating dense fields since the points are initially separated and
then become dense as they all move to the origin.
%}

close all;
clear all;
clc;

% Set parameters
speed = 0.01; % Step size
Nt = 100; % Number of frames
Np = 8; % Number of points


% Initialise matrix (3 x Np x Nt)
points(:, : , Nt) = zeros(3,Np);

% Randomise the first frame. All points start between [0,1]
points_init = rand(3, Np);
points(:, : , 1) = points_init;

% Perform walk
for cont=2:Nt

    % Random walk step, generate step in x,y,z for each point
    step=randi(3, 3, Np)-2; % generates steps: -1, 0, or +1
    
    % Component that pulls them towards the center (original comment translated)
    % Overwrite the previous iteration position, perform a slight pull
    % towards origin.
    points(:,:,cont-1) = points(:,:,cont-1) - points(:,:,cont-1)/10;
    
    % Get new step
    points(:,:,cont) = points(:,:,cont-1) + step*speed;
end


% Save the dataset
save('movimento_punti_random_100frames','points');

%% Plot the random walk

cols = [
    [0,0,1];
    [1 0 0];
    [0 1 0];
    [0 1 1];
    [1 0 1];
    [1 0.5 0];
    [0 0.5 0.5];
    [0 0 0];
    ];

ms = 12; % markersize

% Init figure
figure;
axis equal; % make the cube appear equal
grid on;
view(3) % set to 3D

xlabel('x');
ylabel('y');
zlabel('z');

hold on;

% Plot the vertices
for frame = 1:Nt
    for k = 1:Np
        k_col = cols(k, :);
        plot3(points(1,k, frame), points(2,k, frame), points(3,k, frame), '.', 'Color', k_col, 'MarkerSize', ms);
    end
    pause(0.05)
end


title('Trajectories (Random Walk)')

% Save figure
% saveas(gcf, 'figures/punti_random_walk_trajectories.png');