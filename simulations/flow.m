function flow


%Init
clc;
nNodes = 10;



%Create nodes
x = sin(linspace(0,2*pi,nNodes+1));
y = cos(linspace(0,2*pi,nNodes+1));
V = [x' y'];
V = V(1:end-1,:);
V


%Create flow
Tin = rand(nNodes,nNodes);
Tout = rand(nNodes,nNodes);
for i=1:nNodes
  Tin(i,i) = 0;
  Tout(i,i) = 0;
end



%Normalize
for i=1:nNodes
  val = Tin(:,i);
  val = val ./ sum(val);
  Tin(:,i) = val;
  val = Tout(:,i);
  val = val ./ sum(val);
  Tout(:,i) = val;
end



%Random Walk
S = ones(nNodes,1);
Stot = S;
for m=1:10
  for i=1:5
    S = Tin*S;
    Stot = [Stot S];
  end
  for i=1:5
    S = Tout*S;
    Stot = [Stot S];
  end
end



Stot = Stot - 0.5;
Stot
for m=1:100
  clf;
  for j=1:nNodes
    c = Stot(j,m);
    if (c < 0) 
      c = 0;
    end
    if (c > 1)
      c = 1;
    end
    h = scatter(V(j,1),V(j,2),'filled');
    set(h,'MarkerEdgeColor',[c c c],'MarkerFaceColor',[c c c]);
    h = get(h,'Children');
    set(h(1),'MarkerSize',50*c);
    hold on;
    axis([-1.2 1.2 -1.2 1.2]);
    box on;
  end
  pause(0.25);
end




