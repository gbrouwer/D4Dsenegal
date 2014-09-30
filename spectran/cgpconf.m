function [cconf,gconf,pconf] = cgpconf(cgpsp,fx,fy,alpha)
%***********************************************************************
%   This function computes the confidence interval for the coherency, 
%   gain and phase angle
%   See Koopmans, L.H.(1974), "The Spectral Analysis of Time Series", 
%   pp. 282-287, Table 8.1 (p.279)
% 
%      INPUTS:
%-------------
%     REQUIRED
%      cgpsp : structure, output of function cohepha
%         fx : smoothed periodogram of x
%         fy : smoothed periodogram of y 
%
%     OPTIONAL
%      alpha : significance level needed for calculation of 
%              the confidence intervals;
%              alpha = 0.05, if alpha is not input to cgpsp or
%              if alpha is empty
%
%     OUTPUTS:
%-------------
%      cconf : confidence intervals for the coherency
%      gconf : confidence intervals for the gain
%      pconf : confidence intervals for the phase angle
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

% Check the number of arguments
if nargin < 3
    error('There must be at least three inputs to cgpconf');
end

% Set default value for the significance level

if nargin == 3 || isempty(alpha)
    alpha = 0.05;
end

co = cgpsp.co;
sco = cgpsp.sco;
ga = cgpsp.ga;
ph = cgpsp.ph;
n = cgpsp.n;
win = cgpsp.win;
winlag = cgpsp.winlag;

if win == 0
    error('Confidence intervals are computed only for the smoothed cross spectral measures');
end
    
% Compute EDV (equivalent degrees of freedom) dependent on the window
% function
% See Table 8.1, p.279
if win == 1       % Blackman-Tukey
    a = sp.a;
    edf = (n/winlag)*(1-4*a+6*a^2);
elseif win == 2   % Parzen
    edf = 3.7*(n/winlag);
elseif win == 3   % Tukey-Hanning
     edf = 2.67*(n/winlag);
end

hedf = edf/2;

%------------------------------------------------------------------
% Confidence intervals for the coherency (pp.282,283)

% Upper cutoff alpha/2 point for the standard normal distribution
ustnd = norminv((1-alpha/2),0,1);

aa = (2*(hedf-1))^(-0.5);
bb = atanh(co) - ustnd*aa - aa^2;
cc = atanh(co) + ustnd*aa - aa^2;
lcconf = tanh(bb);
ucconf = tanh(cc);

cconf = [lcconf, ucconf];

%------------------------------------------------------------------------

% Confidence intervals for the gain (pp.284,285)

% Upper alpha cutoff point of the F distribution with 2 and edf-2 
% degrees of freedom
% P(F_{2,edf-2} <= F_{2,edf-2}(alpha)) = 1-alpha

uf = finv(1-alpha,2,edf-2);

% Upper alpha cutoff point of the t distribution with nu degrees of
% freedom, where nu = hedf-2 if frequency = 0 and nu = hedf-1 if frequency
% = pi

% np=floor((n-1)/2);
% np=n/2;
% frq=zeros(np+1,1);
% 
% for i=0:np
%    frq(i+1)=2*pi*i/n;
% end

nu1 = hedf-2;
nu2 = hedf-1;

ut1 = tinv(1-alpha,nu1);
ut2 = tinv(1-alpha,nu2);

lg = length(ga);

isco = 1.-sco;
d = (fx.*isco)./fy;
dd = ((1/nu1)*d*uf).^(0.5);
dd1 = (((1/nu1)*d(1))^(0.5))*ut1;
dd2 = (((1/nu2)*d(end))^(0.5))*ut2;

lgconf = zeros(lg,1);
lgconf(1) = ga(1)-dd1;
lgconf(2:end-1) = ga(2:end-1)-dd(2:end-1);
lgconf(end) = ga(end)-dd2;

ugconf = zeros(lg,1);
ugconf(1) = ga(1)+dd1;
ugconf(2:end-1) = ga(2:end-1)+dd(2:end-1);
ugconf(end) = ga(end)+dd2;

gconf = [lgconf, ugconf];

%---------------------------------------------------------------------
% Confidence intervals for the phase angle

% Upper alpha/2 cutoff point of the t distribution with edf-2 degrees of
% freedom

ut = tinv(1-(alpha/2),edf-2);

p = isco./(sco*(edf-2));
pp = sqrt(p)*ut;

lpconf = ph - asin(pp);
upconf = ph + asin(pp);

for i = 1:lg
    if lpconf(i) < -pi
        lpconf(i) = lpconf(i) + 2*pi;
    end
    if upconf(i) > pi
        upconf(i) = upconf(i) - 2*pi;
    end
end

pconf = [lpconf, upconf];
pconf = real(pconf);      % possible complex values

% The computed confidence intervals hold for all frequencies except 0 and pi

pconf(1,:) = [NaN, NaN];
pconf(end,:) = [NaN, NaN];











