function hh = bar3c( varargin )
%BAR3C Summary of this function goes here
%   Detailed explanation goes here
% extra parameter: 'absClr', absClr_value
% will set the cdata of the bottom of each bar to this value
% Hereby, this is the maximum color value in the plot, and all other 
% color values can be absolute to this reference.
%
	
	[abscolor, idxabsc]=getarg('absClr',varargin{:});
	if idxabsc
		varargin(idxabsc+(0:1))=[];
	end
	
	h = bar3(varargin{:});
	for ii = 1:numel(h)
		zdata = get(h(ii),'Zdata');
		N = size(zdata,1)/6;
		
		zdata = zdata(2:6:end,2);
		expand_idx = reshape(repmat(1:N,6,1),[],1);
		cdata = repmat(zdata(expand_idx),1,4);
		
% 		if idxabsc
% 			cdata;
% 		end
% 		
		set(h(ii),'Cdata',cdata, 'facecolor','flat');
	end
	
	if nargout>0, 
		hh = h; 
	end
end

function [val, idx] = getarg(strname,varargin)
	idx = 0;
	val = 0;
	for jj=1:nargin-2
		if strcmpi(varargin{jj},strname)
			idx = jj;
			val = varargin{jj+1};
			return;
		end
	end
end

