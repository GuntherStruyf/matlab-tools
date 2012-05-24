function compare_profile_results(strfile1, strfile2 ,Ntop)
%COMPARE_PROFILE_RESULTS

TAB_SPACE_LENGTH = 4; % number of spaces per tab
str_margin = '\t';
if nargin<2
	error('no profiles to compare specified');
end
if nargin<3
	Ntop = 10;
end

% load profiles
if length(strfile1)>=4
	if ~strcmpi(strfile1(end-3:end),'.mat')
		strfile1 = [strfile1 '.mat'];
	end
else
	strfile1 = [strfile1 '.mat'];
end
if length(strfile2)>=4
	if ~strcmpi(strfile2(end-3:end),'.mat')
		strfile2 = [strfile2 '.mat'];
	end
else
	strfile2 = [strfile2 '.mat'];
end
profile(1) = load(strfile1);
profile(2) = load(strfile2);


% sort profile1 by name/total time
% profile(1).FunctionTable	= sortby_funname(profile(1).FunctionTable);
profile(1).FunctionTable	= sortby_funtime(profile(1).FunctionTable);


% regard the top 10 most time consuming functions of profile1 and compare
% with profile2
funname_len = max(maxlen(profile(1).FunctionTable),13);
funname_len = length(tab2space(sprintf([repmat(' ',1,funname_len) str_margin])));

fprintf(['%s' str_margin 'time 1' str_margin str_margin 'time 2\n'], addPadding('Function name',funname_len));
disp(repmat('-',1,funname_len+5*length(tab2space(str_margin)) + 2*6));
for jj = 1:min(Ntop, numel(profile(1).FunctionTable))
	strtime1	= sprintf('%2.3g',profile(1).FunctionTable(jj).TotalTime);
	ft2idx	= getFunStat(profile(1).FunctionTable(jj).FunctionName, profile(2).FunctionTable);
	if isempty(ft2idx) || ft2idx==0
		time2	= [];
	else
		time2	= profile(2).FunctionTable(ft2idx).TotalTime;
	end
	fprintf(['%s' str_margin '%s' str_margin '%2.3g\n'], addPadding(profile(1).FunctionTable(jj).FunctionName,funname_len),addPadding(strtime1,length(tab2space(sprintf(['time 1' str_margin])))),time2);
end

disp(repmat('-',1,funname_len+5*length(tab2space(str_margin)) + 2*6));







	function str = addPadding(str,total_length)
		total_length = TAB_SPACE_LENGTH*ceil(total_length/TAB_SPACE_LENGTH);
		lenstr = length(tab2space(str));
		if lenstr<total_length
			str = [str repmat(sprintf('\t'),1,ceil((total_length-lenstr)/TAB_SPACE_LENGTH))];
		end
	end
	function str = tab2space(str)
		tidx = strfind(str,sprintf('\t'));
		while ~isempty(tidx)
			numspaces = TAB_SPACE_LENGTH-rem(tidx(1)-1,TAB_SPACE_LENGTH);
			str = [str(1:tidx(1)-1) repmat(' ',1,numspaces) str(tidx(1)+1:end)];
			tidx = strfind(str,sprintf('\t'));
		end
	end
end

function FT = sortby_funtime(FT)
	[~, sort_idxs] = sort( [FT.TotalTime] , 'descend');
	FT = FT(sort_idxs);
end
function FT = sortby_funname(FT)
	[~, sort_idxs] = sort( {FT.FunctionName} );
	FT = FT(sort_idxs);
end
function m = maxlen(strarr)
	m = max(arrayfun(@(x) length(getShortName(x.FunctionName)), strarr));
end
function strName = getShortName(strName)
	ss = strfind(strName,'/');
	if ~isempty(ss)
		strName = strName(ss(end)+1:end);
	end
	dd = strfind(strName,'.');
	if ~isempty(dd);
		strName = strName(1:dd(end));
	end
end


function idx = getFunStat(strfunname, FT)
	for ii = 1:numel(FT)
		if strcmpi(strfunname, FT(ii).FunctionName)
			idx = ii;
			return;
		end
	end
	idx = 0;
end


