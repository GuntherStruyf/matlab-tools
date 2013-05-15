function retval = isOctave()
	persistent octave_it_is;
	if isempty(octave_it_is)
		octave_it_is = (exist('OCTAVE_VERSION','builtin')~=0);
	end
	retval = octave_it_is;
end