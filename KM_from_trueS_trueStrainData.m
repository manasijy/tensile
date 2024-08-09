%% This script is used to create Kocks-Mecking plots from true stress
% and true plastic strain data. To run it one must first store these two variables 
% in the workspace as True_Pl_Strain,True_Pl_Stress variables. (One can change these names)
% 

[trueStrain, trueStress] = prepareCurveData(True_Pl_Strain,True_Pl_Stress);
clear True_Pl_Strain True_Pl_Stress
%% K-M plotting

% Set up fittype and options.
% fitmodel = {'x^5','x^4','x^3','x^2','x','sqrt(0.001+x)','1'};
% fitmodel = {'x^7','x^6','x^5','x^4','x^3','x^2','x','sqrt(0.001+x)','1'};
fitmodel = {'x^9','x^8','x^7','x^6','x^5','x^4','x^3','x^2','x','sqrt(0.001+x)','1'};
ft = fittype( fitmodel );
% Fit model to data.
[fitresult, gof] = fit( TplStrain,TplStress, ft );

% Plot fit with data.
figure( 'Name', [fitmodel,'fit']);
h = plot( fitresult, trueStrain, trueStress );
legend( h, 'True Stress vs. True Plastic Strain', [fitmodel,'fit'] , 'Location', 'SouthEast' );
% Label axes
xlabel( 'True Plastic Strain');
ylabel( 'True Stress'); 
grid on

KMY = differentiate(fitresult,trueStrain);
figure( 'Name', 'd(sigma)/d(epsilon) vs sigma' );
KMX = fitresult(trueStrain);
h1 = plot(KMX,KMY);
xlabel( 'True Stress - Yield Stress (MPa)' );
ylabel( 'd(sigma)/d(epsilon)' );
grid on
grid minor
