clc
close all
clear all


n_d                                         =   3;

time                                        =   clock;
filestring                                  =   sprintf('L-systems Tree, %4.0f-%02.0f-%02.0f, %02.0f%2.0f',[time(1) time(2) time(3) time(4) time(5)]);

fprintf(1,'Loading  Parameters\n')
%% Trunks
n_t                                         =   2;             % Number of Trunks

o_t                                         =   NaN;            % offset of bifurcations (1= end of branch)
c_t                                         =   NaN;            % angle  of bifurcations

%Shape parameters
l_t                                         =   15;             % length of the Trunk                                   20.0 m
d_t                                         =   0.2;            % base thickness of the Trunk                           00.2 cm

p_tipt                                      =   03;
p_curvt                                     =   0.5;

% Simulation parameters
n_nt0                                       =   8;              % Number of vertices in layer0
n_lt                                        =   160;             % number of layers trunk
n_vt                                        =   2*n_nt0*n_lt;   % number of vertices
n_vt0                                       =   n_vt+1;         % number of vertices + zero point

VerticesTrunk

%% Woody Elements
[n_b,       n_sb,       n_tw]               =   deal(4);        % number of bifurcations
% n_b                                         =   8;              % number of bifurcations
% n_sb                                        =   8;              % number of bifurcations
% n_tw                                        =   8;              % number of bifurcations

[o_b,       o_sb,       o_tw]               =   deal(0.2);      % offset of bifurcations (1= end of branch)             1
[c_b,    	c_sb,       c_tw]               =   deal(40);       % angle  of bifurcations                                40

%Shape parameters
r                                           =   3;              % reduction

l_b                                         =   l_t/r;          % length of branch                                      05.0 m
l_sb                                        =   l_b/r;          % length of subbranch                                   01.6 m
l_tw                                        =   l_sb/r;         % length of twigs                                       00.3 m

d_b                                         =   d_t/r;          % base thickness of branch                              00.1 m
d_sb                                        =   d_b/r;          % base thickness of subbranch                           00.03m
d_tw                                        =   d_sb/r;         % base thickness of twig                                00.01m

[p_tipb,    p_tipsb ,   p_tiptw ]           =   deal(03);       % parameter for tipping     (0 is no tipping)
[p_curvb,   p_curvsb,   p_curvtw]           =   deal(00.5);     % parameter for curvature   (0 is no curvature)


% Simulation parameters
[n_nb0,     n_nsb0,     n_ntw0]             =   deal(06);       % number of vertices in layer0
[n_lb,      n_lsb,      n_ltw]              =   deal(10);       % number of layers subbranch

n_vb                                        =   2*n_nb0*n_lb;   % number of vertices
n_vsb                                       =   2*n_nsb0*n_lsb; % number of vertices
n_vtw                                       =   2*n_nsb0*n_lsb; % number of vertices

n_vb0                                       =   n_vb+1;         % number of vertices + zero point
n_vsb0                                      =   n_vsb+1;        % number of vertices + zero point
n_vtw0                                      =   n_vsb+1;        % number of vertices + zero point

%% Leafs
n_l                                         =   16;             % number of leafs per subbranch                                         
o_l                                         =   0;             % offset of bifurcations (1= end of branch)
c_l                                         =   45;
l_l                                         =   0.15;            % length of leaf  (default is 10cm)
n_vl                                        =   22;             % number of vertices
n_vl0                                       =   n_vl;           % number of vertices + zero point (no zeropoint)

VerticesLeaf

%% Allocate memory
Vertices.Trunk                              =   zeros(n_vt0 ,n_d,n_t);
Vertices.Branch                             =   zeros(n_vb0  ,n_d,n_t,n_b);
Vertices.SubBranch                          =   zeros(n_vsb0 ,n_d,n_t,n_b,n_sb);
Vertices.Twig                               =   zeros(n_vsb0 ,n_d,n_t,n_b,n_sb,n_tw);
Vertices.Leaf                               =   zeros(n_vl   ,n_d,n_t,n_b,n_sb,n_tw,n_l);


Polynomial.Trunk                            =   zeros(5     ,3  ,n_t);
Polynomial.Branch                           =   zeros(5     ,3  ,n_t,n_b);
Polynomial.SubBranch                        =   zeros(5     ,3  ,n_t,n_b,n_sb);
Polynomial.Twig                             =   zeros(5     ,3  ,n_t,n_b,n_sb,n_tw);

