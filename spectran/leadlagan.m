function llst = leadlagan(fid,per,sp,fband,meanph,phfband,vnames,ppi)
%*************************************************************************
%                     LEAD-LAG ANALYSIS
%
%    Phase shifts between the reference series and an other series 
%    at the most important frequency are computed.
%    The most important frequency is defined as the one at which the
%    highest (partial) coherence occurs; (partial) coherence is used as  
%    a measure of the relationship between two cycles. 
%    
%
%     INPUTS:
%------------
%       fid : id of the text file where the output is to be written
%       per : frequency of the data (number of periods per year)
%        sp : structure being output of crosspan or mulparspan
%     fband : frequency interval for which results are displayed;
%             default is [0,pi]
%    meanph : structure being output of meanphconf
%   phfband : frequency interval for which results for the mean (partial)
%             phase angle are displayed; default is [0,pi]
%    vnames : name/s of the series
%       ppi : 0, do not express angular measures in terms of pi (default)
%             1, express all angular measures in terms of pi
%
%     OUTPUT: (optional)
%------------
%      llst : structure with following fields:
%             .masco     : maximum (partial) coherences
%             .maxfrq    : frequencies corresponding to maxsco
%             .maxph     : (partial) phase angle values corresponding 
%                          to maxsco
%             .mapht     : (partial) phase delay values corresponding
%                          to maxsco
%             .maxphconf : confidence intervals for maxph;
%                          field if pconf is field of sp
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
    error('There must be at least three inputs to leadlagan')
end

if isempty(fid) || isempty(per) || isempty(sp)
    error('fid, per and sp are required inputs to leadlagan')
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

frq=sp.frq;

kf = (frq >= fband(1) & frq <= fband(2));
     
frqk = frq;
     
if ~isequal(fband,[0,pi])
    frqk = frqk(kf);
end
     
if ~isfield(sp,'psco')
    % Bivariate analysis
    sco=sp.sco;     % coherence
    ph=sp.ph;       % phase angle
    pht=sp.pht;     % phase delay
else
    % Multivariate analysis
    sco=sp.psco;    % partial coherence
    ph=sp.pph;      % partial phase angle
    pht=sp.ppht;    % partial phase delay
end

 
ncp = size(sco,2);

if ~isequal(fband,[0,pi])
    k = ncp;
    kkf = repmat(kf,1,k);
    sco = sco(kkf);
    sco = reshape(sco,[],k);
    ph = ph(kkf);
    ph = reshape(ph,[],k);
    pht = pht(kkf);
    pht = reshape(pht,[],k);
end

if isfield(sp,'pconf')
    pconf = sp.pconf;
    if ~isequal(fband,[0,pi])
        k2 = k*2;
        kk2f = repmat(kf,1,k2);
        pconf = pconf(kk2f);
        pconf = reshape(pconf,[],k2);
    end
    alpha=sp.alpha;
    ci=100*(1-alpha);
end
        
if ~isempty(meanph)
    mph = meanph.mph;
    mphconf = meanph.mphconf;
    malpha = meanph.alpha;
    mci = (1-malpha)*100;
end

if isempty(vnames)
    vnames = cell(ncp+1,1);
    for i=1:ncp+1
        vnames{i} = ['series ', num2str(i)];
    end
end

if ~isempty(phfband)
    phpband = 2*pi./phfband;
end

% For each pair (reference series and other series), find the strongest
% (partial) coherence, its position and the corresponding frequency

maxsco = zeros(ncp,1);
maxfrq = zeros(ncp,1);
maxph = zeros(ncp,1);
maxpht = zeros(ncp,1);
llag = cell(ncp,1);
mllag = cell(ncp,1);
if isfield(sp,'pconf')
   maxphconf = zeros(ncp,2);
end

jj=0;

for i=1:ncp
    jj = jj+1;
    ij=(i-1)+jj;
    isco = sco(:,i);
    iph = ph(:,i);
    ipht = pht(:,i);
    imaxsco = max(isco);
    maxsco(i) = imaxsco;
    j = isco==imaxsco;
    imaxfrq = frqk(j);
    maxfrq(i) = imaxfrq;
    imaxph = iph(j);
    maxph(i) = imaxph;
    imaxpht = ipht(j);
    if imaxph > 0
        llag{i} = 'lag';
    elseif imaxph < 0
        llag{i} = 'lead';
    else
        llag{i} = '0';
    end
    if mph(i) > 0
        mllag{i} = 'lag';
    elseif mph(i) < 0
        mllag{i} = 'lead';
    else
        mllag{i} = '0';
    end
    maxpht(i) = imaxpht;
    if isfield(sp,'pconf')
       iphconf = pconf(:,ij:ij+1);
       imaxphconf = iphconf(j,1:2);
       maxphconf(i,1:2) = imaxphconf;
    end
end
     
if ppi == 1
    maxph = maxph./pi;
    if isfield(sp,'pconf')
        maxphconf = maxphconf./pi;
    end
    if ~isempty(meanph)
        mph = mph./pi;
        mphconf = mphconf./pi;
    end
end


% Store results in the structure llst
if nargout == 1
    llst.maxsco = maxsco;
    llst.maxfrq = maxfrq;
    llst.maxph = maxph;
    llst.mapht = maxpht;
    if isfield(sp,'pconf')
       llst.maxphconf = maxphconf;
    end
end

