
%{
This program can plot EnggStress-EnggStrain, TrueStress-TrueStrain and also
find out yield stress and UTS on its own. This is semi-automatic as it
reqires user input one time. This program is broken into three sections: 
1) Import and plotting of raw data
2) Yield locus determination: this section requires manual input
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
%% Part1- import and plotting of data

%% Initialize variables.
foldername = 'C:\Users\Manasij Yadava\Desktop\MKY_IITK\ISRO Project\ISRO_FSP_Project_Data\Tensile Test Data\Cryo test\cryo results FSP';
fname = 'Specimen_RawData_612@77K.csv';
filename = fullfile(foldername,fname);
saveLocation = fullfile(foldername,[extractBefore(fname,'.'),'testData.mat']);
delimiter = ',';
startRow = 3;

%% Format for each line of text:
%   column4: double (%f)
%	column5: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%*s%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);
%% Create output variable
TestData = table(dataArray{1:end-1}, 'VariableNames', {'Tensilestrain','Tensilestress'});
EnggStress = TestData.Tensilestress;
EnggStrain = (TestData.Tensilestrain)/100; % Check if strain is in percentage
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
plot(EnggStrain,EnggStress,'-.b')

pause

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

%% There are three different methods to select and differentiate tensile data
% One - no change
% Two - Select peaks or valleys: good for data with serrations
% Three - select npoints to be fitted with straight line
% Four - Select nsample data points randomly and use them to fit a moving
% linear fit 

%% One - no change

TStress = TplStress;
TStrain = TplStrain;

%% Two - Select peaks or valleys: good for data with serrations


% [Value_peaks,locs_peaks,~,prominance_peaks] = findpeaks(TplStress);
% [Value_valleys,locs_valleys,~,prominance_valleys] = findpeaks(-TplStress);
% TStress = TplStress(locs_peaks);
% TStrain = TplStrain(locs_peaks);
% % TStress = TplStress(locs_valleys);
% % TStrain = TplStrain(locs_valleys);

%% Three - Select nsample data points randomly and use them to fit a moving
% linear fit 
% [y, idx] = datasample(TplStrain,100);
% idxx = sort(idx,'ascend');
% % we can plot to check if the sample is good
% plot(TplStrain(idxx),TplStress(idxx))
% trueStrain = TplStrain(idxx);
% trueStress = TplStress(idxx);
% npoints =  5;


%% Four - select npoints to be fitted with straight line

npoints = 50; %Number of points to be taken for fitting a straight line
[trueStrain, trueStress] = prepareCurveData(TStrain,TStress);
l =  length(trueStrain);
% k=l-4;           % It limits the data to points which have altlest four points beyond it.  
k=l-npoints+1;


%% Initialization

m=zeros(1,k);
c=zeros(1,k);
Rsq=zeros(1,k);
sigma = zeros(1,k);
epsilon = zeros(1,k);
j=1;

%% 'For' loop for finding out slope at each point
for i=1:1:k
    
    stress1 = trueStress(i:(i+npoints-1));% Temporary array holds the npoints where line is fit
    strain1 = trueStrain(i:(i+npoints-1));
    
    [xData, yData] = prepareCurveData( strain1, stress1 ); % Input function for fitting program

    %% Polynomial (degree 1) fitting function
    
    ft = fittype( 'poly1' );
    opts = fitoptions( ft );

    opts.Lower = [-Inf -Inf];
    opts.Upper = [Inf Inf];
    
    [f, gof] = fit( xData, yData, ft, opts );
    
%% Assignments of values obtained from the fitting curve

    coeffvals = coeffvalues(f);
    m(j) = coeffvals(1);
    c(j)= coeffvals(2);
    Rsq(j)= gof.rsquare;
    sigma(j)= trueStress(i);
    epsilon(j)= trueStrain(i);
    j=j+1;
end

%%

KMY = m;
KMX = sigma;

%% PLotting KM plot and analysis
figure( 'Name', 'd\sigma/d\epsilon vs  \sigma-\sigma_{y}' );
h1 = plot(KMX-KMX(1),KMY);
xlabel( '\sigma-\sigma_{y} (MPa)' );
ylabel( 'd\sigma/d\epsilon' );
grid on
grid minor
% pause
% [linfitKM, gofKM] = fit(ans2(:,1),ans2(:,2),'poly1');
% h2=plot( linfitKM, (KMX-KMX(1)),KMY,'-.k');
% legend( h2, 'd\sigma/d\epsilon vs \sigma-\sigma_{y}', 'linear fit' ,...
%     'Location', 'NorthEast','FontSize',14 );
% k = [linfitKM.p1,linfitKM.p2];
% % k1 = linfitKM.p1;
% k2 = linfitKM.p1;