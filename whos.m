function S = whos( SORT_ASC_BYTES )
%MYWHOS give information about matlab memory usage and workspace variables
% INPUT
%	var_whos	output of normal whos function


% get caller workspace
%var_whos = evalin('caller','[whos ; whos(''global'')]');
var_whos = evalin('caller',[ '[' orig_whos('') ';' orig_whos('global') ']']);

if nargout==1
	S = evalin('caller', orig_whos(''));
end


% EXECUTE PREFERENCES
if nargin>=1
	if SORT_ASC_BYTES
		[~ , tmp_sort_idx] = sort([var_whos.bytes]);
		var_whos = var_whos(tmp_sort_idx);
	end
end

%% set constants
% number of spaces per tab
if isCommandWindowOpen
	TAB_SPACE_LENGTH = com.mathworks.services.Prefs.getIntegerPref('CommandWindowSpacesPerTab');
	if TAB_SPACE_LENGTH==0
		TAB_SPACE_LENGTH=4; % set to default 
	end
else
	TAB_SPACE_LENGTH=8; % non commandwindow default
end

str_margin = '\t';

% filter out doubles
ii = 1;
while ii < length(var_whos)
	jj_remove = [];
	for jj=ii+1:length(var_whos)
		if isEqualVar(var_whos(ii), var_whos(jj))
			jj_remove = [jj_remove jj];
		end
	end
	var_whos(jj_remove)=[];
	ii=ii+1;
end


fn = fieldnames(var_whos);
num_fields = numel(fn);
num_vars = numel(var_whos);
if num_vars==0
	fprintf('workspace is empty\n\n');
	return;
end

var_ind(6)	= 9; % persistent
var_ind(1)	= 1; % name
var_ind(2)	= 2; % size
var_ind(3)	= 3; % bytes
var_ind(4)	= 4; % class
var_ind(5)	= 5; % global
num_output_fields = numel(var_ind);

% get output strings
var_info(num_vars) = struct('data',[]);
for jj = 1:num_vars
	var_info(jj).data{1}	=			var_whos(jj).(fn{var_ind(1)});
	var_info(jj).data{2}	= size2str(	var_whos(jj).(fn{var_ind(2)}));
	var_info(jj).data{3}	= byte2str(	var_whos(jj).(fn{var_ind(3)}));
	var_info(jj).data{4}	=			var_whos(jj).(fn{var_ind(4)});
	var_info(jj).data{5}	= bool2str(	var_whos(jj).(fn{var_ind(5)}));
	var_info(jj).data{6}	= bool2str(	var_whos(jj).(fn{var_ind(6)}));
end

% get max length of output strings + print field names (top line)
output_maxlen = zeros(num_output_fields,1);
for ii = 1:num_output_fields
	output_maxlen(ii) = max([length(fn{var_ind(ii)}) arrayfun(@(x) length(x.data{ii}),var_info)]);
	fprintf(['%s' str_margin],addPadding(fn{var_ind(ii)},output_maxlen(ii),TAB_SPACE_LENGTH));
end
fprintf('\n');

total_screen_len = sum(arrayfun(@(x) length(tab2space([addPadding('',x,TAB_SPACE_LENGTH) sprintf(str_margin)],TAB_SPACE_LENGTH)),output_maxlen));
disp(repmat('-',1,total_screen_len));

% print output
for jj = 1:num_vars
	for ii = 1:num_output_fields
		fprintf(['%s' str_margin],addPadding(var_info(jj).data{ii},output_maxlen(ii),TAB_SPACE_LENGTH));
	end
	fprintf('\n');
end

disp(repmat('-',1,total_screen_len));
total_bytes = sum([var_whos(:).bytes]);
byte_screen_len = sum(arrayfun(@(x) length(tab2space([addPadding('',x,TAB_SPACE_LENGTH) sprintf(str_margin)],TAB_SPACE_LENGTH)),output_maxlen(1:2)));
fprintf('%s%s\n', addPadding('Total:',byte_screen_len,TAB_SPACE_LENGTH), byte2str(total_bytes));
fprintf('\n');



end

function str = addPadding(str,total_length,TAB_SPACE_LENGTH)
	total_length = TAB_SPACE_LENGTH*ceil(total_length/TAB_SPACE_LENGTH);
	lenstr = length(tab2space(str,TAB_SPACE_LENGTH));
	if lenstr<total_length
		str = [str repmat(sprintf('\t'),1,ceil((total_length-lenstr)/TAB_SPACE_LENGTH))];
	end
end
function str = tab2space(str,TAB_SPACE_LENGTH)
	tidx = strfind(str,sprintf('\t'));
	while ~isempty(tidx)
		numspaces = TAB_SPACE_LENGTH-rem(tidx(1)-1,TAB_SPACE_LENGTH);
		str = [str(1:tidx(1)-1) repmat(' ',1,numspaces) str(tidx(1)+1:end)];
		tidx = strfind(str,sprintf('\t'));
	end
end
	

function retcmd = orig_whos(options)
	if nargin==0 || isempty(options)
		retcmd = ['builtin(''whos'')'];
	else
		retcmd = ['builtin(''whos'',''' options ''')'];
	end
end

function str = toString(var)
	str = evalc('disp(var)');
	str = strrep(str, sprintf('\n'),' ');
	str = strtrim(str);
end

function str = size2str(nsize)
	str = '';
	if ~isempty(nsize)
		str = int2str(nsize(1));
		for ii = 2:length(nsize)
			str = [str 'x' int2str(nsize(ii))];
		end
	end
end
function str = bool2str(b)
	if b
		str='true';
	else
		str='false';
	end
end
function str = byte2str(bytes)
% BYTES2STR Take integer bytes and convert it to scale-appropriate size.
scale = floor(log(bytes)/log(1024));
switch scale
	case 0
		str = sprintf('%7.0f\tB',bytes);
	case 1
		str = sprintf('%7.2f\tkB',bytes/(1024));
	case 2
		str = sprintf('%7.2f\tMB',bytes/(1024^2));
	case 3
		str = sprintf('%7.2f\tGB',bytes/(1024^3));
	case 4
		str = sprintf('%7.2f\tTB',bytes/(1024^4));
	case -inf
		% size == zero
		str = sprintf('      0\tB');
	otherwise
% 		str = 'Over a petabyte!!!';
		str = 'Over 9000!!';
	end
end

function retval = isEqualVar(v1,v2)
	retval = (strcmp(v1.name,v2.name) && v1.bytes==v2.bytes && ...
		all(v1.size==v2.size) && strcmp(v1.class,v2.class));
end

function retval = isCommandWindowOpen()
	if isOctave()
		retval = false;
	else
		% there are a few ways of doing this, not exactly sure which is correct	

		% retval = desktop('-inuse');

		jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
		retval = ~isempty(jDesktop.getClient('Command Window'));

		% clientTitles = jDesktop.getClientShortTitles
		% compare if any contains command window
	end
end

