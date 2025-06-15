function Out = move3_split(W_init,H,T,K,G)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% tracks with more than 4 frames are chosen %%%%%%%%%%  to be redone using taui frame field
longtaus=zeros(K,G);
for k=1:K
   for g=H-T:G % takes into account the sliding window
      if tauexist(W_init,g,k) %%%%%%%%%%%%%%
         longtaus(k,g) = 1;
      end
   end
end

Ltau=find(sum(longtaus,2) >= 4); % returns the tracks that satisfy the length condition
if isempty(Ltau)
   Out=666;
   return % the move is rejected if there are no tracks present in at least 4 frames
end

s=Ltau(randi(length(Ltau))); % choose a random track from these, tau_s
Ts=find(longtaus(s,:)==1); % all valid instances of tau_s
line=length(Ts); % number of instants in which tau_s occurs
r=randi(line); % tr=Ts(r); % chooses the median instant at random among the valid ones of the track taus
while r==1 || r==line || r==line-1  % tr==Ts(1) || tr==Ts(line) || tr==Ts(line-1) || tr==Ts(line-2) % the median instant must be between frames [2,...,abs(taui)-2], otherwise it is re-extracted
   r=randi(line); % tr=Ts(r);
end

% track s remains from 1 to r
W_init.track(Ts(r)).tau(s).islast=1;

for o=r+1:line 
   W_init.track(Ts(o)).tau(K+1).y = W_init.track(Ts(o)).tau(s).y;  % track2 = from the middle to the end
   W_init.track(Ts(o)).tau(K+1).frame = o-r; % it is said that the i-th observation of tauK1 corresponds to
   W_init.track(Ts(o)).tau(s).y=[]; % it empties itself of associations
   W_init.track(Ts(o)).tau(s).frame=[]; 
end      
W_init.track(Ts(line)).tau(K+1).islast=1;
W_init.track(Ts(line)).tau(s).islast=[];
W_init.track(Ts(line)).tau(K+1).AAA='mossa3'; %%%%%%%%%%%%
W_init.tracks=K+1; % are now K+1 tracks existed or existing in all

Out=W_init;

end

