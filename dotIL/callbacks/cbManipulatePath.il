procedure( cbMovePath(o action m)
let( (p ps x y dx dy (pts list()))
	ps = o~>points
	s = techGetMfgGridResolution(dilTechFile) * m
	case( action
		( "h" dx = 0 dy = s )
		( "v" dx = s dy = 0 )
	)
	foreach( p ps
		x = car(p) + dx
		y = cadr(p) + dy
		pts = append1(pts list(x y))
	)
	o~>points = pts
);let
);procedure
