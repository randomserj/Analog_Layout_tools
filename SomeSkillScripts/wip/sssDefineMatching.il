procedure( SSSDefineMatching()
let( ( obj objs )
	objs = setof( obj geGetSelSet() obj~>objType == "inst" && obj~>cellName != "matchingDef" )
	if( objs then
		unless( boundp('sssDefineMatchingForm) && hiIsFormDisplayed(sssDefineMatchingForm)
			SSSDefineMatchingForm(objs)
		)
		hiDisplayForm(sssDefineMatchingForm)
	else
		println("no objects selected")
	)
);let
);procedure

hiSetBindKey( "Schematics" "<Key>F4" "SSSDefineMatching()" )
