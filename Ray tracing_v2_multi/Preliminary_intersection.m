function    [INdex,L1]  =   Preliminary_intersection(light_start_position2,light_vector,light_width)
global Vertices

Diff0  =   light_vector;

Diff1   =   -[light_start_position2(:,1)-Vertices.All(:,1),  ...
             light_start_position2(:,2)-Vertices.All(:,2),  ...
             light_start_position2(:,3)-Vertices.All(:,3)];
L1      =   sqrt(sum(Diff1.^2,2));
Diff11  =   [Diff1(:,1)./L1 Diff1(:,2)./L1 Diff1(:,3)./L1 ];
theta   =   acos(abs(Diff0*Diff11')');
Ll      =   sin(theta).*L1;
INdex   =   find(Ll<light_width);
