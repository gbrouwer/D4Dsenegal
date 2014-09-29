function plotConnectivity

%Init
clc;



%Read Matrix
data = csvread('data/text_total_district');
M = sparse(data(:,1),data(:,2),data(:,3));



%Read Towers
towers = csvread('meta/towers');



%Load Senegal Country Shape
country = csvread('meta/senegal');



%Load Senegal outlines
load('meta/districts.mat'); 



%Plot outlines
subplot(2,2,1);
plot(country(:,1),country(:,2),'k');
box on; hold on;
subplot(2,2,2);
plot(country(:,1),country(:,2),'k');
box on; hold on;
axis([-18 -16 13 16]);



%Plot the district centers
meanX = [];
for i=1:123
  X = outlines(i).X;
  name = outlines(i).name;
  meanX = [meanX ; mean(X)];
end




%Draw the outlines
for i=1:123
  for j=i+1:123
    val = log(M(i,j));
    if (val > 14)
      from = meanX(i,:);
      to = meanX(j,:);
      subplot(2,2,1); hold on;
      h = line([from(1) to(1)],[from(2) to(2)]);
      subplot(2,2,2); hold on;
      h = line([from(1) to(1)],[from(2) to(2)]);
    end
  end
end



subplot(2,2,1);
h = scatter(meanX(:,1),meanX(:,2),'filled');
set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);
subplot(2,2,2);
h = scatter(meanX(:,1),meanX(:,2),'filled');
set(h,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);
