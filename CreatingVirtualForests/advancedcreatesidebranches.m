function [Branch_rt, Faces1,Color, Polynomial1,i]= advancedcreatesidebranches(Trunk,Polynomial_Trunk,n_b,l,d,o,c,n_v,p_tip,p_curv)     

Branch_rt                               =   zeros(n_v*2*6+1,3,n_b);
% Polynomial1                             =   zeros(5,2,n_b);
i                                       =   zeros(1,1,n_b);
                                         
%% Orientation of the Branch vertices (hexagonal)
Branch0                                 =   [cos(-180/180*pi) sin(-180/180*pi) 0
                                             cos(-120/180*pi) sin(-120/180*pi) 0
                                             cos(-060/180*pi) sin(-060/180*pi) 0
                                             cos(+000/180*pi) sin(+000/180*pi) 0
                                             cos(+060/180*pi) sin(+060/180*pi) 0
                                             cos(+120/180*pi) sin(+120/180*pi) 0];


%% Branch Parameters Tipping, Curvature
Tip                                     =   p_tip* (01 + 10*rand(n_b,1));
Curv                                    =   p_curv*(00 + 01*rand(n_b,1));

Quadrants_branch                        =   linspace(0,360,n_b+1);
Theta_branch                            =   (Quadrants_branch(1:end-1)+Quadrants_branch(2:end))/2;
Theta_branch                            =   Theta_branch/180*pi;
%%
for jj=1:n_b
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create Subbranch%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    [Branch ,...
     Faces1 ,...
     Color  ,...
     Polynomial1(:,:,jj)]               =   createssubbranch(Branch0,n_v,l,d,Tip(jj),Curv(jj));
     N_branch                           =   1:length(Branch);               
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create Subbranch%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%     t                                   =   Theta_branch(jj);
% 	[i(:,:,jj),vector_d]                =   intersection(Trunk,Polynomial_Trunk,o,t,c);
    t                                   =   Theta_branch(jj);
    if jj==1    
        [i(:,:,jj),vector_d]            =   intersection(Trunk,Polynomial_Trunk,o,t,0);        
    else
        [i(:,:,jj),vector_d]            =   intersection(Trunk,Polynomial_Trunk,o,t,c);    
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Oriente to vector%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    [theta_branch,phi_branch]           =   cart2sph(vector_d(:,1),vector_d(:,2),vector_d(:,3));
    chi_branch                          =   pi/2-phi_branch;
    
    X_branch                            =   Branch(:,1);
    Y_branch                            =   Branch(:,2);
    Z_branch                            =   Branch(:,3);

    [X_branch,Y_branch,Z_branch]        =   rotatecylindrical(X_branch,Y_branch,Z_branch,'z',-theta_branch);
    [X_branch,Y_branch,Z_branch]        =   rotatecylindrical(X_branch,Y_branch,Z_branch,'y',-chi_branch);
    [X_branch,Y_branch,Z_branch]        =   rotatecylindrical(X_branch,Y_branch,Z_branch,'z',theta_branch);

    Branch_r                            =   [X_branch Y_branch Z_branch];                           % Branch rotated


    %%%%%%%%Rotate polynomial%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    X_branch_p                          =   polyval(Polynomial1(:,1,jj),N_branch);                         % convert to curvature
    Y_branch_p                          =   polyval(Polynomial1(:,2,jj),N_branch);                         % convert to curvature
    Z_branch_p                          =   polyval(Polynomial1(:,3,jj),N_branch);                         % convert to curvature

    [X_branch_p,Y_branch_p,Z_branch_p]  =   rotatecylindrical(X_branch_p,Y_branch_p,Z_branch_p,'z',-theta_branch);  % rotate curvature
    [X_branch_p,Y_branch_p,Z_branch_p]  =   rotatecylindrical(X_branch_p,Y_branch_p,Z_branch_p,'y',-chi_branch);    % rotate curvature
    [X_branch_p,Y_branch_p,Z_branch_p]  =   rotatecylindrical(X_branch_p,Y_branch_p,Z_branch_p,'z',theta_branch);   % rotate curvature

    Polynomial1(:,1,jj)                 =   polyfit(N_branch,X_branch_p,4);                                   % convert back to polynomial
    Polynomial1(:,2,jj)                 =   polyfit(N_branch,Y_branch_p,4);                                   % convert back to polynomial
    Polynomial1(:,3,jj)                 =   polyfit(N_branch,Z_branch_p,4);                                   % convert back to polynomial

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Put Branch to height of the node%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Branch_rt(:,:,jj)                   =   Branch_r + ones(size(Branch_r,1),1)*Trunk(i(:,:,jj),:);  %Branch rotated + translated

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Put Branch to neighbours of the node to branch%%%%%%%%%%%%%%%%%%%%%%%%
    % The trunk is now only connected with "j", a better solution should be created (for instance the use of
    % the variable "index"
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Draw the Trunk + branches (looking good)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
end