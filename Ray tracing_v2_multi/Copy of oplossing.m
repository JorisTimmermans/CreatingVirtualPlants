% A=[1 0 0];
% B=[0 2 0];
% AxB =   cross(a,b);
% N   =   AxB / sqrt(a*a'*b*b' -a*b')

N_t =   (n_vt  +1) *n_t;                %total number of trunk nodes
N_b =   (n_vb  +1) *n_t*n_b;            %total number of branch nodes
N_sb=   (n_vsb +1)*n_t*n_b*n_sb;        %total number of subbranch nodes
N_l =   (n_vl  )  *n_t*n_b*n_sb*n_l;    %total number of leaf nodes

INDEX   =   INDEx(1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N10  =   INDEX;
N20  =  (N10 - N_t )*(N10>N_t);         %correct
N30  =  (N20 - N_b )*(N20>N_b);         %correct
N40  =  (N30 - N_sb)*(N30>N_sb);        %correct
%Trunk%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntot    =   (n_vt +1);
N_T     =   ceil(N10/ntot);
N11     =   N10  -   (N_T-1)*ntot;

N_V     =   N11;
[Vertices.All(N10,:);Vertices.Trunk(N_V,:,N_T)]
%Branch%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntot    =   (n_vb +1)*n_b
N_T     =   ceil(N20/ntot);
N21     =   N20  -   (N_T-1)*ntot;

ntot    =   (n_vb +1);
N_B     =   ceil(N21/ntot);
N22     =   N21 -   (N_B-1)*ntot;

N_V     =   N22;
[Vertices.All(N10,:);Vertices.Branch(N_V,:,N_T,N_B)]
%SubBranch%%%%%%%%%%%%%%%%%%%%%%%%%%
ntot    =   (n_vsb +1)*n_b*n_sb
N_T     =   ceil(N30/ntot);
N31     =   N30  -   (N_T-1)*ntot;

ntot    =   (n_vsb +1)*n_sb;
N_B     =   ceil(N31/ntot);
N32     =   N31 -   (N_B-1)*ntot;

ntot    =   (n_vsb +1);
N_SB    =   ceil(N32/ntot);
N33     =   N32 - (N_SB-1)*ntot;

N_V     =   N33;
[Vertices.All(N10,:);Vertices.SubBranch(N_V,:,N_T,N_B,N_SB)]
%Leafs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntot    =   (n_vl)*n_b*n_sb*n_l;
N_T     =   ceil(N40/ntot);
N41     =   N40  -   (N_T-1)*ntot;

ntot    =   (n_vl)*n_sb*n_l;
N_B     =   ceil(N41/ntot);
N42     =   N41 -   (N_B-1)*ntot;

ntot    =   (n_vl)*n_l
N_SB    =   ceil(N42/ntot);
N43     =   N42 - (N_SB-1)*ntot;

ntot    =   (n_vl)
N_L     =   ceil(N43/ntot);
N44     =   N43 - (N_L-1)*ntot;

N_V     =   N44
[Vertices.All(N10,:);Vertices.Leaf(N_V,:,N_T,N_B,N_SB,N_L)]