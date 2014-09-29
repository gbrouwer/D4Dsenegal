function correctImage

%Init
clc;
im = imread('language.png');


dum1 = im(:,:,1) < 10;
dum2 = im(:,:,2) < 10;
dum3 = im(:,:,3) < 10;
dum = dum1 + dum2 + dum3;
dum = find(dum == 3);


newim = im;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(1,1,:);
end


im = newim;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(3,3,:);
end


im = newim;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(3,1,:);
end


im = newim;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(1,3,:);
end


im = newim;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(2,1,:);
end


im = newim;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(1,2,:);
end

im = newim;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(2,3,:);
end


im = newim;
for i=1:numel(dum)
  [x,y] = ind2sub(size(dum1),dum(i));
  subim = im(x-1:x+1,y-1:y+1,:);
  newim(x,y,:) = subim(3,2,:);
end


imagesc(newim);