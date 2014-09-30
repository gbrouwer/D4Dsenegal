function specst = unispout(fid,per,sp,fband,vnames)
%*************************************************************************
% This function is an auxiliary function for the function specwrite; it is
% designed for writing the output of the univariate spectral analysis only
%
%     INPUTS:
%------------
%       fid : id of the text file where the output is to be written
%       per : frequency of the data (number of periods per year)
%        sp : structure being output of the function periodg
%     fband : frequency interval for which results are displayed;
%             default is [0,pi];
%    vnames : name/s of the series; it can be empty
%
%     OUTPUT: 
%------------
%     specst: structure; all fields refer to the interval given by fband
%             All possible fields:
%             .frq    : frequencies
%             .f      : spectrum of the series
%             .fconf  : confidence interval
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
    error('There must be at least three inputs to unispout')
end

if isempty(fid) || isempty(per) || isempty(sp)
    error('fid, per and sp are required inputs to unispout')
end

if nargin < 5
    vnames = [];
end

if ~isempty(vnames)
   if (~ischar(vnames) && ~iscellstr(vnames))
       error('vnames must be a string/string array');
   end
end

if ischar(vnames)
    vnames = {vnames};
end


if nargin < 4
    fband = [];
end

if isempty(fband)
    fband = [0,pi];
end


%------------------------------------------------

frq = sp.frq;

kf = (frq >= fband(1) & frq <= fband(2));
     
frqk = frq;

if ~isequal(fband,[0,pi])
    frqk = frqk(kf);
end

pband = 2*pi./fband;

if isempty(vnames)
   vnames = {'series'};
end

rfname = vnames{1}; % name of the reference series
lrf = length(rfname);  
    
fx = sp.f;
fx = fx(kf);
if isfield(sp,'fconf')
   fxconf = sp.fconf;
   alpha = sp.alpha;
   if ~isequal(fband,[0,pi])
      fxconf = fxconf([kf kf]);
      fxconf = reshape(fxconf,[],2);
   end
end
    
    
% Print the results of the spectral analysis
    
fprintf(fid,'\n       UNIVARIATE SPECTRAL ANALYSIS\n');
   
if ~isempty(vnames)
   fprintf(fid,'\n***********  %*s ***********\n',lrf,upper(rfname));
end
   
fprintf(fid,'=====================================================\n');
fprintf(fid,'\nFREQUENCY BAND:  [%2.2f %4.2f]\n',fband(1),fband(2));
      if per == 1
         seas = 'YEARS';
      elseif per == 4
         seas = 'QUARTERS';
      elseif per == 12
         seas = 'MONTHS';
      end
      ls = length(seas);
      fprintf(fid,'PERIODS BETWEEN %2i AND %2i %*s\n',pband(2),pband(1),ls,seas);
   
if isfield(sp,'fconf')
   ci = (1-alpha)*100;
   fprintf(fid,'\nSignificance level: %2i%%\n',alpha*100);
        
   fprintf(fid,'\n  Freq.   Spectrum  %2.0f%% Conf. interval\n',ci);
   apb = [frqk,fx,fxconf];
   fprintf(fid,'%5.4f %10.4f %10.4f %10.4f\n',apb');
else
   apb = [frqk,fx];
   fprintf(fid,'  Freq.   Spectrum\n');
   fprintf(fid,'%5.4f %10.4f\n',apb');
end
   
% Store the results in the structure specst

specst.frq = frqk;
specst.fx = fx;
if isfield(sp,'fconf')
   specst.fxconf = fxconf;
   specst.alpha = alpha;
end





