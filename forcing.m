%-----------------------------------------------------------------------
% Orographic Modification on the Simulated Random Cascade Field
%-----------------------------------------------------------------------
function [pfield2] = forcing(varargin)
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
%
% Syntax:
%
%    pfield2 = forcing(pfield1,ftop)
%
% Description:
%
%    This function is designed to compute a topographic-enhanced 
%    random-cascade field using the matrix of topographic-enhanced 
%    function values.
%
%
% Input arguments:
%
%    pfield1: Simulated random cascade fieldDIM=[MxM].
%             with M=Nx2^Nsta.
%    ftop:    Topographic enhancement function values, DIM=[MxM].
%             with M=Nx2^Nsta.
%    Nsta:    Number of stages in the multiplicative process, 
%             DIM=[1x1].
%
% Output arguments:
%
%    pfield2:  Topographic-enhanced random-cascade fieldDIM=[MxM].
%              with M=Nx2^Nsta.
%
% Last update: June 19, 2026. 
% Authors:  Victor Penaranda-Velez (victor.penaranda[at]atmosfera.unam.mx)
%           Carlos A. Ochoa-Moya (carlos.ochoa[at]atmosfera.unam.mx)
%           Arturo I. Quintanar (arturo.quintanar[at]atmosfera.unam.mx)
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

  if nargin == 2
  
      pfield1 = varargin{1}; % Simulated random cascade field
      
      ftop = varargin{2};    % topographic enhancement values
  
      HvsFun = pfield1>0;    % Finding location of non-zero precipitation
      
      A = ftop(HvsFun==1);   % topographic enhancement function values at
                             % the location of non-zero precipitation
      
      nftop = A/mean(A);     % Normalization for preserving the mean field
      
      pfield2 = pfield1;
      
      pfield2(HvsFun==1) = pfield2(HvsFun==1).*nftop; % Updating multipliers
  
  else
  
      error('Incorrect number of input variables')
  
  end

%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
