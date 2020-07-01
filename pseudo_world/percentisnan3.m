%percentisnan3.m
%input X - 3d structure w/ nans
%output percent of nans
function [p] = percentisnan3(X)
p = sum(sum(sum(isnan(X))))/numel(X)
q = 1 - p 
