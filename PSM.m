%% Function description: polar scan matching
%===============================================================================
% INPUT:
% @scan0        previous raw data form like [r1 r2 ... rk]
% @scan1        new raw data form like [r1 r2 ... rk]
% @params       listing in the function
% OUTPUT:
% @T_psm        3x3xk transform matrix that applying scan_now to align scan_pre
% @e_psm        error metric of range
% @t_psm        the calculation times per iteration
% DATE:         2018/11/11 wyq
%===============================================================================

function [T_psm, e_psm, t_psm, delta_psm]=PSM(scan0,scan1,params)

if nargin<3
    % default parameters
    params.max_range = pi/2;
    params.usable_range = [0.1 20];
    params.weight_c = 0.1; % computeW factor
    params.weight_m = 2; % computeW factor
    params.search_window_psm = -20:20; % search area in orientation estimation
    params.resolution = deg2rad(1);  % resolution of laser sensor in orientation correction
    params.max_error = 1;% threshold that data accepted in translation estimation
    params.iter = 100; % iterative times
    params.orient_threshold = deg2rad(0.1);%deg2rad(0.1);
    params.translate_threshold = 0.005;%0.005;
end

%% process

scan1PSM_trans= scan1;
scan0 = scan0(:,and(scan0(2,:)>params.usable_range(1),scan0(2,:)<params.usable_range(2)));
new_a = scan0(1,:);
delta_psm = zeros(3,params.iter);
e_psm = 1000*ones(params.iter,1);
T_psm = repmat(eye(3),[1 1 params.iter]);
t_psm = zeros(params.iter,1);

% projection
scan1PSM_new = scan1PSM_trans(:,and(scan1PSM_trans(2,:)>params.usable_range(1),scan1PSM_trans(2,:)<params.usable_range(2))); % delete the bad points
new_r = interp1(scan1PSM_new(1,:),scan1PSM_new(2,:),new_a,'linear','extrap');
scan1PSM_new=[new_a;new_r];

tic;
for iter =1:params.iter
    
    % orientation estimation
    e = 1000*ones(length(params.search_window_psm),1);
    j = 1;
    for i = params.search_window_psm
        if i <= 0
            error = abs(scan0(2,1:end+i) - scan1PSM_new(2,-i+1:end));
            e(j) = sum(error)/length(error);
        else
            error = abs(scan0(2,i+1:end) - scan1PSM_new(2,1:end-i));
            e(j) = sum(error)/length(error);
        end
        j = j+1 ;
    end
    [~, index_min] = min(e);
    i_min = params.search_window_psm(index_min);
    delta_O = i_min*params.resolution;
    
    % correcting by quadratic interpolation
    if index_min > 1 && index_min < length(params.search_window_psm)
        num = e(index_min+1) -  e(index_min-1);
        den = 2*( 2*e(index_min) - e(index_min-1)- e(index_min+1));
        delta = num/den;
        delta_O = delta_O+delta*params.resolution;
    end
    
    % translation estimation
    delta_r =  scan0(2,:)-scan1PSM_new(2,:) ;
    index_r = abs(delta_r)<params.max_error;
    delta_r = delta_r(index_r);
    if size(delta_r,2) < 10
        fprintf('WARNING: In PSM %d Iter, Points_overlap is Less Than Require.\n',iter);
        break;
    end
    W = computeW(delta_r, params);
    H = [cos(scan1PSM_new(1,index_r))' sin(scan1PSM_new(1,index_r))'];
    delta_T = (H'*W*H)\H'*W*delta_r';

    % transform current scan
    x = scan1PSM_trans(2,:).*cos(scan1PSM_trans(1,:)+delta_O)+delta_T(1);
    y = scan1PSM_trans(2,:).*sin(scan1PSM_trans(1,:)+delta_O)+delta_T(2);
    scan1PSM_trans = [atan2(y,x); sqrt(x.^2+y.^2)];
    
    % projection
    scan1PSM_new = scan1PSM_trans(:,and(scan1PSM_trans(2,:)>params.usable_range(1),scan1PSM_trans(2,:)<params.usable_range(2))); % delete the bad points
    new_r = interp1(scan1PSM_new(1,:),scan1PSM_new(2,:),new_a,'linear','extrap');
    scan1PSM_new=[new_a;new_r];
    t_psm(iter) = toc;
    
    % transformation record
    if iter == 1
        delta_psm(:,iter) = [delta_O;delta_T];
    else
        delta_psm(:,iter)= delta_psm(:,iter-1) + [delta_O;delta_T];
    end
    T_psm(:,:,iter) = [cos(delta_psm(1, iter)) -sin(delta_psm(1, iter)) delta_psm(2, iter);sin(delta_psm(1, iter)) cos(delta_psm(1, iter)) delta_psm(3, iter); 0 0 1];

    
    % terminal judge
    if norm(delta_T) < params.translate_threshold && norm(delta_O) < params.orient_threshold
        fprintf('BREAK: In PSM %d Iter, Delta_Translation %f and Delta_Orientation %f is Smaller Than Threshold.\n',iter,norm(delta_T), delta_O); 
        break;
    end

end