index.t2b                                   =   zeros(1     ,1  ,n_t,n_b);
index.b2sb                                  =   zeros(1     ,1 ,n_t,n_b,n_sb);
index.sb2tw                                 =   zeros(1     ,1 ,n_t,n_b,n_sb,n_tw);
index.tw2l                                  =   zeros(1     ,1 ,n_t,n_b,n_sb,n_tw,n_l);

%% Creation
fprintf(1,'Creation Virtual Forest\n')

l_c_max                                     =   l_b+l_sb+l_tw;
for j_t=1:n_t
    [Vertices.Trunk(:,:,j_t)                                                                                        ,...
     Faces.Trunk                                                                                                    ,...
     Color.Trunk                                                                                                    ,...
     Polynomial.Trunk(:,:,j_t)]             =   createssubbranch(   Trunk0                                          ,...
                                                                    n_lt                                            ,...
                                                                    l_t                                             ,...
                                                                    d_t                                             ,...
                                                                    p_tipt                                          ,...
                                                                    p_curvt) ;
	if n_t>=10 && j_t<=n_t/2
        Vertices.Trunk(:,1,j_t)             =   Vertices.Trunk(:,1,j_t) +  l_c_max/1*(j_t-3) +rand*0.1;
        Vertices.Trunk(:,2,j_t)             =   Vertices.Trunk(:,2,j_t) - -l_c_max/2         +rand*0.1;
	elseif n_t>=10 && j_t>n_t/2
        Vertices.Trunk(:,1,j_t)             =   Vertices.Trunk(:,1,j_t) +  l_c_max/1*(j_t-8) +rand*0.1;
        Vertices.Trunk(:,2,j_t)             =   Vertices.Trunk(:,2,j_t) + -l_c_max/2         +rand*0.1;
    else
	end        
end


for j_t=1:n_t,                        %trunkindex
    fprintf('.')
    [Vertices.Branch(:,:,j_t,:)                                                                                     ,...
     Faces.Branch                                                                                                   ,...     
     Color.Branch                                                                                                   ,...
     Polynomial.Branch(:,:,j_t,:)                                                                                   ,...
     index.t2b(:,:,j_t,:)]                   =   advancedcreatesidebranches( Vertices.Trunk(:,:,j_t)                 ,...
                                                                            Polynomial.Trunk(:,:,j_t)               ,...
                                                                            n_b                                     ,...
                                                                            l_b                                     ,...
                                                                            d_b                                     ,...
                                                                            o_b                                     ,...
                                                                            c_b                                     ,...
                                                                            n_lb                                    ,...
                                                                            p_tipb                                  ,...
                                                                            p_curvb);
    for j_b=1:n_b,                        %Branchindex
        [Vertices.SubBranch(:,:,j_t,j_b,:)                                                                          ,...
         Faces.SubBranch                                                                                            ,...
         Color.SubBranch                                                                                            ,...
         Polynomial.SubBranch(:,:,j_t,j_b,:)                                                                        ,...
         index.b2sb(:,:,j_t,j_b,:)]          =   advancedcreatesidebranches( Vertices.Branch(:,:,j_t,j_b)            ,...
                                                                            Polynomial.Branch(:,:,j_t,j_b)          ,...
                                                                            n_sb                                    ,...
                                                                            l_sb                                    ,...
                                                                            d_sb                                    ,...
                                                                            o_sb                                    ,...
                                                                            c_sb                                    ,...
                                                                            n_lsb                                   ,...
                                                                            p_tipsb                                 ,...
                                                                            p_curvsb);                                                               
        for j_sb=1:n_sb
            [Vertices.Twig(:,:,j_t,j_b,j_sb,:)                                                                      ,...
             Faces.Twig                                                                                             ,...
             Color.Twig                                                                                             ,...
             Polynomial.Twig(:,:,j_t,j_b,j_sb,:)                                                                    ,...
             index.sb2tw(:,:,j_t,j_b,j_sb,:)]=   advancedcreatesidebranches( Vertices.SubBranch(:,:,j_t,j_b,j_sb)    ,...
                                                                            Polynomial.SubBranch(:,:,j_t,j_b,j_sb)  ,...
                                                                            n_tw                                    ,...
                                                                            l_tw                                    ,...
                                                                            d_tw                                    ,...
                                                                            o_tw                                    ,...
                                                                            c_tw                                    ,...
                                                                            n_ltw                                   ,...
                                                                            p_tiptw                                 ,...
                                                                            p_curvtw);
            for j_tw=1:n_tw
                q_l                         =   linspace(0,360,n_l+1);
                T_l                         =   (q_l(1:end-1)+q_l(2:end))/2;
                T_l                         =   T_l/180*pi;
                
                for j_l=1:n_l
                    [indexx,vector_d]       =    intersection(Vertices.Twig(  :,:,j_t,j_b,j_sb,j_tw)                ,...
                                                              Polynomial.Twig(:,:,j_t,j_b,j_sb,j_tw)                ,...
                                                              o_l, T_l(j_l), c_l);

                    x                       =   Leaf0(:,1,1,1,1);
                    y                       =   Leaf0(:,2,1,1,1);
                    z                       =   Leaf0(:,3,1,1,1);
                    [alpha1]                =   cart2pol(vector_d(:,1),vector_d(:,2));
                    [theta,alpha2]          =   cart2sph(vector_d(:,1),vector_d(:,2),vector_d(:,3));
                    [x,y,z]                 =   rotatecylindrical(x,y,z,'z',-pi/4);
                    [x,y,z]                 =   rotatecylindrical(x,y,z,'x',pi*rand);
                    [x,y,z]                 =   rotatecylindrical(x,y,z,'y',alpha2);
                    [x,y,z]                 =   rotatecylindrical(x,y,z,'z',alpha1);
                    Vertices.Leaf(:,:,j_t,j_b,j_sb,j_tw,j_l) = [x + Vertices.Twig(indexx,1,j_t,j_b,j_sb,j_tw)       ,...
                                                                y + Vertices.Twig(indexx,2,j_t,j_b,j_sb,j_tw)       ,...
                                                                z + Vertices.Twig(indexx,3,j_t,j_b,j_sb,j_tw)];
                    index.tw2l(:,:,j_t,j_b,j_sb,j_tw,j_l)=indexx;                                                
                end
            end
        end
    end    
