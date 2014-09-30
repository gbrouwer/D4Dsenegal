%*****************************************************************
%                    DEMO FILE   exUS2.m
%
%    SPECTRAL ANALYSIS: US INDUSTRIAL PRODUCTION, CONSUMPTION AND HOURS
% 
% Series: Cycles of the US IPI, consumption and working hours (monthly data)
% Time span: 1953.M4 - 2097.M9 
%*****************************************************************

clear;
clc;

% As an alternative to the analysis in the file exUS1.m, function spectran
% can be called instead.
% Function spectran performs the entire spectral analysis

% Read the Excel file with the cycles DataUS.xls
[ser,headers] = xlsread('data\DataUS.xls');

% Settings for spectran:
per = 12;         % frequency of the data
pband = [18,96];  % Business cycle periodicities (expressed in months)
path = 'results';
% Other parameters are set to their default values

% Standard bivariate spectral measures are computed:
specb = spectran(ser,per,'vnames',headers,'corlag',12,'conf',1,...
       'pband',pband,'phmean',1,'phpband',pband,'graph',1,'graphconf',1,...
       'path',path,'leadlag',1,'pi',1);
   

% Partial spectral measures are computed:
specp = spectran(ser,per,'vnames',headers,'corlag',12,'conf',1,...
       'pband',pband,'phmean',1,'phpband',pband,'graph',1,'graphconf',1,...
       'path',path,'leadlag',1,'pi',1,'mulvar',1);   
   