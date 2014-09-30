function specst = mulspout(fid,per,sp,fband,meanpph,phfband,vnames,ppi)
%*************************************************************************
% This function is an auxiliary function for the function specwrite; it is
% designed for writing the output of the multivariate spectral analysis only
%
%     INPUTS:
%------------
%       fid : id of the text file where the output is to be written
%       per : frequency of the data (number of periods per year)
%        sp : structure being output of the function mulparspan
%     fband : frequency interval for which results are displayed and stored;
%             default is [0,pi]
%   meanpph : structure being output of meanphconf
%   phfband : frequency interval for which results for meanpph have been
%             calculated; default is [0,pi]
%    vnames : name/s of the series; it can be empty
%       ppi : 0, do not express angular measures in terms of pi (default)
%             1, express all angular measures in terms of pi
%
%     OUTPUT: 
%------------
%     specst: structure; all fields refer to the interval given by fband
%             All possible fields:
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
% Copyright (c) 2012 
% The authors assume no responsibility for errors or damage resulting from the use
% of this code. Usage of this code in applications and/or alterations of it should 
% be referenced. This code may be redistributed if nothing has been added or
% removed and no money is charged. Positive or negative feedback would be appreciated.
%
%*********************************************************************

% Check the inputs and set the defaults

if nargin < 3
    error('There must be at least three inputs to mulspout')
end

if isempty(fid) || isempty(per) || isempty(sp)
    error('fid, per and sp are required inputs to mulspout')
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
    meanpph = [];
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

%-------------------------------------------------------------------------


frq = sp.frq;

kf = (frq >= fband(1) & frq <= fband(2));
     
frqk = frq;
     
if ~isequal(fband,[0,pi])
    frqk = frqk(kf);
end
     
lf = length(frqk);

pband = 2*pi./fband;

if ~isempty(phfband)
    phpband = 2*pi./phfband;
end

mco=sp.mco;
msco=sp.msco;
pco=sp.pco;
psco=sp.psco;
pph=sp.pph;
ppht=sp.ppht;
pphd=sp.pphd;
pga=sp.pga;
fx=sp.fx;
fy=sp.fy;
   
ncp = size(pph,2);
ny = ncp+1;

if isempty(vnames)
   vnames = cell(ny,1);
   for i=1:ny
       vnames{i} = ['series ', num2str(i)];
   end
end
rfname = vnames{1};
lrf = length(rfname);

for i = 2:ny
    lr = length(vnames{i});
end
nlr = max(lr);
        
if ~isequal(fband,[0,pi])
   k = ncp;
   mco = mco(kf);
   msco = msco(kf);
   kkf = repmat(kf,1,k);
   pco = pco(kkf);
   pco = reshape(pco,[],k);
   psco = psco(kkf);
   psco = reshape(psco,[],k);
   pph = pph(kkf);
   pph = reshape(pph,[],k);
   ppht = ppht(kkf);
   ppht = reshape(ppht,[],k);
   pphd = pphd(kkf);
   pphd = reshape(pphd,[],k);
   pga = pga(kkf);
   pga = reshape(pga,[],k);
   fx = fx(kf);
   fy = fy(kkf);
   fy = reshape(fy,[],k);
end

if isfield(sp,'fxconf')
   fxconf = sp.fxconf;
   fyconf = sp.fyconf;
   alpha = sp.alpha;
   ci = 100*(1-alpha);
        
   if ~isequal(fband,[0,pi])
      k2 = k*2;
      kk2f = repmat(kf,1,k2);
      fxconf = fxconf([kf kf]);
      fxconf = reshape(fxconf,[],2);
            
      fyconf = fyconf(kk2f);
      fyconf = reshape(fyconf,[],k2);
   end
end

if ~isempty(meanpph)
    mpph = meanpph.mph;
    mpphconf = meanpph.mphconf;
    malpha = meanpph.alpha;
    mci = (1-malpha)*100;
end
    
% Express all angular measures in terms of pi
if ppi == 1
   pph = pph./pi;
   pphd = pphd./pi;
   if ~isempty(meanpph)
       mpph = mpph./pi;
       mpphconf = mpphconf./pi;
   end
end
  
% Store the results in the structure specst
specst.frq = frqk;
specst.fx = fx;
specst.fy = fy;
specst.mco = mco;
specst.msco = msco;
specst.pco = pco;
specst.psco = psco;
specst.pph = pph;
specst.ppht = ppht;
specst.pphd = pphd;
specst.pga = pga;
if isfield(sp,'fxconf')
   specst.fxconf = fxconf;
   specst.fyconf = fyconf;
end
if ~isempty(meanpph)
   specst.mpph = mpph;
   specst.mpphconf = mpphconf;
end

%---------------------------------------------------------------
jj = 0;
  
