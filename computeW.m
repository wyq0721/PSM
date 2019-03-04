%% Function description: the computation of weight
%===============================================================================
% INPUT:
% @delta_r      the distance between corresponding polar radius
% @params       same with function 'PSM'
% OUTPUT:
% @W        	a diagonal matrix that includes the weight for each corresponding pair
% DATE:         2018/11/11 wyq
%===============================================================================

function w = computeW(delta_r,params)
% sigmoid function(https://en.wikipedia.org/wiki/Sigmoid_function)
w = (params.weight_c^params.weight_m)./(delta_r.^params.weight_m + params.weight_c^params.weight_m);
w = diag(w);