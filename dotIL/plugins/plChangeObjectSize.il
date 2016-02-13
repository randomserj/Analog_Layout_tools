printf("\tLoading bind keys to change size of objects...\n")

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

procedure( DILChangeNewObjectSize(k)
let( (l w envVar)
	envVar = sprintf(nil "%sWidth" dilIsDrawingType)
	w = leGetEnv(envVar)
	l = car(leGetEntryLayer())
	leSetEnv(envVar DILCalculateNewWidth(k l w))
	)
);let
);procedure

procedure( DILChangeExistedObjectSize(k)
let( (obj objs l w)
	objs = geGetSelSet()
	foreach( obj objs
		case( obj~>objType
			( "path" || "wire" || "pathSeg"
				l = obj~>layerName
				w = obj~>width
				obj~>width = DILCalculateNewWidth(k l w)	
			)
		)
	)
);let
);procedure

procedure( DILChangeObjectSize(k)
let( ()
	if( dilIsDrawing then
		DILChangeNewObjectSize(k)
	else
		DILChangeExistedObjectSize(k)
	)
);let
);procedure

hiSetBindKey("Layout" "<Key>[" "DILChangeObjectSize(-1)")
hiSetBindKey("Layout" "<Key>]" "DILChangeObjectSize(1)")
