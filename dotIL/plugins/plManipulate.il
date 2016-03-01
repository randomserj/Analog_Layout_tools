procedure( DILManipulate()
let( (obj)
	obj = car(geGetSelSet())
	case( obj~>objType
		( "stdVia"
			DILManipulateVIA(obj)
		)
		( "path"
			DILManipulatePath(obj)
		)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>;" "DILManipulate()" )
