%percentisnan2.m
%input X - 2d structure w/ nans
%output percent of nans
function [p] = percentisnan2(X)
p = sum(sum(isnan(X)))/numel(X)
q = 1 - p 
