

foldername = 'C:\Users\PC#3\Desktop\MKY_IITK\ISRO Project\ISRO_FSP_Project_Data\Tensile Test Data\633P\3.is_metal_RawData';
fname = 'StressDrop.mat';
filename = fullfile(foldername,fname);
load(filename,'SDrop_x','SDrop_y','StressDrop_significant')
nn = numel(StressDrop_significant);
StressDrop_significant(nn:numel(SDrop_x)) = 0;
A_matrix = [SDrop_x,SDrop_y,StressDrop_significant];
loc_xls = fullfile('C:\Users\PC#3\Desktop\MKY_IITK\ISRO Project\ISRO_FSP_Project_Data\Tensile Test Data','AllStressDrop.xlsx');
xlswrite(loc_xls,A_matrix,9,'i2');%:A, E, I
