function distxy = getDistMatrix( siz, refpos )
%GETDISTMATRIX Calculate the distances in a N-D grid from one
% reference point to all other points on the grid.


if nargin==0
	% demo mode
	siz = [4 3];
	refpos = [1 1];
end

siz = siz(:)';
refpos = refpos(:)';
N = numel(siz);
M = prod(siz);
if numel(refpos)~=N
	error('argument mismatch');
end
if any(refpos>siz)||any(refpos<1)
	error('reference position out of matrix scope');
end


% % speedup: take advantage of mirror symmetry around refpos
% maxsubsize = max([siz-refpos+1	; refpos],[],1);
% 
% % speedup: take advantage of point symmetry around refpos
% % ...


% just calculate it all
distxy = zeros(siz);
for ii=1:numel(siz)
	s = siz; s(ii) = [];
	
	x = ((1:siz(ii))' - refpos(ii)).^2;
	
	% speedup: instead of repmat, use tmpdist(ones(...),...) or something alike
% 	distxy = distxy + reshape( x(:,ones(prod(s),1)),siz);
	distxy = distxy + permute(reshape( x(:,ones(prod(s),1)),[siz(ii) s]),[2:ii 1 ii+1:N]);
end

distxy = sqrt(distxy);

% % % % % just calculate it all
% % % % distxy = zeros(sizeM);
% % % % for ii=1:numel(sizeM)
% % % % 	tmpdist = ((1:sizeM(ii)) - refpos(ii)).^2;
% % % % 	tmpsize = [ones(1,ii-1) sizeM(ii) ones(1,N-ii)];
% % % % 	tmpsize2 = sizeM - tmpsize+1;
% % % % 	
% % % % 	distxy = distxy + repmat(reshape(tmpdist,tmpsize),tmpsize2);
% % % % 	% speedup: instead of repmat, use tmpdist(ones(...),...) or something alike
% % % % end
% % % % 
% % % % distxy = sqrt(distxy);

end


