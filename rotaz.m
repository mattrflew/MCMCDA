function [R] = rotaz(a, b, c)
%ROTAZ
%{
    rotaz: rotation
    
    a: Rotation angle around x-axis
    b: Rotation angle around y-axis
    c: Rotation angle around z-axis

    R: Combined x,y,z rotations
   
%}
    % Define rotations in x,y,z axes
    rx=[1 0 0; 
        0 cos(a) -sin(a); 
        0 sin(a) cos(a)];
    
    ry=[cos(b) 0 sin(b); 
        0 1 0; 
        -sin(b) 0 cos(b)];
    
    rz=[cos(c) -sin(c) 0;
        sin(c) cos(c) 0;
        0 0 1];
    
    % Combine the rotations
    R=rz*ry*rx;
    
end

