function corwrite(fid,ns,cr,corlag,vnames)
%************************************************************************
%
%      This function writes the autocorrelations or 
%      cross correlations in a text file
% 
%     INPUTS:
%------------
%       fid : id of the text file where the output is to be written
%        ns : number of series (1 or 2)
%        cr : autocorrelations or cross correlations
%    corlag : number of leads and lags at which the
%             auto/cross correlations are computed;
%    vnames : name/s of the series
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

if nargin < 4
    error('There must be at least four inputs to corwrite')
end

if nargin < 5
    vnames = [];
end

if isempty(fid) || isempty(ns) || isempty(cr) || isempty(corlag)
    error('fid, ns, cr and corlag are required inputs to corwrite')
end

if ~isempty(vnames)
   if (~ischar(vnames) && ~iscellstr(vnames))
       error('vnames must be a string/string array');
   end
end

if ischar(vnames)
    vnames = {vnames};
end

%---------------------------------------------------------------------

ind=-corlag+1:corlag;

if ~isempty(vnames)
    rfname = vnames{1}; % name of the reference series
    lrf = length(rfname);
    if ns == 2
       rname = vnames{2};
       lr = length(rname);
    end
end

if ns == 1
   corr = 'autocorrelations';     
   if ~isempty(vnames)
       fprintf(fid,'\n\n***********  %*s ***********\n',lrf,upper(rfname));
   end
else 
   corr = 'cross correlations';
   if ~isempty(vnames)
       fprintf(fid,'\n\n********   %*s AND %*s   *********\n',...
               lrf,upper(rfname),lr,upper(rname));
   end
end

lcorr = length(corr);
    
% Print autocorrelations/cross correlations
fprintf(fid,'   %*s: t =%3i to %3i   ',lcorr,corr,[-corlag+1 corlag]);

for j=1:ceil(corlag/4)
    fprintf(fid,'\n%7i%7i%7i%7i%7i%7i%7i%7i ',...
            ind(8*(j-1)+1:min(8*j,2*corlag)));
    fprintf(fid,'\n%7.3f%7.3f%7.3f%7.3f%7.3f%7.3f%7.3f%7.3f',...
            cr(8*(j-1)+1:min(8*j,2*corlag)));
end
[mx,k]=max(abs(cr));
fprintf(fid,'\n   maximum correlation at t =%3i',ind(k)); 
fprintf(fid,'\n   correlation =%7.3f\n',mx);
    
    
    
    