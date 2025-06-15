function W_hat = multiscanMCMCDA(W_prev)
% multiscanMCMCDA multi-scan MCMCDA tracking algorithm
%   centralized version

global Y % from frame 1 to H (current)
% Y = [Y1 ,..., YH] — structure-matrix of all measurements up to the current time H,
% each frame is a structure: Yi = struct('data', matrix_data)
% each row of a normal matrix_data is a measurement [x y z]
% Y(i).data(ai,:) is the ai-th 3D measurement at time i

global nt % here from frame 1 to H

% [nt(H), ~] = size(Y(H).data); % from frame 1 to H, grows at each step but still shows green box...

% W = struct('track', A, 'frame', H-1, 'tracks', K)
% A = [w1 ,..., w{H-1}] — array of association structures for each time step
% K is the number of all tracks that have ever existed or currently exist
%
% w1 associates each measurement with a target
%
% wt = struct('tau0', false_alarms, 'tau1', 1st_track, ..., 'frame', Hw)
%
% wt.tau0 = [a1, ..., aU] contains U false alarms corresponding to (..., Y(t).data(ai,:), ...)
%
% wt.taui = struct('y', bi, 'frame', n, 'islast', []) 
% associates the bi-th measurement Y(t).data(bi,:) to target i at frame n
% islast is a boolean: 1 if this is the last measurement of target i, otherwise it's empty
% W.track(t).(tau(i)).y is the index bi of the measurement associated with track i at time t
% Assumes only one possible measurement per target at each time (non-ubiquity assumption)
% A new track may not have an associated field in frames where it doesn't appear,
% or it may have been deleted from a certain time step

% At the very first step (W.frame = 1; H = 2), it is assumed that W is already initialized:
% W.track(1).(tau(j)).y = Y(1).data(j,:);
% W.track(1).(tau(j)).frame = 1;
% W.track(1).(tau(j)).islast = 1;
% W.track(1).tau0 = [];
% [Ny ~] = size(Y(1).data);
% W.tracks = Ny;

% global Nmc
% Nmc = Nmc + nt(H); % update number of samples — faster than computing sum(sum(Y)) every time

global Nmc

% W_hat = struct(); %%%%%%%%%%

W_init = W_prev;
W_W = W_init;
W_hat = W_init;
for n = 1:Nmc
    % propose w_prop based on w_prev
    W_primo = proposal_distribution(W_hat);
    U = rand;
    % Any issues? — X.W.Cui, 2020-3-26.
    pww = PW_Y(W_W); 
    pwp = PW_Y(W_primo);
%     pwh = PW_Y(W_hat);
%     acc = acceptancePw(pww, pwh);
    acc = acceptancePw(pww, pwp);

    if U < acc  % under acceptance probability
        W_W = W_primo;
        pww = PW_Y(W_W);
        disp('ACCEPT');
    end    

    msg = strcat('U = ', num2str(U), ' acc = ', ' ', num2str(acc), '; pww = ', ' ', num2str(pww), ', pwp = ', ' ', num2str(pwp));
    disp(msg);
    
    pwh = PW_Y(W_hat);
    if pww > pwh % if w_w is more probable than w_hat
        W_hat = W_W;
        disp('                                                        PASSPROB');
    end 

    msg = strcat('time step = ', ' ', num2str(W_prev.frame), ', iteration = ', ' ', num2str(n));
    disp(msg);
    disp(' ');
end

W_hat.frame = W_hat.frame + 1; % this is because W is being proposed up to the current Y (time H)

% function end
end
