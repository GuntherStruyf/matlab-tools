function saveprofile_info()
%SAVEPROFILE_INFO save profiling info to a mat file for later use and
%comparison

s = profile('status');
if ~strcmpi(s.ProfilerStatus,'on')
	warning('SAVEPROFILE_INFO:NO_DATA','Profiling is off, no profiling info saved');
else
	if nargin<1
		p = profile('info');
	end

	strdir	= fullfile(cd,'profiling_results');
	strfile	= ['profile_' datestr(now,'yyyymmdd_HHMMSS') '.mat'];
	if ~exist(strdir,'dir')
		mkdir(strdir);
	end

	save( fullfile(strdir,strfile),'-struct','p')
end

end

