% ----------------------------------------------------------------------
% Topographic enhancement function
% ---------------------------------------------------------------------- 

function [ftop] = topofun(varargin)

   % Variables

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

    % Estimation of the topographic function

    for ii = 1:size(Z,1);
    
        for jj = 1:size(Z,2);
    
            ftop(ii,jj) = fun(par,Z(ii,jj));
            
        end
        
    end
