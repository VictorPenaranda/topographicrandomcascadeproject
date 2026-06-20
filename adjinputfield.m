%-----------------------------------------------------------------------
% Dimensional Adjustment to the Coarse-Scale Input Data
%-----------------------------------------------------------------------
function [pfield0] = adjinputfield(PRE) 
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
%
% Syntax:
%
%    pfield0 = adjinputfield(PRE)
%
% Description:
%
%    This function is designed to perform a dimensional adjustment on 
%    the input precipitation data to generate a suitable matrix for 
%    the topographic random cascade algorithm.
%
% Input arguments:
%
%    PRE:      Coarse-scale precipitation field, DIM=[NxN].
%
% Output arguments:
%
%    pfield0:  Dimensional-adjusted coarse-scale precipitation field, 
%              DIM=[(N-1)x(N-1)].
%
% Last update: June 20, 2026. 
% Authors:  Victor Penaranda-Velez (victor.penaranda[at]atmosfera.unam.mx)
%           Carlos A. Ochoa-Moya (carlos.ochoa[at]atmosfera.unam.mx)
%           Arturo I. Quintanar (arturo.quintanar[at]atmosfera.unam.mx)
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

  % Checking dimensionality of the source field

  N = unique(size(PRE));

  if length(N)~=1, error('Non-squared input precipitation matrix'), end

  if mod(log2(N),2)>0
      
      N = N - 1;
      
      if mod(2^log2(N),2)~=0
          
          error('Input precipitation matrix requires a dimensional adjustment')
      
      end

      pfield0 = zeros(N); 

      for ii = 1:N
          
          for jj = 1:N
              
              pfield0(ii,jj) = mean(reshape(PRE(ii:ii+1,jj:jj+1),1,4));
          
          end
      
      end

  else

        pfield0 = PRE;
        
  end

%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
