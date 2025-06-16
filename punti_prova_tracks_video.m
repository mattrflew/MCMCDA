%% Set-up
clear all;
close all;
clc;

%{
Scripts takes the points created in punti_prova.m and shows the true
trajectories.
%}


load("movimento_punti_3D_100frames.mat")

[dim, K, n_frame] = size(points);


% Find the min, max values for x,y,z to define plotting limits

% reshape the matrix to 3 x 800 to easily do this
points_flat = reshape(points, 3, []);

% min, max vals for x,y,z
min_vals = min(points_flat, [], 2);
max_vals = max(points_flat, [], 2);

% The vertices are labelled a-h
% 1 2 3 4 5 6 7 8 (K value)
% a b c d e f g h (label)
vertex_lbl = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];


%% Plot the initial cube, along with vertex label

% Use same colours as other scripts for each of the tracks
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

% Control figure
% set axis limits
pad = 0.25;

xlim([min_vals(1)-pad, max_vals(1)+pad])
ylim([min_vals(2)-pad, max_vals(2)+pad])
zlim([min_vals(3)-pad, max_vals(3)+pad])

xlabel('x');
ylabel('y');
zlabel('z');

hold on;

% Plot the vertices
frame=1;
for k = 1:K
    k_col = cols(k, :);
    plot3(points(1,k, frame), points(2,k, frame), points(3,k, frame), '.', 'Color', k_col, 'MarkerSize', ms);

    str_lbl = strcat(string(k), '(', vertex_lbl(k), ')');
    text(points(1,k, frame), points(2,k, frame), points(3,k, frame), str_lbl)
end

% Plot the edges
edges = [
    1 2; 2 3; 3 4; 4 1; % front face
    5 6; 6 7; 7 8; 8 5; % back face
    3 6; 4 5;           % top
    2 7; 1 8;           % back
];


for e = 1:size(edges,1)
    p1 = squeeze(points(:, edges(e,1), frame));
    p2 = squeeze(points(:, edges(e,2), frame));
    plot3([p1(1), p2(1)], [p1(2), p2(2)], [p1(3), p2(3)], 'k-');
end

title('Initial Cube')

% Save figure
% saveas(gcf, 'figures/punti_prova_initial_cube_with_vertex_labels.png');



%% Plot the trajectories (video)
% Init figure
figure;
axis equal; % make the cube appear equal
grid on;
view(3) % set to 3D

% Control figure
% set axis limits
pad = 0.25;

xlim([min_vals(1)-pad, max_vals(1)+pad])
ylim([min_vals(2)-pad, max_vals(2)+pad])
zlim([min_vals(3)-pad, max_vals(3)+pad])

xlabel('x');
ylabel('y');
zlabel('z');

hold on;

% Plot the vertices
for frame = 1:n_frame
    for k = 1:K
        k_col = cols(k, :);
        plot3(points(1,k, frame), points(2,k, frame), points(3,k, frame), '.', 'Color', k_col, 'MarkerSize', ms);
    end
    pause(0.05)
end


title('Trajectories')

% Save figure
% saveas(gcf, 'figures/punti_prova_trajectories.png');


%% Plot the cube movement (video)
% Define the edges
edges = [
    1 2; 2 3; 3 4; 4 1; % front face
    5 6; 6 7; 7 8; 8 5; % back face
    3 6; 4 5;           % top
    2 7; 1 8;           % back
];

% Init figure
figure;
axis equal; % make the cube appear equal
grid on;
view(3) % set to 3D

% Control figure
% set axis limits
pad = 0.25;

xlim([min_vals(1)-pad, max_vals(1)+pad])
ylim([min_vals(2)-pad, max_vals(2)+pad])
zlim([min_vals(3)-pad, max_vals(3)+pad])

xlabel('x');
ylabel('y');
zlabel('z');

hold on;
shg; % show current figure

% Initialise edge line and vertex dots plotting objects for speed, and so
% they can be deleted easily
edge_lines = gobjects(size(edges,1), 1);
vertex_dots = gobjects(K, 1);


% Save to video
% v = VideoWriter('figures/punti_prova_cube_trajectories.mp4', 'MPEG-4');
% v.FrameRate = 10;
% open(v);

% Plot the cube trajectories
for frame = 1:n_frame
    % Delete the old vertices and edges from figure
    delete(edge_lines); 
    delete(vertex_dots);

    % Plot cube edges
    for e = 1:size(edges,1)
        p1 = squeeze(points(:, edges(e,1), frame));
        p2 = squeeze(points(:, edges(e,2), frame));
        edge_lines(e) = plot3([p1(1), p2(1)], [p1(2), p2(2)], [p1(3), p2(3)], 'k-');
    end

    % Plot vertices
    for k = 1:K
        k_col = cols(k, :);
        vertex_dots(k) = plot3(points(1,k, frame), points(2,k, frame), points(3,k, frame), '.', 'Color', k_col, 'MarkerSize', ms);
    end
    
    pause(0.05)

    
    % drawnow; % force draw
    % current_frame = getframe(gcf);
    % writeVideo(v, current_frame); 
end

% close(v);