end
fprintf(1,'.. done\n')

%% Calculate Leaf Area per height
fprintf(1,'Calculate Effective Leaf Area\n')
%We first turn the vertix positions to according to the vector, after which we calculate the along vector and cross vector effective areas
Vector_Obs(1,:)                                                 =   [0  1   0];
Vector_Obs(2,:)                                                 =   [1  0   0];
[Az,El]                                                         =   cart2sph(Vector_Obs(:,1),Vector_Obs(:,2),Vector_Obs(:,3));

A_eff_sum                                                       =   zeros(100,60,5,2);
A_tot_sum                                                       =   zeros(100,60,5,2);
for j=1:2
    Vector_obs                                                  =   Vector_Obs(j,:);
    az                                                          =   Az(j);
    el                                                          =   El(j);

    Vertices_rot.Trunk                                          =   zeros(size(Vertices.Trunk));
    Vertices_rot.Branch                                         =   zeros(size(Vertices.Branch));
    Vertices_rot.SubBranch                                      =   zeros(size(Vertices.SubBranch));
    Vertices_rot.Twig                                           =   zeros(size(Vertices.Twig));
    Vertices_rot.Leaf                                           =   zeros(size(Vertices.Leaf));

    [Vertices_rot.Trunk(:,1,:,:,:,:,:)          ,...
     Vertices_rot.Trunk(:,2,:,:,:,:,:)          ,...
     Vertices_rot.Trunk(:,3,:,:,:,:,:)]                         =   rotatecylindrical(Vertices.Trunk(:,1,:,:,:,:,:)         ,...
                                                                                      Vertices.Trunk(:,2,:,:,:,:,:)         ,...
                                                                                      Vertices.Trunk(:,3,:,:,:,:,:)         ,...
                                                                                      'z',az);
    [Vertices_rot.Branch(:,1,:,:,:,:,:)         ,...
     Vertices_rot.Branch(:,2,:,:,:,:,:)         ,...
     Vertices_rot.Branch(:,3,:,:,:,:,:)]                        =   rotatecylindrical(Vertices.Branch(:,1,:,:,:,:,:)        ,...
                                                                                      Vertices.Branch(:,2,:,:,:,:,:)        ,...
                                                                                      Vertices.Branch(:,3,:,:,:,:,:)        ,...
                                                                                      'z',az);
    [Vertices_rot.SubBranch(:,1,:,:,:,:,:)      ,...
     Vertices_rot.SubBranch(:,2,:,:,:,:,:)      ,...
     Vertices_rot.SubBranch(:,3,:,:,:,:,:)]                     =   rotatecylindrical(Vertices.SubBranch(:,1,:,:,:,:,:),...
                                                                                      Vertices.SubBranch(:,2,:,:,:,:,:)     ,...
                                                                                      Vertices.SubBranch(:,3,:,:,:,:,:)     ,...
                                                                                      'z',az);
    [Vertices_rot.Twig(:,1,:,:,:,:,:)           ,...
     Vertices_rot.Twig(:,2,:,:,:,:,:)           ,...
     Vertices_rot.Twig(:,3,:,:,:,:,:)]                          =   rotatecylindrical(Vertices.Twig(:,1,:,:,:,:,:)          ,...
                                                                                      Vertices.Twig(:,2,:,:,:,:,:)          ,...
                                                                                      Vertices.Twig(:,3,:,:,:,:,:)          ,...
                                                                                      'z',az);

    [Vertices_rot.Leaf(:,1,:,:,:,:,:)           ,...
     Vertices_rot.Leaf(:,2,:,:,:,:,:)           ,...
     Vertices_rot.Leaf(:,3,:,:,:,:,:)]                          =   rotatecylindrical(Vertices.Leaf(:,1,:,:,:,:,:)          ,...
                                                                                      Vertices.Leaf(:,2,:,:,:,:,:)          ,...
                                                                                      Vertices.Leaf(:,3,:,:,:,:,:)          ,...
                                                                                      'z',az);
    fprintf(1,'- Area calculation\n')
    for j_t=1:n_t
        A                                                       =   Calculate_Effective_Area(Vertices_rot.Trunk(:,:,j_t)                    ,Faces.Trunk    ,'Along');
        A(A(:,5)>0,4:5)                                         =   0;
        A(:,5)                                                  =   abs(A(:,5));
        Area_eff.Trunk(:,:,j_t)                                 =   A;
        for j_b=1:n_b
            A                                                   =   Calculate_Effective_Area(Vertices_rot.Branch(:,:,j_t,j_b)               ,Faces.Branch   ,'Along');
            A(A(:,5)>0,4:5)                                     =   0;
            A(:,5)                                              =   abs(A(:,5));
            Area_eff.Branch(:,:,j_t,j_b)                        =   A;
            for j_sb=1:n_sb
                A                                               =   Calculate_Effective_Area(Vertices_rot.SubBranch(:,:,j_t,j_b,j_sb)       ,Faces.SubBranch,'Along');
                A(A(:,5)>0,4:5)                                 =   0;
                A(:,5)                                          =   abs(A(:,5));
                Area_eff.SubBranch(:,:,j_t,j_b,j_sb)            =   A;
                for j_tw=1:n_tw
                    A                                           =   Calculate_Effective_Area(Vertices_rot.Twig(:,:,j_t,j_b,j_sb,j_tw)       ,Faces.Twig     ,'Along');
                    A(A(:,5)>0,4:5)                             =   0;
                    A(:,5)                                      =   abs(A(:,5));
                    Area_eff.Twig(:,:,j_t,j_b,j_sb,j_tw)        =   A;

                    for j_l=1:n_l
                        A                                       =   Calculate_Effective_Area(Vertices_rot.Leaf(:,:,j_t,j_b,j_sb,j_tw,j_l)   ,Faces.Leaf0    ,'Along');

                        A(A(:,5)>0,4:5)                         =   0;
                        A(:,5)                                  =   abs(A(:,5));
                        Area_eff.Leaf(:,:,j_t,j_b,j_sb,j_tw,j_l)=   A;

                    end
                end
            end
        end
    end
    
    % Sum-up the area
    d_max                           =   l_b+l_sb+l_tw+l_l';
    h_max                           =   l_t+l_b+l_sb+l_tw+l_l';
    x                               =   linspace(  -40, 40,     101);
    z                               =   linspace(  0,   h_max,  061);

    x_i                             =   (x(1:end-1)+x(2:end))/2;
    z_i                             =   (z(1:end-1)+z(2:end))/2;    
    
    fprintf(1,'- Gridding\n')
    for ix=1:100
        Ix.Trunk                    =   Area_eff.Trunk(     :,1,:)        <x(ix+1) & Area_eff.Trunk(    :,1,:)        >=x(ix);
        Ix.Branch                   =   Area_eff.Branch(    :,1,:,:)      <x(ix+1) & Area_eff.Branch(   :,1,:,:)      >=x(ix);
        Ix.SubBranch                =   Area_eff.SubBranch( :,1,:,:,:)    <x(ix+1) & Area_eff.SubBranch(:,1,:,:,:)    >=x(ix);
        Ix.Twig                     =   Area_eff.Twig(      :,1,:,:,:,:)  <x(ix+1) & Area_eff.Twig(     :,1,:,:,:,:)  >=x(ix);
        Ix.Leaf                     =   Area_eff.Leaf(      :,1,:,:,:,:,:)<x(ix+1) & Area_eff.Leaf(     :,1,:,:,:,:,:)>=x(ix);        
        if any(Ix.Trunk(:)) || any(Ix.Branch(:)) || any(Ix.SubBranch(:)) || any(Ix.Twig(:)) || any(Ix.Leaf(:))
            for iz=1:60    
                Iz.Trunk                    =   Area_eff.Trunk(     :,3,:)        <z(iz+1) & Area_eff.Trunk(     :,3,:)        >=z(iz);
                Iz.Branch                   =   Area_eff.Branch(    :,3,:,:)      <z(iz+1) & Area_eff.Branch(    :,3,:,:)      >=z(iz);
                Iz.SubBranch                =   Area_eff.SubBranch( :,3,:,:,:)    <z(iz+1) & Area_eff.SubBranch( :,3,:,:,:)    >=z(iz);
                Iz.Twig                     =   Area_eff.Twig(      :,3,:,:,:,:)  <z(iz+1) & Area_eff.Twig(      :,3,:,:,:,:)  >=z(iz);
                Iz.Leaf                     =   Area_eff.Leaf(      :,3,:,:,:,:,:)<z(iz+1) & Area_eff.Leaf(      :,3,:,:,:,:,:)>=z(iz);

                if any(Iz.Trunk(:)) || any(Iz.Branch(:)) || any(Iz.SubBranch(:)) || any(Iz.Twig(:)) || any(Iz.Leaf(:))
                    A_tot_sum(ix,iz,1,j)    =   sum(reshape (Area_eff.Trunk(     :,4,:        ).*( Ix.Trunk      & Iz.Trunk)     ,1,[]));
                    A_tot_sum(ix,iz,2,j)    =   sum(reshape (Area_eff.Branch(    :,4,:,:      ).*( Ix.Branch     & Iz.Branch)    ,1,[]));
                    A_tot_sum(ix,iz,3,j)    =   sum(reshape (Area_eff.SubBranch( :,4,:,:,:    ).*( Ix.SubBranch  & Iz.SubBranch) ,1,[]));         
                    A_tot_sum(ix,iz,4,j)    =   sum(reshape (Area_eff.Twig(      :,4,:,:,:,:  ).*( Ix.Twig       & Iz.Twig)      ,1,[]));           
                    A_tot_sum(ix,iz,5,j)    =   sum(reshape (Area_eff.Leaf(      :,4,:,:,:,:,:).*( Ix.Leaf       & Iz.Leaf)      ,1,[]));

                    A_eff_sum(ix,iz,1,j)    =   sum(reshape (Area_eff.Trunk(     :,5,:        ).*( Ix.Trunk      & Iz.Trunk)     ,1,[]));
                    A_eff_sum(ix,iz,2,j)    =   sum(reshape (Area_eff.Branch(    :,5,:,:      ).*( Ix.Branch     & Iz.Branch)    ,1,[]));
                    A_eff_sum(ix,iz,3,j)    =   sum(reshape (Area_eff.SubBranch( :,5,:,:,:    ).*( Ix.SubBranch  & Iz.SubBranch) ,1,[]));         
                    A_eff_sum(ix,iz,4,j)    =   sum(reshape (Area_eff.Twig(      :,5,:,:,:,:  ).*( Ix.Twig       & Iz.Twig)      ,1,[]));           
                    A_eff_sum(ix,iz,5,j)    =   sum(reshape (Area_eff.Leaf(      :,5,:,:,:,:,:).*( Ix.Leaf       & Iz.Leaf)      ,1,[]));
                end
            end
        end
    end
end
%%
fprintf(1,'\nSaving Data\n')
save(    ['Output/',filestring,'.mat'])

%% Plotting
Plotting