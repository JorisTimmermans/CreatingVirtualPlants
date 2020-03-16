function [I,u,v] =   triangle_line_intersection(Triangle,light_start_position,light_vector)
%Intersection scheme according to 
%Tomas Moller (prosolvia Claus AB, Chalmers University of Technology )
%and
%Ben Trumbore (Program of Computer Graphics, Cornell University)
%script written by Joris Timmermans, (Water Resource Department, ITC)
%j.timmermans@itc.nl

light_start_position2    = light_start_position  ;

V0  =   Triangle(1,:);
V1  =   Triangle(2,:);
V2  =   Triangle(3,:);
O   =   light_start_position2;
D   =   light_vector;

E1  =   V1 -V0;
E2  =   V2 -V0;
T   =   O - V0;
Q   =   cross(T,E1);
P   =   cross(D,E2);

vector  =   1/(P*E1')*[Q*E2', P*T', Q*D'];

t   =   vector(1);
u   =   vector(2);
v   =   vector(3);
I   =   u*E1 + v*E2 + V0;

I   =   D*t + O;
I   =   I;
