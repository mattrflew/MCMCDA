clear;
clc;
punti_prova;
load('movimento_punti_3D_100frames');


global Ts sigmaW sigmaV P0 A C Q R Y pz pd Tmax nt L_Birth L_False Nmc Hfinal d_bar v_bar
Ts = 1; 
sigmaW = 0.0002;%0.002;
sigmaV = 0.0001;%0.001;
P0 = 1000 * eye(6); % P0 and X0 must be initialized with previous values in case of sliding window

L_Birth=0.000001;
L_False=0.00001;

Nmc = 30; 

% Hfinal=97;
Hfinal=5;



Tmax=10;

A = [1 Ts 0 0  0 0;
     0  1 0 0  0 0;
     0  0 1 Ts 0 0;
     0  0 0 1  0 0;
     0  0 0 0  1 Ts;
     0  0 0 0  0 1];

C = [1 0 0 0 0 0;
     0 0 1 0 0 0;
     0 0 0 0 1 0];

Q = sigmaW * eye(6);
R = sigmaV * eye(3);

pd = 0.99; 

pz = 0.01; 



%pd = 0.7; 
%pdt = 0.99; % 


%s = ceil(G); % number of measurements considered
%pdt = 1-(1-pd)^s; 
d_bar = 1;%= ceil( log(1-pdt)/log(1-pd) );%1

%pz = 1/20; % probability that a track disappears

v_bar = 0.15; % cm/s, max directional speed of any target — can be based on shape constraints / recursively


for n=1:100
   Y(n).data=points(:,:,n)';
end



[Ny ~]=size(Y(1).data);


% tau=struct();
% for k=1:Ny^2
%    tau=[tau struct()];
% end
% 
% for t=1:Hfinal
%    wt(t)=struct('tau', tau);
% end


wt=struct();
W=struct('track', wt, 'frame', 1, 'tracks', 0);
for t=1:Hfinal+2
   for k=1:Ny^2
      if t==1 && k<=8 
         W.track(1).tau(k).y=k;
         W.track(1).tau(k).frame=1;
         W.track(1).tau(k).islast=1;
         W.track(1).tau0=[];
      else
         W.track(t).tau0=[];
      end
   end
end
W.frame=2;
W.tracks=Ny;


for h=1:Hfinal
   [nt(h),~] = size(Y(h).data);
end

% At the very first step (G = 1, H = 2), W is assumed to be already initialized


W.tracks=Ny;

%testTime = 900;

% % use profiler or not
% useProfiler = true;

% % start profiler
% if useProfiler
% 	profile clear
% 	profile on
% end

% % initialize
% startTime = clock;
% h = waitbar(0, 'Please wait', 'Name', mfilename);

tstart = tic;
for t=1:Hfinal
   W = multiscanMCMCDA(W);
   disp(' ');disp(' ');disp(' ');disp(' ');
   disp('istante =');disp(W.frame);
   disp(' ');disp(' ');disp(' ');disp(' ');
   

%    % set waitbar
%    curTime = etime(clock, startTime);
%    waitbar(curTime/testTime, h);
   
%    % stop after given time
%    if curTime > testTime
%         break
%    end
end
telapsed = toc(tstart);

% close(h);
% 
% if useProfiler
% 	profile off
% 	profile report
% end

plotW(W,Y);

msg=strcat('simulazione_',datestr(now,1),'_',datestr(now,'HH'),'-',datestr(now,'MM'),'-',datestr(now,'SS'));
save(msg);

