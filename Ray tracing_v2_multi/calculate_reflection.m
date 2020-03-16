function    [l_r_v]=calculate_reflection(Triangle,light_vector)
vectors                         =   diff(Triangle);
A                               =   vectors(1,:);
B                               =   vectors(2,:);

%for specular reflection we can assume the reflection law (theta_i=-theta_r);
AxB                             =   cross(A,B);                     %calculate the normal to the surface
N                               =   AxB / (sqrt((A*A')*(B*B') + (A*B')^2));
N                               =   N/sqrt(N*N');

L       =  light_vector*N';
l_r_v  =   -(2*L*N - light_vector);          %simple algebra