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
		( "figGroup"
			DILManipulateGroup(obj)
		)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>;" "DILManipulate()" )
