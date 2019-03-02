function w = computeW(delta_r,params)
w = (params.weight_c^params.weight_m)./(delta_r.^params.weight_m + params.weight_c^params.weight_m);
w = diag(w);