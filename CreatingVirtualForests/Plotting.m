cd('Output')

%% Plot 3D trees
warning off
h11                                     =   figure('Visible','off','Renderer', 'zbuffer');
h12                                     =   axes;
for j_t=1:n_t
    fprintf('.')
    patch('Faces'                               ,Faces.Trunk                    ,...        %creating plot of the tree
          'FaceAlpha'                           ,0.4                            ,...        %with all faces special color         
          'FaceVertexCData'                     ,Color.Trunk                    ,...
          'FaceColor'                           ,'flat'                         ,... 
          'EdgeColor'                           ,Color.Trunk(1,:,:)/1.1         ,...
          'Vertices'                            ,Vertices.Trunk(:,:,j_t))   ;
    hold on
    axis equal

    for j_b=1:n_b
        patch('Faces'                           ,Faces.Branch                   ,...        %creating plot of the tree
              'FaceAlpha'                       ,0.4                            ,...        %with all faces special color                 
              'FaceVertexCData'                 ,Color.Branch                   ,...
              'FaceColor'                       ,'flat'                         ,...       
              'EdgeColor'                       ,Color.Branch(1,:,:)/1.1        ,...
              'Vertices'                        ,Vertices.Branch(:,:,j_t,j_b));
        for j_sb=1:n_sb
            patch('Faces'                       ,Faces.SubBranch                ,...        %creating plot of the tree
                  'FaceAlpha'                   ,0.4                            ,...        %with all faces special color                 
                  'FaceVertexCData'             ,Color.SubBranch                ,...
                  'FaceColor'                   ,'flat'                         ,...
                  'EdgeColor'                   ,Color.SubBranch(1,:,:)/1.1     ,...
                  'Vertices'                    ,Vertices.SubBranch(:,:,j_t,j_b,j_sb));
              for j_tw=1:n_tw
                  patch('Faces'                 ,Faces.Twig                     ,...        %creating plot of the tree
                        'FaceAlpha'             ,0.4                            ,...        %with all faces special color                 
                        'FaceVertexCData'       ,Color.Twig                     ,...
                        'FaceColor'             ,'flat'                         ,...
                        'EdgeColor'             ,Color.Twig(1,:,:)/1.1          ,...
                        'Vertices'            	,Vertices.Twig(:,:,j_t,j_b,j_sb,j_tw));
                  for j_l=1:n_l                      
                      patch('Faces'             ,Faces.Leaf0                    ,...        %creating plot of the tree
                            'FaceAlpha'         ,0.4                            ,...        %with all faces special color                 
                            'FaceVertexCData'   ,Color.Leaf0                    ,...
                            'FaceColor'         ,'flat'                         ,...       
                            'EdgeColor'         ,'none'                          ,...
                            'Vertices'          ,Vertices.Leaf(:,:,j_t,j_b,j_sb,j_tw,j_l));                      
                  end
              end
        end
    end
end
axis equal tight off
light('Position',[0 0 1])
set(h11,'Visible','on')

view(40,80)
Filestring0 =   sprintf(['3D forest, '                      ,'(with view= [%05.2f %05.2f]).png'],[40 80]);
saveas(h11,Filestring0,'png')


view(Az(1),Ez(1))
Filestring1     =   sprintf(['3D forest, '                      ,'(with view= [%05.2f %05.2f]).png'],[Az(1) El(1)]*180/pi);
saveas(h11,Filestring1,'png')

view(Az(2),Ez(2))
Filestring1     =   sprintf(['3D forest, '                      ,'(with view= [%05.2f %05.2f]).png'],[Az(1) El(1)]*180/pi);
saveas(h11,Filestring1,'png')

close(h11)
%% Plot Areas
for j=1:2
    Vector_obs                                                  =   Vector_Obs(j,:);
    az                                                          =   Az(j);
    el                                                          =   El(j);
    %
    Filestring1     =   sprintf(['3D forest, '                      ,'(with view= [%05.2f %05.2f]).png'],[az el]*180/pi);
    
    try        
        h11a        =   figure('Visible','off','Renderer', 'zbuffer');
        h12a        =   copyobj(h12,h11a);        
        h14a(1)     =   title({'Virtual Forest'; sprintf('with view: [%05.2f %05.2f]',[az el]/180/pi)});
        drawnow
        view([-az el]/pi*180)
        light('Position',[0 0 1])        
        set(h11a,'Visible','on')
        saveas(h11a,Filestring1,'png')
    catch warningmsg
    end

    h21             =   figure('Visible','on','Renderer', 'zbuffer');    
    h22             =   axes;
    h23             =   pcolor(x_i,z_i,(A_eff_sum(:,:,5,j))');
    h24(1)          =   title({'Effective Leaf Area'; sprintf('with view: [%05.2f %05.2f]',[az el]/180/pi)});
    h24(2)          =   xlabel('Distance (Cross view)');
    h24(3)          =   ylabel('height');
    h25             =   colorbar;    
	Filestring2     =   sprintf(['Effective Leaf Area, '            ,'(with view= [%05.2f %05.2f]).png'],[az el]*180/pi);
    set(h23,'LineStyle','none');
    saveas(h21,Filestring2,'png')
    
    h31             =   figure('Visible','on','Renderer', 'zbuffer');
    h32             =   axes;
    h33             =   pcolor(x_i,z_i,sum(A_eff_sum(:,:,1:4,j),3)');
    h34(1)          =   title({'Effective Woody Material Area'; sprintf('with view: [%05.2f %05.2f]',[az el]/180/pi)});
    h34(1)          =   xlabel('Distance (Cross view)');
    h34(1)          =   ylabel('height');    
    h35             =   colorbar;
    Filestring3     =   sprintf(['Effective Woody Material Area, '  ,'(with view= [%05.2f %05.2f]).png'],[az el]*180/pi);
    set(h33,'LineStyle','none');
    saveas(h31,Filestring3,'png')
    
    h41             =   figure('Visible','on','Renderer', 'zbuffer');    
    h42             =   axes;
    h43             =   semilogx(permute(mean(A_eff_sum(:,:,:,j)./A_tot_sum(:,:,:,j)),[2 3 1]),z_i);
    h44(1)          =   title({'Contribution of total Area '; sprintf('with view: [%05.2f %05.2f]',[az el]/180/pi)});
    h44(1)          =   xlabel('R_{eff} <A_{e}/A_{t}>');
    h44(1)          =   ylabel('height');
	h45             =   legend('Trunks','Branches','SubBranches','Twigs','Leafs');
	Filestring4     =   sprintf(['Mean Effective Leaf Area, '       ,'(with view= [%05.2f %05.2f]).png'],[az el]*180/pi);
    set(h43,'Linewidth',2)
    saveas(h41,Filestring4,'png')
end
cd('..')
fprintf(1,'\nFinished\n')