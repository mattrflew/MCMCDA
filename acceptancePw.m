function [ P_acc ] = acceptancePw(pww, pwh)
%ACCEPTANCE( W0, W1 ) 
%   Calculates the acceptance probability of new feasible association set
%   W0 given the previous accepted feasible solution set W0

global mprev mcurr xsiprev xsicurr % bei pronti (nice and ready)

% % Matt
% what does it mean for q to be empty?
% Where are xsi defined?

xsicurr
qh=xsicurr(mcurr)
qw=xsiprev(mprev)

if isempty(qw)
    qh=1;
    qw=1;
end

P_acc = min(1, (pwh/pww)*(qh/qw));
%msg=strcat('Prob. acceptance = ',' ',num2str(P_acc));
%disp(msg);
end

