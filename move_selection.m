function m = move_selection(K, nobirth)

% xsi distribution for the choice of move m, is a function of how many K there are
%  m  = { 1   2   3   4   5   6   7   8 }
% xsi = [pr1 pr2 pr3 pr4 pr5 pr6 pr7 pr8] 

global xsicurr

global randomw

if nargin == 1
   if K==0
      m=1; % Only the track changes
   else
      if K==1
         xsicurr=[1/6 1/6 1/6 0 1/6 1/6 1/6 0];  % No merging or crossover
         P = [1 2 3 3 4 5 6 6]./6; % For speed, create the distribution ahead of time
         d = rand;   % random number between [0,1]
         [~,m] = max(P>d);
      else 
         if isempty(randomw)
            %xsi = [1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8]
            %m = randi(8); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xsicurr =[1 1 2 2 9 5 5 5]./30; %for i=1:8 P(i)=sum(xsi(1:i)); end
            P = [0.0333    0.0667    0.1333    0.2000    0.5000    0.6667    0.8333    1.0000]; % For speed, create the distribution ahead of time
            d = rand;
            [~,m] = max(P>d);
         else
            xsicurr = [1/8 1/8 1/8 1/8 1/8 1/8 1/8 1/8];
            m = randi(8); % if random walk
         end
      end
   end
elseif strcmp(nobirth, 'nobirth') % no feasible birth
   if K==0
      m=666; % no tracks and no birth: all objects are out of frame
   else
      if K==1
         xsicurr =[0 1/5 1/5 0 1/5 1/5 1/5 0];  % no merge or track switch moves
         P = [0 1 2 2 3 4 5 5]./5; % distribution % preallocating for speed
         d = rand;
         [~,m] = max(P>d);
      else 
         xsicurr = [0 1/7 1/7 1/7 1/7 1/7 1/7 1/7];
         P = [0 1 2 3 4 5 6 7]./7; % distribution % preallocating for speed
         d = rand;
         [~,m] = max(P>d);
      end
   end
end


end

