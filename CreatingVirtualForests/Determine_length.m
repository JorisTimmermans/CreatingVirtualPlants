function    [L,Direction] =   Determine_length(Vertices,Faces)

% keyboard

L           =       zeros((size(Faces,2)-1),size(Faces,1));
Direction   =       zeros(size(Faces,1),3);
for i=1:size(Faces,1)
    for ii=1:(size(Faces,2)-1)
        K       =   Faces(i,ii);
        L       =   Faces(i,ii+1);
        Diff    =   Vertices(L,:,:)-Vertices(K,:,:);
        
        L(ii,i)     =   sqrt(Diff*Diff');
               
        Direction(ii,:)   =   Diff/L(ii,i);
%         sum(c.^2,2)
%         
%         warning off
%         theta       =   atan(Diff(:,2)./Diff(:,1));
%         phi         =   atan(sqrt(Diff(:,1).^2 + Diff(:,2).^2)./Diff(:,3));
%         warning on
%         Direction(ii,:)   =   [sin(phi).*cos(theta) sin(phi)*sin(theta) cos(phi)];
    end
end

% keyboard
if any(any(isnan(Direction)))
    index               =   find(isnan(Direction));
    Direction(index)    =   0;
end
% keyboard
