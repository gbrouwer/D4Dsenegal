function spectr = spectran(y,per,varargin)  
%**********************************************************************
%                       SPECTRAL ANALYSIS
%
%  This program computes spectrum, (multiple/partial) coherence, 
%  (partial) phase angle, (partial) phase delay, (partial) gain and 
%  auto- or cross-correlations between a reference series and other series.
%     
%                      The syntax :
% spectr = spectran(y,per,'option1',optionvalue1,'option2',optionvalue2,...)
%
% 
%       INPUTS :
%------------------
%      REQUIRED 
%            y : (ly x ny) matrix with the series;
%                if ny = 1, univariate spectral analysis and computation
%                of autocorrelations of y are performed,
%                if ny > 1, bivariate or multivariate spectral analysis 
%                and computation of cross-correlations are performed; 
%                the program assumes that the first column contains 
%                the reference series
%          per : frequency of the data (number of periods per year)
%------------------
%       OPTIONS
%     'vnames' : string array with names for the series; the program
%                assumes that their order coincides with the order in y;
%                default: refseries, series1, series2,...
%     'corlag' : number of leads and lags at which the
%                auto-/cross-correlations are computed; default: ly-1
%        'win' : window function used for (cross-)periodogram smoothing
%                0, no window is applied (nonsmoothed periodogram).
%                1, the Blackman-Tukey window
%                2, the Parzen window (default)
%                3, the Tukey-Hanning window
%     'winlag' : window lag size;
%                default: depending on the window function
%     'mulvar' : 0, if bivariate analysis in case of ny > 2 
%                   is to be performed (default);
%                   (always 0 for ny <= 2)
%                1, if multivariate analysis in case of ny > 2 
%                   is to be performed
%       'conf' : 0, do not compute confidence intervals for the spectral
%                   measures (default)
%                1, compute confidence intervals
%      'alpha' : significance level; default (if conf = 1): 0.05
%      'pband' : time interval expressed in time units corresponding to
%                per, results are displayed and saved for the chosen
%                pband; default: 
%                [2,inf] corresponding to frequency interval [0,pi]
%     'phmean' : 0, do not compute the mean phase angle values and their 
%                   confidence intervals (default)
%                1, compute the mean phase angle values and their 
%                   confidence intervals
%    'phpband' : time interval expressed in time units corresponding to
%                per, phase angle is averaged over phpband;
%                default (if phmean = 1): [2,inf]
%      'graph' : 0, do not produce graphs
%                1, produce graphs (default)
%  'graphconf' : 0, do not plot confidence intervals (default)
%                1, plot confidence intervals (phmean or alpha must then
%                   be specified)
%        'out' : 0, do not write the output to a text file
%                1, write output to a text file (default)
%       'path' : string specifying the path to the directory where the
%                output file/s should be written;
%                default: folder 'results' in the current directory
%       'save' : 0, do not save the graphs (default)
%                1, save the graphs;
%                   the graphs will be saved in the subfolder 'plots'
%                   in the directory given by path, with default 
%                   extension .fig (if ext or format are not specified)
%        'ext' : extension for saving the graphs (see function saveas)
%     'format' : format for saving the graphs (see function saveas)
%    'leadlag' : 0, do not produce separate file with the lead-lag
%                   analysis (default)
%                1, produce separate file 'leadlag.txt' with the lead-lag
%                   analysis 
%         'pi' : 0, (default)
%                1, express all angular measures in terms of pi
%
%
%       OUTPUT :
%------------------
%       spectr : structure containing all results depending on the
%                dimension of y and options chosen; all fields refer to the
%                interval given by fband
%
%                All possible fields for ny = 1:
%                .frq    : frequencies
%                .f      : spectrum of the series
%                .fconf  : confidence interval
%
%                All possible fields for ny = 2 and ny > 2, if value for 
%                'mulvar' is 0:
%                .frq    : frequencies
%                .fx     : (smoothed) periodogram of the reference series
%                .fy     : (smoothed) periodograms of all other series
%                .co     : matrix with columns containing coherency
%                          between the ref. series and a particular series
%                .sco    : matrix with columns containing coherence
%                         (squared coherency) between the ref. series 
%                          and a particular series
%                .ga     : matrix with columns containing gain
%                          between the ref. series and a particular series
%                .ph     : matrix with columns containing phase angle
%                          between the ref. series and a particular series
%                .pht    : matrix with columns containing phase delay
%                          of a particular series relative to the
%                          ref. series
%                .phd    : matrix with columns containing group delay
%                          of a particular series relative to the
%                          ref. series
%                .mph    : vector with mean phase angle values  
%                          between the ref. series and a particular series
%                .fxconf : confidence intervals for fx
%                .fyconf : confidence intervals for fy
%                .cconf  : confidence intervals for co
%                .gconf  : confidence intervals for ga
%                .pconf  : confidence intervals for ph
%                .mphconf: confidence intervals for mph
%
%                All possible fields for ny > 2, if value for 'mulvar' is 1:
%                .frq    : frequencies
%                .fx     : (smoothed) periodogram of the reference series
%                .fy     : (smoothed) periodograms of all other series
%                .mco    : matrix with columns containing multiple coherency
%                          between the ref. series and a particular series
%                .msco   : matrix with columns containing multiple 
%                          coherence (squared multiple coherency) between 
%                          the ref. series and a particular series
%                .pco    : matrix with columns containing partial coherency
%                          between the ref. series and a particular series
%                .psco   : matrix with columns containing partial 
%                          coherence (squared partial coherency) between 
%                          the ref. series and a particular series
%                .pga    : matrix with columns containing partial gain
%                          between the ref. series and a particular series
%                .pph    : matrix with columns containing partial phase angle
%                          between the ref. series and a particular series
%                .ppht   : matrix with columns containing partial phase delay
%                          of a particular series relative to the
%                          ref. series
%                .pphd   : matrix with columns containing partial group delay
%                          of a particular series relative to the
%                          ref. series
%                .mpph   : vector with mean partial phase angle values  
%                          between the ref. series and a particular series
%                .fxconf : confidence intervals for fx
%                .fyconf : confidence intervals for fy
%                .mpphconf: confidence intervals for mpph
%
%     Examples:
%       
%     s = spectran(y,per,'vnames',{'GDP','IPI'},'conf',1,'graphconf',1)
%     s = spectran(y,per,'pband',[8,32],'save',1)
%     s = spectran(y,per,'alpha',0.01,'phmean',1,'graph',0)
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

