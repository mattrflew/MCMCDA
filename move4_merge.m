function Out = move4_merge(W_init,H,T,K,G,v_bar)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

global Y % from frame 1 to H (current)

neartaus=zeros(K,4); % there would be K! possible pairs, but for too many markers it is expensive, K possibilities are posed
tf=zeros(K); % final moments
c=1; % in case the counter adds rows to the matrix
for k1=1:K
   for g=H-T:G % takes into account the sliding window
      if tauexist(W_init,g,k1) && ~isempty(W_init.track(g).tau(k1).islast) % for each final instant tauk1(tf)
         tf(k1)=g;
         for k2=1:K
            if k2~=k1 && g+1 <= G % avoids both G<2 and exceeding into the future
               for h=g+1:G % searching in the moments ahead
                  if tauexist(W_init,h,k2) &&  W_init.track(h).tau(k2).frame==1 % if you find the first frame of some track
                     if pdist([ Y(g).data( W_init.track(g).tau(k1).y ,:) ; Y(h).data( W_init.track(h).tau(k2).y ,:) ]) <= (h-g)*v_bar
                        neartaus(c,:)=[k1 g k2 h]; 
                        c=c+1;
                     end
                  end
               end
            end
         end
      end
   end
end

if c==1
   Out=666;
   return % the move is rejected if there are no possible track pairs
end


%neartaus(Msp,:)=[k1 g k2 h]; 
q=neartaus(randi(c-1),:);

K1=q(1);
tf1=q(2);

K2=q(3);
ti2=q(4);
tf2=tf(K2);


W_init.track(tf1).tau(K1).islast=[];
n = W_init.track(tf1).tau(K1).frame;
b=1;

for o=ti2:tf2
   if tauexist(W_init,o,K2)
      W_init.track(o).tau(K1).y = W_init.track(o).tau(K2).y; % Track K2 becomes track K1
      W_init.track(o).tau(K1).frame = n+b;
      W_init.track(o).tau(K2).y = []; % K2 is emptied
      W_init.track(o).tau(K2).frame = [];
      b=b+1;
   end
end      
W_init.track(tf2).tau(K1).islast=1;
W_init.track(tf2).tau(K1).AAA='mossa4'; %%%%%%%%%%%%

% W_init.tracks = K-1 is not done; because K is the number of all tracks that existed or exist

Out=W_init;

end

