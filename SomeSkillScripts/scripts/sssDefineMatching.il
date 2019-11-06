procedure( SSSDefineMatching()
let( ( inst insts props )
	insts = setof( inst geGetSelSet() inst~>objType == "inst" )
	props = css()~>matching
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
