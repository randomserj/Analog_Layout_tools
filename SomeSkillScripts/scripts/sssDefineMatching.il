procedure( SSSDefineMatching()
let( ( inst insts )
	insts = setof( inst geGetSelSet() inst~>objType == "inst" )
	if( insts then
		unless( boundp('sssDefineMatchingForm) && hiIsFormDisplayed(sssDefineMatchingForm)
			SSSDefineMatchingForm(insts)
		)
		hiDisplayForm(sssDefineMatchingForm)
	else
		println("no instances selected")
	)
);let
);procedure

hiSetBindKey( "Schematics" "<Key>F4" "SSSDefineMatching()" )
