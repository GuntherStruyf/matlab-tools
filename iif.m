function val = iif(expr, truepart, falsepart)
	if isscalar(truepart)
		truepart=truepart(ones(size(expr)));
	end
	if isscalar(falsepart)
		falsepart=falsepart(ones(size(expr))); 
	end
	val = arrayfun(@iif_scalar, expr, truepart, falsepart);
end
function val = iif_scalar(expr,truepart,falsepart)
	if expr
		val = truepart;
	else
		val = falsepart;
	end
end
