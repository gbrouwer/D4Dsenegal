function cqsp = cospqu(x,y,win,winlag)
%************************************************************************
%
%        This function computes the (smoothed) cross-periodogram
%
%     INPUTS:
%------------
%   REQUIRED
%        x,y : series
%
%   OPTIONAL
%       win : window used for smoothing the periodogram; 
%             = 0 : no smoothing is performed
%             = 1 : Blackman-Tukey window
%             = 2 : Parzen window
%             = 3 : Tukey-Hanning window
%             Parzen window is used, if win is not input to cospqu or 
%             if win is empty, 
%    winlag : window lag size; if it is not input to cospqu or if it
%             empty, winlag is computed by the program
%
%
%    OUTPUTS:
%------------
%      cqsp : structure with the following fields
%             .c      : cospectrum
%             .q      : quadrature spectrum
%             .n      : length of x and y
%             .win    : window used for smoothing the periodogram
%             .winlag : window lag size; empty if no smoothing was
%                       performed
%             .a      : parameter of the Blackman-Tukey window; 
%                       a is field of sp if win = 1
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
cxy0=croscov(x,y,0);
% np=floor((n-1)/2);
np=n/2;
c=zeros(1,np+1);
q=zeros(1,np+1);

% Check the arguments and set defaults

if nargin < 2
    error('x and y are required inputs to cospqu');
end

if nargin == 2 || isempty(win)
    win = 2;
end

if nargin < 4
    winlag = [];
end

if win >= 1
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
   cxy=zeros(1,m);
   cyx=zeros(1,m);
   for i=1:m
      cxy(i)=croscov(y,x,i);
      cyx(i)=croscov(x,y,i);
   end
   for i=1:np
      auxc=0;
      auxq=0;
      for j=1:m
         auxc=auxc+w(j)*(cxy(j)+cyx(j))*cos(2*pi*j*i/n);
         auxq=auxq+w(j)*(cxy(j)-cyx(j))*sin(2*pi*j*i/n);
      end
      c(i+1)=(cxy0+auxc)/(2*pi);
      q(i+1)=auxq/(2*pi);
    end
    auxc=(cxy+cyx)*w;
    c(1)=(cxy0+auxc)/(2*pi);
    q(1)=0;
else
   cxy=zeros(1,np+1);
   cyx=zeros(1,np+1);
   for i=1:np
      cxy(i)=croscov(y,x,i);
      cyx(i)=croscov(x,y,i);
   end
   for i=1:np
      auxc=0;
      auxq=0;
      for j=1:np
         auxc=auxc+(cxy(j)+cyx(j))*cos(2*pi*j*i/n);
         auxq=auxq+(cxy(j)-cyx(j))*sin(2*pi*j*i/n);
      end
      c(i+1)=(cxy0+auxc)/(2*pi);
      q(i+1)=auxq/(2*pi);
    end
    auxc=sum(cxy+cyx);
    c(1)=(cxy0+auxc)/(2*pi);
    q(1)=0;
    winlag = [];
end

q=-q;

% Collect variables in the structure cqsp
cqsp.c = c';
cqsp.q = q';
cqsp.n = n;
cqsp.win = win;
cqsp.winlag = winlag;
if win == 1
    cqsp.a = a;
end

