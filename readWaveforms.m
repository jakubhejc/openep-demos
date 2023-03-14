clc, clear

cfg.ENSITE_V = 'x1v1.x'; %choices: 'precision', 'x1'
cfg.DIR_PATH = '/backup/data/valencia_ensite/2022_07_21_17_55_27';
cfg.FILE_NAME = 'EP_Catheter_Unipolar_Waveforms_Raw.csv';
% 
% cfg.DIR_PATH = '/backup/data/WaveMap/study_dwsG701583_2019_10_15_02_50_07/2022_03_11_09_24_19';
% cfg.FILE_NAME = 'EPcathBIObipol_FILTERED.csv';

% construct fullpath and check if exists
fullPath = fullfile(cfg.DIR_PATH, cfg.FILE_NAME);

mustBeFolder(cfg.DIR_PATH); mustBeFile(fullPath);

% Create version specific function handle (future releas)
switch cfg.ENSITE_V
    case {'precision', 'x1v1.x'}
        loadwave = @loadprecision_wavefile;            
    case 'x1v2.x'
        error('Not implemented error.')    
end


% Import unipolar and bipolar waveform files
% Data are stored in substructure info.catheters.
% 
% Each column in info.catheters.egms contain acquired channel (either
% unipolar or bipolar - depends on the file readed)
% 
% Each row in info.catheters.egmNames contain name of the channel/column
% in info.catheters.egms


disp(['Processing file:' cfg.FILE_NAME])
info = loadwave(fullPath);

disp()

