function    [N_V_n, Vertics, Face, N_index]=retrace_index(INDEX)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Vertices Faces
global N_t  N_b  N_sb  N_l
global n_t  n_b  n_sb  n_l
global n_vt n_vb n_vsb n_vl

N10  =   INDEX;
N20  =  (N10 - N_t ).*(N10>N_t);         %correct
N30  =  (N20 - N_b ).*(N20>N_b);         %correct
N40  =  (N30 - N_sb).*(N30>N_sb);        %correct
N50  =  (N40 - N_l ).*(N40>N_l);          %correct

N_V =   0;
N_T =   0;
N_B =   0;
N_SB=   0;
N_L =   0;


if N20  ==  0                           %Trunk%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ntot    =   (n_vt +1);
    N_T     =   ceil(N10/ntot);          %assumed only 1 trunk
    N11     =   N10  -   (N_T-1)*ntot;

    N_V     =   N11;
    Ind     =   't';
elseif N30  == 0                        %Branch%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ntot    =   (n_vb +1)*n_b;
    N_T     =   ceil(N20/ntot);
    N21     =   N20  -   (N_T-1)*ntot;

    ntot    =   (n_vb +1);
    N_B     =   ceil(N21/ntot);
    N22     =   N21 -   (N_B-1)*ntot;

    N_V     =   N22;
    Ind     =   'b';
elseif N40  ==  0                       %SubBranch%%%%%%%%%%%%%%%%%%%%%%%%%%
    ntot    =   (n_vsb +1)*n_b*n_sb;
    N_T     =   ceil(N30/ntot);
    N31     =   N30  -   (N_T-1)*ntot;

    ntot    =   (n_vsb +1)*n_sb;
    N_B     =   ceil(N31/ntot);
    N32     =   N31 -   (N_B-1)*ntot;

    ntot    =   (n_vsb +1);
    N_SB    =   ceil(N32/ntot);
    N33     =   N32 - (N_SB-1)*ntot;

    N_V     =   N33;
    Ind     =   'sb';
%Leafs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif N50==0
    ntot    =   (n_vl)*n_b*n_sb*n_l;
    N_T     =   ceil(N40/ntot);
    N41     =   N40  -   (N_T-1)*ntot;

    ntot    =   (n_vl)*n_sb*n_l;
    N_B     =   ceil(N41/ntot);
    N42     =   N41 -   (N_B-1)*ntot;

    ntot    =   (n_vl)*n_l;
    N_SB    =   ceil(N42(1)/ntot);
    N43     =   N42 - (N_SB-1)*ntot;

    ntot    =   (n_vl);
    N_L     =   ceil(N43(1)/ntot);
    N44     =   N43 - (N_L-1)*ntot;

    N_V     =   N44;
    Ind     =   'l';
else    
    N_V     =   N50;
    Ind     =   'g';
end

switch Ind
    case 'g'                                                %Ground
        N_V_n   =   find(any((Faces.Ground==N_V)'));         %neighbours of N_V
        Face    =   Faces.Ground(N_V_n,:);                   %Reshape Index
        N_index =   (N_t + N_b + N_sb + N_l)       + ...    %Reshape Index
                    Face;                                   %Reshape Index
        Vertics =   Vertices.Ground(:,:);                   %Position of N_V
    case 't'                                                %Trunk
        N_V_n   =   find(any((Faces.Trunk==N_V)'));         %neighbours of N_V
        Vertics =   Vertices.Trunk(:,:,N_T);                %Position of N_V
        Face    =   Faces.Trunk(N_V_n,:);                   %Reshape Index
        N_index =   (N_T )*n_vb  + Face;                    %Reshape Index
    case 'b'                                                %Branch
        N_V_n   =   find(any((Faces.Branch==N_V)'));        %neighbours of N_V
        Vertics =   Vertices.Branch(:,:,N_T,N_B);
        Face    =   Faces.Branch(N_V_n,:);                  %Reshape Index
        N_index =   (N_t       )       + ...                %Reshape Index
                    (N_T + N_B )*n_vb  + Face;              %Reshape Index
    case 'sb'                                               %SubBranch
        N_V_n   =   find(any((Faces.SubBranch==N_V)'));     %neighbours of N_V
        Vertics =   Vertices.SubBranch(:,:,N_T,N_B,N_SB);   %Position of N_V
        Face    =   Faces.SubBranch(N_V_n,:);               %Reshape Index
        N_index =   (N_t + N_b       )        + ...         %Reshape Index
                    (N_T + N_B + N_SB)*n_vsb  + Face;       %Reshape Index
    case 'l'                                                %Leafs
        N_V_n   =   find(any((Faces.Leaf0==N_V)'));         %neighbours of N_V
        Face    =   Faces.Leaf0(N_V_n,:);                   %Reshape Index
        N_index =   (N_t + N_b + N_sb      )       + ...    %Reshape Index
                    (N_T + N_B + N_SB + N_L)*n_vl  + Face;  %Reshape Index
        Vertics =   Vertices.Leaf(:,:,N_T,N_B,N_SB,N_L);    %Position of N_V    
end