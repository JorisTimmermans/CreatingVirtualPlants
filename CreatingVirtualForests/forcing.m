close all
clc

dt          =   0.00002
g           =   9.81;
% m           =   0.1
D           =   0;
% k_r         =   10;

% Mass.Trunk      =   ones(n_vt,1)*1e+2;
% Mass.Branch     =   ones(n_vb,1)*1e+1;
% Mass.SubBranch  =   ones(n_vsb,1)*1e+0;
% Mass.Leaf       =   ones(n_vl,1)*1e-1;
% 
% names           =   [{'Ground'},{'Trunk'},{'Branch'},{'SubBranch'},{'Leaf'}];


% x0      =   Vertices.(cell2mat(names(2)))(:,:,1)
% x       =   x0;
v              =   0;
% l0      =   Faces_Length.(cell2mat(names(2)))(:,:,1);
% d0      =   Faces_Direct.(cell2mat(names(2)))(:,:,1);

x0          =   [0 0 0; 0 0.0001 -0.9999999]*20;
[l0,d0]     =   Determine_length((x0),[1 2]);
x           =   zeros(size(x0,1),size(x0,2),2);
x(:,:,1)    =   x0;
m           =   [100];  
Fg          =   -[m*0 m*0 m*g];                 


%%%%%%%%%%%%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!! take rotational forces + momenta
for jj=2:200
    for j=2:2
        [l,d]       =   Determine_length((x(:,:,jj-1)),[1 2]);  %Determine direction
        
        Fg_p        =   Fg*d'*d;                                %F parallel to vertices
        Fg_n        =   Fg-Fg_p;                                %F normal   to vertices 
        
        Ft          =   Fg_n;                                   %F total    on node
        a           =   Ft./[m m m];                            %acceleration of node
        v           =   v + a*dt;                               %speed of node
        x(2,:,jj)   =   x(2,:,jj-1) + v*dt;                     %position of node
        x(1,:,jj)   =   x0(1,:);                                %nodes vertices are connected

        [l,d]       =   Determine_length((x(:,:,jj)),[1 2]);    %determine length of vertices
        x(2,:,jj)   =   l0*ones(1,3).*d;                        %Lengths of vertices are fixed!        
    end
    figure(1)
    patch('Faces',[1 2]       , 'Vertices',x(:,:,jj));
    axis([-30 30 -30 30 -30 30]);
    drawnow
    close(1)
%     keyboard
end
