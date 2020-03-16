Vertices.Trunk          =   [];
Vertices.Trunk(:,:,1)   =   [0      0       0       ;...
                             1      -2       100    ];
Faces.Trunk             =   [1 2 2]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('n_nt0')
    if n_nt0==8
        Trunk0                  =   [-1             0              0       ;...            Creating the first vertices
                                     -sqrt(2)/2     -sqrt(2)/2      0       ;...
                                      0             -1              0       ;...
                                      sqrt(2)/2     -sqrt(2)/2      0       ;...
                                      1              0              0       ;...
                                      sqrt(2)/2      sqrt(2)/2      0       ;...
                                      0              1              0       ;...
                                     -sqrt(2)/2      sqrt(2)/2      0]      ;
    elseif n_nt0==6
        Trunk0                  =   [cos(-180/180*pi) sin(-180/180*pi) 0
                                     cos(-120/180*pi) sin(-120/180*pi) 0
                                     cos(-060/180*pi) sin(-060/180*pi) 0
                                     cos(+000/180*pi) sin(+000/180*pi) 0
                                     cos(+060/180*pi) sin(+060/180*pi) 0
                                     cos(+120/180*pi) sin(+120/180*pi) 0];
    end
end