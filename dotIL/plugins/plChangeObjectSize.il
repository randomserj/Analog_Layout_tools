printf("\tLoading bind keys to change size of objects...\n")

procedure( DILCustomRoutingObjectWidth(k)
let( (l w)
	case( dilIsDrawingType
	("path"
		w = leGetEnv("pathWidth")
		l = car(leGetEntryLayer())
		leSetEnv("pathWidth" DILCalculateNewWidth(k l w))
	)
	("wire"
		w = leGetEnv("wireWidth")
		l = car(leGetEntryLayer())
		leSetEnv("wireWidth" DILCalculateNewWidth(k l w))
	)
	)
);let
);procedure

procedure( DILRoutingObjectWidth(k)
let( (shape shapes l w m ms)
	shapes = geGetSelSet()
	foreach( shape shapes
		if( shape~>objType == "path" || shape~>objType == "pathSeg" then
			l = shape~>layerName
			w = shape~>width
			shape~>width = DILCalculateNewWidth(k l w)
		)
	)
);let
);procedure

procedure( DILCalculateNewWidth(k l w)
prog( (m ms a b c)
	if( !member(l dilMetals) then
		printf("[WARNING] Selected layer is not a metal layer, the width won't be changed\n")
		return(w)
	)
	ms = dilMetalWidthList
	foreach( m ms
		if( l == nth(0 m) then
			a = nth(1 m)
			b = nth(2 m)
			if( w < a && k == 1 then
				return(a)
			else
				c = truncate( (w + k*0.001 - a)/b )
				return( a + b*(c + (k+1)/2) )
			)
		)
	)
);prog
);procedure

procedure( DILChangeObjectSize(k)
let( ()
	if( dilIsDrawing then
		DILCustomRoutingObjectWidth(k)
	else
		DILRoutingObjectWidth(k)
	)
);let
);procedure

hiSetBindKey("Layout" "<Key>[" "DILChangeObjectSize(-1)")
hiSetBindKey("Layout" "<Key>]" "DILChangeObjectSize(1)")
