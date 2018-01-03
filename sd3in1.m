
foldername = 'C:\Users\PC#3\Desktop\MKY_IITK\ISRO Project\ISRO_FSP_Project_Data\Tensile Test Data\Cryo test';
mkdir FSP633
Fig_folder = 'FSP633';
fname1 = 'RmSD.fig';
fname2 = 'RmHist.fig';
% saveLocation = fullfile(foldername,'StressDrop.mat');
%%
SDrop_x1 = AllStressDrop.SDrop_x;
SDrop_x2 = AllStressDrop.SDrop_x1;
SDrop_x3 = AllStressDrop.SDrop_x2;
SDrop_y1 = AllStressDrop.SDrop_y;
SDrop_y2 = AllStressDrop.SDrop_y1;
SDrop_y3 = AllStressDrop.SDrop_y2;
StressDrop_significant1 = AllStressDrop.StressDrop_significant;
StressDrop_significant2 = AllStressDrop.StressDrop_significant1;
StressDrop_significant3 = AllStressDrop.StressDrop_significant2;
%% Stress drop calculation


h(1) = figure;
X = [SDrop_x1,SDrop_x2, SDrop_x3];
Y = [SDrop_y1,SDrop_y2, SDrop_y3];
hstem = stem(X,Y,'LineStyle',':');

hstem(1).Color = 'green';
hstem(1).Marker = 'square';
hstem(2).Color = 'm';
hstem(2).Marker = 'o';
hstem(3).Color = 'b';
hstem(3).Marker = 'd';
text(0.005,3.5,'FSP 611','FontName','Arial','FontSize',16,'FontWeight','bold')
legend('Specimen 1','Specimen 2','Specimen 3','Location','west');
% hbase = hstem.BaseLine; 
% hbase.LineStyle = '--';
% hbase.Visible = 'off';
xlabel('Plastic Strain')
ylabel('Stress Drop (MPa)')
% title('Stress Drop vs Plastic Strain') 
box('on');
axis('square');
set(gca,'FontName','Arial','FontSize',16,'FontWeight','bold','GridColor',...
    [0.5 0.5 0.5],'GridLineStyle','--','LineWidth',1,'MinorGridColor',...
    [0.9 0.9 0.9],'TickLabelInterpreter','latex','TickLength',[0.03 0.075],...
    'XGrid','on','XMinorTick','on','YGrid','on','YMinorTick','on');

%%
h(2) = figure;

hold on
hist1= histogram(StressDrop_significant1,10,'FaceColor','none','EdgeColor','g','BinWidth',0.5);
hist2= histogram(StressDrop_significant2,10,'FaceColor','none','EdgeColor','m','BinWidth',0.5);
hist3= histogram(StressDrop_significant3,10,'FaceColor','none','EdgeColor','b','BinWidth',0.5);

legend('Specimen 1','Specimen 2','Specimen 3','Location','east');
xlabel('Stress Drop (MPa)')
ylabel('Frequency')

title('Stress Drop Histogram') 
box('on');
axis('square');
set(gca,'FontName','Arial','FontSize',16,'FontWeight','bold','GridColor',...
    [0.5 0.5 0.5],'GridLineStyle','--','LineWidth',1,'MinorGridColor',...
    [0.9 0.9 0.9],'TickLabelInterpreter','latex','TickLength',[0.03 0.075],...
    'XGrid','on','XMinorTick','on','YGrid','on','YMinorTick','on','ylim', [0, 10]);

%%
savefig(h(1),fullfile(Fig_folder,fname1));
savefig(h(2),fullfile(Fig_folder,fname2));

