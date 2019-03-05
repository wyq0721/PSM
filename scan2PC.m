%% Function description: trans the scan from one dimension to two dimension
%===============================================================================
% INPUT:
% @scan         scan data in the form [rho]
% @params       same with function 'PSM'
% OUTPUT:
% @pointcloud   scan data in the form [theta;rho]
% DATE:         2018/11/11 wyq
%===============================================================================
function [pointcloud] = scan2PC(scan,params)

pointcloud = [linspace(-params.max_range,params.max_range,size(scan,2));scan];