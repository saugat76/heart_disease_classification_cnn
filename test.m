%%test
clear 
close all
%% Creation of a preprocessed datastore for every patients
diagnostic_tbl = readtable('C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\Diagnostics.xlsx', 'Sheet', 'sheet1');

% Isolation of only required data i.e. filename and rhythym 
diagnostic_tbl = diagnostic_tbl(:,["FileName","Rhythm"]);
filename = table2array(diagnostic_tbl(:,1));
label = table2array(diagnostic_tbl(:,2));

filename_id = strcat('C:\Users\tripats\Documents\Biomedical Signal Analysis\Grad Single Project\ECGData\ECGData\',filename,'.csv');

% For this particular project we are going to use all the available rhythm
% diagnosis of the dataset

preprocessData(char(filename_id(1)), label(1), filename(1));


