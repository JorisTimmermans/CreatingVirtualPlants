function    [x,y,z] = rotatecylindrical(x0,y0,z0,axis,Angle)

        z       =   z0;
        y       =   y0;
        x       =   x0; 

% keyboard
    
switch axis
    case 'x'
        [theta,r]   =   cart2pol(y,z);
        theta       =   theta + Angle;
        [y,z]       =   pol2cart(theta,r);
    case 'y'        
        [theta,r]   =   cart2pol(x,z);
        theta       =   theta + Angle;
        [x,z]       =   pol2cart(theta,r);
    case 'z'
        [theta,r]   =   cart2pol(x,y);
        theta       =   theta + Angle;
        [x,y]       =   pol2cart(theta,r);
end
        