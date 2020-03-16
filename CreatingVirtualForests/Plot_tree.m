for j=1:n_t
    for jj=1:n_b
        for jjj=1:n_sb
            for jjjj=1:n_l                
                patch(  'Faces'             ,Faces.Leaf0     ,...
                        'EdgeColor'         ,'none'         ,...
                        'Vertices'          ,Vertices.Leaf_a(:,:,j,jj,jjj,jjjj),...
                        'FaceVertexCData'   ,Color.Leaf0     ,...
                        'FaceAlpha'         ,0.2            ,...
                        'FaceLighting'      ,'phong'        ,... 
                        'FaceColor'         ,'flat'); 
            end
                        
            patch('Faces',Faces.SubBranch  , 'Vertices',Vertices.SubBranch(:,:,j,jj,jjj))
        end
        patch('Faces',Faces.Branch  , 'Vertices',Vertices.Branch(:,:,j,jj))
    end
    patch('Faces',Faces.Trunk       , 'Vertices',Vertices.Trunk(:,:,j));
end


light
warning off
axis([-30*n_t 30*n_t -30 30 50 110])
warning on
rotate3d
axis off
set(gcf,'Color',[1 1 1],'DockControls','off','MenuBar','none');
view(45,45)