% Check the number and validity of arguments and set defaults

if nargin < 2
    error('There must be at least two inputs to spectran');
end

if isempty(y)
    error('y is required input to spectran');
end

if isempty(per)
    error('per is required input to spectran');
end

[ly,ny] = size(y);

% Specify default values 
def = cell(1,19);
ldef = length(def);

dvnames = cell(1,ny);
dvnames{1} = 'refseries';
if ny > 1
   for i = 2:ny
      dvnames{i} = ['series' num2str(i-1)];
   end
end

def{1} = dvnames;
def{2} = ly-1;              % maximum number of lags
%def{3} = [];               % Parzen window  
%def{4} = [];
def{5} = 0;                 % do note perform multivariate analysis
def{6} = 0;                 % do not compute confidence bounds for spectral
%def{7} = [];               % significance level
def{8} = [2,inf];           % default perodicity band 
def{9} = 0;                 % do not compute the mean phase angle
%def{10} = [];              % default periodicity band for the mean phase angle
def{11} = 1;                % produce graphs
def{12} = 0;                % do not plot confidence bounds
def{13} = 1;                % write the output to a text file
%def{14} = [];              % the results are written to the current directory
                            % (pwd identifies the current folder)
def{15} = 0;                % do not save figures
%def{16} = [];
%def{17} = [];
def{18} = 0;                % do not produce separate file with the lead-lag
                            % analysis
def{19} = 0;                % do not express angular measures in terms of pi

if nargin == 2   % Set default values for all other parameters 
      val = def;
end

lvar = length(varargin);

