function [w,m,a]=blacktu(n,m)
%************************************************************************
%        This function computes the weights for the
%        Blackman-Tukey window
%
%     INPUTS:
%         n : lentgh of the series; required input to compute window lag 
%             size if m is not input to blacktu
%         m : window lag size
% 
%    OUTPUTS:
%         w : weights of the Blackman-Tukey window
%         m : window lag size; 
%             the same as input m if m was input to blacktu, otherwise
%             calculated with n
%         a : parameter in the window function
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


if nargin == 1
    if ~isempty(n)
        m=floor(n^(.756));
    else
        error('n cannot be empty if it is the only input to blacktu');
    end
end

a=.25;
w=zeros(m,1);
for i=1:m
  w(i) = 1-2*a+2*a*cos(pi*(i/m));
end
