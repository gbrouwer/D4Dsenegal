function cgpsp = cohepha(cqsp,fxx,fyy)
%************************************************************************
%
%        This function computes coherency, coherence (squared coherency),
%        gain and phase angle
%
%     INPUTS:
%------------
%      cqsp : structure, output of function cospqu
%       fxx : (smoothed) periodogram of x
%       fyy : (smoothed) periodogram of x
%
%
%    OUTPUTS:
%------------
%     cgpsp : structure with the following fields
%             .co     : coherency
%             .sco    : coherence (squared coherency)
%             .ga     : gain
%             .ph     : phase angle
%             .n      : length of x and y
%             .win    : window function
%             .winlag : window lag size
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

if nargin < 3
    error('cqsp, fxx and fyy are required inputs to cohepha');
end

cxy = cqsp.c;
qxy = cqsp.q;
n = cqsp.n;
win = cqsp.win;
winlag = cqsp.winlag;

alpha=cxy.^2+qxy.^2;        % squared modulus of the cross spectrum
sco=alpha./(fxx.*fyy);      % squared coherency (coherence)

co=(alpha./(fxx.*fyy)).^(0.5);   % coherency 

ga=(alpha./fyy.^2).^(.5);   % gain

l=length(cxy);
ph = zeros(l,1);
for i=1:l
    ph(i) = atan2(qxy(i),cxy(i));  % phase angle
end

% Collect variables in the structure cpgsp

cgpsp.co = co;
cgpsp.sco = sco;
cgpsp.ph = ph;
cgpsp.ga = ga;
cgpsp.n = n;
cgpsp.win = win;
cgpsp.winlag = winlag;


