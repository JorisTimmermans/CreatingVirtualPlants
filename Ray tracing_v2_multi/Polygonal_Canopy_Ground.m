maxr    =   1+p_curvt + l_b + l_sb + l_l;

N_g     =   ceil(maxr)*2;
[x,y]   =   meshgrid(1:N_g,1:N_g);
x       =   reshape(x,N_g*N_g,1);
y       =   reshape(y,N_g*N_g,1);

% Faces.Ground = delaunay(x,y,{'QJ'});
Faces.Ground = delaunay(x,y);
Vertices.Ground =   [x/N_g*2*maxr-maxr,...
                     y/N_g*2*maxr-maxr,...
                     rand(size(x))];
% trisurf(Faces.Ground,Vertices.Ground(:,1),Vertices.Ground(:,2),Vertices.Ground(:,3))


% Vertices.Ground     =   [-maxr -maxr 0;
%                           maxr -maxr 0;
%                           maxr  maxr 0;
%                          -maxr  maxr 0];
% Faces.Ground        =   [1 2 3 4];
Color.Ground        =   [1 1 1];


