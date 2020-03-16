clear all
clc

% global n_t
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_d     =   3;              %number of dimensions
n_t     =   2;              %number of trunks
n_b     =   2;              %number of branches
n_sb    =   2;              %number of subbranches per subbranch
n_l     =   2;              %number of leafs per subbranch

% Vertices(n_v,n_d,n_t,n_b,n_sb,n_l)

l_b     =   10;             %length of branches
l_sb    =   5;              %length of subbranches

o_t     =   0;              %offset were to place trunks
o_sb    =   0.5;            %offset were to place branches
o_b     =   0.5;            %offset were to place subbranches

%%%%%%%%%%%%%%%%%Creating the tree trunck, branches and subbranches%%%%%%%%%%%%%
Vertices.Trunk          =   zeros(2,n_d,n_t);
VerticesTrunk
for j=2:n_t;
    Vertices.Trunk(:,:,j)   =   Vertices.Trunk(:,:,1) + [-30*(j-1) 0 0; -30*(j-1) 0 0];
end

Vertices.Ground         =   Vertices.Trunk(1,:,:);
Vertices.Branch         =   zeros(2,n_d,n_t,n_b);
Vertices.SubBranch      =   zeros(2,n_d,n_t,n_b,n_sb);
VerticesLeaf0

Faces.Leaf_a         =   Faces.Leaf0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:n_t
    [Vertices.Branch(:,:,j,:),Faces.Branch,...
     Vertices.Trunk2(:,:,j)  ,Faces.Trunk2]  = createSidebranches(Vertices.Trunk(:,:,j),n_b,l_b,o_b);
%     keyboard
    for jj=1:n_b
        [Vertices.SubBranch(:,:,j,jj,:),Faces.SubBranch,...
         Vertices.Branch2(:,:,j,jj)    ,Faces.Branch2]  = createSidebranches(Vertices.Branch(:,:,j,jj)   ,...
                                                                               n_sb                      ,...
                                                                               l_sb                      ,...
                                                                               o_sb);    
    end
end

n_vt                    =   size(Vertices.Trunk,1);         %Number of vertices of Trunk
n_vb                    =   size(Vertices.Branch,1);        %Number of vertices of Branch
n_vsb                   =   size(Vertices.SubBranch,1);     %Number of vertices of SubBranch
n_vl                    =   size(Vertices.Leaf0,1);          %Number of vertices of Leaf
% %%%%%%%%%%%%%%%%%%%Creating all the leaf inclinations possible%%%%%%%%%%%%%%%%%%%%                         
 x0  =    Vertices.Leaf0(:,1);
 y0  =    Vertices.Leaf0(:,2);
 z0  =    Vertices.Leaf0(:,3);

Rotateaxis =   ['x';'y';'z'];
for jj=1:n_d
     x  =   [];
     y  =   [];
     z  =   [];
     for j=0:20    
         Turn(j+1,jj)   =   j*0.1*pi;
         [x1,y1,z1]     =   rotatecylindrical(x0,y0,z0,Rotateaxis(jj),Turn(j+1,jj));
         x              =   [x;x1];
         y              =   [y;y1];
         z              =   [z;z1];
     end
     %xyz now has dimensions (21*21*6,1)
    x0      =   x;
    y0      =   y;
    z0      =   z;
end
 %xyz now has dimensions (21*21*6,1) 
 X   =   reshape(x,n_vl,21,21,21);
 Y   =   reshape(y,n_vl,21,21,21);
 Z   =   reshape(z,n_vl,21,21,21);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%putting the leafs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
% Vertices.Leaf_a     =   zeros(size(
k=2;l=2;
for j=1:n_t    
    for jj=1:n_b        
        for jjj=1:n_sb            
            [temp1,temp2,Vertices.SubBranch2(:,:,j,jj,jjj),Faces.SubBranch2]= createSidebranches(Vertices.SubBranch(:,:,j,jj,jjj),n_l,1,0);                        
            for jjjj=1:n_l
                m=randperm(10);
                Vertices.Leaf_a(:,:,j,jj,jjj,jjjj) = [X(:,k,l,m(1)) + temp1(1,1,jjjj)     ,...
                                                      Y(:,k,l,m(1)) + temp1(1,2,jjjj)     ,...
                                                      Z(:,k,l,m(1)) + temp1(1,3,jjjj)];
            end
        end
    end
end
Faces.Trunk         =   Faces.Trunk2;
Faces.Branch        =   Faces.Branch2;
Faces.SubBranch     =   Faces.SubBranch2;
Vertices.Trunk      =   Vertices.Trunk2;
Vertices.Branch     =   Vertices.Branch2;
Vertices.SubBranch  =   Vertices.SubBranch2;
Leaf_orientations   =   (permute(cat(5,X,Y,Z),[1 5 2 3 4]));

n_vt                    =   size(Vertices.Trunk,1);         %Number of vertices of Trunk
n_vb                    =   size(Vertices.Branch,1);        %Number of vertices of Branch
n_vsb                   =   size(Vertices.SubBranch,1);     %Number of vertices of SubBranch
n_vl                    =   size(Vertices.Leaf0,1);          %Number of vertices of Leaf

clear Faces.SubBranch2 Faces.Branch2 Faces.Trunk2 vertices2 faces2

Plot_tree

for j=1:n_t
    for jj=1:n_b
        for jjj=1:n_sb
            for jjjj=1:n_l
                [Faces_Length.Leaf_a(:,:,j,jj,jjj,jjjj)  ,...
                 Faces_Direct.Leaf_a(:,:,j,jj,jjj,jjjj)] =   Determine_length(Vertices.Leaf_a(:,:,j,jj,jjj,jjjj),Faces.Leaf_a);
            end
            [Faces_Length.SubBranch(:,:,j,jj,jjj)  ,...
             Faces_Direct.SubBranch(:,:,j,jj,jjj)] =   Determine_length(Vertices.SubBranch(:,:,j,jj,jjj),Faces.SubBranch);
        end
        [Faces_Length.Branch(:,:,j,jj)  ,...
         Faces_Direct.Branch(:,:,j,jj)] =   Determine_length(Vertices.Branch(:,:,j,jj),Faces.Branch);
    end
    [Faces_Length.Trunk(:,:,j)  ,...
     Faces_Direct.Trunk(:,:,j)] =   Determine_length(Vertices.Trunk(:,:,j),Faces.Trunk);    
end

clear z1 z0 z y y0 y1 x1 x0 x m k l m j jj jjj jjjj ans a Turn Rotateaxis A X Y Z temp2 temp1

% % % Length_0    =   sqrt(diff(Vertices.Trunk)*diff(Vertices.Trunk)');