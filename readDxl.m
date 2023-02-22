clc, clear

cfg.ENSITE_V = 'precision'; %choices: 'precision', 'x1'
cfg.DIR_PATH = '/media/jakubhejc/hejc_usb04/study_dwsG701583_2021_07_13_12_08_28/081-RA-followup_2022_08_24_12_13_39';


% List DxL files
dxlFiles = dir(fullfile(cfg.DIR_PATH, 'DxL_*.csv'));

if isempty(dxlFiles)
    error(['No DxL file has been found in folder: ', cfg.DIR_PATH])
end


% Create version specific function handle (future releas)
switch cfg.ENSITE_V
    case 'precision'
        loadxl = @loadprecision_dxldata;
    case 'x1'
        error('Not implemented error.')
end


% Import and concatanate individual DxL file
%
% Data from HD-Grid are stored in 'egms.rovtrace'. Each column contains
% single channel. You can see detailed info about each channel in 'points',
% e.g.: 1st row in 'points' corresponds to 1st column in 'egms.rovtrace'.
% 
% 'points.ptnumber' is index of acquired beat. E.g. all rows where
% 'points.ptnumber' == 2 represents signals from HD Grid recorded during
% second acquired beat. Indices of rows maps corresponding columns with
% signals in 'egms.rovtrace'.
% 
% 'points.rovingx',..., 'points.rovingz': coordinates of
% electrical point in 3D space. In unipolar setting it should represent
% coordinate of particular catheter electrode.
% 'points.surfPtx',...,'points.surfPtz' are on the other hand coordinates
% on the surface of 3D anatomy map to which electrical point was projected
% to. The reason is the anatomy and egm maps are separate instances.

k = 1;
fullPath = fullfile(dxlFiles(k).folder, dxlFiles(k).name);
disp(['Processing files:' dxlFiles(k).name])
[info, points, egms] = loadxl(fullPath);



