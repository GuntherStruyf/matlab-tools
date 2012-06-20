function retval = isInt(val)
	retval = isscalar(val) && isnumeric(val) && isreal(val) && isfinite(val) && (val == fix(val));
end
