function meanph = meanphconf(ph,frq,pband,alpha)
%************************************************************************
%  This function computes the mean (partial) phase angle values and 
%  their confidence intervals.
%  Computation is based on the circular statistics.
%
%     INPUTS:
%------------
%   REQUIRED
%        ph : matrix with columns containing (partial) phase angle
%             corresponding to the ref. series and a particular series
%       frq : frequencies, frq and ph must be of the same size;
%             the program assumes that the rows of frq and ph correspond to
%             each other
%
%   OPTIONAL, if the (partial) phase angle values are to be averaged 
%             over a specified interval
%     pband : time interval expressed in time units;
%             (partial) phase angle values are averaged over pband
%     alpha : significance level; default is 0.05
%
%
%     OUTPUT:
%------------
%    meanph : structure containing followig fields:
%             .mph     : mean (partial) phase angle values
%             .mphconf : confidence intervals for mph
%             .alpha   : significance level
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

if nargin < 2 || (isempty(ph) || isempty(frq))
    error('ph and frq are required inputs to meanphconf');
end

if nargin == 2 || isempty(pband)
    phk = ph;
end

if nargin >= 3 || isempty(alpha)
    if isvector(pband) && ~iscellstr(pband) && length(pband)==2
        if pband(1) < 2
           error('First element of pband must be greater than 2');
        end
        if pband(2) < pband(1) 
           error('Second element of pband must be greater than the first one');
        end
        fbandk = fliplr(2*pi./pband);
    else
        error('If pband is to be specified, it must be a two-dimensional vector');
    end
end

if nargin < 4 
    alpha = [];
end

%-------------------------------------------------------------

fband = [frq(1) frq(end)];
sph = size(ph,2);

if ~isequal(fbandk,fband)
   k = (frq >= fbandk(1) & frq <= fbandk(2));
   kf = repmat(k,1,sph);
   phk = ph(kf);
   phk = reshape(phk,[],sph);
end

[mph,mphconf,alpha] = circconfmean(phk,alpha);

mph = mph';
mphconf = mphconf';

meanph.mph = mph;
meanph.mphconf = mphconf;
meanph.alpha = alpha;



    

