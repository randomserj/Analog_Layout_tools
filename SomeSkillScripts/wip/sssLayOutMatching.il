procedure( SSSLayOutMatching()
let( ( obj objs )
	objs = setof( obj geGetSelSet() obj~>objType == "inst" )
	if( objs then
		unless( boundp('sssLayOutMatchingForm) && hiIsFormDisplayed(sssLayOutMatchingForm)
			SSSLayOutMatchingForm(objs)
		)
		hiDisplayForm(sssLayOutMatchingForm)
	else
		println("no objects selected\n")
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>F4" "SSSLayOutMatching()" )
