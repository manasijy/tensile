%{ 
Modified by MKY: 23/11/2017 - in part 2- manual ( compare it with
TensileTestAnalysis.m code

- removed a bug in calculating YS by intersection of straight line and the
stress strain plot. Instead of taking the whole data, took data from the
minimum of selected strain data in 'ans1'
.
-----------------------------------------
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

foldername = 'C:\Users\PC#3\Desktop\MKY_IITK\ISRO Project\Serrations Work\Analysis of Data\AA2198-UA\AA2198-UA';
fname = 'Specimen_RawData_5 (1).csv';
filename = fullfile(foldername,fname);
saveLocation = fullfile(foldername,[extractBefore(fname,'.'),'testData.mat']);
delimiter = ',';
startRow = 17;
% formatSpec = '%*q%*q%*q%q%q%[^\n\r]';
% formatSpec = '%*q%q%*q%q%*q%[^\n\r]';
formatSpec = '%*q%*q%*q%*q%*q%q%q%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable

% EnggStress = cell2mat(raw(:, 1));
% EnggStrain = cell2mat(raw(:, 2));

% Here the code is modified for a set of data in different format
EnggStrain = cell2mat(raw(:, 1));
EnggStress = cell2mat(raw(:, 2));

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;
plot(EnggStrain,EnggStress,'-.b')

pause

%% Part2 - Manual

%{
% Now go to the figure and use brush tool to select the elastic deformation
% data. It will appear in red color.Right click and save as workspace
% variable 'elast'. This will be a numel(strain)X 2 matrix. now run the
% following:
%}
e_min = min(ans1(:,1));
e_start_index = find(EnggStrain == e_min,1,'last');
linfit = fit(ans1(:,1),ans1(:,2),'poly1');
slope = linfit.p1;
hold on
% plot(linspace(0,0.1,10)+0.002, linfit.p2+linfit.p1.*linspace(0,0.1,10))
plot(linspace(0,0.05,10)+0.002, linfit.p2+linfit.p1.*linspace(0,0.05,10))
err = EnggStress(e_start_index:end) - polyval([linfit.p1,(linfit.p2-0.002*linfit.p1)],EnggStrain(e_start_index:end));
[index] = find(abs(err)== min(abs(err)));
index = max(index)+e_start_index; % MKY23112017, here I have modified the index in case of more than one index values
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
save(saveLocation,'yieldStress','UTS','linfit','EnggStress','EnggStrain','TrueStrain','TrueStress','TplStrain','TplStress','UTS_Engg');
% % % save('testData.mat','yieldStress','UTS','linfit','EnggStress','EnggStrain','TrueStrain','TrueStress','TplStrain','TplStress');
% % clearvars ;%ax ans ans1 err h index linfit maxStressIndex TruePlasticStrain; 


%% K-M plotting

% % Set up fittype and options.
% %Degree of polynomial used for fitting. 5 works fine. But check it though.
% degree = 7; 
% fitpolytype = ['poly',num2str(degree)];
% ft = fittype( fitpolytype );
% 
% % Fit model to data.
% [fitresult, gof] = fit( TplStrain,TplStress, ft );
% 
% % Plot fit with data.
% figure( 'Name', [fitpolytype,'fit']);
% h = plot( fitresult, TplStrain,TplStress );
% legend( h, 'True Stress vs. True Plastic Strain', [fitpolytype,'fit'] , 'Location', 'SouthEast' );
% % Label axes
% xlabel( 'True Plastic Strain');
% ylabel( 'True Stress'); 
% grid on
% 
% KMY = differentiate(fitresult,TplStrain);
% figure( 'Name', 'd(sigma)/d(epsilon) vs sigma' );
% KMX = fitresult(TplStrain);
% h1 = plot(KMX,KMY);
% xlabel( 'True Stress - Yield Stress (MPa)' );
% ylabel( 'd(sigma)/d(epsilon)' );
% grid on
% grid minor

%%