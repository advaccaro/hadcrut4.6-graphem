function [ci3string] = latexci3(low, middle, high)
%% latexci3.m
% INPUTS: low (2.5 percentile)
%	  middle (50 percentile)
%	  high (97.5 percentile)
% OUTPUT: LaTeX formatted string

low_str = num2str(low, '%3.3f');
mid_str = num2str(middle, '%+3.3f');
high_str = num2str(high, '%3.3f');

ci3string = strcat("$_{",low_str,"}",mid_str,"_{",high_str,"}$");
