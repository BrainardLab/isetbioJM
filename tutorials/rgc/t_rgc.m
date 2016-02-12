%% A simple implementation and tutorial of the inner retina mosaics
%
% A sensor/cone mosaic and outersegment are loaded from the Remote Data
% Toolbox. The stimulus consists of a bar sweeping from left to right. The
% spatial nature of the stimulus allows the RGC response to be visualized
% easily. An rgcLayer object is created, and the rgc mosaic responses are
% computed. Several plotting operations are demonstrated.
% 
% 02/2016 JRG (c) isetbio team

%%
ieInit

%% Load sensor/cone mosaic and os

% The stimulus is a dynamic scene that consists of a bar sweeping from left
% to right. The scene, oi, sensor/cone mosaic and outer segment have been
% precomputed and are loaded using the Remote Data Tooblox (RDT)

% Initialize RDT
rdt = RdtClient('isetbio');
rdt.crp('resources/data/rgc');

% Read the artifact containing a description of the cone mosaic
% (coneMosaic) and the biophysical properties of the outer segment (os).
% Because these are stored in a matlab file, the data are returned.
data = rdt.readArtifact('t_rgcData', 'type', 'mat');
coneMosaic = data.coneMosaic;
os   = data.os;

%% Visualize the cone mosaic absoprtion pattern
%
% cMosaic25 = coneMosaic;
% cMosaic25.data.volts = coneMosaic.data.volts(:,:,25);
% vcAddObject(cMosaic25);sensorWindow('scale',true);
%
% Or make a color movie
%
% coneImageActivity(coneMosaic,'step',1,'dFlag',true);
% 

%% Build the inner retina object
%
% The inner retina holds the ganglion cell mosaics. 
%
% The user names the object, specifies the type of model (linear, LNP,
% GLM, etc.) and the position of the retinal patch (which eye, radius from
% fovea and polar angle). The RGC determines the size of spatial receptive
% fields based on the temporal equivalent eccentricity calculated from th
% patch location, and build RGCs with spatial RFs over the cone mosaic and
% temporal impulse responses with the appropriate sampling rate.

% Create the inner retina that holds the rgc mosaics
innerRetina = irCreate(os, 'name','Macaque inner retina','model','GLM');

%% Build RGC mosaics (OPTIONAL)
% 
% This is now handled internally in rgcCompute with the same call to
% rgcMosaicCreate. This ensures the mosaics have the correct properties
% according to those set in the rgc parent object.
% 
% The mosiac property of the RGC layer object stores the mosaics of the
% different types of RGCs. The code currently supports the five most common
% types: ON parasol, OFF parasol, ON midget, OFF midget and small
% bistratified. Mosaics can be added individually or all five may be added
% automatically using the loop structure below. If no mosaics are added
% manually, then they are automatically built on the call to rgcCompute.

% numberMosaics = 5; % setting to 5 generates all five of the most common types.
% for cellTypeInd = 1:numberMosaics
%     rgc1 = rgcMosaicCreate(rgc1);
% end

% Alternative syntax for creating single layers at a time
innerRetina = rgcMosaicCreate(innerRetina,'mosaicType','on midget');
         
%% Compute the RGC responses
% Compute linear and nonlinear responses
innerRetina = rgcCompute(innerRetina, os);

% Compute spiking response
numberTrials = 5;
for repititions = 1:numberTrials
    innerRetina = rgcComputeSpikes(innerRetina, os);
end

%% Plot various aspects of the RGC response
% rgcPlot(rgc1, 'mosaic');
rgcPlot(innerRetina, 'rasterResponse');
% rgcPlot(rgc1, 'psthResponse');

% Create a movie of the response
% rgcMovie(rgc1, os);
% rgcMovieWave;

%%
