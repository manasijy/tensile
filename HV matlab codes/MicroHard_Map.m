[X,Y] = meshgrid(-12:1:12,0.5:.5:2);
% [X,Y] = pol2cart(th,r);
% % h = polar([0 pi/2], [0 4]);
% % delete(h)
hold on
% surf(X,Y,Hardness)
% view([0,90])
LineSpec = ':r';
contourf(X,Y,HV611,10,LineSpec);

colormap autumn;
h1 =colorbar('location','eastoutside');%,'Title', 'Microhardness in HV')
axis equal
xlabel('Distance from center','FontSize',14);
xlim([-12 12]);
caxis([70 160]); 
title(h1,'HV')
caxis manual;
hold off
