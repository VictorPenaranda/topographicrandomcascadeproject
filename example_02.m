% ----------------------------------------------------------------------
% ----------- Topographic Random Cacade Model - Example 2 --------------
% ----------------------------------------------------------------------
% ---------------- Source coarse-scale field: IMERG --------------------
%-----------------------------------------------------------------------

tic

pcl = parcluster;

Nnodes = 30;

pooltrc = parpool(pcl,Nnodes);

% ------------------------------------------------------------------------
% ------------ Paths to Scripts, Input Data and Output Folder ------------
% ------------------------------------------------------------------------

cd ~/TRC_project/scripts/

pathfiles0 = '~/TRC_project/';

folder = 'IMERG'; % Results' Folder

if ~exist([pathfiles0,'results/',folder],'dir'), 
    
    mkdir([pathfiles0,'results/',folder])

end

pathfiles1 = [pathfiles0,'results/',folder,'/'];

pathfiles2 = [pathfiles0,'DEMs/'];

pathfiles3 = [pathfiles0,'IMERG/'];

addpath([pathfiles0,'scripts'])

% ------------------------------------------------------------------------
% -------------- Computing Topographic Enhancement Function --------------
% ------------------------------------------------------------------------

% Loading the DEM for CHIRPS-based simulation at resolution 256x256

[Z,GR] = readgeoraster([pathfiles2,'interpdem_imerg_resolution289m.tif']);

x = -1:0.01:1;

x1 = min(x(:)); x2 = max(x(:));

z1 = min(Z(:)); z2 = max(Z(:));

for ii = 1:size(Z,1);
    
    for jj = 1:size(Z,2);

        zpt = Z(ii,jj);

        Znor(ii,jj) = x1 + (zpt-z1)*(x2-x1)/(z2-z1); % Normalization 
        
    end
    
end

ftop = topofun(Znor,'hastenrath',[1.8802 0.5000 0.4700]);

% ------------------------------------------------------------------------
% ------------------- Loading daily precipitation data -------------------
% ------------------------------------------------------------------------

% Loading daily precipitation data

pdata = ncread([pathfiles3,'pfields_IMERG_observations_2001-2020.nc'],'PRE');

nfields = size(pdata,3); % Length of the temporal record

M = 2^8;                 % Size of the output field

% ------------------------------------------------------------------------
% ----------------------- Computing TRC Fields ---------------------------
% ------------------------------------------------------------------------

ticBytes(gcp);

psim = zeros(M,M,nfields);

parfor (kk = 1:nfields)

    % Reading the source field
    
    pfield0 = pdata(:,:,kk);

    pfield0 = adjinputfield(pfield0);

    % Checking if there is a non-zero precipitation field
    
    flag = length(pfield0(pfield0>0))>1;
    
    if flag == 1
        
        % Random Cascade Process

        Nsim = 100; % Number of random realizations

        Nsta = 5;   % Number of stages in the random cascade
        
        pfield1 = randomcascadefun(pfield0,Nsta,Nsim); % 5 for 256; 6 for 512; 7 for 1024
    
        % Topographic Forcing
    
        pfield2 = forcing(pfield1,ftop);
        
        % Diffusive Process

        epsilon = 0.7

        niter = 100;

        ptol = 3;
        
        pfield3 = diffusionfun(pfield2,epsilon,niter,ptol);
       
    else
    
        pfield3 = zeros(M);
        
    end

    psim(:,:,kk) = pfield3;

end

tocBytes(gcp)

% ------------------------------------------------------------------------
% ------------------------------ Results ---------------------------------
% ------------------------------------------------------------------------

% Reading geographic coordinates

lon = ncread([pathfiles3,'pfields_IMERG_observations_2001-2020.nc'],'lon');

lon = linspace(mean([lon(1) lon(2)]),mean([lon(end-1) lon(end)]),M);

lat = ncread([pathfiles3,'pfields_IMERG_observations_2001-2020.nc'],'lat');

lat = linspace(mean([lat(1) lat(2)]),mean([lat(end-1) lat(end)]),M);

% Reading time vector

TI = ncread([pathfiles3,'pfields_IMERG_observations_2001-2020.nc'],'time');

% Saving results in a NetCDF file

ncfilename = 'pfields_IMERG_simulation_2001-2020.nc';

nccreate([pathfiles1,ncfilename],'PRE','Dimensions',...
      {'lon',length(lon),'lat',length(lat),'time',nfields},'Datatype','double');

ncwriteatt([pathfiles1,ncfilename],'PRE','units','mm');

ncwriteatt([pathfiles1,ncfilename], 'PRE', 'long_name', 'precipitation');

nccreate([pathfiles1,ncfilename],'lon','Dimensions',...
      {'lon',length(lon)},'Datatype','single');

ncwriteatt([pathfiles1,ncfilename], 'lon', 'units', 'degrees');

ncwriteatt([pathfiles1,ncfilename], 'lon', 'long_name', 'longitude');

ncwrite([pathfiles1,ncfilename], 'lon', lon);

nccreate([pathfiles1,ncfilename],'lat','Dimensions',...
      {'lat',length(lat)},'Datatype','single');

ncwriteatt([pathfiles1,ncfilename], 'lat', 'units', 'degrees');

ncwriteatt([pathfiles1,ncfilename], 'lat', 'long_name', 'latitude');

ncwrite([pathfiles1,ncfilename], 'lat', lat);

nccreate([pathfiles1,ncfilename],'time','Dimensions',...
      {'time',nfields},'Datatype','double');

ncwriteatt([pathfiles1,ncfilename], 'time', 'units', ...
      'days since 1900-1-1 0:0:0');

ncwriteatt([pathfiles1,ncfilename], 'time', 'standard_name', 'time');

ncwriteatt([pathfiles1,ncfilename], 'time', 'calendar', 'gregorian');

ncwriteatt([pathfiles1,ncfilename], 'time', 'axis', 'T');

ncwriteatt([pathfiles1,ncfilename],'/','title',...
      'IMERG - TRC Precipitation Downscaling for CDMX metropolitan area')

for kk = 1:nfields

    ncwrite([pathfiles1,ncfilename],'PRE',psim(:,:,kk),[1 1 kk]);

    ncwrite([pathfiles1,ncfilename],'time',TI(kk),kk);

end

toc

delete(gcp('nocreate'));
