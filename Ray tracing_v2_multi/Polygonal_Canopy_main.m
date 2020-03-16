clc
close all
clear all
warning off

n_d     =   3;
%%%%%%%%%%%%%%%%%%%Trunk
n_t     =   1;              %Number of Trunks
n_nt0   =   8;              %Number of vertices in layer0
n_lt    =   100;            %number of layers trunk
n_vt    =   2*n_nt0*n_lt;   %number of vertices
n_vt0   =   n_vt+1;         %number of vertices + zero point
l_t     =   100;            %length of the Trunk
d_t     =   2;              %base thickness of the Trunk
p_tipt  =   2;              %parameter for tipping of the branch
p_curvt =   015;            %parameter for curvature of the branch
alpha_t =   0.2;            %absortion coefficient for the trunk
Polygonal_Canopy_Trunk
Vertices.Trunk  =   zeros(n_vt0 ,n_d,n_t);
Polynomial.Trunk=   zeros(5     ,3  ,n_t);
%%%%%%%%%%%%%%%%%%%%%branches
n_b     =   3;              %number of branches
n_nb0   =   6;              %number of vertices in layer0
n_lb    =   40;             %number of layers branch
n_vb    =   2*n_nb0*n_lb;   %number of vertices
n_vb0   =   n_vb+1;         %number of vertices + zero point
o_b     =   0.2;            %offset were to place the branches
l_b     =   10;             %length of branch
d_b     =   0.5;            %base thickness of branch
p_tipb  =   2;              %parameter for tipping of the branch
p_curvb =   015;            %parameter for curvature of the branch
alpha_b =   0.2;            %absortion coefficient for the branch
Vertices.Branch     =   zeros(n_vb0  ,n_d,n_t,n_b);
Polynomial.Branch   =   zeros(5     ,3  ,n_t,n_b);
index.tb            =   zeros(1     ,1  ,n_t,n_b);
%%%%%%%%%%%%%%%%%%%%%subbranches
n_sb    =   3;             %number of subbranches
n_nsb0  =   6;              %number of vertices in layer0
n_lsb   =   40;             %number of layers subbranch
n_vsb   =   2*n_nsb0*n_lsb; %number of vertices
n_vsb0  =   n_vsb+1;        %number of vertices + zero point
o_sb    =   0.2;            %offset were to place the subbranches
l_sb    =   1;              %length of subbranch
d_sb    =   0.01;           %base thickness of subbranch
p_tipsb =   2;              %parameter for tipping of the subbranch
p_curvsb=   015;            %parameter for curvature of the subbranch
alpha_sb=   0.2;            %absortion coefficient for the subbranch
Vertices.SubBranch   =   zeros(n_vsb0 ,n_d,n_t,n_b,n_sb);
Polynomial.SubBranch =   zeros(5    ,3  ,n_t,n_b,n_sb);
index.bsb            =   zeros(1     ,1 ,n_t,n_b,n_sb);
%%%%%%%%%%%%%%%%%%%%%leaf
n_l     =   5;             %number of leafs per subbranch
n_vl    =   22;             %number of vertices
n_vl0   =   n_vl;           %number of vertices + zero point (no zeropoint)
o_l     =   0.5;            %offset were to place the leafs
l_l     =   .1;             %dummie parameter for use of advancesubbranch
k       =   2;              %defines subset of the leaf orientation
l       =   2;              %defines subset of the leaf orientation
alpha_l =   0.2;            %absortion coefficient for the trunk
Polygonal_Canopy_Leaf
Vertices.Leaf   =   zeros(n_vl,n_d,n_t,n_b,n_sb,n_l);
index.sbl       =   zeros(1     ,1 ,n_t,n_b,n_sb,n_l);
%%%%%%%%%%%%%%%%%%%Ground
Polygonal_Canopy_Ground
n_g     =   1;
n_nt0   =   size(Vertices.Ground,1);
n_lg    =   1;
n_vg    =   n_nt0*n_lg;
l_g     =   maxr;
d_g     =   maxr;
alpha_g =   0.2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Vertices.Trunk(:,:,1)      ,...
 Faces.Trunk                ,...
 Color.Trunk                ,...
 Polynomial.Trunk(:,:,1)]       =   Polygonal_Canopy_subbranch(Trunk0   ,...
                                                               n_lt     ,...
                                                               l_t      ,...
                                                               d_t      ,...
                                                               p_tipt   ,...
                                                               p_curvt) ;
for j=1:n_t,                        %trunkindex
    [Vertices.Branch(:,:,j,:)   ,...
     Faces.Branch               ,...
     Color.Branch               ,...
     Polynomial.Branch(:,:,j,:) ,...
     index.tb(:,:,j,:)]             = Polygonal_Canopy_attach(Vertices.Trunk(:,:,j)      ,...
                                                              Faces.Trunk                ,...
                                                              Polynomial.Trunk(:,:,j)    ,...
                                                              n_b                        ,...
                                                              l_b                        ,...
                                                              d_b                        ,...
                                                              o_b                        ,...
                                                              n_lb);                                                                            
    for jj=1:n_b,                        %Branchindex
        [Vertices.SubBranch(:,:,j,jj,:)     ,...
         Faces.SubBranch                    ,...
         Color.SubBranch                    ,...
         Polynomial.SubBranch(:,:,j,jj,:)   ,...
         index.bsb(:,:,j,jj,:)]         = Polygonal_Canopy_attach(Vertices.Branch(:,:,j,jj)  ,...
                                                                  Faces.Branch               ,...
                                                                  Polynomial.Branch(:,:,j,jj),...
                                                                  n_sb                       ,...
                                                                  l_sb                       ,...
                                                                  d_sb                       ,...
                                                                  o_sb                       ,...
                                                                  n_lsb);                
        for jjj=1:n_sb,
            for jjjj=1:n_l
                [indexx,vector_d]      =Polygonal_Canopy_Intersection(Vertices.SubBranch(:,:,j,jj,jjj)  ,...
                                                                      Polynomial.SubBranch(:,:,j,jj,jjj),...
                                                                      o_l);
                x               =   Leaf0(:,1,1,1,1);
                y               =   Leaf0(:,2,1,1,1);
                z               =   Leaf0(:,3,1,1,1);
                [alpha1]        =   cart2pol(vector_d(:,1),vector_d(:,2));
                [theta,alpha2]  =   cart2sph(vector_d(:,1),vector_d(:,2),vector_d(:,3));
                [x,y,z]         =   Polygonal_Canopy_rotatecylindrical(x,y,z,'z',-pi/4);
                [x,y,z]         =   Polygonal_Canopy_rotatecylindrical(x,y,z,'x',pi*rand);
                [x,y,z]         =   Polygonal_Canopy_rotatecylindrical(x,y,z,'y',alpha2);
                [x,y,z]         =   Polygonal_Canopy_rotatecylindrical(x,y,z,'z',alpha1);
                Vertices.Leaf(:,:,j,jj,jjj,jjjj) = [x + Vertices.SubBranch(indexx,1,j,jj,jjj)     ,...
                                                    y + Vertices.SubBranch(indexx,2,j,jj,jjj)     ,...
                                                    z + Vertices.SubBranch(indexx,3,j,jj,jjj)];
                index.sbl(:,:,j,jj,jjj,jjjj)=indexx;
            end
        end
    end
end
Polygonal_Canopy_plot_canopy
save data.mat