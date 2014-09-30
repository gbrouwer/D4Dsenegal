function sp = periodg(x,win,winlag,alpha)
%************************************************************************
%        This function computes the (smoothed) periodogram
%
%     INPUTS:
%------------
%   REQUIRED
%         x : series
%
%   OPTIONAL
%       win : window used for smoothing the periodogram; 
%             = 0 : no smoothing is performed
%             = 1 : Blackman-Tukey window
%             = 2 : Parzen window
%             = 3 : Tukey-Hanning window
%             Parzen window is used, if win is not input to periodg or 
%             if win is empty, 
%    winlag : window lag size; if it is empty, winlag is computed by the program
%    alpha  : significance level needed for calculaction of the confidence
%             intervals; if alpha is not input to periodg or if alpha is
%             empty, confidence intervals are not computed
%
%
%    OUTPUTS:
%------------
%        sp : structure with the following fields:
%             .f      : (smoothed) periodogram
%             .n      : length of x
%             .win    : window used for smoothing the periodogram
%             .winlag : window lag size; empty if no smoothing was
%                       performed
%             .a      : parameter of the Blackman-Tukey window; a is field
%                       of sp if win = 1
%             Additional field, if alpha is input to periodg and is not
%             empty
%             .fconf  : confidence intervals for f
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

n=length(x);
cxx0=croscov(x,x,0);
% np=floor((n-1)/2);
np=floor(n/2);
frq=zeros(np+1,1);

for i=0:np
   frq(i+1)=2*pi*i/n;
end

% Check the arguments and set defaults

if nargin == 1 || isempty(win)
    win = 2;
end
 
if nargin < 4
    alpha = [];
end

if nargin < 3
    winlag = [];
end


%------------------------------------------------------------------

if win >= 1
   f=zeros(1,np+1);
   if win == 1
       if isempty(winlag)
           [w,winlag,a]=blacktu(n);
       else
           [w,winlag,a]=blacktu(n,winlag);
       end
   elseif win == 2
        if isempty(winlag)
           [w,winlag]=parzen(n);
        else
           [w,winlag]=parzen(n,winlag);
        end
   elseif win == 3
      if isempty(winlag)
           [w,winlag]=tukhan(n);
       else
           [w,winlag]=tukhan(n,winlag);
       end
   end
   m = winlag;
   cxx=zeros(1,m);
   for i=1:m
      cxx(i)=croscov(x,x,i);
   end
   for i=1:np
      aux=0;
      for j=1:m
         aux=aux+w(j)*cxx(j)*cos(2*pi*j*i/n);
      end
      f(i+1)=cxx0/(2*pi)+aux/pi;
    end
    aux=cxx*w;
    f(1)=cxx0/(2*pi)+aux/pi;
else
   winlag = [];
   f=zeros(1,np+1);
   m=n-1;
   cxx=zeros(1,m);
   for i=1:m
      cxx(i)=croscov(x,x,i);
   end
   for i=1:np
      aux=0;
      for j=1:m
         aux=aux+cxx(j)*cos(2*pi*j*i/n);
      end
      f(i+1)=cxx0/(2*pi)+aux/pi;
    end
    f(1)=(n/(2*pi))*(mean(x))^2;
end


% Collect variables in the structure sp
sp.f = f';
sp.n = n;
sp.win = win;
sp.winlag = winlag;
sp.frq = frq;
if win == 1
    sp.a = a;
end

if ~isempty(alpha)
    fconf = spconf(sp,alpha);
    sp.fconf = fconf;
    sp.alpha = alpha;
end


