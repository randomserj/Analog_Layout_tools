procedure( DILSmartVia()
let( (obj)
	obj = car(geGetSelSet())
	when( obj~>objType == "stdVia"
		DILSmartViaForm(obj)
		hiDisplayForm('dilSmartViaForm)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>;" "DILSmartVia()" )
