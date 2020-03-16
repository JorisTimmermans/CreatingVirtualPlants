function [vertices2,faces2,vertices1,faces1]= createSidebranches(vertices1,n,l,o)

vertices2       =   zeros(2,3,n);
for j=1:n
    a                   =   (randperm(1000-o*1000)+o*1000)/(1000);
    vertices2(1,:,j)    =   [vertices1(2,:,1)-vertices1(1,:,1)]*a(1) +vertices1(1,:,1);
    direction_displace  =   [(rand-0.5)*2 (rand-0.5)*2 (rand-0.5)*2];
    vertices2(2,:,j)    =   (vertices2(1,:,j) + direction_displace*l);
end
vertices2(:,3,:)        =   abs(vertices2(:,3,:));      %branches cannot penetrate the ground!
faces2                  =   [1 2 2];

vertices3               =   permute(vertices2(1,:,:),[3 2 1]);
l                       =   (vertices3(:,1) - vertices1(1,1)).^2 +...
                            (vertices3(:,2) - vertices1(1,2)).^2 +...
                            (vertices3(:,3) - vertices1(1,3)).^2;
[l,i]                   =   sort(l);                        
vertices1               =   [vertices1(1,:);...
                             vertices3(i,:);...
                             vertices1(2,:)];

faces1                  =   1:size(vertices1);