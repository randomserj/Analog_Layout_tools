procedure( DILSmartVia()
let( (obj)
	obj = car(geGetSelSet())
	when( obj~>objType == "stdVia"
		unless( boundp('dilSmartViaForm) && hiIsFormDisplayed(dilSmartViaForm)
			DILSmartViaForm(obj)
		)
		hiDisplayForm('dilSmartViaForm)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>;" "DILSmartVia()" )
