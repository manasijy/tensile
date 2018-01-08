[th,r] = meshgrid((0:22.5:90)*pi/180,0:.4:4);
[X,Y] = pol2cart(th,r);
% h = polar([0 pi/2], [0 4]);
% delete(h)
hold on
% surf(X,Y,Hardness)
% view([0,90])
LineSpec = ':w';
contourf(X,Y,Hardness,10,LineSpec);

colormap autumn;
h1 =colorbar('location','eastoutside');%,'Title', 'Microhardness in HV')
axis equal
xlabel('Distance from center','FontSize',14);
xlim([0 4]);
caxis([170 280]); 
title(h1,'HV')
caxis manual;
hold off
