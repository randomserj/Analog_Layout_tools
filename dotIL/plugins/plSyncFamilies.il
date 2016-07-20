procedure( DILSyncFamilies()
let( ((obj nil))

	dilSyncFamiliesFormTabH = 10
	dilSyncFamiliesFormTabV = 10
	
	when( length(geGetSelSet()) == 1 obj = car(geGetSelSet()) )
	when( obj~>objType == "figGroup"
		DILSyncFamiliesForm(obj)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>/" "DILSyncFamilies()" )
