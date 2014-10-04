function exportPolygons

%Init
clc;


%Load
load('meta/towerpolygons.mat');


%Store
for i=1:numel(polygons)
  polygon = polygons{i};
  fid = fopen(['towers/polygon' num2str(i)],'w');
  for j=1:size(polygon,1)
    fprintf(fid,'%f\t%f\n',polygon(j,1),polygon(j,2));
  end
  fclose(fid);
end
