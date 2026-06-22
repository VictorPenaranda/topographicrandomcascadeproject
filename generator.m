%---------------------------------------------------------------------------
% 2D-Cascade Generator
%---------------------------------------------------------------------------
function [W] = generator(varargin)
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%
% Syntax:
%
%    W = generator(codi,gammaless,gammaplus)
%
% Description:
%
%    This function is designed to estimate the multiplier statistics of the 
%    random cascade model. To execute this function, the codimension of the 
%    source precipitation field and the generator’s exponents, which represent 
%    the increasing and decreasing transformations of the mass density, are 
%    required.
%
% Input arguments:
%
%       codi:       Codimension of the source field, DIM: [1x1].
%       gammaless:  Negative gamma exponent, DIM: [1x1].
%       gammaplus:  Positive gamma exponent, DIM: [1x1].
%
% Output arguments:
%
%       W:          Multipliers of the random cascade model, DIM: [2x2].
%
% Last update: June 18, 2026
% Authors:  Victor Penaranda-Velez (victor.penaranda[at]atmosfera.unam.mx)
%           Carlos A. Ochoa-Moya (carlos.ochoa[at]atmosfera.unam.mx)
%           Arturo I. Quintanar (arturo.quintanar[at]atmosfera.unam.mx)
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

if nargin==3

    % Variables
    
    codi = varargin{1};      % Codimension
    
    gammaless = varargin{2}; % Exponent of the cascade generator
    
    gammaplus = varargin{3}; % Exponent of the cascade generator

    lambda0 = 0.5;           % Single-step scale ratio
    
    branch = 4;              % Branching number

    W = zeros(1,branch);
    
    for ii = 1:2:length(W)
    
        rdn = rand(1);
    
        if rdn <= lambda0^codi
    
            W(ii) = lambda0^(gammaless);
            
            W(ii+1) = lambda0^(gammaplus);
            
        else
    
            W(ii) = lambda0^(gammaplus);
            
            W(ii+1) = lambda0^(gammaless);
    
        end
        
    end
    
    W = reshape(W,log2(branch),log2(branch));  % Sorting values in a matrix form
    
    W(:) = W(randperm(numel(W)));              % Multipliers

else

    error('Incorrect number of input variables')

end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
