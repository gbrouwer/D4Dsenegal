function crossp = crosspan(y,win,winlag,alpha)
%************************************************************************
%    This function performs the cross-spectral analysis and optionally
%    calculates the confidence intervals for the estimated spectra of
%    two time series, coherency, gain and phase angle
%
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
%
%     OUTPUT:
%------------
%    crossp : structure with the following fields:
%             .frq    : frequencies
%             .fx     : (smoothed) periodogram of the reference series
%             .fy     : (smoothed) periodograms of all other series
%             .co     : matrix with columns containing coherency
%                       between the ref. series and a particular series
%             .sco    : matrix with columns containing coherence
%                       (squared coherency) between the ref. series 
%                       and a particular series
%             .ga     : matrix with columns containing gain
%                       between the ref. series and a particular series
%             .ph     : matrix with columns containing phase angle
%                       between the ref. series and a particular series
%             .pht    : matrix with columns containing phase delay
%                       of a particular series relative to the ref. series 
%             .phd    : matrix with columns containing group delay
%                       of a particular series relative to the ref. series 
%             .n      : length of the series
%             Additional fields, if alpha is input to crosspan and is not
%             empty:
%             .fxconf : confidence intervals for fx
%             .fyconf : confidence intervals for fy
%             .cconf  : confidence intervals for co
%             .gconf  : confidence intervals for ga
%             .pconf  : confidence intervals for ph
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
    error('y is required input to crosspan');
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

%---------------------------------------------------------------------
[n,ny] = size(y);
xx = y(:,1);

np=floor(n/2);
frq=zeros(np+1,1);

for i=0:np
   frq(i+1)=2*pi*i/n;
end

lf = length(frq);

if isempty(win) && isempty(winlag)
    if isempty(alpha)
       spx=periodg(xx);
    else
       spx=periodg(xx,[],[],alpha);
    end
elseif ~isempty(win) && isempty(winlag)
    if isempty(alpha)
       spx=periodg(xx,win);
    else
       spx=periodg(xx,win,[],alpha);
    end
else
    if isempty(alpha)
       spx=periodg(xx,win,winlag); 
    else
       spx=periodg(xx,win,winlag,alpha); 
    end
end
   
fx = spx.f;
if ~isempty(alpha)
    fxconf = spx.fconf;
end

% Matrices for storing results in each loop
cco = zeros(lf,ny-1);
ssco = zeros(lf,ny-1);
pph = zeros(lf,ny-1);
ppht = zeros(lf,ny-1);
pphd = zeros(lf,ny-1);
gga = zeros(lf,ny-1);
ffy = zeros(lf,ny-1);
if ~isempty(alpha)
    ffyconf = zeros(lf,(ny-1)*2);
    ccconf = zeros(lf,(ny-1)*2);
    ggconf = zeros(lf,(ny-1)*2);
    ppconf = zeros(lf,(ny-1)*2);
end

jj = 0;

for i = 1:ny-1
    yy = y(:,i+1);
    if isempty(win) && isempty(winlag)
       spy=periodg(yy);
       cqsp=cospqu(xx,yy);
    elseif ~isempty(win) && isempty(winlag)
       spy=periodg(yy,win);
       cqsp=cospqu(xx,yy,win);
    else
       spy=periodg(yy,win,winlag);
       cqsp=cospqu(xx,yy,win,winlag);
    end

    fy = spy.f;
    cgpsp=cohepha(cqsp,fx,fy);
    
    % phase angle
    ph = cgpsp.ph;

    % phase delay function
    pht = ph;
    for j=1:np
        pht(j+1)=pht(j+1)/frq(j+1);
    end
    
    %group delay
    phd = diff(ph)./diff(frq);
    phd = [0;phd];
    
    % coherency
    co = cgpsp.co;

    % coherence
    sco = cgpsp.sco;

    % gain
    ga = cgpsp.ga;
    
    % Store the results in the matrices
    ffy(:,i) = fy;
    cco(:,i) = co;
    ssco(:,i) = sco;
    pph(:,i) = ph;
    ppht(:,i) = pht;
    pphd(:,i) = phd; 
    gga(:,i) = ga;
    
    if ~isempty(alpha)
        fyconf = spconf(spy,alpha);
        [cconf, gconf, pconf] = cgpconf(cgpsp,fx,fy,alpha);
        
        jj = jj+1;
        ij = (i-1)+jj;
        ffyconf(:,ij:ij+1) = fyconf;
        ccconf(:,ij:ij+1) = cconf;
        ggconf(:,ij:ij+1) = gconf;
        ppconf(:,ij:ij+1) = pconf;
    end
end

% Collect all computed values in the structure crossp

crossp.n = n;
crossp.co = cco;
crossp.sco = ssco;
crossp.ph = pph;
crossp.pht = ppht;
crossp.phd = pphd;
crossp.ga = gga;
crossp.fx = fx;
crossp.fy = ffy;
crossp.frq = frq;

% Save confidence intervals in the structure crossp

if ~isempty(alpha)
    crossp.fxconf = fxconf;
    crossp.fyconf = ffyconf;
    crossp.cconf = ccconf;
    crossp.gconf = ggconf;
    crossp.pconf = ppconf;
    crossp.alpha = alpha;
end



