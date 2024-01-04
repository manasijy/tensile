%{
This program can plot EnggStress-EnggStrain, TrueStress-TrueStrain and also
find out yield stress and UTS on its own. This is semi-automatic as it
reqires user input one time. This program is broken into three sections: 
1) Import and plotting of raw data
2) Yield stress determination: this section requires manual input
3) True stress and true stress calculation and plotting

Method:
1) change the filename in Section 1 -- filename = '-----'
2) run section 1
3) go to figure, choose brush tool and select the elastic region data where
you want to fit the straight line to determine modulus (apparant)
4) In the same selected data right click and select 'create new variable'
modify the default name 'ans' to 'ans1'
5) go to program and run section 2 only or all the remaining sections.

Another approach could be to use import data tool to import Engg
Stress-Strain data and save that as 'EnggStress' and 'EnggStrain' variable
in the workspace. Plot it and then follow step 3 onwards.

-prepared by Dr. Manasij Kumar Yadava, IIT Kanpur
%}

clear;
close;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The first part is about getting the engg stress and engg strain data into the matlab workspace
% you can use matlab tools to get the two columns into the workspace. These variables can be renamed 
% according to the respective variable names in this script

%%
plot(EnggStrain,EnggStress,'-.b')

pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Part2 - Manual

%{
% Now go to the figure and use brush tool to select the elastic deformation
% data. It will appear in red color.Right click and save as workspace
% variable 'elast'. This will be a numel(strain)X 2 matrix. now run the
% following:
%}

linfit = fit(ans1(:,1),ans1(:,2),'poly1');
slope = linfit.p1;
hold on
plot(linspace(0,0.1,10)+0.002, linfit.p2+linfit.p1.*linspace(0,0.1,10))
err = EnggStress - polyval([linfit.p1,(linfit.p2-0.002*linfit.p1)],EnggStrain);
[index] = find(abs(err)== min(abs(err)));
yieldStress = EnggStress(index);
hold off

%%  part3 - auto
TrueStrain = log(ones(length(EnggStrain),1)+EnggStrain);
TrueStress = EnggStress.*(ones(length(EnggStrain),1)+EnggStrain);
TruePlasticStrain = TrueStrain - TrueStress*(1/linfit.p1);
maxStressIndex = find (TrueStress == max(TrueStress));
TplStrain =TruePlasticStrain(index:maxStressIndex)-TruePlasticStrain(index);
TplStress= TrueStress(index:maxStressIndex);
UTS = TrueStress(maxStressIndex);
UTS_Engg = max(EnggStress);
% h = figure;
plot((TruePlasticStrain(index:maxStressIndex)-TruePlasticStrain(index)),TrueStress(index:maxStressIndex),'-r');
% ax = plot((TruePlasticStrain(index:maxStressIndex)-TruePlasticStrain(index)),TrueStress(index:maxStressIndex),'-r');
ylim([0 inf]); 
pbaspect([1 1 1]);
% % % save('testData.mat','yieldStress','UTS','linfit','EnggStress','EnggStrain','TrueStrain','TrueStress','TplStrain','TplStress');
% % clearvars ;%ax ans ans1 err h index linfit maxStressIndex TruePlasticStrain; 


%% K-M plotting

% Set up fittype and options.
%Degree of polynomial used for fitting. 5 works fine. But check it though.
degree = 6; 
fitpolytype = ['poly',num2str(degree)];
ft = fittype( fitpolytype );

% Fit model to data.
[fitresult, gof] = fit( TplStrain,TplStress, ft );

% Plot fit with data.
figure( 'Name', [fitpolytype,'fit']);
h = plot( fitresult, TplStrain,TplStress );
legend( h, 'True Stress vs. True Plastic Strain', [fitpolytype,'fit'] , 'Location', 'SouthEast' );
% Label axes
xlabel( 'True Plastic Strain');
ylabel( 'True Stress'); 
grid on

KMY = differentiate(fitresult,TplStrain);
figure( 'Name', 'd(sigma)/d(epsilon) vs sigma' );
KMX = fitresult(TplStrain);
h1 = plot(KMX,KMY);
xlabel( 'True Stress - Yield Stress (MPa)' );
ylabel( 'd(sigma)/d(epsilon)' );
grid on
grid minor

%%
save(saveLocation,'yieldStress','UTS','linfit','EnggStress','EnggStrain','TrueStrain','TrueStress','TplStrain','TplStress','UTS_Engg','KMX','KMY');

%% To save in excel sheet

A_matrix = padcat(EnggStress,EnggStrain,TrueStrain,TrueStress,TplStrain,TplStress,KMX,KMY,yieldStress,UTS,UTS_Engg);
xlswrite('AnalysedData.xls',A_matrix); I