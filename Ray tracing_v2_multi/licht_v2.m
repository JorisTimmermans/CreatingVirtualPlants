clc
close all
clear all
% keyboard
global Vertices Faces
global N_t  N_b  N_sb  N_l N_g
global n_t  n_b  n_sb  n_l n_g
global n_vt n_vb n_vsb n_vl n_vg

uiload;
Vertices.Ground(:,3)=zeros(size(Vertices.Ground(:,3)));
t0 = clock;
% Polygonal_Canopy_plot_canopy
drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%direct sunlight
Light.energy0           =   1;
Light.vector0           =   [0 0 -1];
Light.vector0           =   Light.vector0/sqrt(Light.vector0*Light.vector0');
Light.reflection_index  =   [];
Light.number_x          =   100;                  %number of light rays
Light.number_y          =   100;                  %number of light rays
Light.number_z          =   1000;
Light.number_tot        =   sqrt(Light.number_x^2+Light.number_y^2+Light.number_z^2);
Light.width             =   1;                    %light width for preliminary, best result for larger values, but 
                                                 %slower, since more nodes will be scanned (value~1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%BOX voor raytracing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5                                                      
maxz    =   l_t + l_b + l_sb + l_l;
Vertices.Box     =  [-maxr -maxr -1;
                      maxr -maxr -1;
                      maxr  maxr -1;
                     -maxr  maxr -1;
                     -maxr -maxr maxz;
                      maxr -maxr maxz;
                      maxr  maxr maxz;
                     -maxr  maxr maxz];

n_j                     =   [Light.number_x,Light.number_z,Light.number_z,Light.number_z,Light.number_z ];
L_j                     =   [2*maxr        ,maxz          ,maxz          ,maxz          ,maxz           ];
shift_j                 =   [1 0 0         ;0 0 1         ;0 0 1         ;0 0 1         ;0 0 1          ];
n_jj                    =   [Light.number_y,Light.number_x,Light.number_x,Light.number_y,Light.number_y ];
L_jj                    =   [2*maxr        ,2*maxr        ,2*maxr        ,2*maxr        ,2*maxr         ];
shift_jj                =   [0 1 0         ;1 0 0         ;-1 0 0        ;0 1 0         ;0 -1 0         ];
Vertices.Box_j          =   [Vertices.Box(7,:);Vertices.Box(7,:);...
                             Vertices.Box(5,:);Vertices.Box(7,:);...
                             Vertices.Box(5,:)];
                         
Faces.Box =   [1 2 3 4; 1 2 6 5;1 4 8 5; ...
               2 3 7 6; 3 4 8 7; 5 6 7 8];
h         =   figure(1);
patch('Faces'             ,Faces.Box                 ,...
      'FaceAlpha'         ,0.1                     ,...    %with all faces special color
      'Vertices'          ,Vertices.Box);                         

%%%%%%%%%%%%%%%Numbers to be declared
N_g =   (n_vg)     *n_g;                %total number of ground nodes
N_t =   (n_vt  +1) *n_t;                %total number of trunk nodes
N_b =   (n_vb  +1) *n_t*n_b;            %total number of branch nodes
N_sb=   (n_vsb +1) *n_t*n_b*n_sb;       %total number of subbranch nodes
N_l =   (n_vl  )   *n_t*n_b*n_sb*n_l;   %total number of leaf nodes

%%%%%%%%%%%%%%%alternative reshape... to track the individual pieces better%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Trunk_re        =   [];
Branch_re       =   [];
SubBranch_re    =   [];
Leaf_re         =   [];
Ground_re       =   Vertices.Ground;
for j=1:n_t
    Trunk_re    =   [Trunk_re;Vertices.Trunk(:,:,j)];
    for jj=1:n_b
        Branch_re    =   [Branch_re;Vertices.Branch(:,:,j,jj)];
        for jjj=1:n_sb
                SubBranch_re    =   [SubBranch_re;Vertices.SubBranch(:,:,j,jj,jjj)];
            for jjjj=1:n_l
                Leaf_re    =   [Leaf_re;Vertices.Leaf(:,:,j,jj,jjj,jjjj)];
            end
        end
    end
end
Vertices.All            =   [Trunk_re   ;   Branch_re   ;   SubBranch_re    ;   Leaf_re;    Ground_re];
clear Trunk_re Branch_re SubBranch_re Leaf_re Ground_re
Energy                  =   sparse(zeros(size(Vertices.All,1),1));

%%%%%%%%%%%%%%%raytracing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set (h,'Visible','off')
drawnow
drawpoint   =   1;
for k=1:5
    for j=1:n_j(k)        Light.start_position      =   Vertices.Box_j(k,:) + shift_j(k,:)*-(j)/(n_j(k)+1)*L_j(k);        
        for jj=1:n_jj(k)
            pack
            
            fprintf(1,'.')
            drawpoint       =       drawpoint+1;
            if drawpoint    ==100                                                   %print percentage of calculation
                fprintf(1,[' ',num2str(round(100*(n_j(k)*(k-1) + j)/sum(n_j))),' %% \n'])   
                drawpoint   =   1;
            end
            
            Light.energy            =   Light.energy0;                              %for direct sunlight, Lenergy=c
            Light.vector            =   Light.vector0;                              %for direct sunlight, Lvector=c
            Light.start_position2   =   Light.start_position + shift_jj(k,:)*-(jj)/(n_jj(k)+1)*L_jj(k);
            Nextlightbeam           =   0;                                          %To begin with, no nextbeamlight
            reflections             =   0;                                          %To begin with, no reflection
                        
            while Nextlightbeam ~=1 & Light.energy>1e-3;
                [INdex,L1]          =   Preliminary_intersection(Light.start_position2  ,...
                                                                 Light.vector           ,...
                                                                 Light.width);                
                INdex               =   setdiff(INdex,Light.reflection_index');     %starting point has ofcourse the 
                                                                                    %shortest length, but not particate
                reflection              =   0;
                if length(INdex)==0                                                 %light is not close to objects
                    Nextlightbeam       =   1;
                else                                                               %light is close to node N_V
                    [L1min,INDex]       =   sort(L1(INdex));                        %sort nodes on length
                    INdex               =   INdex(INDex);
                    L1                  =   Inf;                                    %Without intersection, light
                                                                                    %travels forever
                    q                   =   0;
                    while reflection~=1 & q<length(INdex)                           %for each node determine if light
                        q               =   q+1;
                        INDEX           =   INdex(q);                               %neighbours
                        [N_V_n, Vertics, Face, N_index]=retrace_index(INDEX);
                        for qq=1:length(N_V_n)                                      %search triangles with neighbours
                            Triangle    =   Vertics(Face(qq,:),:);                  %for intersections
                            [l_r_p,u,v] =   triangle_line_intersection (Triangle               ,...
                                                                        Light.start_position2  ,...
                                                                        Light.vector);
                            L2           =   sum(Light.start_position2-l_r_p)^2;
                            if u>0 & u<1 & v>0 & v<1 &(u+v)<1 & L2<L1
                                reflection                  =   1;                  %Yes a reflection!
                                L1                          =   L2;                 %Redefine L
                                Light.reflection_position   =   l_r_p;              %store the reflection position
                                Light.reflection_vector     =   calculate_reflection(Triangle,Light.vector);
                                Light.reflection_index      =   N_index(qq,:);      %store the index for the neighbours
                            end
                        end
                    end
                    if reflection==0                                                %light passed by an object, but
                        Nextlightbeam   =   1;                                      %did not hit, next lightbeam...
                    else
%                         plotlightreflection                                         %now track reflected lightbeam
                        Energy(Light.reflection_index)  =   Light.energy*alpha_t/3; %the use alpha_tsi wrong, improve!!!!!!!!
                        Light.energy            =   Light.energy*(1-alpha_t);
                        Light.vector            =   Light.reflection_vector;        %with the reflection_vector as 
                        Light.start_position2   =   Light.reflection_position;      %new light vector and reflection
                                                                                    %_position as start_position2
                    end                
                end
            end            
        end        
    end    
end
save nieuw.mat
% set (gcf,'Visible','on')
fprintf(1,['\n the simulation took :', num2str(etime(clock,t0)),' seconds \n'])     %print total time measured
384.413                                                                             %reference time for desktop


Energy_state=unique(Energy)
hold on
for j=1:size(Energy_state)
    state_i =   Energy>=Energy_state(j);
    plot3(Vertices.All(state_i,1),...
          Vertices.All(state_i,2),...
          Vertices.All(state_i,3),...
          '.',...
          'MarkerFaceColor',1-[1 1 1]/j,...
          'MarkerEdgeColor',1-[1 1 1]/j)
end
