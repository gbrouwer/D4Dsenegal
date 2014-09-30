function specst = crosspout(fid,per,sp,fband,meanph,phfband,vnames,ppi)
%*************************************************************************
% This function is an auxiliary function for the function specwrite; it is
% designed for writing the output of the bivariate or multivariate 
% spectral analysis
%
%     INPUTS:
%------------
%       fid : id of the text file where the output is to be written
%       per : frequency of the data (number of periods per year)
%        sp : structure being output of crosspan or mulparspan
%     fband : frequency interval for which results are displayed and stored;
%             default is [0,pi]
%    meanph : structure being output of meanphconf
%   phfband : frequency interval for which results for meanph have been 
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
%             .mph    : vector with mean phase angle values  
%                       between the ref. series and a particular series
%             .fxconf : confidence intervals for fx
%             .fyconf : confidence intervals for fy
%             .cconf  : confidence intervals for co
%             .gconf  : confidence intervals for ga
%             .pconf  : confidence intervals for ph
%             .mphconf: confidence intervals for mph
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
    error('There must be at least three inputs to crosspout')
end

if isempty(fid) || isempty(per) || isempty(sp)
    error('fid, per and sp are required inputs to crosspout')
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

%-------------------------------------------------------------

% Determine whether sp corresponds to the bivariate spectral analysis from
% (crosspan) or multivariate spectral analysis (mulparspan)

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
   
co=sp.co;
sco=sp.sco;
ph=sp.ph;
pht=sp.pht;
phd=sp.phd;
ga=sp.ga;
fx=sp.fx;
fy=sp.fy;
   
ncp = size(ph,2);
if isempty(vnames)
   vnames = cell(ncp+1,1);
   for i=1:ncp+1
       vnames{i} = ['series ', num2str(i)];
   end
end
rfname = vnames{1};
lrf = length(rfname);
        
if ~isequal(fband,[0,pi])
   k = ncp;
   kkf = repmat(kf,1,k);
   co = co(kkf);
   co = reshape(co,[],k);
   sco = sco(kkf);
   sco = reshape(sco,[],k);
   ph = ph(kkf);
   ph = reshape(ph,[],k);
   pht = pht(kkf);
   pht = reshape(pht,[],k);
   phd = phd(kkf);
   phd = reshape(phd,[],k);
   ga = ga(kkf);
   ga = reshape(ga,[],k);
   fx = fx(kf);
   fy = fy(kkf);
   fy = reshape(fy,[],k);
end
   
if isfield(sp,'fxconf')
   fxconf = sp.fxconf;
   fyconf = sp.fyconf;
   cconf = sp.cconf;
   gconf = sp.gconf;
   pconf = sp.pconf;
   alpha = sp.alpha;
        
   ci = 100*(1-alpha);
        
   if ~isequal(fband,[0,pi])
      k2 = k*2;
      kk2f = repmat(kf,1,k2);
      fxconf = fxconf([kf kf]);
      fxconf = reshape(fxconf,[],2);
            
      fyconf = fyconf(kk2f);
      fyconf = reshape(fyconf,[],k2);
            
      cconf = cconf(kk2f);
      cconf = reshape(cconf,[],k2);
            
      gconf = gconf(kk2f);
      gconf = reshape(gconf,[],k2);
            
      pconf = pconf(kk2f);
      pconf = reshape(pconf,[],k2);
   end
end

if ~isempty(meanph)
    mph = meanph.mph;
    mphconf = meanph.mphconf;
    malpha = meanph.alpha;
    mci = (1-malpha)*100;
end

% Express all angular measures in terms of pi
if ppi == 1
   ph = ph./pi;
   phd = phd./pi;
   if isfield(sp,'pconf')
      pconf = pconf./pi;
   end
   if ~isempty(meanph)
      mph = mph./pi;
      mphconf = mphconf./pi;
   end
end
  
% Store the results in the structure specst
specst.frq = frqk;
specst.fx = fx;
specst.fy = fy;
specst.co = co;
specst.sco = sco;
specst.ph = ph;
specst.pht = pht;
specst.ga = ga;
if isfield(sp,'fxconf')
   specst.fxconf = fxconf;
   specst.fyconf = fyconf;
   specst.cconf = cconf;
   specst.pconf = pconf;
   specst.gconf = gconf;
   specst.alpha = alpha;
end
if ~isempty(meanph)
   specst.mph = mph;
   specst.mphconf = mphconf;
end
 
