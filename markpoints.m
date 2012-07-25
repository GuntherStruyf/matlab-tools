function hfig = markpoints( x,y,idx_mark,mark_style,plot_style )
%MARKPOINTS 
if nargin<5
	plot_style = '.';
end
if nargin<4
	mark_style = 'or';
end


hfig = figure;hold on
plot(x,y,plot_style);
plot(x(idx_mark),y(idx_mark),mark_style);


end

