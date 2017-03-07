function prob = gmmLINprob(mix, x,W)
%GMMPROB Computes the data probability for a Gaussian mixture model.
%
%	Description
%	 This function computes the unconditional data density P(X) for a
%	Gaussian mixture model.  The data structure MIX defines the mixture
%	model, while the matrix X contains the data vectors.  Each row of X
%	represents a single vector.
%
%	See also
%	GMM, GMMPOST, GMMACTIV
%

%	Copyright (c) Ian T Nabney (1996-2001)

% Check that inputs are consistent
errstring = consist(mix, 'gmm', x);
if ~isempty(errstring)
  error(errstring);
end

% Compute activations
ndata = size(x, 1);
a     = zeros(ndata, mix.ncentres); 
normal = (2*pi)^(mix.nin/2);
for j = 1:mix.ncentres
%   diffs = x - (mix.centres(j, :) * W(j).w')';
%   %%a(:, j) = exp(-0.5*sum(diffs.*diffs,2) / mix.covars(j))./(normal*sqrt(mix.covars(j))); %% modif 27/11/09
%   C     = inv(diag( mix.covars(j,:)));%% modif 27/11/09
%   a(:, j) = exp(-0.5*(diffs' * C *diffs))./(normal*sqrt(det(C))); %% modif 27/11/09
  
  
  diffs = x - (mix.centres(j).c * W(j).w')';
  %diffs = x - ones(size(x,1),1)*mix.centres(j).c(:,3)';
  
  d2    = diffs .* diffs;
  d2    = sum(d2 ./ (ones(size(x,1),1)*mix.covars(j,:)),2);
  sj    = prod( mix.covars(j,:) );
  
  a(:, j) = exp(-0.5*d2) / (normal*sqrt(sj)); 
end

% Form dot product with priors
prob = a * (mix.priors)';