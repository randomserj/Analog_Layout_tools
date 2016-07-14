procedure( DILManipulate()
let( (obj)

	dilFormULX = 0
	dilFormULY = 0
	dilFormTabW = 10
	dilFormTabH = 10
	
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
