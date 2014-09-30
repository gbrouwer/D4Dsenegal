function [mu,conf,alpha] = circconfmean(theta,alpha,w,dim)
%********************************************************************
%   This function computes the mean direction and the confidence interval
%   for the mean direction for circular data
%
%   See Fisher and Lewis (1983) "Estimating the Common Mean Direction of
%   Several Circular or Spherical Distributions with Differing
%   Dispersions", Biometrika, 70, pp. 333-341
%
%   INPUTS:
% ---------
%   theta :  vector or matrix with angle values in radians (required)
%   alpha :  significance level; default is 0.05
%       w :  weights in case of binned angle data;
%            default is vector with ones
%     dim :  dimension, along which the mean direction is to be computed;
%            default is 1
%
%  OUTPUTS:
% ---------
%      mu :  mean direction
%    conf :  confidence bounds for mu
%   alpha :  significance level
% 
%
% Martyna Marczak                     Victor Gomez
% Department of Economics (520G)      Ministerio de Hacienda 
% University of Hohenheim             Direccion Gral. de Presupuestos
% Schloss, Museumsfluegel             Subdireccion Gral. de Analisis y P.E.
% 70593 Stuttgart                     Alberto Alcocer 2, 1-P, D-34
% GERMANY                             8046 Madrid
%                                     SPAIN                     
% Phone: + 49 711 459 23823           Phone : +34 915835439
% E-mail: marczak@uni-hohenheim.de    E-mail: vgomez@sepg.minhap.es    
%
%                                
% Copyright (c) 2012 
% The authors assume no responsibility for errors or damage resulting from the use
% of this code. Usage of this code in applications and/or alterations of it should 
% be referenced. This code may be redistributed if nothing has been added or
% removed and no money is charged. Positive or negative feedback would be appreciated.
%
%***************************************************************************

% Check arguments and set defaults

if nargin < 4
  dim = 1;
end

if nargin < 3 || isempty(w)
	w = ones(size(theta));
else
  if size(w,2) ~= size(theta,2) || size(w,1) ~= size(theta,1) 
    error('Input dimensions do not match');
  end 
end

% set significance level to default
if nargin < 2 || isempty(alpha)
  alpha = 0.05;
end

%--------------------------------------------------------------

[mu,R] = circmean(theta,w,dim);

theta2 = 2*theta;
% Convert values of theta, if necessary:
wrap1 = theta2 > pi;
wrap2 = theta2 < -pi;
theta2(wrap1) = theta2(wrap1)-2*pi;
theta2(wrap2) = theta2(wrap2)+2*pi;

[junk,alph2] = circmean(theta2,w,dim);

[n, nth] = size(theta);
sigma = (1-alph2)./(2*n*R.^2);
sigma = sqrt(sigma);
d = norminv(1-alpha/2)*sigma;

conf = zeros(2,nth);

for i = 1:nth
    if d(i) < 1
       dev = d(i);
       dev = asin(dev);
       conff = mu(i) + [-dev; dev];
       % Convert the confidence limits, if necessary:
       if conff(1,1) < -pi
           conff(1,1) = conff(1,1)+2*pi;
       end
       if conff(2,1) > pi
           conff(2,1) = conff(2,1)-2*pi;
       end
       conf(:,i) = conff;
    else
       conf(:,i) = [-pi;pi];
    end
end





