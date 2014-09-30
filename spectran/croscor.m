function [cr,stdx,stdy] = croscor(x,y,lag)
%************************************************************************
%
%    This function computes the correlations between x(t) and y(t+lag). 
%    Lag can be both positive and negative.
%
%     INPUTS:
%------------
%    REQUIRED
%       x,y : series; y = x, if autocorrelations are to be computed
%
%    OPTIONAL
%       lag : number of lags at which the correlations are to be computed
%             (negative lags are interpreted as leads);
%             lag = length(y)-1, if lag is not input to croscor or if lag
%             is empty
%
%    OUTPUTS:
%------------
%        cv : correlations between x and y
%      stdx : standard deviation of x
%      stdy : standard deviation of y
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
%*************************************************************************

% Check the arguments 

if nargin < 2 || isempty(x) || isempty(y)
    error('x and y are required inputs to croscov');
end
    
n=length(y);

if n~=length(x)
   error('x and y must be the same size');
end

if nargin == 2 || isempty(lag)
    lag = n-1;
end


stdx=sqrt((x-mean(x))'*(x-mean(x)));
stdy=sqrt((y-mean(y))'*(y-mean(y)));
if lag < 0
   cr=((x(1-lag:n)-mean(x))'*(y(1:n+lag)-mean(y)))/(stdx*stdy);
elseif lag > 0
   cr=((x(1:n-lag)-mean(x))'*(y(1+lag:n)-mean(y)))/(stdx*stdy);
else
   cr=((x-mean(x))'*(y-mean(y)))/(stdx*stdy);
end
