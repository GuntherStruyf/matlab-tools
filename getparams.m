function [ inp, outp ] = getparams ( func )

if ~ischar(func)
	s=inputname(1);
	[~,func,~] = fileparts(s);
end
s = which(func);

fid = fopen(s);
% assuming the header is on line 1, so there are no leading blank lines
strheader = strrep(fgetl(fid),' ',''); % remove all those nasty spaces
fclose(fid);

eqp = strfind(strheader,'=');

strh1 = strheader(10:eqp-1); % get rid of 'function '
strh1 = regexprep(strh1,'[\[\]]','');
inp = textscan(strh1,'%s','Delimiter',',');

strh2 = strheader(eqp+length(func)+2:end-1);
outp = textscan(strh2,'%s','Delimiter',',');


end

