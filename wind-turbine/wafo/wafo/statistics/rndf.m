function R = rndf(varargin)
%RNDF Random matrices from the Snedecor's F distribution
%
% CALL:  R = rndf(df1,df2,sz);
%
%        R = matrix of random numbers
% df1,df2, = degrees of freedom
%     phat = Distribution parameter struct
%             as returned from WFFIT.  
%       sz = size(R)    (Default size(b))
%            sz can be a comma separated list or a vector 
%            giving the size of R (see zeros for options)
%
% The random numbers are generated by the inverse method. 
% 
% Example:
%   R=sort(rndf(10,10,100,1));
%   plotedf(R); hold on;
%   plot(R,cdff(R,10,10),'r'); hold off;
%
%   close all;
%
% See also  pdff, cdff, invf, fitf, momf
  
% tested on matlab 5.3
%History:
%revised pab 29.10.2000
% adapted from stixbox
% -added nargchk, comnsize + check that df1, df2 are positive integers
%        Anders Holtsberg, 18-11-93
%        Copyright (c) Anders Holtsberg

%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU Lesser General Public License as published by
%     the Free Software Foundation; either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU Lesser General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

%error(nargchk(1,inf,nargin))
narginchk(1,inf)
Np = 2;
options = []; % default options
[params,options,rndsize] = parsestatsinput(Np,options,varargin{:});
% if numel(options)>1
%   error('Multidimensional struct of distribution parameter not allowed!')
% end

[df1,df2] = deal(params{:});

if isempty(rndsize),
  [csize] = comnsize(df1,df2);
else
  [csize] = comnsize(df1,df2,zeros(rndsize{:}));
end 
if any(isnan(csize))
  error('df1 and df2 must be a scalar or of corresponding size as given by m and n.');
end

%x = invbeta(rand(csize),df1/2,df2/2);
x  = rndbeta(df1/2,df2/2,csize);
R = df2./((1./x-1).*df1);

% if nargin<3,
%   [iscmn a b] = comnsize(a,b);
% else
%   [iscmn a b] = comnsize(a,b,zeros(varargin{:}));
% end 
% if ~iscmn
%   error('df1 and df2 must be a scalar or of corresponding size as given by m and n.');
% end
% 
% 
% R = zeros(size(a));
% 
% ok = (a>0 & b>0 & floor(a)==a & floor(b)==b);
% 
% k = find( ok);
% if any(k)
%   x = rndbeta(a(k)/2,b(k)/2);
%   R(k) = x.*b(k)./((1-x).*a(k));
% end
%
% k3=find(~ok);
% if any(k3)
%   R(k3)=nan;
% end
