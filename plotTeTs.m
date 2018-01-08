function plotTeTs(X1, Y1, X2, Y2, X3, Y3, X0, Y0,fname)
% function plotTeTs(X1, Y1, X2, Y2, X3, Y3,fname)
%plotTeTs(Te1611, Ts1611, Te1612, Ts1612, Te1613, Ts1613)

foldername = 'C:\Users\PC#3\Desktop\MKY_IITK\ISRO Project\ISRO_FSP_Project_Data\Tensile Test Data\TeTs_Temp';
filename = fullfile(foldername,[fname,'.fig']);
figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(X0,Y0,'DisplayName','20K','LineWidth',2,'LineStyle',':',...
    'Color',[0 0 0]);
plot(X1,Y1,'DisplayName','77K','LineWidth',2,'LineStyle','-',...
    'Color',[1 0 0]);
plot(X2,Y2,'DisplayName','173K','LineWidth',2,'LineStyle','--',...
    'Color',[1 0 1]);
plot(X3,Y3,'DisplayName','298K','LineWidth',2,'LineStyle','-.',...
    'Color',[0 0 1]);

xlabel('True Plastic Strain','FontWeight','normal');
ylabel('True Stress (MPa)','FontWeight','bold');
ylim(axes1,[200 800]);
box(axes1,'on');
axis(axes1,'square');
set(axes1,'FontSize',14,'FontWeight','normal','GridColor',[0.5 0.5 0.5],...
    'GridLineStyle','--','LineWidth',1,'MinorGridColor',[0.9 0.9 0.9],'XGrid','on',...
    'XMinorTick','on','XTick',[0 0.02 0.04 0.06 0.08 0.10 0.12 0.14],'YMinorTick','on','YTick',...
    [200 300 400 500 600 700 800]);
legend1 = legend(axes1,'show');
set(legend1,'TextColor',[0 0 1],'Location','southeast','FontSize',12);
savefig(filename)