if lvar > 0
    if mod(lvar,2) == 1     % number of elements is odd
        error('To specify an option, one of the admissible types and an admissible value must be chosen');
    else
        opt = {'vnames',...   %1
               'corlag',...   %2
               'win',....     %3
               'winlag',...   %4
               'mulvar',...   %5
               'conf',...     %6
               'alpha',...    %7
               'pband',...    %8
               'phmean',...   %9
               'phpband',...  %10
               'graph',...    %11
               'graphconf',...%12
               'out',...      %13
               'path',...     %14
               'save',...     %15
               'ext',...      %16
               'format',...   %17
               'leadlag',...  %18
               'pi'};         %19
        ldef = length(opt);
        val = def;
        for i = 1:2:(lvar-1)
            if any(strcmpi(varargin{i},opt))
                for k = 1:ldef
                    if strcmpi(varargin{i},opt{k})
                        val{k} = varargin{i+1};
                    end
                end
            else
                error('Option must be of an admissible type');
            end
        end
    end
end

% Check the validity of option values if they are not set to defaults

for i = 1:ldef
    if ~isequal(val{i},def{i})
        if strcmpi('vnames',opt{i})
            if (~ischar(val{i}) && ~iscellstr(val{i}))
                error('Value of option vnames must be a string/string array');
            else
                if length(val{i}) ~= ny
                    error('Number of vnames must be equal to the number of columns of y');
                end
            end
        elseif strcmpi('corlag',opt{i})
            if ~isscalar(val{i})
                error('Value of option corlag must be a scalar');
            end
        elseif strcmpi('win',opt{i})
            valwin = 0:3;
            l = (val{i} == valwin);
            if ~any(l)
                error('Value of option win must be 0,1,2 or 3');
            end
        elseif strcmpi('winlag',opt{i})
            if (~isscalar(val{i}) && val{i} > ly-1)
                error('Value of option corlag must be a scalar <= length of the series-1');
            end
         elseif strcmpi('mulvar',opt{i})
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option mulvar must be either 0 or 1');
            end      
        elseif strcmpi('alpha',opt{i})
            if (~isscalar(val{i}) && (val{i} > 1 || val{i} < 0))
                error('Value of option alpha must lie on the interval [0,1]');
            end  
        elseif strcmpi('pband',opt{i})
            if isvector(val{i}) && length(val{i}) == 2
                pb = val{i};
                if pb(1) < 2
                    error('First element of pband must be greater than 2');
                end
                if pb(2) < pb(1) 
                    error('Second element of pband must be greater than the first one');
                end
            else
                error('Value of option pband must be a two-dimensional vector');
            end          
        elseif strcmpi('phmean',opt{i})
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option phmean must be either 0 or 1');
            end  
        elseif strcmpi('phpband',opt{i})
            if isvector(val{i}) && length(val{i}) == 2
                ppb = val{i};
                if ppb(1) < 2
                    error('First element of phpband must be greater than 2');
                end
                if ppb(2) < ppb(1) 
                    error('Second element of phpband must be greater than the first one');
                end
            else
                error('Value of option phpband must be a two-dimensional vector');
            end      
        elseif strcmpi('graph',opt{i})   
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option graph must be either 0 or 1');
            end
        elseif strcmpi('graphconf',opt{i})   
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option graphconf must be either 0 or 1');
            end
        elseif strcmpi('out',opt{i})
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option out must be either 0 or 1');
            end    
        elseif strcmpi('path',opt{i})
            if exist(val{i},'dir') ~= 7
                error('Value of option path must be an existent path');
            end
        elseif strcmpi('save',opt{i})
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option save must be either 0 or 1');
            end   
        elseif strcmpi('leadlag',opt{i})
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option leadlag must be either 0 or 1');
            end  
        elseif strcmpi('pi',opt{i})
            if (val{i} ~= 0) && (val{i} ~= 1)
                error('Value of option pi must be either 0 or 1');
            end           
        end
    end
end

if val{5} == 1 && ny <= 2
    val{5} = 0;
    warning('MATLAB:paramAmbiguous',...
         'Value for ''mulvar'' cannot be 1, if number of series is less than 3');
end

if val{6} == 1 && isempty(val{7})
    val{7} = 0.05;
end

if val{6} == 0 && ~isempty(val{7})
    val{6} = 1;
end

if val{9} == 1 && ny == 1
    val{9} = 0;
    warning('MATLAB:paramAmbiguous',...
         'If y is a vector, the mean phase angle cannot be computed');
end
    
if ~isempty(val{10}) && val{9} == 0
    val{9} = 1;
