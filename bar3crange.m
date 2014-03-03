function hh = bar3crange(edges, varargin )
%BAR3C Extension of bar3, which sets the bar color corresponding to its
%height.
%
% INPUT
%	edges	A vector of bin dividers, the colors will be uniform inside
%			each bin.
%
	h = bar3(varargin{:});
	for ii = 1:numel(h)
		zdata = get(h(ii),'Zdata');
		cdata = makecdata(bincolor(edges,zdata(2:6:end,2)));
		set(h(ii),'Cdata',cdata, 'facecolor','flat');
	end
	
	if nargout>0, 
		hh = h; 
	end
end
function cdata = makecdata(clrs)
	cdata = NaN(6*numel(clrs),4);
	for ii=1:numel(clrs)
		cdata((ii-1)*6+(1:6),:)=makesingle_cdata(clrs(ii));
	end
end
function scdata = makesingle_cdata(clr)
	scdata = NaN(6,4);
	scdata(sub2ind(size(scdata),[3,2,2,1,2,4],[2,1,2,2,3,2]))=clr;
end
function clrs = bincolor(edges, vals)
	[~, clrs] = histc(vals,edges);
	clrs(clrs==0)=nan;
end