fprintf(fid,'\n\n       MULTIVARIATE SPECTRAL ANALYSIS\n');
fprintf(fid,'\n=====================================================\n');
fprintf(fid,'\n         MULTIPLE (SQUARED) COHERENCY \n');
   
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

fprintf(fid,'\n Reference series: %*s',lrf,rfname);
fprintf(fid,'\n Other series: %*s',nlr,vnames{2});
if ny > 2
   for i = 3:ny
       fprintf(fid,',%*s',nlr,vnames{i});
   end
end
fprintf(fid,'\n\n');
out = [frqk,mco,msco];
fprintf(fid,'\n   Freq.  Mul. coher.   Mul. sq. coher.\n');
fprintf(fid,'%6.3f  %12.3f  %12.3f\n',out');

fprintf(fid,'\n------------------------------------------------------------\n');
fprintf(fid,'\n\n          PARTIAL ANALYSIS\n');
   
for i = 1:ncp
    jj = jj+1;
    rname = vnames{i+1};
    lr = length(rname);
       
    % Print the results of the partial spectral analysis
   
    fprintf(fid,'\n********   %*s AND %*s   *********\n',...
            lrf,upper(rfname),lr,upper(rname));
   
    fprintf(fid,'\n=====================================================\n');
    
    fprintf(fid,'\nFREQUENCY BAND:  [%2.2f %4.2f]\n',fband(1),fband(2));
    fprintf(fid,'PERIODS BETWEEN %2i AND %2i %*s\n',pband(2),pband(1),ls,seas);
    
    pcopb = pco(:,i);
    pscopb = psco(:,i);
    pphpb = pph(:,i);
    pphpbt = ppht(:,i);
    pphpbd = pphd(:,i);
    pgapb = pga(:,i);
    fypb = fy(:,i);
    
    apb1 = [frqk,pcopb,pscopb,pphpb,pphpbt,pphpbd];
    
    if ppi == 1
       fprintf(fid,'\n  Freq.  Coherency  Coherence  Phase angle*  Phase delay  Group delay*\n');
    else
       fprintf(fid,'\n  Freq. Coherency  Coherence  Phase angle  Phase delay  Group delay\n');
    end
    fprintf(fid,'%5.4f %10.4f %10.4f %10.4f %12.4f %12.4f\n',apb1');
    fprintf(fid,'--------------------------------------------------\n');
    if ppi == 1
       fprintf(fid,'* Phase angle is expressed in terms of pi\n');
    end
        
    if lrf > 15
       lrf = 15;
    end
       
    if lr > 15
       lr = 15;
    end
    
    if isfield(sp,'fxconf')
          ij = (i-1) + jj;
          fyconfpb = fyconf(:,ij:ij+1);
          fprintf(fid,'\n  Freq.  Gain  Spectrum %*s %2.0f%% Conf. interval\n',...
                  lrf,rfname,ci);
          for m = 1:lf
              fprintf(fid,'%5.4f %10.4f %*.4f %10.4f %10.4f\n',...
                frqk(m),lrf+8,fx(m),fxconf(m,1),fxconf(m,2));
          end
          fprintf(fid,'--------------------------------------------------\n');
          fprintf(fid,'\n  Freq.  Spectrum %*s  %2.0f%% Conf. interval\n',...
                lr,rname,ci);
          for m = 1:lf
              fprintf(fid,'%5.4f %*.4f %10.4f %10.4f\n',...
                     frqk(m),lr+8,fypb(m),fyconfpb(m,1),fyconfpb(m,2));
          end
    else
        fprintf(fid,'\n  Freq.  Gain  Spectrum %*s  Spectrum %*s\n',...
                lrf,rfname,lr,rname);
          for m = 1:lf
              fprintf(fid,'%5.4f %8.4f %*.4f %*.4f\n',...
                     frqk(m),pgapb(m),lrf+8,fx(m),lr+8,fypb(m));
          end
    end
        
    fprintf(fid,'--------------------------------------------------\n');
  
    if ~isempty(meanpph)
       fprintf(fid,'\nFREQUENCY BAND FOR THE MEAN PARTIAL PHASE ANGLE:  [%2.2f %4.2f]\n',...
               phfband(1),phfband(2));
       fprintf(fid,'PERIODS BETWEEN %2i AND %2i %*s\n',...
               phpband(2),phpband(1),ls,seas);
       
       fprintf(fid,'\nSignificance level: %2i%%\n',malpha*100);  
       
       fprintf(fid,'\n  Mean partial phase angle  %2.0f%% Conf. interval\n',mci);
       mmpph = [mpph(i), mpphconf(i,:)];
       fprintf(fid,'%15.4f %10.4f %10.4f\n',mmpph');
       fprintf(fid,'--------------------------------------------------\n');
       if ppi == 1
          fprintf(fid,'* All angular measures are expressed in terms of pi\n');
       end
    end
end



 

