procedure( DILSyncFamilies()
let( ((obj nil) families)

	dilSyncClonesFormTabH = 10
	dilSyncClonesFormTabV = 10
	
	when( length(geGetSelSet()) == 1 obj = car(geGetSelSet()) )
	when( obj~>objType == "figGroup"
		dilFamilies = geGetEditCellView()~>families
		DILSyncFamiliesForm(obj families)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>/" "DILSyncFamilies()" )
