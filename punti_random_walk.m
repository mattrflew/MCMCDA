clear all
speed=0.01;
Nt=100;
Np=8;

points(:,:,Nt)=zeros(3,Np);
points=rand(3,Np)/1;

for cont=2:Nt
    % I decide whether to take a positive, negative or firm step
    passo=randi(3, 3,Np)-2;
    
    % Component that pulls them towards the center
    points(:,:,cont-1)=points(:,:,cont-1)-points(:,:,cont-1)/10;
    
    points(:,:,cont) = points(:,:,cont-1)+passo*speed;
end
disp('end')



save('movimento_punti_random_100frames','points');
