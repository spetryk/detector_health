%% This script is to run the detector health report for the City of Arcadia
clear
clc
close all


%% Load the detector config file
config=load_config('Arcadia_detector_config.xlsx');
config.detectorConfig=config.detector_property('Detector_Properties');


%% Extract health analysis report
params=struct(...
    'StartDate',        struct(...
        'Year',     2016,...
        'Month',    2,...
        'Day',      7),...
    'EndDate',        struct(...
        'Year',     2016,...
        'Month',    12,...
        'Day',      10),...
    'DetectorList', config);

extract_health_report(params,'Arcadia');