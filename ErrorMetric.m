%% Function description: the computation of error metric
%===============================================================================
% INPUT:
% @scan0        reference raw data 
% @scan1        cuurent raw data 
% @params       same with function 'PSM'
% @method       'RMS' or 'MSE'
% OUTPUT:
% @error        the error between two scans
% DATE:         2018/11/11 wyq
%===============================================================================

function error = ErrorMetric(scan0,scan1,params,method)

if strcmp(method,'RMS')
    
    % delete the bad points
    scan0 = scan0(:,and(scan0(2,:)>params.usable_range(1),scan0(2,:)<params.usable_range(2)));
    new_a = scan0(1,:);    
    scan1_new = scan1(:,and(scan1(2,:)>params.usable_range(1),scan1(2,:)<params.usable_range(2))); 
    new_r = interp1(scan1_new(1,:),scan1_new(2,:),new_a,'linear','extrap');
    scan1_new=[new_a;new_r];
    error = abs(scan0(2,:) - scan1_new(2,:));
    error = sum(error)/length(error);

elseif strcmp(method,'MSE')
    
    index0 = scan0(2,:)<params.usable_range(2) & scan0(2,:)>params.usable_range(1);
    index1 = scan1(2,:)<params.usable_range(2) & scan1(2,:)>params.usable_range(1);    
    index = index0 & index1;
    scan0 = scan0(:,index);
    scan1 = scan1(:,index);
    scan0xy = polar2xy(scan0);
    scan1xy = polar2xy(scan1);
    [q_match,p_match]=matchpoints(scan0xy,scan1xy);
    error=mean(sqrt(sum(power(p_match-q_match,2))));
       
end