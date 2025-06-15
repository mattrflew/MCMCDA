function Out = move5_extension(W_init,H,T,K,G,v_bar,d_bar)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

global pz

aliveK=zeros(K,2);
c=1;
for k=1:K
   for g=H-T:G % Taking into account the sliding window
      if tauexist(W_init,g,k) && ~isempty(W_init.track(g).tau(k).islast) % f the track exists and is at the last moment, and the track length is not equal to 1
         aliveK(c,:)=[k g];
         c=c+1; 
         break;
      end         
   end
end

if c==1 % All traces have disappeared
   Out=666;
   return
end
a=randi(c-1);
k2extend=aliveK(a,1);
tfk2extend=aliveK(a,2);
N2ext=W_init.track(tfk2extend).tau(k2extend).frame;
% Implemented by new transformation
Out = move1_birth(W_init,H,T,K,d_bar,v_bar,pz,k2extend,tfk2extend,N2ext);

end

