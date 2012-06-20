function retval = isInt(val)
	if length(val)==1
		retval = isnumeric(val) && isreal(val) && isfinite(val) && (val == fix(val));
	else
		retval = false;
	end
end
