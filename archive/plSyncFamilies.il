procedure( DILSyncFamilies()
let( ((obj nil))

	dilSyncFamiliesFormTabH = 10
	dilSyncFamiliesFormTabV = 10
	
	obj = car(geGetSelSet())
	when( obj~>objType == "figGroup"
		unless( boundp('dilSyncFamiliesForm) && hiIsFormDisplayed(dilSyncFamiliesForm)
			DILSyncFamiliesForm(obj)
		)
		hiDisplayForm(dilSyncFamiliesForm)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>/" "DILSyncFamilies()" )
