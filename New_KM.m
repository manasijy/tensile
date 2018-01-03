
[trueStrain, trueStress] = prepareCurveData(True_Pl_Strain,True_Pl_Stress);
clear True_Pl_Strain True_Pl_Stress
%% K-M plotting

% Set up fittype and options.
%Degree of polynomial used for fitting. 5 works fine. But check it though.
degree = 5; 
fitpolytype = ['poly',num2str(degree)];
ft = fittype( fitpolytype );

% Fit model to data.
[fitresult, gof] = fit( trueStrain,trueStress, ft );

% Plot fit with data.
figure( 'Name', [fitpolytype,'fit']);
h = plot( fitresult, trueStrain, trueStress );
legend( h, 'True Stress vs. True Plastic Strain', [fitpolytype,'fit'] , 'Location', 'SouthEast' );
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