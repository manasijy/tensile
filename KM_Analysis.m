
%% PLotting KM plot and analysis
figure( 'Name', 'd\sigma/d\epsilon vs  \sigma-\sigma_{y}' );
h1 = plot(KMX-KMX(1),KMY);
xlabel( '\sigma-\sigma_{y} (MPa)' );
ylabel( 'd\sigma/d\epsilon' );
grid on
grid minor
pause

% Here the select the range where you want to fit the linear voce curve and
% save that data as 'ans2' variable in work space
plot((KMX-KMX(1)),KMY,'-.k','LineWidth',2);
hold on
[linfitKM, gofKM] = fit(ans2(:,1),ans2(:,2),'poly1');
xspace = linspace(0,200,50);
fit_y = linfitKM(xspace);
plot(xspace,fit_y,'g','LineWidth',2);
hold off
ylim([0 10000]);
xlim([0 280]);
box('on');
axis('square');
set(gca,'FontName','Arial','FontSize',16,'FontWeight','bold','GridColor',...
    [0.5 0.5 0.5],'GridLineStyle','--','LineWidth',1,'MinorGridColor',...
    [0.9 0.9 0.9],'TickLabelInterpreter','latex','TickLength',[0.03 0.075],...
    'XGrid','on','XMinorTick','on','YGrid','on','YMinorTick','on','XTick',...
    [0 40 80 120 160 200 240 280]);
xlabel( '\sigma-\sigma_{y} (MPa)' );
ylabel( 'd\sigma/d\epsilon (MPa)' );
legend(gca, 'd\sigma/d\epsilon vs \sigma-\sigma_{y}', 'linear fit' ,...
    'Location', 'NorthEast');%,'FontSize',14 );
%% parameter calculations

p = [linfitKM.p1,linfitKM.p2];
saturation_stress = roots(p); % sigma_s
initial_strain_Hardening = p(2); %theta_0
recovery_param = initial_strain_Hardening/saturation_stress;
alpha = 0.3;
G = 27e3;% MPa
b = 284e-12;% meter
M = 3.01;%
k1 = 2*initial_strain_Hardening/(alpha*G*b*M^2);
k2 = 2*initial_strain_Hardening/saturation_stress;
txt1 = ['\sigma_{s} = ', num2str(saturation_stress,'%6.2e')];
txt2 = ['\theta_{o} = ', num2str(initial_strain_Hardening,'%6.2e')];
txt3 = ['k1 = ', num2str(k1,'%6.2e')];
txt4 = ['k2 = ', num2str(k2,'%6.2e')];
text(gca,160,7000,txt1,'FontSize',14);
text(gca,160,6000,txt2,'FontSize',14);
text(gca,10,1800,txt3,'FontSize',14);
text(gca,10,1200,txt4,'FontSize',14);
% savefig('C:\Users\PC#3\Documents\MATLAB\tensile\KMPlots\611_2.fig')
%% Voce equation
% sigma = saturation_stress(1-exp(-initial_strain_Hardening*eps_p/saturation_stress));
%% forest evolution
