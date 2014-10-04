function createTowerMap

%Init
clc;
figure;



%Load Outline
outline = csvread('meta/senegal.csv');



%Load Towers
towers = csvread('meta/towers.csv');



%Plot Outline and tower locations
plot(outline(:,1),outline(:,2),'k');
hold on;
sizer = towers(:,1);
sizer(:) = 10;
scatter(towers(:,3),towers(:,4),sizer,'filled');



%Create Polygons
dt = delaunayTriangulation(towers(:,3:4));
[V R] = dt.voronoiDiagram();



%Loop through polygons
exlist = [693 289 316 282];
for i=1:size(R)

  outside = 0;
  polygon = V(R{i},:);
  
  %Remove inf
  dum = ~isinf(polygon(:,1));
  polygon = polygon(dum,:);

  if (isempty(find(exlist == i)))
    
    validlist(i) = 1;
    edgeval = [];
    %Check whether points in polygon fall outside outline
    for j=1:size(polygon,1)-1
      xs = polygon(j,1);
      xe = polygon(j+1,1);
      ys = polygon(j,2);
      ye = polygon(j+1,2);
      sin = inpolygon(xs,ys,outline(:,1),outline(:,2));
      ein = inpolygon(xe,ye,outline(:,1),outline(:,2));
      edgeval = [edgeval ; sin ein];
      if (sin == 0 & ein == 0)
        outside = 1;
      end
    end



    polygon(end+1,:) = polygon(1,:);
    if (outside == 2)
      plot(polygon(:,1),polygon(:,2),'b');
    else
      if ~isempty(find(edgeval == 0))
        [xo,yo] = polybool('intersection',polygon(:,1), polygon(:,2), outline(:,1), outline(:,2));
        plot(xo,yo,'m');
        if (numel(xo) > 0)
          polygon = [xo yo];
        end
        plot(polygon(:,1),polygon(:,2),'g');
      else
        plot(polygon(:,1),polygon(:,2),'g');
      end
    end

    if (i == 914)
      polygon = textread('p914');
      polygon(end+1,:) = polygon(1,:);
      plot(polygon(:,1),polygon(:,2),'y');
    end

  else
    validlist(i) = 0;
  end
  
  polygons{i} = polygon;
  
end
save('towerpolygons.mat','polygons');







