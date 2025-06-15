function Out = move6_reduction(W_init,H,T,K,G)
%MOVE6_REDUCTION Randomly reduces a track from W_init.
%   Selects a track that still exists and truncates it after a randomly chosen frame.

aliveK=zeros(K,2);
c=1;
for k=1:K
   for g=H-T:G % Consider motion gating window
      if tauexist(W_init,g,k) && ~isempty(W_init.track(g).tau(k).islast) && W_init.track(g).tau(k).frame~=1 
         % If track exists and is marked as last, and the length is not 1
         aliveK(c,:)=[k  W_init.track(g).tau(k).frame];
         c=c+1;
         break;
      end         
   end
end

if c==1 % All tracks have already been removed
   Out=666;
   return
end
a=randi(c-1);
k2red=aliveK(a,1);
Nf2kred=aliveK(a,2);

if Nf2kred==2 
   r=2; % r is uniformly randomly selected between (2, Nf2kred-1)
else
   r=randi(Nf2kred-2)+1; % r is uniformly randomly selected between (2, Nf2kred-1)
end

% Remove associations after frame r
for g=H-T:G % Consider motion gating window
   if tauexist(W_init,g,k2red)
      if W_init.track(g).tau(k2red).frame == r
         W_init.track(g).tau(k2red).islast = 1;
      elseif W_init.track(g).tau(k2red).frame > r
         if isfield(W_init.track(g),'tau0') && ~isempty(W_init.track(g).tau0)
      		W_init.track(g).tau0=[W_init.track(g).tau0 W_init.track(g).tau(k2red).y]; % Move to unassigned list
   		else
      		W_init.track(g).tau0=W_init.track(g).tau(k2red).y;
   		end
         W_init.track(g).tau(k2red).y=[]; % Clear association
         W_init.track(g).tau(k2red).frame=[]; % Clear frame index
         if ~isempty(W_init.track(g).tau(k2red).islast)
            W_init.track(g).tau(k2red).islast = [];
            W_init.track(g).tau(k2red).AAA='mossa6'; % Mark with identifier
            break
         end
      end
   end         
end

Out=W_init;

end
