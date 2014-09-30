function [mu,R] = circmean(theta,w,dim)
%*************************************************************************
%   This function computes the mean direction and the mean resultant 
%   length for circular data
%
%   See Fisher and Lewis (1983) "Estimating the Common Mean Direction of
%   Several Circular or Spherical Distributions with Differing
%   Dispersions", Biometrika, 70, pp. 333-341
%
%   INPUTS:
% ---------
%   theta :  vector or matrix with angle values in radians (required)
%       w :  weights in case of binned angle data; 
%            default is vector with ones
%     dim :  dimension, along which the mean direction is to be computed;
%            default is 1
%
%  OUTPUTS:
% ---------
%      mu :  mean direction
%       R :  mean resultant length
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

if (nargin < 3) || (isempty(dim))
  dim = 1;
end

if nargin < 2 || isempty(w)
	w = ones(size(alpha));
else
  if size(w,2) ~= size(theta,2) || size(w,1) ~= size(theta,1) 
    error('Input dimensions do not match');
  end 
end

%--------------------------------------------------------------

% compute weighted sum of cos and sin of angles
r = sum(w.*exp(1i*theta),dim);

% obtain mean by
mu = angle(r);

% obtain length 
R = abs(r)./sum(w,dim);