%---------------------------------------------------------------
  jj = 0;
  
   fprintf(fid,'\n\n          BIVARIATE SPECTRAL ANALYSIS\n');
   
   for i = 1:ncp
       jj = jj+1;
       rname = vnames{i+1};
       lr = length(rname);
       
       % Print the results of the cross spectral analysis
   
       fprintf(fid,'\n********   %*s AND %*s   *********\n',...
               lrf,upper(rfname),lr,upper(rname));
   
       fprintf(fid,'\n=====================================================\n');
    
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
    
      copb = co(:,i);
      scopb = sco(:,i);
      phpb = ph(:,i);
      phpbt = pht(:,i);
      phpbd = phd(:,i);
      gapb = ga(:,i);
      fypb = fy(:,i);
    
      if isfield(sp,'fxconf')
          ij = (i-1) + jj;
          cconfpb = cconf(:,ij:ij+1);
          pconfpb = pconf(:,ij:ij+1);
          gconfpb = gconf(:,ij:ij+1);
          fyconfpb = fyconf(:,ij:ij+1);
          apb1 = [frqk,copb,cconfpb,scopb];
          apb2 = [frqk,phpb,pconfpb,phpbt,phpbd];
          apb3 = [frqk,gapb,gconfpb];
        
          fprintf(fid,'\nSignificance level: %2i%%\n',alpha*100);
        
          fprintf(fid,'\n  Freq. Coherency   %2.0f%% Conf. interval    Coherence\n',ci);
          fprintf(fid,'%5.4f %10.4f %10.4f %10.4f %10.4f\n',apb1');
          fprintf(fid,'--------------------------------------------------\n');
            
          if ppi == 1
             fprintf(fid,'\n  Freq. Phase angle*  %2.0f%% Conf. interval*  Phase delay  Group delay*\n',ci);
          else
             fprintf(fid,'\n  Freq. Phase angle  %2.0f%% Conf. interval  Phase delay  Group delay\n',ci); 
          end
          fprintf(fid,'%5.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n',apb2');
          fprintf(fid,'--------------------------------------------------\n');
          if ppi == 1
              fprintf(fid,'* All angular measures are expressed in terms of pi\n');
          end
        
          fprintf(fid,'\n  Freq.    Gain      %2.0f%% Conf. interval \n',ci);
          fprintf(fid,'%5.4f %10.4f %10.4f %10.4f\n',apb3');
          fprintf(fid,'--------------------------------------------------\n');
        
          fprintf(fid,'\n  Freq.  Spectrum %*s  %2.0f%% Conf. interval\n',...
                lrf,rfname,ci);
          for m = 1:lf
              fprintf(fid,'%5.4f %*.4f %10.4f %10.4f\n',...
                     frqk(m),lrf+9,fx(m),fxconf(m,1),fxconf(m,2));
          end
          fprintf(fid,'--------------------------------------------------\n');
         
          fprintf(fid,'\n  Freq.  Spectrum %*s  %2.0f%% Conf. interval\n',...
                 lr,rname,ci);
          for m = 1:lf
              fprintf(fid,'%5.4f %*.4f %10.4f %10.4f\n',...
                    frqk(m),lr+9,fypb(m),fyconfpb(m,1),fyconfpb(m,2));
          end
          fprintf(fid,'--------------------------------------------------\n');
      else
           
          apb1 = [frqk,copb,scopb,phpb,phpbt,phpbd];
        
          if ppi == 1
             fprintf(fid,'\n  Freq.  Coherency  Coherence  Phase angle*  Phase delay  Group delay*\n');
          else
             fprintf(fid,'\n  Freq.  Coherency  Coherence  Phase angle  Phase delay  Group delay\n');
          end
          fprintf(fid,'%5.4f %10.4f %10.4f %10.4f %10.4f %10.4f\n',apb1');
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
          fprintf(fid,'\n  Freq.  Gain  Spectrum %*s  Spectrum %*s\n',...
                lrf,rfname,lr,rname);
          for m = 1:lf
              fprintf(fid,'%5.4f %10.4f %*.4f %*.4f\n',...
                     frqk(m),gapb(m),lrf+9,fx(m),lr+9,fypb(m));
          end
          fprintf(fid,'--------------------------------------------------\n');
      end
      
      if ~isempty(meanph)
         fprintf(fid,'\nFREQUENCY BAND FOR THE MEAN PHASE ANGLE:  [%2.2f %4.2f]\n',...
                 phfband(1),phfband(2));
         fprintf(fid,'PERIODS BETWEEN %2i AND %2i %*s\n',...
                 phpband(2),phpband(1),ls,seas);
             
         fprintf(fid,'\nSignificance level: %2i%%\n',malpha*100);
         
         fprintf(fid,'\n  Mean phase angle  %2.0f%% Conf. interval\n',mci);
         mmph = [mph(i), mphconf(i,:)];
         fprintf(fid,'%15.4f %10.4f %10.4f\n',mmph');
         fprintf(fid,'--------------------------------------------------\n');
         if ppi == 1
             fprintf(fid,'* All angular measures are expressed in terms of pi\n');
         end
      end
   end
