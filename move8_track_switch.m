function Out = move8_track_switch(W_init,H,T,K,G,d_bar,v_bar)
%MOVE8_TRACK_SWITCH Attempts a track switch between two targets.
%   Swaps trajectory segments if distance and timing constraints are met.

global Y % from frame 1 to H (current)

neartaupairs=zeros(K*K,4); % preallocate for candidate track pair switches; K*K to limit cost
c=1; % counter for adding rows to the matrix

% temporal order: [ t_p <--> t_q ]  >-->  [ t_{p+1} <--> t_{q+1} ]
for k1=1:K
   for g=H-T:G % t_p, consider within sliding window
      if tauexist(W_init,g,k1) && isempty(W_init.track(g).tau(k1).islast) % if this is a moment in k1, and not its last
         n1=W_init.track(g).tau(k1).frame;
         for g1=g+1:G % t_{p+1}
            if tauexist(W_init,g1,k1) && W_init.track(g1).tau(k1).frame == n1+1 % check for the next moment
               for k2=1:K
                  for h=g1+1:G % t_q , where 0 < h - g1
                     if tauexist(W_init,h,k2) && isempty(W_init.track(h).tau(k2).islast) % valid, not the last moment of k2
                        if h-g1 <= d_bar  % enforce max frame gap
                           if pdist([ Y(h).data(W_init.track(h).tau(k2).y,:) ; Y(g1).data(W_init.track(g1).tau(k1).y,:) ]) <= (h-g1)*v_bar  
                              % if tauK1(t_{p+1}) ∈ L_{t_{p+1}-t_q}(tauK2(t_q)) — neighborhood condition
                              n2=W_init.track(h).tau(k2).frame;
                              if g+1 <= G
                                 for h1=g+1:G % t_{q+1}
                                    if tauexist(W_init,h1,k2) 
                                       if W_init.track(h1).tau(k2).frame == n2+1 % look for the next moment
                                          if h1-g <= d_bar
                                             if pdist([ Y(h1).data(W_init.track(h1).tau(k2).y,:) ; Y(g).data(W_init.track(g).tau(k1).y,:) ]) <= (h1-g)*v_bar  
                                                % if tauK2(t_{q+1}) ∈ L_{t_{q+1}-t_p}(tauK1(t_p))
                                                neartaupairs(c,:)=[k1 g1 k2 h1]; % store the next valid pair
                                                c=c+1;
                                             end
                                          end
                                       end
                                    end
                                 end
                              end
                           end
                        end
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
   return % reject the move if no valid track pairs were found
end

q=neartaupairs(randi(c-1),:); % pick a random valid track pair

K1=q(1);
tp1=q(2);
n1=W_init.track(tp1).tau(K1).frame;
b1=1; % index for next frame from n1

K2=q(3);
tq1=q(4);
n2=W_init.track(tq1).tau(K2).frame;
b2=1; % index for next frame from n2

last1OR2=0;
for o=min(tp1,tq1):G
   if tauexist(W_init,o,K1) && tauexist(W_init,o,K2)
      SWAP=W_init.track(o).tau(K2).y;
      W_init.track(o).tau(K2).y = W_init.track(o).tau(K1).y; % track K1 becomes K2
      W_init.track(o).tau(K2).frame = n2+b2;
      b2=b2+1;
      W_init.track(o).tau(K1).y = SWAP; % track K2 becomes K1
      W_init.track(o).tau(K2).frame = n1+b1;
      b1=b1+1;
   elseif tauexist(W_init,o,K1)
      W_init.track(o).tau(K2).y = W_init.track(o).tau(K1).y; % K1 copied to K2
      W_init.track(o).tau(K2).frame = n2+b2;
      b2=b2+1;   
      W_init.track(o).tau(K1).y = []; % clear K1
      W_init.track(o).tau(K1).frame = [];
   elseif tauexist(W_init,o,K2)
      W_init.track(o).tau(K1).y = W_init.track(o).tau(K2).y; % K2 copied to K1
      W_init.track(o).tau(K1).frame = n1+b1;
      b1=b1+1;   
      W_init.track(o).tau(K2).y = []; % clear K2
      W_init.track(o).tau(K2).frame = [];      
   end
   
   % Check for terminal points and update
   if tauexist(W_init,o,K1) && ~isempty(W_init.track(o).tau(K1).islast)
      W_init.track(o).tau(K1).islast=[];
      W_init.track(o).tau(K2).islast=1;
      W_init.track(o).tau(K1).AAA='mossa8'; % mark move 8
      if ~last1OR2
         last1OR2=1;
      else
         break % reached the last frame of the track that wasn't already ended
      end
   end
   if tauexist(W_init,o,K2) && ~isempty(W_init.track(o).tau(K2).islast)
      W_init.track(o).tau(K2).islast=[];
      W_init.track(o).tau(K1).islast=1;
      W_init.track(o).tau(K2).AAA='mossa8'; % mark move 8
      if ~last1OR2
         last1OR2=1;
      else
         break % reached the last frame of the track that wasn't already ended
      end
   end
end      

Out=W_init;

end