end

if isempty(val{10}) && val{9} == 1
    val{10} = [2,inf];
end

if val{12} == 1 && isempty(val{7})
    val{12} = 0;
    warning('MATLAB:paramAmbiguous',...
        'If option ''alpha'' is not specified, value for ''graphconf'' must be 0');
end

if val{12} == 1 && val{11} == 0
    val{12} = 0;
    warning('MATLAB:paramAmbiguous',...
        'If value of ''graph'' is 0, value for ''graphconf'' must also be 0');
end
    
if isempty(val{14})
    path = pwd;
    if exist([path,'\results'],'dir') ~= 7
       mkdir(path,'results');
    end
end

if val{15} == 0 && (~isempty(val{16}) || ~isempty(val{17}))
    val{15} = 1;
end

if val{15} == 1 && val{11} == 0
    error('If value of ''save'' is 1, value of ''graph'' cannot be 0');
end

if val{15} == 1 && (isempty(val{16}) && isempty(val{17}))
    val{15} = 'fig';
end

if val{18} == 1 && ny == 1
    val{17} = 0;
    warning('MATLAB:paramAmbiguous',...
        'value of ''leadlag'' cannot be 1 if y is a vector');
end

if val{19} == 1 && ny == 1
    val{19} = 0;
    warning('MATLAB:paramAmbiguous',...
        '''pi'' cannot be 1 if y is a vector');
end

vnames = val{1};
corlag = val{2};
win = val{3};
winlag = val{4};
mulvar = val{5};
conf = val{6};
alpha = val{7};
pband = val{8};
phmean=val{9};
phpband=val{10};
graph = val{11};
graphconf = val{12};
out = val{13};
path = val{14};
save = val{15};
ext = val{16};
format = val{17};
leadlag = val{18};
ppi = val{19};

% Convert the periods to the frequencies:

fband = fliplr(2*pi./pband);
if ~isempty(phpband)
    phfband = fliplr(2*pi./phpband);
else
    phfband = [];
end

% Create a new folder for plots if save == 1

if save == 1
    if exist([path,'\plots'],'dir') ~= 7
       mkdir(path,'plots');
    end
end



%***********************************************************************
%***********************************************************************


refc = y(:,1);      % reference series
rfname = vnames{1}; % name of the reference series

% Compute frequencies corresponding to the interval fband
n = ly;
np = n/2;
frq = zeros(np+1,1);

 for i = 0:np
    frq(i+1) = 2*pi*i/n;
 end
 
%-----------------------------------------------------------------------
% Determine name/s of the output text file/s
 
% Find the name of the calling script file (caution: this does not work
% with evaluation of a cell within the script file; in such a case name of
% the function spectran will be identified instead)

stack = dbstack;
mname = stack(end).name;

if out == 1 && leadlag == 0
   outf = spectxtname(path,mname,out,leadlag);
elseif out == 0 && leadlag == 1
   leadlf = spectxtname(path,mname,out,leadlag);  
else
   [outf,leadlf] = spectxtname(path,mname,out,leadlag);
end


%******************************************************************

if ny == 1          % Univariate analysis
   %--------------------------------------------
   % Compute autocorrelations
    
   cr=zeros(2*corlag,1);
   ind=-corlag+1:corlag;
   for j=ind
       [cro,stdx,stdx]=croscor(refc,refc,j);
       cr(corlag+j)=cro;
   end   
   
   %---------------------------------------------
   % Univariate spectral analysis
   
   if conf == 1
       sp = periodg(y,win,winlag,alpha);
       fxconf = sp.fconf;
   else 
       sp = periodg(y,win,winlag);       
   end
   fx = sp.f;
   
   
    %---------------------------------------------------------------
    if out == 1
        
       % Write the results to a text file
       fid=fopen(outf,'w'); 
       fprintf(fid,'=====================================================\n');    
       fprintf(fid,'\n               TIME-DOMAIN ANALYSIS\n');
       
       % Print autocorrelations
       corwrite(fid,1,cr,corlag,rfname)
       % Print results of spectral analysis
       spst = specwrite(fid,per,sp,fband,[],[],[],vnames,ppi);
    
       fclose(fid);
    end
    
    %------------------------------------------------------------------
   
   % Save the results in the structure spectr, if the user specified spectr to
   % be the output of spectran
   
   %if nargout == 1
       spectr.cr = cr;
       spectr.frq = spst.frq;
       spectr.f = spst.fx;
       if conf == 1
           spectr.fconf = spst.fxconf;
           spectr.alpha = alpha;
       end
   %end
   
   
    % Plot spectrum
    if graph == 1
        mul = 0;
        figure
        if graphconf == 1
           specplot(frq,per,mul,fx,fband,fxconf,alpha,'Spectrum',rfname)
        else
           specplot(frq,per,mul,fx,fband,[],[],'Spectrum',rfname) 
        end
       
        % Save figure
        if save == 1
           if isempty(format)
               saveas(gcf,[path '\plots\spec.' ext])
           elseif isempty(ext)
               saveas(gcf,[path '\plots\spec'], format)
           else
               saveas(gcf,[path '\plots\spec.' ext],format)
           end
        end
        pause
    end
    
else
    
%************************************************************************
    if out == 1
       fid=fopen(outf,'w');
       fprintf(fid,'=====================================================\n');    
       fprintf(fid,'\n               TIME-DOMAIN ANALYSIS\n');
    end
     
    for i = 2:ny      % Multivariate analysis
        comc = y(:,i);
        rname = vnames{i};
    
        %-----------------------------------------------------
        % Compute cross correlations
        
        cr=zeros(2*corlag,1);
        ind=-corlag+1:corlag;
        for j=ind
           [cro,stdx,stdx]=croscor(refc,comc,j);
           cr(corlag+j)=cro;
        end   
   
       %------------------------------------------------------
       
       if out == 1
         % Write the results to a text file
       
         % Print cross correlations
          corwrite(fid,2,cr,corlag,{rfname,rname})
       end
       
       %-------------------------------------------------------
       
     end
       
     % Bivariate or multivariate spectral analysis 
     if mulvar == 0  
        sp=crosspan(y,win,winlag,alpha); 
        co=sp.co;
        %sco=sp.sco;
        ph=sp.ph;
        pht=sp.pht;
        fx=sp.fx;
        fy=sp.fy;
     else
         sp=mulparspan(y,win,winlag,alpha);
         mco=sp.mco;
         %msco=sp.msco;
         co=sp.pco;
         %sco=sp.psco;
         ph=sp.pph;
         pht=sp.ppht;
         fx=sp.fx;
         fy=sp.fy;
     end
    
     if phmean == 1
        meanph = meanphconf(ph,frq,phpband,alpha);
     else 
         meanph = [];
     end
             
     if conf == 1
        fxconf = sp.fxconf;
        fyconf = sp.fyconf;
        if mulvar == 0
           cconf = sp.cconf;
           pconf = sp.pconf;
        end
     end

 
 %----------------------------------------------------------------------
     if out == 1
       % Write the results to the file 
     
       % Print results of cross-spectral analysis
        spst = specwrite(fid,per,sp,fband,meanph,phfband,vnames,ppi);
       
        fclose(fid);
     end
 
  %-----------------------------------------------------------------------
    % Save the results for frequency band defined by pband in 
    % the structure spectr
     spectr = spst;
                
    % Produce graphs
     if graph == 1
         
    % Path to the subdirectory where plots are to be saved
    if save == 1
        plotp = [path '\plots\'];
    end
      
    % Settings depending on the option 'mulvar'
        if mulvar == 0
            gco = 'Coherence';
            gpht = 'Phase delay';
            par = '';
        else
            gmco = 'Multiple coherency';
            gco = 'Partial coherency';
            gpht = 'Partial phase delay'; 
            par = 'par';
            if ny < 4
               other = [vnames{2} ' + ' vnames{3}];
            else
               other = 'other series';
            end
        end
        
    % Plot spectrum of the reference series
        mul = 0;  
        figure
        if graphconf == 1
           specplot(frq,per,mul,fx,fband,fxconf,alpha,'Spectrum',rfname)
        else
           specplot(frq,per,mul,fx,fband,[],[],'Spectrum',rfname) 
        end  
             
        % Save figure
        if save == 1
           if isempty(format)
              saveas(gcf,[plotp 'specx.' ext])
           elseif isempty(ext)
              saveas(gcf,[plotp 'specx'],format)
           else
              saveas(gcf,[plotp 'specx.' ext],format)
           end
        end
    
        % Plot multiple coherency
    %-------------------------------------------------------------     
        if mulvar == 1
           mul = 1;
           figure
           specplot(frq,per,mul,mco,fband,[],[],gmco,{rfname,other}) 
   
           % Save figure
           if save == 1
              if isempty(format)
                 saveas(gcf,[plotp 'mulcoherence' num2str(i) '.' ext])
              elseif isempty(ext)
                 saveas(gcf,[plotp 'mulcoherence' num2str(i)],format)
              else
                 saveas(gcf,[plotp 'mulcoherence' num2str(i) '.' ext],format)
              end
           end
        end
    %-------------------------------------------------------------
        jj = 0;
        for i=1:ny-1
            rname = vnames{i+1};
            jj = jj+1;
            ij = (i-1) + jj;
            % Plot spectrum of the other series
            mul = 0;
            figure
            if graphconf == 1
               specplot(frq,per,mul,fy(:,i),fband,fyconf(:,ij:ij+1),...
                        alpha,'Spectrum',rname)
            else
               specplot(frq,per,mul,fy(:,i),fband,[],[],'Spectrum',rname) 
            end
        
            % Save figure
            if save == 1
               if isempty(format)
                  saveas(gcf,[plotp 'specy' num2str(i) '.' ext])
               elseif isempty(ext)
                  saveas(gcf,[plotp 'specy' num2str(i)],format)
               else
                  saveas(gcf,[plotp 'specy' num2str(i) '.' ext],format)
               end
            end
        
   
        %-----------------------------------------------------------------     
        % Plot (partial) coherency 
        
            mul = 1;
            figure
            if mulvar == 0 && graphconf == 1
               specplot(frq,per,mul,co(:,i),fband,cconf(:,ij:ij+1),...
                        alpha,gco,{rfname,rname})
            else
               specplot(frq,per,mul,co(:,i),fband,[],[],gco,{rfname,rname}) 
            end
         
       
            % Save figure
            if save == 1
               if isempty(format)
                  saveas(gcf,[plotp par 'coherency' num2str(i) '.' ext])
               elseif isempty(ext)
                  saveas(gcf,[plotp par 'coherency' num2str(i)],format)
               else
                  saveas(gcf,[plotp par 'coherency' num2str(i) '.' ext],format)
               end
            end                       

       %---------------------------------------------------------------
       % Plot (partial) phase angle
       
           figure
           if mulvar == 0 && graphconf == 1
              phplot(frq,per,ph(:,i),fband,pconf(:,ij:ij+1),alpha,...
                  {rfname,rname},mulvar)
           else
              phplot(frq,per,ph(:,i),fband,[],[],{rfname,rname},mulvar) 
           end
           
           % Save figure
           if save == 1
              if isempty(format)
                 saveas(gcf,[plotp par 'phangle' num2str(i) '.' ext])
              elseif isempty(ext)
                 saveas(gcf,[plotp par 'phangle' num2str(i)],format)
              else
                 saveas(gcf,[plotp par 'phangle' num2str(i) '.' ext],format)
              end
           end
              
       %----------------------------------------------------------------
       % Plot (partial) phase delay
       
           mul = 1;
           figure
           specplot(frq,per,mul,pht(:,i),fband,[],[],gpht,{rfname,rname}) 
       
           % Save figure
           if save == 1
              if isempty(format)
                 saveas(gcf,[plotp par 'phdel' num2str(i) '.' ext])
              elseif isempty(ext)
                 saveas(gcf,[plotp par 'phdel' num2str(i)],format)
              else
                 saveas(gcf,[plotp par 'phdel' num2str(i) '.' ext],format)
              end
           end
         end
     end
      
     % Close all figures
     closefig;
   %--------------------------------------------------------------------  
     
     if leadlag  == 1
        fid=fopen(leadlf,'w');
        leadlagan(fid,per,sp,fband,meanph,phfband,vnames,ppi)
        fclose(fid);
     end
end

spectr.spectran = [];   % create field identifying structure created with
                        % spectran



