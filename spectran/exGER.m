%*****************************************************************
%                   DEMO FILE  exGER.m
%
%    SPECTRAL ANALYSIS: GERMAN INDUSTRIAL PRODUCTION AND REAL WAGE
% 
% Series: Cycles of the German IPI and consumer real wage (quarterly data)
% Time span: 1970.Q1 - 2011.Q3
%*****************************************************************

clear;
clc;

x = load('data\PRGer.dat','-ascii');
y = load('data\CWGer.dat','-ascii');


% Settings for the spectral analysis:
alpha = 0.05;  % compute conf. intervals with the significance level alpha
win = 1;       % Blackman-Tukey window
winlag = [];   % default window lag size

% Spectral analysis of the IPI
spx = periodg(x,win,winlag,alpha);   

% Spectral analysis of the real wage
spy = periodg(y,win,winlag,alpha);

% Write the output of the spectral analysis

per = 4;      % frequency of the data
% frequency band for which the results are displayed;
% it corresponds to business cycle periodicities (periods between 6 and 32
% quarters)
fband = 2*pi./[32 6];  


% IPI
fid = fopen('results\specPRGer.txt','w');
specwrite(fid,per,spx,fband,[],[],[],'PRGer')
fclose(fid);

% Real wage
fid = fopen('results\specCWGer.txt','w');
specwrite(fid,per,spy,fband,[],[],[],'CWGer')
fclose(fid);


% Produce plots

% IPI
frq = spx.frq;
mul = 0;
fx = spx.f;
fxconf = spx.fconf;
specplot(frq,per,mul,fx,fband,fxconf,alpha,'Spectrum','PRGer')


% Real wage
fy = spy.f;
fyconf = spy.fconf;
specplot(frq,per,mul,fy,fband,fyconf,alpha,'Spectrum','CWGer')


% Close figures
closefig;

