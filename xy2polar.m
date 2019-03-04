%% Function description: transform scan from cartesian coordiante to polar coordinate
%===============================================================================
% INPUT:
% @scanxy       the scan in cartesian coordiante
% OUTPUT:
% @scan         the scan in polar coordiante
% DATE:         2018/11/11 wyq
%===============================================================================
function scan = xy2polar(scanxy)

scan(1,:) = atan2(scanxy(2,:),scanxy(1,:));
