
foldername = 'C:\Users\PC#3\Desktop\MKY_IITK\ISRO Project\Serrations Work\Analysis of Data\AA2198-UA\AA2198-UA';
% foldername = 'C:\Users\PC#3\Desktop\MKY_IITK\ISRO Project\ISRO_FSP_Project_Data\Tensile Test Data\611P\1.is_metal_RawData';
fname = 'Specimen_RawData_5 (1)testData.mat';
% fname = 'testData.mat';
filename = fullfile(foldername,fname);
load(filename,'TplStrain','TplStress');

%% Stress drop calculation

[Value_peaks,locs_peaks,~,prominance_peaks] = findpeaks(TplStress);
[Value_valleys,locs_valleys,~,prominance_valleys] = findpeaks(-TplStress);
data_length = min(length(Value_peaks),length(Value_valleys));

if locs_peaks(1)< locs_valleys(1)
    StressDrop = Value_peaks(1:data_length) - abs(Value_valleys(1:data_length));
    loc_Drops = locs_peaks(1:data_length);
else
    StressDrop = Value_peaks(1:data_length-1) - abs(Value_valleys(2:data_length-1));
    loc_Drops = locs_peaks(1:data_length-1);
end

Loc_significant = find(StressDrop>1);
StressDrop_significant = StressDrop(Loc_significant);
loc_Drops_significant = loc_Drops(Loc_significant);
strainData = TplStrain(loc_Drops(Loc_significant));

SDrop_x = TplStrain(loc_Drops);
SDrop_y = StressDrop;

ax1 = subplot(2,2,[1,2]);
plot(ax1,TplStress);
hold on
grid on
plot(locs_peaks,TplStress(locs_peaks),'rv','MarkerFaceColor','r');%,'MarkerSize',1);
plot(locs_valleys,TplStress(locs_valleys),'rs','MarkerFaceColor','b');
axis([0 7000 100 600])
legend('True Stress','Peaks','Valleys')
xlabel('Reading Number')
ylabel('True Stress(MPa)')
title('Peaks and Valleys in True Stress') 
hold off

ax2 = subplot(2,2,3);
stem(ax2,TplStrain(loc_Drops),StressDrop,':m');%'LineStyle',':');
xlabel('Plastic Strain')
ylabel('Stress Drop (MPa)')
title('Stress Drop vs Plastic Strain') 

ax3 = subplot(2,2,4);
histogram(StressDrop_significant,10,'FaceColor','r')
xlabel('Stress Drop (MPa)')
ylabel('Frequency')
title('Stress Drop Histogram') 
savefig(fullfile(foldername,[extractBefore(fname,'.'),'serrartion.fig']));

clearvars data_length filename foldername fname loc_Drops loc_Drops_significant...
    Loc_significant locs_peaks locs_valleys prominance_peaks prominance_valleys strainData StressDrop ...
    StressDrop_significant Value_peaks Value_valleys 
