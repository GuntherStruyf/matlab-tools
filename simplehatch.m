function simplehatch(xmin,xmax,ymin,ymax,       N,clr,theta,linestyle,          box,boxclr)
% FUNCTION simplehatch(xmin,xmax,ymin,ymax,N,clr,theta,box)
%       draws a hatch
%
%       xmin, xmax      : x limits
%       ymin, ymax      : y limits
%
%       --- following arguments are optional
%       N                       : number of lines to draw
%       clr                     : line color
%       theta           : angle of the lines vs the horizontal
%       box                     : draw a box around the hatch
%       boxclr          : box color

%% init
if nargin < 4
        xmin=-2;
        xmax=2;
        ymin=-3;
        ymax=7;
end
if nargin<5
        N=30;
elseif N<=0
        return;
end
if nargin<6
        clr='red';
end
if nargin<7
        theta=pi/4;     % 45°
end
if nargin<8
        linestyle='-';
end
if nargin<9
        box=false;
end
if nargin<10
        boxclr='black';
end

if xmax<xmin
        tmp=xmax;
        xmax=xmin;
        xmin=tmp;
end
if ymax<ymin
        tmp=ymax;
        ymax=ymin;
        ymin=tmp;
end

%% configure bounds
X=xmax-xmin;
Y=ymax-ymin;
a=tan(theta); % rico: y=a*x

%% setup points
if a==0 % horizontal lines
        Xstart  = xmin*ones(1,N);
        Xend    = xmax*ones(1,N);
        Ystart  = linspace(ymin,ymax,N+2);
        Ystart  = Ystart(2:end-1);
        Yend    = Ystart;
else % other
        if a>0 % start on bottom, extend x to the left
                Ystart  = ymin*ones(1,N);
                Yend    = ymax*ones(1,N);
        else % start on top, extend x to the left
                Ystart  = ymax*ones(1,N);
                Yend    = ymin*ones(1,N);
                Y=-Y;
        end
        % this way, Xstart<Xend  always! --> easier check for bordercrossing
        Xstart  = linspace(xmin-Y/a,xmax,N+2);
        Xstart  = Xstart(2:end-1);
        Xend    = Xstart+Y/a;
        
        % cut off left edge:
        idx     = Xstart<xmin;
        Ystart(idx) = Ystart(idx) + a*(xmin-Xstart(idx));
        Xstart(idx) = xmin;
        
        % right edge:
        idx     = Xend>xmax;
        Yend(idx) = Ystart(idx) + a*(xmax-Xstart(idx));
        Xend(idx) = xmax;
        
end

%% plot
% line(X,Y) : rows are connected, columns are seperate lines
% line( [x1 x3] ,       [y1 y3] )
%               [x2 x4]         [y2 y4]
% plots two lines: one from (x1,y1) to (x2,y2)
%                          and one from (x3,y3) to (x4,y4)
line([Xstart;Xend],[Ystart;Yend],'Color',clr,'Linestyle',linestyle)

if box
        line([xmin;xmin;xmax;xmax;xmin],[ymin;ymax;ymax;ymin;ymin],'Color',boxclr);
end

end
