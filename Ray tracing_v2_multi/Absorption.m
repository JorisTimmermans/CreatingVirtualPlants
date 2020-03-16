                   
%                      %%%%%%%%%%%%%%%%%%%Light Absorbtion%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                    Energy(INDEx)          =   Energy(INDEx) + alpha(N_V,1,N_T,N_B,N_SB,N_L)*light_energy/3; 
%                      Energy(INDEx)          =   Energy(INDEx) + alpha_t*light_energy/3; %Wrong correct with above
% %                    light_energy           =   light_energy *(1-alpha(N_V,1,N_T,N_B,N_SB,N_L);%%%%%%%%%%!!!!!!!!!!!
%                      light_energy           =   light_energy *(1-alpha_t);              %Wrong correct with above
%                     %%%%%%%%%%%%%%%%%%%Light Reflection%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      light_start_position2  =   light_reflection_position;
%                      light_vector           =   light_reflection_vector;
%                      if reflection          >   0;
%                          plot3([light_path2(:,1)],...
%                           [light_path2(:,2)],...
%                           [light_path2(:,3)],'redo-')
%                            drawnow
%                            figure(1)
%                      end
%                      reflection             =   reflection + 1;
%                      Hitscheme(j,jj,k)      =   1; %we can use this hitscheme to improve calculation time, on larger
%                                                     %canopies and smaller steps of the light!