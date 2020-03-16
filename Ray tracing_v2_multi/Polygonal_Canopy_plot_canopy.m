for j=1:n_t
    patch('Faces'             ,Faces.Trunk(:,:,j)       ,...                %creating plot of the tree
          'FaceAlpha'         ,0                        ,...                %with all faces special color         
          'FaceVertexCData'   ,Color.Trunk(:,:,j)       ,...
          'FaceColor'         ,'flat'                   ,... 
          'Vertices'          ,Vertices.Trunk(:,:,j))   ;
    hold on
    axis equal
    view(-120,45)
    drawnow
    patch('Faces'             ,Faces.Ground(:,:,1)      ,...                %creating plot of the tree
          'FaceAlpha'         ,0                      ,...                %with all faces special color         
          'FaceVertexCData'   ,Color.Ground(:,:,j)      ,...
          'FaceColor'         ,'flat'                   ,... 
          'Vertices'          ,Vertices.Ground(:,:,j))   ;
    
    for jj=1:n_b
        patch('Faces'             ,Faces.Branch                 ,...        %creating plot of the tree
              'FaceAlpha'         ,0                           ,...        %with all faces special color                 
              'FaceVertexCData'   ,Color.Branch                 ,...
              'FaceColor'         ,'flat'                       ,...       
              'Vertices'          ,Vertices.Branch(:,:,j,jj));
        for jjj=1:n_sb
            patch('Faces'             ,Faces.SubBranch              ,...    %creating plot of the tree
                  'FaceAlpha'         ,0                           ,...    %with all faces special color                 
                  'FaceVertexCData'   ,Color.SubBranch              ,...
                  'FaceColor'         ,'flat'                       ,...       
                  'Vertices'          ,Vertices.SubBranch(:,:,j,jj,jjj));
              for jjjj=1:n_l
                  patch('Faces'             ,Faces.Leaf0                  ,...    %creating plot of the tree
                        'FaceAlpha'         ,0                           ,...    %with all faces special color                 
                        'FaceVertexCData'   ,Color.Leaf0                  ,...
                        'FaceColor'         ,'flat'                       ,...       
                        'Vertices'          ,Vertices.Leaf(:,:,j,jj,jjj,jjjj));
              end
        end
    end
end       
axis off
axis tight