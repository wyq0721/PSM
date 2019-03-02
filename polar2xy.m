function scanxy = polar2xy(scan)
%% trans scan from polar coordiante to cartesian coordiante

% %% the part of test
%     clear;
%     clc;
%     seattle = load('seattle.mat');
%     scan = seattle.range(678,:);

%% polar to xy
% if size(scan,1) == 1 
%     angel = linspace(-pi/2,pi/2,size(scan,2));
%     scanxy = [scan(1,:).*cos(angel(1,:));scan(1,:).*sin(angel(1,:))];
% else

    scanxy = [scan(2,:).*cos(scan(1,:));scan(2,:).*sin(scan(1,:))];
% end

% %% visualization
%     figure(1)
%     polarplot(angel,scan,'.k');
%     figure(2)
%     plot(scanxy(1,:),scanxy(2,:),'.k');