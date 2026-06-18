% ----------------------------------------------------------------------
% Topographic enhancement function
% ---------------------------------------------------------------------- 
function [ftop] = topofun(varargin)
% ---------------------------------------------------------------------- 
% ---------------------------------------------------------------------- 
% Syntax:
%
%   ftop = topofun(Z,modphi,par)
%
% Description:
%
%   This function is designed to estimate the enhancement values 
%   resulting from the topographic effect, which will be utilized along 
%   the random-cascade-simulated field to generate a spatial 
%   representation of the precipitation field.
%
% Input arguments:
%
%   Z:      Normalized values representing the altitudinal terrain 
%           position. Z is a squared matrix of size N x N.
%   Modphi: The selected model for representing the altitudinal 
%           variation of precipitation. Two models are available for 
            selection: “exponential” and “hasteranth”.
%   par:    Parameters of the selected model for representing altitudinal 
%           variation of precipitation.
%           For the “exponential” model, M=2 parameters are required. 
%           For the “hastenrath” model, M=3 parameters are required.
%           par is a vector of size 1 x M. 
%
% Output arguments:
%
%   ftop:   matrix of topographic-enhancement values.
%
% Last update: June 18, 2026. 
% Authors:  Victor Penaranda-Velez (victor.penaranda[at]atmosfera.unam.mx)
%           Carlos A. Ochoa-Moya (carlos.ochoa[at]atmosfera.unam.mx)
%           Arturo I. Quintanar (arturo.quintanar[at]atmosfera.unam.mx)
% ---------------------------------------------------------------------- 
% ---------------------------------------------------------------------- 

% Reading variables

   Z = varargin{1};

   modphi = varargin{2};

   if matches(modphi,'exponential')==1
   
     par = varargin{3};
   
     fun = @(par,x) par(1)*exp(par(2)*x);
   
   elseif matches(modphi,'hastenrath')==1
   
     par = varargin{3}
   
     fun = @(par,x) 0.5.*(par(1)*exp(-(x.^2)./(2.*par(2).^2))).*(1-erf(par(3)*x./sqrt(0.5)))
   
   else
   
     error('Incomplete Input Parameters')
   
   end

% Estimation of the topographic enhancement function
   
   for ii = 1:size(Z,1);
   
     for jj = 1:size(Z,2);
   
         ftop(ii,jj) = fun(par,Z(ii,jj));
         
     end
     
   end
   
% ----------------------------------------------------------------------
% ----------------------------------------------------------------------
