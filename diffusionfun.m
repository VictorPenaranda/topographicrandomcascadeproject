%-----------------------------------------------------------------------
% Diffusive Filter
%-----------------------------------------------------------------------
function [pfield3] = diffusionfun(varargin)
% ---------------------------------------------------------------------- 
% ---------------------------------------------------------------------- 
% Syntax:
%
%   pfield3 = diffusionfun(pfield2,epsilon,niter,ptol);
%
% Description:
%
%   This function is designed to filter the simulated random-cascade field
%   to correct the blockiness effect. 
%
% Input arguments:
%
%  pfield2:  Topographic-enhanced random-cascade field, DIM=[MxM].
%  epsilon:  Smoothing velocity parameter, DIM=[1x1].
%  niter:    Number of iterations to conduct in the diffusion filter, 
%            DIM=[1x1]. 
%  ptol:     Porcentage of tolerance in the mean field value difference 
%            between the original and filtered fields, DIM=[1x1].
%
% Output arguments:
%
%  pfield3:  blockiness-corrected topographic-enhanced precipitation 
%            field, DIM=[MxM].
%
% Last update: June 19, 2026. 
% Authors:  Victor Penaranda-Velez (victor.penaranda[at]atmosfera.unam.mx)
%           Carlos A. Ochoa-Moya (carlos.ochoa[at]atmosfera.unam.mx)
%           Arturo I. Quintanar (arturo.quintanar[at]atmosfera.unam.mx)
% ---------------------------------------------------------------------- 
% ---------------------------------------------------------------------- 

  switch nargin
  
    case 4
  
        pfield2 = varargin{1}; 
        
        epsilon = varargin{2};
        
        niter = varargin{3};
        
        ptol = varargin{4};
  
    case 3
  
        pfield2 = varargin{1}; 
        
        epsilon = varargin{2};
        
        niter = varargin{3};
        
        ptol = 3;
  
    case 2
  
        pfield2 = varargin{1}; 
        
        epsilon = varargin{2};
        
        niter = 100;
        
        ptol = 3;
  
    case 1
  
        pfield2 = varargin{1}; 
        
        epsilon = 0.7;
        
        niter = 100;
        
        ptol = 3;
  
    otherwise
  
        error('Incorrect number of input variables')
  
  end
  
  if exist('pfield2','var')&&exist('epsilon','var')&&exist('niter','var')&&exist('ptol','var')
  
    avg0 = mean(pfield2(:));
    
    pfield3 = pfield2; 
    
    Crt = 1; pp = 0;
    
    while Crt==1
    
        AA = circshift(pfield3,-1,2); AA(:,end) = 0;
    
        BB = circshift(pfield3,1,2); BB(:,1) = 0;
    
        CC = circshift(pfield3,-1,1); CC(end,:) = 0;
    
        DD = circshift(pfield3,1,1); DD(1,:) = 0;
    
        pfield3 = (1-epsilon)*pfield3 + epsilon*(AA + BB + CC + DD)/4;
        
        avg1 = mean(pfield3(:));
        
        if (pp<niter)
        
            if ((100*abs(avg1-avg0)/avg0)>ptol) % checking mean field value
            
                Crt = 0;
                
            else
        
                Crt = 1;
    
                pp = pp + 1;
                
            end
            
        else
            
            Crt = 0;
            
        end
          
    end
    
    if isreal(pfield3)==0
    
        IDimg = imag(pfield3)>0
        
        pfield3(find(IDimg==1)) = NaN; % Changing numerical errors
    
    end

end

% ---------------------------------------------------------------------- 
% ---------------------------------------------------------------------- 
