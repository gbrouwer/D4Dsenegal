function outlines2districts

%Init
clc;



%Read names
fid = fopen(['meta/districts'],'r');
for i=1:123
  tline = fgetl(fid);
  [rem,dname] = strtok(tline,',');
  dname = [dname(2) lower(dname(3:end))];
  outlines(i).name = dname;
end



%Read Coordinates
for i=0:122
  
  %Read Index
  fid = fopen(['outlines/lines' num2str(i)],'r');
  tline = fgetl(fid);
  [id,rem] = strtok(tline,',');
  id = str2num(id);
  
  %Read Coordinates
  X = [];
  while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    [left,right] = strtok(tline,',');
    [left,right] = strtok(right(2:end),',');
    X = [X ; str2num(left) str2num(right)];
  end
  fclose(fid);
  if (id+1 == 108)
    disp(['outlines/lines' num2str(i)])
  end
  outlines(id+1).X = X;

end



%Save
save('senegal.mat','outlines');