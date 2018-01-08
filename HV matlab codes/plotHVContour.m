%% This function plots the HV contour of the data file HVmatfile. 
% One has to check the size of the data matrix i.e. row and columns because
% the X-Y meshgrid size need to be matched 

function  plotHVContour(HV)

% % for 421, 621, 821
[X,Y] = meshgrid(-21:1.5:21,0.5:.5:2); 
% [X,Y] = meshgrid(-21:1:21,0.5:.5:2);
name = '821';
h = figure;
contourf(X,Y,HV,10,':r');% LineSpec = ':r';
hold on
text(-20,1.8,name,'Color','black','FontSize',14);
text(-20,0.7,'Ret','Color','black','FontSize',14);
text(17,0.7,'Adv','Color','black','FontSize',14)
colormap autumn;
colorbar('location','eastoutside');
pbaspect([1 0.25 1])
xlabel('Distance from center','FontSize',14);
% xlim([-15 15]);
xlim([-21 21]);
caxis([60 180]); 
caxis manual;
hold off
savefig(h,[name,'.fig'])
print(h, '-dtiff', ['myfigure',name,'.tiff']);
end



% h = open('611.fig');print(gcf, '-dtiff', 'myfigure611.tiff');
% print(open('612.fig'), '-dtiff', 'myfigure612.tiff');
