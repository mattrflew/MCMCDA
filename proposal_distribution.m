function W_out = proposal_distribution(W_init)

%global Y % from frame 1 to H (current)
% Y = [Y1 ,..., YH] — structure-matrix of all measurements up to the current time H, 
% each frame is a structure: Yi = struct('data', matrix_data)
% each row of a normal matrix_data is a measurement [x y z]
% Y(i).data(ai,:) is the ai-th 3D measurement at time i

% W_init = struct('track', W_initW_initW_init, 'frame', H-1, 'tracks', K)
% W_initW_initW_init = [W_init1 ,..., W_init{H-1}] — structure array of associations for each time point
% K is the number of all tracks that have ever existed or currently exist

% W_init1 associates each measurement to a target

% W_initt = struct('tau0', false_alarms, 'tau1', 1st_track, ..., 'frame', HW_init)

% W_initt.tau0 = [ a1, .., aU] represents U false alarms corresponding to (..., Y(t).data(ai,:) ,... )

% W_initt.taui = struct('y', bi, 'frame', n, 'islast', []) 
% means that at the n-th frame of target i, the associated measurement is Y(t).data(bi,:)
% islast is a boolean: 1 if this is the last measurement of target i, otherwise it's empty
% W_init.track(t).(tau(i)).y is the index bi of the measurement corresponding to track i at time t
% Only one measurement per target per time step is assumed (non-ubiquity assumption)
% A new track may not have an associated field in frames where it does not appear, 
% or it may have been deleted from a certain frame onward

% At the very first step (G=1, H=2), it is assumed that W_init is already initialized:
% W_init.track(1).tau(j).y = Y(1).data(j,:);
% W_init.track(1).tau(j).frame = 1;
% W_init.track(1).tau(j).islast = 1;
% W_init.track(1).tau0 = [];
% [Ny ~] = size(Y(1).data);
% W_init.tracks = Ny;


G=W_init.frame; % G = H - 1 
H=G+1;
K=W_init.tracks;

global Tmax
% Sliding window: evolves with G up to a maximum of Tmax before H > Tmax
if H<=Tmax
   T=G;
else
   T=Tmax;
end



%% 
global pd pz d_bar v_bar mprev mcurr xsiprev xsicurr

%%%%%%%%
mprev=mcurr;
xsiprev=xsicurr;

%% move random selection

m = move_selection(K);

mcurr = m;

if m == 1 % birth move 
   Out = move1_birth(W_init, H, T, K, d_bar, v_bar, pz); 
   if isnumeric(Out) && Out == 666 
      % no tracks and no birth: all objects have left the frame,
      % or the move is rejected if the created path has fewer than 2 points
      disp('   m1'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   elseif isnumeric(Out) && Out ~= 666 
      % if it returns the number of another move
      m = Out; % this ensures that the switch-case won't be used
      mcurr = m;
   else 
      W_out = Out;
   end
end



if m==2 % death move 
   Out = move2_death(W_init, H, T, K, G);
   if isnumeric(Out) && Out==666 
      % all tracks are dead
      disp('   m2'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   else 
      W_out = Out;
   end
end



if m==3 % split move
   Out = move3_split(W_init, H, T, K, G);
   if isnumeric(Out) && Out==666 
      % split not possible
      disp('   m3'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   else 
      W_out = Out;
   end
end


if m==4 % merge move
   Out = move4_merge(W_init, H, T, K, G, v_bar);
   if isnumeric(Out) && Out==666 
      % the move is rejected if no valid track pairs are found
      disp('   m4'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   else 
      W_out = Out;
   end    
end



if m==5 % extension move
   Out = move5_extension(W_init, H, T, K, G, v_bar, d_bar);
   if isnumeric(Out) && Out==666 
      % all tracks are dead
      disp('   m5'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   else 
      W_out = Out;
   end    
end



if m==6 % reduction move
   Out = move6_reduction(W_init, H, T, K, G);
   if isnumeric(Out) && Out==666 
      % all tracks are dead
      disp('   m6'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   else 
      W_out = Out;
   end    
end



if m==7 % track update move
   Out = move7_track_update(W_init, H, T, K, G, v_bar, d_bar);
   if isnumeric(Out) && Out==666 
      % all tracks are dead
      disp('   m7'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   else 
      W_out = Out;
   end    
end


if m==8 % track switch move
   Out = move8_track_switch(W_init, H, T, K, G, d_bar, v_bar);
   if isnumeric(Out) && Out==666 
      % the move is rejected if no valid track pairs are found
      disp('   m8'); %%%%%%%%%%%%%
      W_out = W_init;
      return
   else 
      W_out = Out;
   end    
end

      
disp('m = '); %%%%%%%%%%%%%
disp(m); %%%%%%%%%%%%%

% function end
end