function projectPointsToLine

%Init
clc;


%Create Line and points
myline = [0 0 1 1]
points = rand(10,2)


%Loop through points
plot([myline(1) myline(3)],[myline(2) myline(4)],'k');
hold on;
for i=1:10
  point = points(i,:);
  [projpoint,distance] = project(myline,point)
  h = scatter(point(1),point(2),'filled');
  set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);
  hold on;
  h = scatter(projpoint(1),projpoint(2),'filled');
  set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);
  plot([point(1) projpoint(1)],[point(2) projpoint(2)],'r');
end
  
  
  
  
%------------------------------------------------------------------------------
function [newpoint,distance] = project(myline,point)

  %Direction vector of the line
  vx = myline(:, 3);
  vy = myline(:, 4);

  %Difference of point with line origin
  dx = point(:,1) - myline(:,1);
  dy = point(:,2) - myline(:,2);

  %Position of projection on line, using dot product
  tp = (dx .* vx + dy .* vy ) ./ (vx .* vx + vy .* vy);

  %Convert position on line to cartesian coordinates
  newpoint = [myline(:,1) + tp .* vx, myline(:,2) + tp .* vy];

  %Calculate Distance
  distance = pdist([point ; newpoint])

