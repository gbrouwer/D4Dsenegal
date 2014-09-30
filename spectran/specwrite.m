function specst = specwrite(fid,per,sp,fband,meanph,phfband,vnames,ppi)
%**********************************************************************
%  This function writes results of the spectral analysis to a text file
%
%     INPUTS:
%------------
%       fid : id of the text file where the output is to be written
%       per : frequency of the data (number of periods per year)
%        sp : structure being output of the function periodg, crosspan or
%             mulparspan
%     fband : frequency interval for which results are displayed;
%             default is [0,pi]
%    meanph : structure being output of meanphconf;
%             it should be empty if sp is output of periodg
%   phfband : frequency interval for which results for meanph have been
%             calculated; default is [0,pi]
%             it should be empty if sp is output of periodg
%    vnames : name/s of the series; it can be empty
%       ppi : 0, do not express angular measures in terms of pi (default)
%             1, express all angular measures in terms of pi
%
%     OUTPUT: (optional)
%------------
%     specst: structure depending on sp; all fields refer to the
%             interval given by fband
%
%              All possible fields, if sp is output of periodg:
%             .frq     : frequencies
%             .f       : spectrum of the series
%             .fconf   : confidence interval
%
%              All possible fields, if sp is output of crosspan:
%             .frq     : frequencies
%             .fx      : (smoothed) periodogram of the reference series
%             .fy      : (smoothed) periodograms of all other series
%             .co      : matrix with columns containing coherency
%                        between the ref. series and a particular series
%             .sco     : matrix with columns containing coherence
%                        (squared coherency) between the ref. series 
%                        and a particular series
%             .ga      : matrix with columns containing gain
%                        between the ref. series and other series
%             .ph      : matrix with columns containing phase angle
%                        between the ref. series and other series
%             .pht     : matrix with columns containing phase delay
%                        of a particular series relative to the ref. series
%             .phd     : matrix with columns containing group delay
%                        of a particular series relative to the ref. series
%             .mph     : vector with mean phase angle values  
%                        between the ref. series and other series
%             .fxconf  : confidence intervals for fx
%             .fyconf  : confidence intervals for fy
%             .cconf   : confidence intervals for co
%             .gconf   : confidence intervals for ga
%             .pconf   : confidence intervals for ph
%             .mphconf : confidence intervals for mph
%
%             All possible fields, if sp is output of mulparspan: 
%             .frq     : frequencies
%             .fx      : (smoothed) periodogram of the reference series
%             .fy      : (smoothed) periodograms of all other series
%             .mco     : matrix with columns containing multiple coherency
%                        between the ref. series and other series
%             .msco    : matrix with columns containing multiple coherence
%                       (multiple squared coherency) between the ref. series 
%                        and a particular series
%             .pco     : matrix with columns containing partial coherency
%                        between the ref. series and other series
%             .psco    : matrix with columns containing partial coherence
%                        (partial squared coherency) between the ref. series 
%                        and a particular series
%             .pga     : matrix with columns containing partial gain
%                        between the ref. series and a particular series
%             .pph     : matrix with columns containing partial phase angle
%                        between the ref. series and a particular series
%             .ppht    : matrix with columns containing partial phase delay
%                        of a particular series relative to the ref. series
%             .pphd    : matrix with columns containing partial group delay
%                        of a particular series relative to the ref. series
%             .mpph    : vector with mean phase angle values  
%                        between the ref. series and a particular series
%             .fxconf  : confidence intervals for fx
%             .fyconf  : confidence intervals for fy
%             .mpphconf: confidence intervals for mpph 
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
% Copyright (c) 2012 
% The authors assume no responsibility for errors or damage resulting from the use
% of this code. Usage of this code in applications and/or alterations of it should 
% be referenced. This code may be redistributed if nothing has been added or
% removed and no money is charged. Positive or negative feedback would be appreciated.
%                                                       
%*********************************************************************

% Check the inputs and set the defaults

if nargin < 3
    error('There must be at least three inputs to specwrite')
end

if isempty(fid) || isempty(per) || isempty(sp)
    error('fid, per and sp are required inputs to specwrite')
end

if nargin < 8
    ppi = [];
end

if nargin < 7
    vnames = [];
end

if nargin < 6
    phfband = [];
end

if nargin < 5
    meanph = [];
end

if nargin < 4
    fband = [];
end

if isempty(fband)
    fband = [0,pi];
end

if isempty(ppi)
    ppi = 0;
end

if ~isempty(vnames)
   if (~ischar(vnames) && ~iscellstr(vnames))
       error('vnames must be a string/string array');
   end
end

if ischar(vnames)
    vnames = {vnames};
end


%--------------------------------------------------------------------

% Print results to a text file

if ~isfield(sp,'co') && ~isfield(sp,'mco')
    % Print results of the univariate spectral analysis
    spst = unispout(fid,per,sp,fband,vnames);
elseif isfield(sp,'co')
    % Print results of the bivariate spectral analysis
    spst = crosspout(fid,per,sp,fband,meanph,phfband,vnames,ppi);
else
    % Print results of the multivariate spectral analysis
    spst = mulspout(fid,per,sp,fband,meanph,phfband,vnames,ppi);
end

% Store the output in the structure specst
if nargout == 1
    specst = spst;
end
    
    



    
 