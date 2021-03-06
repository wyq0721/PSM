%% Function description:  apply the transformation on current scan
%===============================================================================
% INPUT:
% @scan         the current scan before transformation
% @T            the transformation
% OUTPUT:
% @scan_trans   the scan after transformation
% DATE:         2018/11/11 wyq
%===============================================================================
function scan_trans = TransScan(scan,T)  

scanxy = [scan(2,:).*cos(scan(1,:));scan(2,:).*sin(scan(1,:))];
scan_transxy = T*[scanxy;ones(1,size(scanxy,2))];
scan_transxy = scan_transxy(1:2,:);
scan_trans = [atan2(scan_transxy(2,:),scan_transxy(1,:));sqrt(scan_transxy(1,:).^2+scan_transxy(2,:).^2)];

