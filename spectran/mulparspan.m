function mulsp = mulparspan(y,win,winlag,alpha)
%***********************************************************************
%      This function computes multiple (squared), partial (squared)
%      coherency, partial phase angle and partial gain between 
%      the reference series and other series
%
%     INPUTS:
%------------
%   REQUIRED
%         y : (ly x ny) matrix with the series;
%             the program assumes that the first column contains 
%             the reference series
%
%   OPTIONAL
%       win : window used for smoothing the periodogram; 
%             = 0 : no smoothing is performed
%             = 1 : Blackman-Tukey window
%             = 2 : Parzen window
%             = 3 : Tukey-Hanning window
%             Parzen window is used, if win is not input to crosspan or 
%             if win is empty, 
%    winlag : window lag size; if it is not input to crosspan or if it
%             empty, winlag is computed by the program
%     alpha : significance level needed for calculaction of the confidence
%             intervals; if alpha is not input to crosspan or if alpha is
%             empty, confidence intervals are not computed
%
%     OUTPUT: 
%------------
%     mulsp : structure with following fields:
%             .frq    : frequencies
%             .fx     : (smoothed) periodogram of the reference series
%             .fy     : (smoothed) periodograms of all other series
%             .mco    : matrix with columns containing multiple coherency
%                       between the ref. series and a particular series
%             .msco   : matrix with columns containing multiple 
%                       coherence (squared multiple coherency) between 
%                       the ref. series and a particular series
%             .pco    : matrix with columns containing partial coherency
%                       between the ref. series and a particular series
%             .psco   : matrix with columns containing partial 
%                       coherence (squared partial coherency) between 
%                       the ref. series and a particular series
%             .pga    : matrix with columns containing partial gain
%                       between the ref. series and a particular series
%             .pph    : matrix with columns containing partial phase angle
%                       between the ref. series and a particular series
%             .ppht   : matrix with columns containing partial phase delay
%                       of a particular series relative to the ref. series
%             .pphd   : matrix with columns containing partial group delay
%                       of a particular series relative to the ref. series
%             .n      : length of the series
%             Additional fields, if alpha is input to mulparspan and is not
%             empty:
%             .fxconf : confidence intervals for fx
%             .fyconf : confidence intervals for fy
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

% Check the arguments and set defaults

if isempty(y)
    error('y is required input to mulparspan');
end

if nargin < 4
    alpha = [];
end

if nargin < 3
    winlag = [];
end

if nargin < 2
    win = [];
end


%-----------------------------------------------------------------

[n,ny] = size(y);
np=floor(n/2);

frq=zeros(np+1,1);

for i=0:np
   frq(i+1)=2*pi*i/n;
end
lf = length(frq);

%Create cross-spectral matrix

crossmat = zeros(lf*ny,ny);
fy = zeros(lf,ny-1);
if ~isempty(alpha)
    fxconf = zeros(lf,2);
    fyconf = zeros(lf,(ny-1)*2);
end

i = sqrt(-1);   % imaginary unit
jjj = 0;

for j = 1:ny
    xx = y(:,j);
    spx = periodg(xx,win,winlag,alpha);
    fxi = spx.f;
    if j == 1
        fx = fxi;
        if ~isempty(alpha)
            fxconf = spx.fconf;
        end
    else
        fy(:,j-1) = fxi;
        if ~isempty(alpha)
            ind = j-1+jjj:j+jjj;
            fy(:,ind) = spx.fconf;
            jjj = jjj+1;
        end
    end
    for ilf = 1:lf
        ifr = j+(ilf-1)*ny;
        crossmat(ifr,j) = fxi(ilf);
    end
    for jj = j+1:ny
        cqspx = cospqu(xx,y(:,jj),win,winlag);
        cx = cqspx.c;
        qx= cqspx.q;
        cqx = cx+i*qx;
        for ilf = 1:lf
            ifr = j+(ilf-1)*ny;
            crossmat(ifr,jj) = cqx(ilf);
        end 
    end
    if j > 2
        for k = 1:(j-1)
            cqspy = cospqu(xx,y(:,k),win,winlag);
            cy = cqspy.c;
            qy = cqspy.q;
            cqy = cy+i*qy;
            for ilf = 1:lf
                ifr = j+(ilf-1)*ny;
                crossmat(ifr,k) = cqy(ilf);
            end 
        end
    end
end

msco = zeros(lf,1);
pco = zeros(lf,ny-1);
pph = zeros(lf,ny-1);
pga = zeros(lf,ny-1);

for i = 1:lf
    iffr = 1+(i-1)*ny;
    infr = iffr:iffr+(ny-1);
    cross = crossmat(infr,:);
    subcr11 = cross;
    subcr11(1,:) = [];
    subcr11(:,1) = [];
    mincr11 = det(subcr11);
    frm = (abs(det(cross)/((cross(1,1)*mincr11))));    
    msco(i) = abs(1 - frm);
    for j = 2:ny
        subcrjj = cross;
        subcrjj(j,:) = [];
        subcrjj(:,j) = [];
        mincrjj = det(subcrjj);
        subcr1j = cross;
        subcr1j(:,1) = [];
        subcr1j(j,:) = [];
        mincr1j = det(subcr1j);
        pco(i,j-1) = (abs(mincr1j))/sqrt(abs(mincr11*mincrjj));
        pga(i,j-1) = (abs(mincr1j))/fx(i);
        pph(i,j-1) = atan2(imag(mincr1j),real(mincr1j));
    end    
end

mco = msco.^(0.5);    % multiple coherency
psco = pco.^2;        % partial squared coherency
ppht = pph;           % partial phase delay function
for j=1:np
    ppht(j+1)=ppht(j+1)/frq(j+1);
end
pphd = diff(pph);     % partial group delay function
rfrq = repmat(frq,1,ny-1);
pphd = pphd./diff(rfrq);
pphd = [zeros(1,ny-1);pphd];

% Store the results in the structure mulsp
mulsp.frq = frq;
mulsp.fx = fx;
mulsp.fy = fy;
mulsp.mco = mco;
mulsp.msco = msco;
mulsp.pco = pco;
mulsp.psco = psco;
mulsp.pga = pga;
mulsp.pph = pph;
mulsp.ppht = ppht;
mulsp.pphd = pphd;
if ~isempty(alpha)
    mulsp.fxconf = fxconf;
    mulsp.fyconf = fyconf;
    mulsp.alpha = alpha;
end





    

