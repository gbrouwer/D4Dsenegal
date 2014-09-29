function mapReader6


%Init
clc
im = imread('maps/agroecological.png');
load('meta/districts.mat');


%Positions
xpos = linspace(-17.52999,-11.348894,2048);
ypos = linspace(12.307808,16.691532,2048);
ypos = flipdim(ypos,2);


%Meshgrid
[Xm,Ym] = meshgrid(1:2048,1:2048);
Xm = reshape(Xm,numel(Xm),1);
Ym = reshape(Ym,numel(Ym),1);



%Loop through districts
imagesc(im);
hold on;
colormap gray;
V = []
X = zeros(2048,2048);
for i=1:123
  
  %Get data
  loc = outlines(i).X;
  orig = loc;

  %Center and shrink
  meanval = mean(loc);
  loc(:,1) = loc(:,1) - meanval(1);
  loc(:,2) = loc(:,2) - meanval(2);
  loc = loc * 0.5;
  loc(:,1) = loc(:,1) + meanval(1);
  loc(:,2) = loc(:,2) + meanval(2);
  
  %Correct
  ind = loc2ind(loc);
  ind(:,2) = 1765 - ind(:,2);

  
  %Get values
  indexes = sub2ind(size(im),ind(:,2),ind(:,1));
  mval = mode(im(indexes));

  
  %Correct
  ind = loc2ind(orig);
  ind(:,2) = 1765 - ind(:,2);

  if (mval == 1)
    plot(ind(:,1),ind(:,2),'r');
  end  
  if (mval == 2)
    plot(ind(:,1),ind(:,2),'b');
  end  
  if (mval == 3)
    plot(ind(:,1),ind(:,2),'g');
  end  
  if (mval == 4)
    plot(ind(:,1),ind(:,2),'c');
  end  
  if (mval == 5)
    plot(ind(:,1),ind(:,2),'m');
  end  
  V = [V ; i mval];
end

V





%------------------------------------------------------------
function ind = loc2ind(loc)

  ind = [];
  loc(:,1) = (loc(:,1) + 17.52999) * 0.1615;
  loc(:,2) = (loc(:,2) - 12.30780) * 0.165;
  ind = round(loc * 2048);
  
  
  