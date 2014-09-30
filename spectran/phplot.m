function phplot(frq,per,ph,fband,phconf,alpha,vnames,mulvar)
%************************************************************************
%    This function plots the (partial) phase angle values with
%    their confidence intervals.
%
%     INPUTS:
%------------
%       frq : frequencies
%       per : frequency of the data (number of periods per year)
%        ph : matrix with phase angle values with columns
%             corresponding to the reference series and
%             a particular series
%     fband : frequency interval for which results are displayed;
%             default is [0,pi]
%    phconf : confidence intervals for ph; it can be empty
%     alpha : significance level; it can be empty
%    vnames : name/s of the series; it can be empty
%    mulvar : 0, ordinary phase angle (default)
%             1, partial phase angle
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

if nargin < 3
    error('There must be at least three inputs to phplot')
end

if isempty(frq) || isempty(per) || isempty(ph)
    error('frq, per and ph are required inputs to phplot')
end

if nargin < 8
    mulvar = [];
end

if nargin < 7
    vnames = [];
end

if nargin < 6
    alpha = [];
end

if nargin < 5
    phconf = [];
end

if nargin < 4 || isempty(fband)
    fband = [0,pi];
end

nph = size(ph,2);

if ~isempty(vnames) && (~ischar(vnames) && ~iscellstr(vnames))
    error('vnames must be a string/string array')
else
    if ischar(vnames)
        vnames = {vnames};
    end
    if length(vnames) ~= nph+1;
       error('Number of elements in vnames must be equal equal the number of columns in spec plus one')
    end
end

if isempty(vnames)
    vnames = cell(nph+1,1);
    for i=1:nph+1
        vnames{i} = ['series ' num2str(i)];
     end        
end

%--------------------------------------------------------------------

rfname = vnames{1};

kf = (frq >= fband(1) & frq <= fband(2));
         
if ~isequal(fband,[0,pi])
    frqk = frq(kf);
    kkf = repmat(kf,1,nph);
    ph = ph(kkf);
    ph = reshape(ph,[],nph);
else
    frqk = frq;
end

if ~isempty(phconf)
    if ~isempty(alpha)
        ci = 100*(1-alpha);
    end
    if ~isequal(fband,[0,pi])
       kk2f = repmat(kf,1,nph*2);
       phconf = phconf(kk2f);
       phconf = reshape(phconf,[],nph*2);
    end
end

lf = length(frqk);

if lf > 50
    stf = floor(lf/50);
    g =zeros(lf,1);
    for ii = 1:stf:lf
        g(ii) = 1;
    end
    g = logical(g);
    frqg = frqk(g);
    gg = repmat(g,1,nph);
    phg = ph(gg);
    phg = reshape(phg,[],nph);
           
    if ~isempty(phconf)
        gg2 = repmat(g,1,nph*2);
        phconfg = phconf(gg2);
        phconfg = reshape(phconfg,[],nph*2);
    end
else
    frqg = frqk;
    phg = ph;
    if ~isempty(phconf)
        phconfg = phconf;
    end
end
 
pband = 2*pi./fband;

lfg = length(frqg);
jj = 0;

% Setting for the legend
if mulvar == 0
    gph = 'Phase angle ';
else
    gph = 'Partial phase angle ';
end

for i = 1:nph
    jj = jj+1;
    ij = (i-1) + jj;
    rname = vnames{i+1};
    
    figure
    scatter(frqg,phg(:,i),2.5,'k','filled')
    hold on
    if ~isempty(phconf)
       % Plot confidence intervals
       for kk = 1:lfg
           xx = ones(1,2)*frqg(kk);
           yy = phconfg(kk,ij:ij+1);
           if yy(1) < yy(2)
              plot(xx,yy,'b')
           elseif yy(2) < yy(1)
              plot(xx,[yy(2),-pi],xx,[yy(1),pi],'b')
           end
       end
       if ~isempty(alpha)
           legend([gph rfname ' - ' rname],[ num2str(ci) '% Confidence bounds'])    
       else
           legend([gph rfname ' - ' rname],'% Confidence bounds')
       end
    else
           legend([gph rfname ' - ' rname])
    end
    
    aa = ones(lfg,1);
    plot(frqg,aa*0,':k',frqg,aa*(-pi/2),':k',frqg,aa*(pi/2),':k')
    
    if  pband(1) < 1.5*per || pband(2) > 8*per
        
        cc=ones(100,2); 
        cc(:,1)=cc(:,1)*((2*pi)/(per*1.5)); 
        cc(:,2)=cc(:,2)*((2*pi)/(per*8)); 
        ll=(max(phg(:,i))-min(phg(:,i)))/99;
        dd=min(phg(:,i)):ll:max(phg(:,i));
            
        if pband(1) < 1.5*per && pband(2) > 8*per                 
           plot(cc(:,1),dd,cc(:,2),dd)
        elseif pband(1) < 1.5*per && pband(2) <= 8*per
           plot(cc(:,1),dd)
        elseif pband(1) >= 1.5*per && pband(2) > 8*per
           plot(cc(:,2),dd)          
        end
    end
    hold off   
    set(gca,'YLim',[-pi pi])
    set(gca,'XLim',fband)
    pause
end