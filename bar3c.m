function hh = bar3c( varargin )
%BAR3C Summary of this function goes here
%   Detailed explanation goes here
	
	h = bar3(varargin{:});
	for ii = 1:numel(h)
		zdata = get(h(ii),'Zdata');
		N = size(zdata,1)/6;
		
		zdata = zdata(2:6:end,2);
		expand_idx = reshape(repmat(1:N,6,1),[],1);
		cdata = repmat(zdata(expand_idx),1,4);
		
		set(h(ii),'Cdata',cdata, 'facecolor','flat');
	end
	
	if nargout>0, 
		hh = h; 
	end
end

