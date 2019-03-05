%% Function description: find the closest point pairs in two scans
%===============================================================================
% INPUT:
% @q             reference raw data 
% @p             current raw data 
% OUTPUT:
% @q_match       matched reference raw data 
% @p_match       matched current raw data 
% DATE:          2018/11/11 wyq
%===============================================================================

function [q_match,p_match]=matchpoints(q,p)

% create a kd-tree to accelerate
kdOBJq = KDTreeSearcher(transpose(q));
[match, mindist] = knnsearch(kdOBJq,transpose(p));
p_idx = mindist<0.3;
q_idx = match(p_idx);
q_idx=unique(q_idx);

q_match = q(:,q_idx);
p_match_temp = p(:,p_idx);
kdOBJp = KDTreeSearcher(p_match_temp');
[match, ~] = knnsearch(kdOBJp,q_match');
p_match=p_match_temp(:,match);
