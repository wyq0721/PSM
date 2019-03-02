function [q_match,p_match]=matchpoints(q,p)

% p=trans2D(p,T);

kdOBJq = KDTreeSearcher(transpose(q));
[match, mindist] = knnsearch(kdOBJq,transpose(p));
p_idx = mindist<0.3;
% p_idx = mindist<0.1;
q_idx = match(p_idx);
q_idx=unique(q_idx);

q_match = q(:,q_idx);
p_match_temp = p(:,p_idx);
kdOBJp = KDTreeSearcher(p_match_temp');
[match, ~] = knnsearch(kdOBJp,q_match');
% pt_match=p(:,p_idx);
p_match=p_match_temp(:,match);
