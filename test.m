
%% initial
% load data
clear;
clc;
load('seattle.mat');
data = range;

% parameters
params.max_range = 1/2*pi; 
params.usable_range = [0.2 20];
params.weight_c = 0.1;
params.weight_m = 2;
params.search_window_psm = -50:50;
params.resolution = 2*params.max_range/size(data,2);
params.max_error = 1;%0.1;
params.iter = 100;
params.orient_threshold = deg2rad(0.1);%deg2rad(0.1);
params.translate_threshold = 0.005;%0.005;

%% preprocess
interval = 6;
step = 888;
% step = random('unid',size(data,1));
 
scan0 = data(step,:);
scan1 = data(step+interval,:);
scan0 = scan2PC(scan0,params);% [theta;rho]
scan1 = scan2PC(scan1,params);

%% Scan Matching

% PSM
[T_psm, ~, t_psm] = PSM(scan0,scan1,params);
index_terminal = find(t_psm,1,'last');
time_psm_terminal = t_psm(index_terminal);
scan1PSM_trans = TransScan(scan1,T_psm(:,:,index_terminal));

%% visualization

r_marksize = 6;
c_marksize = 1;
fontsize = 10;

% cartesian
scan0xy = polar2xy(scan0(:,and(scan0(2,:)>params.usable_range(1),scan0(2,:)<params.usable_range(2))));
scan1xy = polar2xy(scan1(:,and(scan1(2,:)>params.usable_range(1),scan1(2,:)<params.usable_range(2))));
scan1PSM_transxy = polar2xy(scan1PSM_trans(:,and(scan1PSM_trans(2,:)>params.usable_range(1),scan1PSM_trans(2,:)<params.usable_range(2))));
    figure(12);
    clf
    set(gcf,'position',[200 200 600 300])
    % Original
    subplot('Position', [0.08 0.15 0.4 0.8]);
    set(gca,'fontsize',fontsize,'fontweight','bold','GridAlph', 0.03);
%     xlim([-20 15])
%     ylim([-20 15])
    hold on
    grid on
    axis equal
    plot(scan0xy(1,:),scan0xy(2,:),'.k','markersize',r_marksize);
    plot(scan1xy(1,:),scan1xy(2,:),'or','markersize',c_marksize);
    lgd = legend({'Reference Scan','Current Scan'},'fontsize',7);
    set(lgd ,'Interpreter','none');
    xlabel('x(m)')
    ylabel('y(m)')
    text(0.04,0.08,'(a) Raw','units','normalized','FontSize',12,'fontweight','bold')
    
    % PSM    
    subplot('Position', [0.58 0.15 0.4 0.8]);
    set(gca,'fontsize',fontsize,'fontweight','bold','GridAlph', 0.03);
%     xlim([-20 15])
%     ylim([-20 15])
    hold on
    grid on
    axis equal
    plot(scan0xy(1,:),scan0xy(2,:),'.k','markersize',r_marksize);
    plot(scan1PSM_transxy(1,:),scan1PSM_transxy(2,:),'or','markersize',c_marksize);
    text(.8, .9,'PSM','units','normalized','FontSize',12,'fontweight','bold');
    xlabel('x(m)')
    ylabel('y(m)')
    text(0.04,0.08,'(b) Alignment','units','normalized','FontSize',12,'fontweight','bold')


%% text display

mse_psm = ErrorMetric(scan0,scan1PSM_trans,params,'MSE');
disp(step)
disp('    psm_time  psm_mse')
disp([ time_psm_terminal mse_psm])
