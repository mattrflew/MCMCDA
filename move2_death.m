function Out = move2_death(W_init,H,T,K,G)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

aliveK=zeros(K,1);
c=1;
for k=1:K
   for g=H-T:G % takes into account the sliding window
      if tauexist(W_init,g,k) && W_init.track(g).tau(k).frame == 1 % if the track currently exists
         aliveK(c)=k;
         c=c+1;
         break;
      end         
   end
end

if c==1 % all the tracks are dead
   Out=666;
   return
end
kdead=aliveK(randi(c-1));

for o=H-T:G
   if tauexist(W_init,o,kdead)
   if isfield(W_init.track(o),'tau0') && ~isempty(W_init.track(o).tau0)
      W_init.track(o).tau0=[W_init.track(o).tau0 W_init.track(o).tau(kdead).y]; % adds to the false alarms
   else
      W_init.track(o).tau0=W_init.track(o).tau(kdead).y;
   end
   W_init.track(o).tau(kdead).y=[]; % it empties itself of associations
   W_init.track(o).tau(kdead).frame=[]; % the association number index is emptied
   if ~isempty(W_init.track(o).tau(kdead).islast) % if it is the last association
      W_init.track(o).tau(kdead).islast = [];
      W_init.track(o).tau(kdead).AAA='mossa2'; %%%%%%%%%%%%
      break
   end
   end
end
% W_init.tracks = K-1 is not done; because K is the number of all tracks that existed or exist
Out=W_init;

end

