function specplot(frq,per,mul,spec,fband,specconf,alpha,specname,vnames)
%************************************************************************
%        This function plots (non-angular) spectral measures and their
%        confidence intervals
%
%     INPUTS:
%------------
%       frq : frequencies
%       per : frequency of the data (number of periods per year)
%       mul : 0, if univariate spectral measures are to be plotted
%             1, if multivariate spectral measures are to be plotted
%      spec : matrix with uni- or multivariate spectral measures with
%             columns corresponding to a particular series or 
%             a pair of series
%     fband : frequency interval for which results are displayed;
%             default is [0,pi]
%  specconf : confidence intervals for spec; it can be empty
%     alpha : significance level; it can be empty
%  specname : name of the spectral measure; it can be empty
%    vnames : name/s of the series; it can be empty
%
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
%************************************************************************

% Check the inputs and set the defaults

if nargin < 4
    error('There must be at least three inputs to specplot')
end

if isempty(frq) || isempty(per) || isempty(mul)|| isempty(spec)
    error('frq, per, mul and spec are required inputs to specplot')
end

if nargin < 9
    vnames = [];
end

if nargin < 8
    specname = [];
end

if nargin < 7
    alpha = [];
end

if nargin < 6
    specconf = [];
end

if nargin < 5 || isempty(fband)
    fband = [0,pi];
end

if (mul ~= 0) && (mul ~= 1)
    error('mul can be either 0 or 1')
end

if ~isempty(specname) && ~ischar(specname)
    error('specname must be a string')
end

ncp = size(spec,2);

if ~isempty(vnames) && (~ischar(vnames) && ~iscellstr(vnames))
    error('vnames must be a string/string array')
else
    if ischar(vnames)
        vnames = {vnames};
    end
    if mul == 0
        if length(vnames) ~= ncp;
           error('Number of elements in vnames must agree with the number of columns in spec')
        else
            nvar = ncp;
        end
    else
         if length(vnames) ~= ncp+1;
           error('Number of elements in vnames must be equal equal the number of columns in spec plus one')
         else
             nvar = ncp+1;
         end
    end
end

%---------------------------------------------------------

kf = (frq >= fband(1) & frq <= fband(2));

if ~isequal(fband,[0,pi])
    frqk = frq(kf);
    kkf = repmat(kf,1,ncp);
    spec = spec(kkf);
    spec = reshape(spec,[],ncp);
else
    frqk = frq;
end

if ~isempty(specconf)
    if ~isequal(fband,[0,pi])
       kk2f = repmat(kf,1,ncp*2);
       specconf = specconf(kk2f);
       specconf = reshape(specconf,[],ncp*2);
    end
end
    

if ~isempty(alpha)
    ci = 100*(1-alpha);
end

if ~isempty(specname) && isempty(vnames)
    vnames = cell(ncp,1);
    if mul == 0 && ncp == 1
        vnames{1} = 'series';
    else
        for i=1:nvar
            vnames{i} = ['series ' num2str(i)];
        end        
    end
end
  
if ~isempty(specname)
    lnames = cell(nvar,1);   % Names for the legend
    if mul == 0
        lnames = vnames;
    else
        for i=1:ncp
            lnames{i} = [vnames{1} ' - ' vnames{i+1}];
        end
    end
end

pband = 2*pi./fband;

jj = 0;

for i=1:ncp
    jj = jj+1;
    ij = (i-1) + jj;
    plot(frqk,spec(:,i))
    hold on
    if ~isempty(specconf)
       % Plot confidence interval
       plot(frqk,specconf(:,ij),':k',frqk,specconf(:,ij+1),':k')
       if ~isempty(specname)
           if ~isempty(alpha)
               legend([specname ' ' lnames{i}],[ num2str(ci) '% Confidence bounds'])
           else
                legend([specname ' ' lnames{i}],'Confidence bounds')
           end
       end
    else
        if ~isempty(specname)
           legend([specname ' ' lnames{i}])
        end
    end
       
    if  pband(1) < 1.5*per || pband(2) > 8*per
        cc=ones(100,2); 
        cc(:,1)=cc(:,1)*((2*pi)/(per*1.5)); 
        cc(:,2)=cc(:,2)*((2*pi)/(per*8)); 
        ll=(max(fxpb)-min(fxpb))/99;
        dd=min(fxpb):ll:max(fxpb);
            
        if pband(1) < 1.5*per && pband(2) > 8*per
           plot(cc(:,1),dd,cc(:,2),dd)
        elseif pband(1) < 1.5*per && pband(2) <= 8*per
           plot(cc(:,1),dd)
        elseif pband(1) >= 1.5*per && pband(2) > 8*per
           plot(cc(:,2),dd)
        end
    end
    hold off
    set(gca,'XLim',fband)
    pause
end


