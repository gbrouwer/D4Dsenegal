%*****************************************************************
%                      DEMO FILE  exUS1.m
%
%    SPECTRAL ANALYSIS: US INDUSTRIAL PRODUCTION, CONSUMPTION AND HOURS
% 
% Series: Cycles of the US IPI, consumption and working hours (monthly data)
% Time span: 1953.M4 - 2097.M9 
%*****************************************************************

clear;
clc;

% Read the Excel file with the cycles DataUS.xls
[ser,headers] = xlsread('data\DataUS.xls');

% Cross-spectral analysis between the reference series IPI and the other
% series: consumption and hours

% Compute confidence intervals with the significance level alpha
alpha = 0.05; 
% default window function (Parzen window) and window lag size
cross = crosspan(ser,[],[],alpha); 


% Compute mean phase angle values with their confidence intervals
ph = cross.ph;
frq = cross.frq;
pband = [18,96];    
meanph = meanphconf(ph,frq,pband,alpha);

%------------------------------------------------------------------------
% Write output of the analysis

% Settings:
per = 12;      % frequency of the data
% frequency band for which the results are displayed;
% it corresponds to business cycle periodicities (periods between 18 and 96
% months)
fband = 2*pi./[96 18];  
vnames = headers;
ppi = 1;       % angular measures (phase angle and the corresponding
               % confidence intervals) are expressed in terms of pi


fid = fopen('results\crossUS.txt','w');
specwrite(fid,per,cross,fband,meanph,fband,headers)
fclose(fid);


% Perform lead-lag analysis and write output to a text file

fid = fopen('results\leadlagUS.txt','w');
leadlagan(fid,per,cross,fband,meanph,fband,vnames,ppi)
fclose(fid);


%----------------------------------------------------------------------
% Plot estimated spectra with confidence bands

% IPI
fx = cross.fx;
fxconf = cross.fxconf;
mul = 0;
specplot(frq,per,mul,fx,fband,fxconf,alpha,'Spectrum','IpiUS')


% Consumption and Hours
fy = cross.fy;
fyconf = cross.fyconf;
vnames = {'ConUS','HoursUS'};
specplot(frq,per,mul,fy,fband,fyconf,alpha,'Spectrum',vnames)


% Plot estimated coherency with confidence bands
coh = cross.co;
cohconf = cross.cconf;
mul = 1;
vnames = {'IpiUS','ConUS','HoursUS'};
specplot(frq,per,mul,coh,fband,cohconf,alpha,'Coherency',vnames)


% Plot estimated phase angle with confidence bands
phconf = cross.pconf;
phplot(frq,per,ph,fband,phconf,alpha,vnames)


%-------------------------------------------------------------------------

% Additionally, compute multiple and partial coherencies (coherences), 
% partial phase angle and partial gain, and write the output to a text file

mulsp = mulparspan(ser,[],[],alpha);
fid = fopen('results\mulparUS.txt','w');
specwrite(fid,per,mulsp,fband,[],[],headers)
fclose(fid);


% Plot estimated multiple coherency
mcoh = mulsp.mco;
specplot(frq,per,mul,mcoh,fband,[],[],'Multiple coherency',...
        {'IpiUS','ConUS+HoursUS'})

% Plot estimated partial coherency
pcoh = mulsp.pco;
specplot(frq,per,mul,pcoh,fband,[],[],'Partial coherency',vnames)

% Plot estimated partial phase angle
parph = mulsp.pph;
phplot(frq,per,parph,fband,[],[],vnames)

% Close figures
closefig;
