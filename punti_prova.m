clear;
clc;


%{
MF:
punti: points
prova: test

Creates the 3D test dataset.
Defines a cube in space and performs translations and rotations.
Points/tracks are on the vertices of the cube as they move through space
for 100 steps.
Saves to "movimento_punti_3D_100frames.mat".

%}

%% (Creating a Cube)

% Vertex a b c d e f g h
% Initialise a unit cube with vertices a-h
% Cube spans [0,1] in x,y,z directions

p3d =    [ 0 1 1 0 0 1 1 0 ;   % x 
           0 0 0 0 1 1 1 1 ;   % y
           0 0 1 1 1 1 0 0 ];  % z

% p3d = p3d*500; % re-scale?    
       
% Set all visible points
%hidden = zeros(1,8);

% Connectivity matrix? (Just for plotting?)
connmatrix = [ 'r'  0   0   0   0   0   0   0  ;
               'g' 'k'  0   0   0   0   0   0  ;
                0  'b' 'b'  0   0   0   0   0  ;
               'r'  0  'b' 'g'  0   0   0   0  ;
                0   0   0  'b' 'b'  0   0   0  ;
                0   0  'b'  0  'b' 'b'  0   0  ;
                0  'b'  0   0   0  'b' 'b'  0  ;
               'c'  0   0   0  'b'  0  'b' 'm' ];

% Camera settings?
kx=1;
ky=1;

K=[ kx  0   0 ;
    0   ky  0 ;
    0   0   1 ];
f=1;

% Plot the initial cube
figure;
plot3(p3d(1,:), p3d(2,:), p3d(3,:), '+');
axis([-2 3 -2 3 -2 3]);

%% Perform transformations to cube and save to file

% passo: step
passoz=0.01; % Translation per frame in z
passox=0.02; % Translation per frame in x

n_frames = 100; % Define the number of frames/steps 
degz = pi*2/n_frames; % Rotation step around the z-axis. Set to 360 deg rotation over the n_frames. 

% Initialise 
points=p3d;

% Generate tracks/points
for z=1:n_frames
    
    % Rotation matrix (around z)
    R = rotaz(0, 0, z*degz); 

    % Translation vector
    T = [z*passox, 0, z*passoz]';

    % Transformation matrix (affine?)
    pt_trasl = [R, T; [0,0,0,1]] * [p3d; ones(1,8)];
    
%     pt_trasl=rotaz(0,0,z*degz)*pt_trasl;
%     pt_trasl(3,:)=p3d(3,:)+z*passoz;
%     pt_trasl(1,:)=p3d(1,:)+z*passox;
    
    % Store only the x,y,z positions of the transformation
    points(:, :, z) = pt_trasl(1:3, :);
    
%     plot3(pt_trasl(1,:),pt_trasl(2,:),pt_trasl(3,:),'+');
%     axis([-2 3 -2 3 -2 3]);   
%     pause(0.03)
end
save('movimento_punti_3D_100frames','points');




%% Commented out code by previous author
% [P2D, hidden] = camera_simulation(eye(3), [-0.5 -0.5 5]', p3d, K, f);

% ccdplot(P2D, hidden, connmatrix) 
% axis([-0.1 0.1 -0.1 0.1]);

% pause;
% for z=0:0.1:3
%     pt_trasl=p3d;
%     pt_trasl(3,:)=p3d(3,:)+z;
%     
%     [P2D, hidden] = camera_simulation(eye(3), [-0.5 -0.5 10]', pt_trasl, eye(3));
%     ccdplot(P2D, hidden, connmatrix) 
%     axis([-0.1 0.1 -0.1 0.1]);
%     pause;
% end
% 
% 
% for z=0:0.1:10
%     pt_trasl=p3d;
%     pt_trasl(3,:)=p3d(3,:)-z;
%     
%     [P2D, hidden] = camera_simulation(eye(3), [-0.5 -0.5 10]', pt_trasl, eye(3));
%     ccdplot(P2D, hidden, connmatrix) 
%     axis([-0.1 0.1 -0.1 0.1]);
%     pause;
% end