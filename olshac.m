function [beta, R2, R2adj, X2_NW, X2_HH, X2_R, std_NW, std_HH, std_R, t_NW, t_HH, t_R] = olshac(y,X,L,H)
% PURPOSE: computes OLS with Robust, Newey-West, and Hansen-Hodrick adjusted
%           heteroscedastic-serial consistent standard errors
% Inputs:
%  y = T x 1 vector, left hand variable data
%  X = T x n matrix, right hand variable data
%  L = number of lags to include in NW corrected standard errors
%  H = number of lags to include in HH corrected standard errors
%
%Note: you must make one column of X a vector of ones if you want a
%   constant.
% Output:
%  beta = regression coefficients 1 x n vector of coefficients
%  R2    =    unadjusted
%  R2adj = adjusted R2
%  X2(Degrees of Freedom) = : Chi-squared statistic for all coefficients
%                               jointly zero.
%  std  = corrected standard errors.
%  t_   = t-stat for NW and HH
%Note: For chi-square test program checks whether first is a constant and ignores that one for
%       test. If there is only one beta the program does not report X^2
%       results since t_stat^2= X2.
%Note: program automatically displays outputs in an organized format. If you want
%to disable the automatic display just comment lines 129-136.
%Estimate Betas and Residuals
[T,n]   =   size(X);
beta    =   (inv(X'*X))*X'*y;
u       =   y-X*beta;
u= u*ones(1,n);
err=X.*u; %estimating residuals for each beta
%Calculate R2
y_bar = mean(y);
R2 = (beta'*X'*X*beta-T*(y_bar^2))/(y'*y-T*(y_bar^2));
R2adj= R2'*(T-1)/(T-n);
%Calculate Hansen Hodrick Corrected Standard Errors
V=[err'*err]/T; %regular weighting matrix
if H > -1
    for ind_i = (1:H);
        S = err(1:T-ind_i,:)'*err(1+ind_i:T,:)/T;
        V = V + (1-0*ind_i/(H+1))*(S + S');
    end;
end;
D       =   inv((X'*X)/T);
varb = 1/T*D*V*D;
seb = diag(varb);
std_HH = sign(seb).*(abs(seb).^0.5);
%F test for all coeffs (except constant) zero -- actually chi2 test
%Regular
if X(:,1) == ones(size(X,1),1);
    chi2val = beta(2:end,:)'*inv(varb(2:end,2:end))*beta(2:end,:);
    dof = size(beta(2:end,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2_HH(:,1:3) = [chi2val dof pval];
else;
    chi2val = beta(:,:)'*inv(varb)*beta(:,:);
    dof = size(beta(:,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2_HH(:,1:3) = [chi2val dof pval];
end;
% T-Stats with HH
t_HH = beta./std_HH;
clear V S D varb seb chi2val dof pval
%-----------------------------------------------------------------------%
%Calculate NW Corrected Standard Errors
V=[err'*err]/T;
if L > -1
    for ind_i = (1:L);
        S = err(1:T-ind_i,:)'*err(1+ind_i:T,:)/T;
        V = V + (1-1*ind_i/(L+1))*(S + S');
    end;
end;
D       =   inv((X'*X)/T);
varb = 1/T*D*V*D;
seb = diag(varb);
std_NW = sign(seb).*(abs(seb).^0.5);
%F test for all coeffs (except constant) zero -- actually chi2 test
%NW
if X(:,1) == ones(size(X,1),1);
    chi2val = beta(2:end,:)'*inv(varb(2:end,2:end))*beta(2:end,:);
    dof = size(beta(2:end,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2_NW(:,1:3) = [chi2val dof pval];
else;
    chi2val = beta(:,:)'*inv(varb)*beta(:,:);
    dof = size(beta(:,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2_NW(:,1:3) = [chi2val dof pval];
end;
% T_Stats
t_NW =  beta./std_NW;
clear V S D varb seb chi2val dof pval
%-----------------------------------------------------------------------%
%Calculate Robust Standard Errors
V=[err'*err]/T;
D       =   inv((X'*X)/T);
varb = 1/T*D*V*D;
seb = diag(varb);
std_R = sign(seb).*(abs(seb).^0.5);
%F test for all coeffs (except constant) zero -- actually chi2 test
%NW
if X(:,1) == ones(size(X,1),1);
    chi2val = beta(2:end,:)'*inv(varb(2:end,2:end))*beta(2:end,:);
    dof = size(beta(2:end,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2_R(:,1:3) = [chi2val dof pval];
else;
    chi2val = beta(:,:)'*inv(varb)*beta(:,:);
    dof = size(beta(:,1),1);
    pval = 1-cdf('chi2',chi2val, dof);
    X2_R(:,1:3) = [chi2val dof pval];
end;
% T_Stats
t_R =  beta./std_R;
% Formatting
disp('     Beta       NW        HH       RR       t_NW       t_HH       t_R');
disp([beta std_NW std_HH std_R t_NW t_HH t_R]);
disp(sprintf('R2 = %.3f', R2(1)));
disp(' ');
if length(beta(2:end,:)) >1
    disp(sprintf('  X2_NW(%d)   X2_HH(%d)   X2_R(%d)', X2_NW(2), X2_HH(2), X2_R(2)))
    disp( [X2_NW(1) X2_HH(1) X2_R(1); X2_NW(3) X2_HH(3) X2_R(3)]) %chi2 values and p-vals
end
end
