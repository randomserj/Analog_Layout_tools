procedure( SSSDefineMatching(@optional props)
let( ( inst insts )
	insts = setof( inst geGetSelSet() inst~>objType == "inst" )
	when( props insts = cadr(props) )
	if( insts then
		unless( boundp('sssDefineMatchingForm) && hiIsFormDisplayed(sssDefineMatchingForm)
			SSSDefineMatchingForm(insts props)
		)
		hiDisplayForm(sssDefineMatchingForm)
	else
		SSSPrint("no instances selected" "w")
	)
);let
);procedure

hiSetBindKey( "Schematics" "<Key>F4" "SSSDefineMatching()" )
hiSetBindKey( "Layout" "<Key>F4" "SSSDefineMatching(css()~>matching)" )
