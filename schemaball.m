function schemaball(varnames, corrMatrix)
corrMatrix = rand(20).^2;	

	M = length(corrMatrix);
	R = 1;
	Nbezier = 100;
	bezierR = 0.1;
	markerR = 0.01;
	labelR = 1.1;
	
	theta = linspace(0,2*pi,M+1);
	theta(end)=[];
	
	[Px,Py] = pol2cart(theta,R);
	P = [Px ;Py];
	
	
	figure; hold all
	set(gca,'color','black');
	axis equal
	%% draw diagonals
	% if you draw the brightest lines first and then the darker lines, the
	% latter will cut through the former and make it look like they have
	% holes. Therefore, sort and draw them in order (darkest first).
	idx = reshape(1:M^2,M,M);
	idx = idx(tril(idx)==0);
	[~,sort_idx]=sort(corrMatrix(idx));
	idx = idx(sort_idx);
	
	for ii=1:numel(sort_idx)
		[jj,kk]=ind2sub([M M],ii);
		[P1x,P1y] = pol2cart((theta(jj)+theta(kk))/2,bezierR);
		Bt = getQuadBezier(P(:,jj),[P1x;P1y],P(:,kk), Nbezier);
		plot(Bt(:,1),Bt(:,2),'color',hsv2rgb([0.1587 0.8750 corrMatrix(jj,kk)]));
	end
	
	%% draw edge markers
	[Px,Py] = pol2cart(theta,R+markerR);
	% base the color of the node on the 'degree of correlation' with other
	% variables:
	V = sum(corrMatrix,2);
	V=V./max(V(:));
	clr = hsv2rgb([ones(M,1)*[0.585 0.5765] V]);
	scatter(Px,Py,20,clr);
	
	%% draw labels
	[Px,Py] = pol2cart(theta,labelR);
	for ii=1:M
		
	end
end
function Bt = getQuadBezier(p0,p1,p2,N)
	% defining Bezier Geometric Matrix B
	B = [p0(:) p1(:) p2(:)]';
	
	% Bezier Basis transformation Matrix M
	M =[1	0	0;
		-2	2	0;
		1	-2	1];
	% Calculation of Algebraic Coefficient Matrix A
	A = M*B;
	% defining t axis
	t = linspace(0,1,N)';
	T = [ones(size(t)) t t.^2];
	% calculation of value of function Bt for each value of t
	Bt = T*A;
end
