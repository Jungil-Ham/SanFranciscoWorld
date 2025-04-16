function b = catuneven(dim, padval, varargin);
ndim = max(cellfun(@ndims, varargin));
ndim = max(ndim, dim);
for ii = 1:ndim
    sz(:,ii) = cellfun(@(x) size(x, ii), varargin);
end
maxsz = max(sz, [], 1);
nv = length(varargin);
val = cell(size(varargin));
for ii = 1:nv
    sztmp = maxsz;
    sztmp(dim) = sz(ii,dim);
      idx = cell(ndim,1);
      [idx{:}] = ind2sub(sz(ii,:), 1:numel(varargin{ii}));
      idxnew = sub2ind(sztmp, idx{:});
      val{ii} = ones(sztmp) * padval;
      val{ii}(idxnew) = varargin{ii};
end
b = cat(dim, val{:});