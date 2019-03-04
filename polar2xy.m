%% Function description: transform scan from polar coordiante to cartesian coordinate
%===============================================================================
% INPUT:
% @scan         the scan in polar coordiante
% OUTPUT:
% @scanxy       the scan in cartesian coordiante
% DATE:         2018/11/11 wyq
%===============================================================================

function scanxy = polar2xy(scan)

scanxy = [scan(2,:).*cos(scan(1,:));scan(2,:).*sin(scan(1,:))];
