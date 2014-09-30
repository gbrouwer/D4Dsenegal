function fconf = spconf(sp,alpha)
%***********************************************************************
% 
%    This function computes the confidence intervals for the smoothed
%    periodogram
%    See Koopmans, L.H.(1974), "The Spectral Analysis of Time Series", 
%    p.274, 279
% 
%      INPUTS:
%-------------
%     REQUIRED
%         sp : structure, output of function periodg
%
%     OPTIONAL
%      alpha : significance level needed for calculation of 
%              the confidence intervals;
%              alpha = 0.05, if alpha is not input to spconf or
%              if alpha is empty
%
%      OUTPUT:
%-------------
%      fconf : confidence intervals for the smoothed periodogram
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


% Set default value for the significance level

if nargin == 1 || isempty(alpha)
    alpha = 0.05;
end

f = sp.f;
n = sp.n;
win = sp.win;
winlag = sp.winlag;

if win == 0
    error('Confidence interval is computed only for the smoothed periodogram');
end
    
% Compute EDV (equivalent degrees of freedom) dependent on the window
% function
% See Table 8.1, p.279
if win == 1       % Blackman-Tukey
    a = sp.a;
    edf = (n/winlag)/(1-4*a+6*a^2); % error in the book (it should be a ratio
                                    % and not a product)
elseif win == 2   % Parzen
    edf = 3.7*(n/winlag);
elseif win == 3   % Tukey-Hanning
     edf = 2.67*(n/winlag);
end
    
% Compute a and b, so that 
% P(chi^2_edf <= a) = alpha/2 
% and 
% P(chi^2 <= b) 1-alpha/2

aa = chi2inv(alpha/2,edf);
bb = chi2inv(1-(alpha/2),edf);

lfconf = (edf*f)/bb;
ufconf = (edf*f)/aa;

fconf = [lfconf, ufconf];

    
    
