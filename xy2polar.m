function scan = xy2polar(scanxy)
%% trans scan from cartesian coordiante to polar coordiante

    scan(1,:) = atan2(scanxy(2,:),scanxy(1,:));
    scan(2,:) = sqrt(scanxy(1,:).^2+scanxy(2,:).^2);
%     polarplot(linspace(-pi/2,pi/2,size(scan,2)),scan,'.k');