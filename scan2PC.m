function [pointcloud] = scan2PC(scan,params)
pointcloud = [linspace(-params.max_range,params.max_range,size(scan,2));scan];