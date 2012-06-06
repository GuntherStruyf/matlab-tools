function zoomout(haxis, fr )
%expandAxis(hfig, zoomout )
%
% Expand the axis of a figure with a factor.
%
%INPUT:
%	haxis		Figure handle. Default: gca
%	fr			Factor to zoomout to. Default: 1.1

	if nargin<1
		haxis = gca;
	end
	if nargin<2
		fr = 1.1;
	end

	XL = xlim(haxis);
	YL = ylim(haxis);

	xlim(haxis, XL + [-1 1]*(fr-1)*diff(XL));
	ylim(haxis, YL + [-1 1]*(fr-1)*diff(YL));
end
