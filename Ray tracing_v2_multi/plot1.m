load nieuw.mat
Energy_States=Unique(Energy);
hold on
for j=1:size(Energy_States)
    E_i         =find(Energy>=Energy_States(j));
    plot3(Vertices.All(E_i,1),Vertices.All(E_i,2),Vertices.All(E_i,3),'x','Color',[1 1 1]/j)
end
    