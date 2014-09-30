function varargout = spectxtname(path,mname,out,leadlag)
%*************************************************************************
%   This function is an auxiliary function called in the function spectran
%   to assign a name to the text file where results of spectran are to be
%   written
%
%     INPUTS:
%------------
%      path : string specifying the path to the directory where the
%             output file/s should be written;
%     mname : name of the script file where spectran has been invoked; if
%             spectran has been called from the command line or while
%             evaluating a cell, mname is spectran
%       out : 0, do not write the the output to a text file
%             1, write output to a text file 
%   leadlag : 0, do not produce separate file with the lead-lag
%             analysis 
%             1, produce separate file 'leadlag.txt' with the lead-lag
%             analysis 
%
%     OUTPUTS:
%-------------
%      outf : name of the text file for writing of the spectral analysis 
%             results; outf is output if out = 1
%    leadlf : name of the text file for writing of the results of the lead-lag
%             analysis; leadlf is output if leadlag = 1
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

% Check the variables in the base workspace. If among the variables there
% are structures with the field "spectran", then the number of them determine
% the id of the process. The id is 0, if there are no such structures.

id = 0;
wvar = evalin('base','whos');
lwvar = size(wvar,1);
for i = 1:lwvar
    if strcmpi('struct',wvar(i).class)
       varname = wvar(i).name;
       str = evalin('base',varname);
       if isfield(str,'spectran')
          id = id+1;
       end
    end
end

% Determine the names of the text files for writing the results depending
% on whether spectran has been called from a script file (the name
% contains then the name of this script) or from the command line/while
% evaluating a cell in the script file (the name contains then the name
% "spectran")

if ~strcmpi(mname,'spectran')
    fname = ['sp_' mname ];
    lname = ['leadlag_' mname]; 
else
    fname = mname;     
    lname = 'leadlag';
end

% Delete text files in the directory determined by the user (or default
% directory) which do not correspond to the current script run (if spectran
% has been called while running the script file) or to the current spectran
% call (if the call has occured from the command line or while cell
% evaulation)

del = dir(fullfile(path,['*' mname '*.txt']));

if size(del,1) ~= 0  
   for i = 1:size(del,1)
       deli = del(i).name;
       [p,deli,ext] = fileparts(deli);
       parts = textscan(deli,'%s','Delimiter','_');
       pp = parts{1,1}{end,1};
       if str2double(pp) > id
           if ~isempty(strfind(deli,fname))
              delete([path '\' fname '_' pp '.txt']);               
           end
           if ~isempty(strfind(deli,lname))
              delete([path '\' lname '_' pp '.txt']); 
           end
       end
   end
end

% Determine full names of the text files including their ids

if out == 1
   outf = [path '\' fname '_' num2str(id+1) '.txt']; 
   varargout{1} = outf;
end
       
if leadlag == 1   
   leadlf = [path '\' lname '_' num2str(id+1) '.txt'];
   if out == 1
       varargout{2} = leadlf;
   else
       varargout{1} = leadlf;
   end
end
       

end