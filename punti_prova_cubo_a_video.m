clear;
clc;

% test_points_cube_on_video.m

%{
Plots the cube's trajectory through space
Also creates the movimento_punti_3D_100frames.mat test data
%}

%% Creating a Cube:

% vertex   a b c d e f g h
p3d =    [ 0 1 1 0 0 1 1 0 ;   % x 
           0 0 0 0 1 1 1 1 ;   % y
           0 0 1 1 1 1 0 0 ];  % z
% p3d = p3d*500;     
       
% Set all visible points      
%hidden = zeros(1,8);
connmatrix = [ 'r'  0   0   0   0   0   0   0  ;
               'g' 'k'  0   0   0   0   0   0  ;
                0  'b' 'b'  0   0   0   0   0  ;
               'r'  0  'b' 'g'  0   0   0   0  ;
                0   0   0  'b' 'b'  0   0   0  ;
                0   0  'b'  0  'b' 'b'  0   0  ;
                0  'b'  0   0   0  'b' 'b'  0  ;
               'c'  0   0   0  'b'  0  'b' 'm' ];
kx=1;
ky=1;

K=[ kx  0   0 ;
    0   ky  0 ;
    0   0   1 ];
f=1;


plot3(p3d(1,:),p3d(2,:),p3d(3,:),'+');
axis([-2 3 -2 3 -2 3]);

passoz=0.01;
passox=0.02;
degz=pi*2/100;

points=p3d;


for z=1:100
    
    R = rotaz(0,0,z*degz);
    T = [z*passox, 0, z*passoz]';

    pt_trasl=[R,T;[0,0,0,1]] * [p3d; ones(1,8)];
    
%     pt_trasl=rotaz(0,0,z*degz)*pt_trasl;
%     pt_trasl(3,:)=p3d(3,:)+z*passoz;
%     pt_trasl(1,:)=p3d(1,:)+z*passox;
   
 
    points(:,:,z)=pt_trasl(1:3,:);
    
    img=strcat('i',int2str(100-z+1),'.png'); % ordine inverso per photoshop
    for k=1:8
    plot3(pt_trasl(1,1:8),pt_trasl(2,1:8),pt_trasl(3,1:8));
    plot3([pt_trasl(1,8) pt_trasl(1,1)],[pt_trasl(2,8) pt_trasl(2,1)],[pt_trasl(3,8) pt_trasl(3,1)]);
    plot3([pt_trasl(1,7) pt_trasl(1,2)],[pt_trasl(2,7) pt_trasl(2,2)],[pt_trasl(3,7) pt_trasl(3,2)]);
    plot3([pt_trasl(1,6) pt_trasl(1,3)],[pt_trasl(2,6) pt_trasl(2,3)],[pt_trasl(3,6) pt_trasl(3,3)]);
    plot3([pt_trasl(1,8) pt_trasl(1,5)],[pt_trasl(2,8) pt_trasl(2,5)],[pt_trasl(3,8) pt_trasl(3,5)]);
    plot3([pt_trasl(1,4) pt_trasl(1,1)],[pt_trasl(2,4) pt_trasl(2,1)],[pt_trasl(3,4) pt_trasl(3,1)]); 
      switch k
			case 1
				kcolor = [0 0 1];
			case 2
				kcolor = [1 0 0];
			case 3
				kcolor = [0 1 0];
			case 4
				kcolor = [0 1 1];
			case 5
				kcolor = [1 0 1];
			case 6
				kcolor = [1 0.5 0];
			case 7
				kcolor = [0 0.5 0.5];
			case 8
				kcolor = [0 0 0];
      end
      plot3(pt_trasl(1,k),pt_trasl(2,k),pt_trasl(3,k),'*','color',kcolor,'LineWidth',3); % 3 per cubo, 1 per traiettorie
      axis([-0.7002    3.2002   -1.4135    1.4135    0.0100    1.9600]);
      hold on;
    end
 
    grid on
    %cd b;
    %saveas(gcf,img);
    %cd ..;
    pause(0.03)
    hold off; % on for trajectories commenting lines cube, off for the cube
end

hold off;
save('movimento_punti_3D_100frames','points');





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