% Compute periods from frequencies
maxper = 2*pi./maxfrq;   % in periods
maxpery = maxper./per;   % in years

cnames = cell(ncp,1);
lc = zeros(ncp,1);

for i = 1:ncp
    cnames{i} = [vnames{1} ' and ' vnames{i+1}];
    lc(i) = length(cnames{i});
end
lcn = max(lc);

% Settings for the output display depending on the bivariate or
% multivariate analysis

if ~isfield(sp,'psco')
    par = '';
    parph = 'Phase';
else
   par = 'Partial ';
   parph = [par 'phase'];
end
lp = length(par);
lpp = length(parph);


if ~isempty(meanph)
   if ppi == 1
      fprintf(fid,'\n%30s MEAN %*sPHASE ANGLE*\n','',lp,upper(par));
   else
      fprintf(fid,'\n%30s MEAN %*sPHASE ANGLE\n','',lp,upper(par));
   end
   
  fprintf(fid,'\n===========================================================');
  
  if ~isempty(phfband)
     fprintf(fid,'\nFREQUENCY BAND FOR THE MEAN %*sPHASE ANGLE:  [%2.2f %4.2f]\n',...
                 lp,upper(par),phfband(1),phfband(2));
     if per == 1
        seas = 'YEARS';
     elseif per == 4
        seas = 'QUARTERS';
     elseif per == 12
        seas = 'MONTHS';
     end
     ls = length(seas);
     fprintf(fid,'PERIODS BETWEEN %2i AND %2i %*s\n',phpband(2),phpband(1),ls,seas);
  end
  
  fprintf(fid,'\nSignificance level: %2i%%\n',malpha*100);
  
  fprintf(fid,'\n%20s Mean value','');
  fprintf(fid,'   %4.0f%% Confidence limits',mci);
  fprintf(fid,'   Lead/lag of the 2nd series\n');
  for i = 1:ncp
      fprintf(fid,'\n%15s  %12.4f %12.4f  %10.4f %10s', cnames{i},...
              mph(i), mphconf(i,:), mllag{i});
  end
  fprintf(fid,'\n------------------------------------------------------------\n');
  if ppi == 1
     fprintf(fid,'* All angular measures are expressed in terms of pi\n\n');
  end
end

if ppi == 1
   fprintf(fid,'\n%30s %*s PHASE ANGLE AND %*sPHASE DELAY**\n','',lp,...
           upper(par),lp,upper(par));
else
   fprintf(fid,'\n%30s %*s PHASE ANGLE AND %*sPHASE DELAY\n','',lp,...
           upper(par),lp,upper(par));
end

fprintf(fid,'\n===========================================================\n');
if per ~= 1
   if isfield(sp,'pconf')
      fprintf(fid,'\nSignificance level: %2i%%\n',alpha*100); 
      
      fprintf(fid,'\n%*s Frequency Per.(in %*s) Per.(in years) Phase angle %2.0f%% Conf. interval Phase delay Lead/lag of the 2nd series\n',...
              lcn,'',ls,lower(seas),ci);
      for i = 1:(ncp)
      fprintf(fid,'\n%*s  %8.3f %10.2f %12.2f %14.3f  %12.3f %8.3f %8.2f %8s',...
            lcn,cnames{i},maxfrq(i),maxper(i),maxpery(i),maxph(i),...
            maxphconf(i,:),maxpht(i),llag{i});
      end
   else
      fprintf(fid,'\n%*s Frequency Per.(in %*s) Per.(in years) %*s angle %*s delay Lead/lag of the 2nd series\n',...
          lcn,'',ls,lower(seas),lpp,parph,lpp,parph);
      for i = 1:(ncp)
      fprintf(fid,'\n%*s  %8.3f %10.2f %12.2f %*.3f  %*.3f %8s',...
            lcn,cnames{i},maxfrq(i),maxper(i),maxpery(i),lpp+8,maxph(i),...
            lpp+6,maxpht(i),llag{i});
      end
   end
else
    if isfield(sp,'pconf')
      fprintf(fid,'\nSignificance level: %2i%%\n',alpha*100); 
      fprintf(fid,'\n%15s Frequency Per.(in years) Phase angle %2.0f%% Conf. interval Phase delay Lead/lag of the 2nd series \n',...
              '',ci);
      for i = 1:(ncp)
      fprintf(fid,'\n%15s  %8.3f %10.2f %14.3f  %12.3f %8.3f %8.2f %8s',...
            cnames{i},maxfrq(i),maxper(i),maxph(i),...
            maxphconf(i,:),maxpht(i),llag{i});
      end
   else
      fprintf(fid,'\n%*s Frequency Per. %*s angle %*s delay Lead/lag of the 2nd series\n',...
              lcn,'',lpp,parph,lpp,parph);
      for i = 1:(ncp)
      fprintf(fid,'\n%*s  %8.3f %10.2f %*.3f  %*.3f %8s',...
            lcn,cnames{i},maxfrq(i),maxper(i),lpp+8,maxph(i),...
            lpp+6,maxpht(i),llag{i});
      end
   end
end
fprintf(fid,'\n------------------------------------------------------------\n');
if ppi == 1
fprintf(fid,'** %*s angle is expressed in terms of pi;\n',lpp,parph);
end

fprintf(fid,'   %*s delay is expressed in %*s\n',lpp,parph,ls,lower(seas));






  