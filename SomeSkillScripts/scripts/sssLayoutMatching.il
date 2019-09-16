procedure( SSSLayOutMatching()
let( ( obj objs mDef)
	objs = setof( obj geGetSelSet() obj~>cellName == "matchingDef" )
	if( objs then
		mDef = car(objs)
		unless( boundp('sssLayOutMatchingForm) && hiIsFormDisplayed(sssLayOutMatchingForm)
			SSSLayOutMatchingForm(mDef)
		)
		hiDisplayForm(sssLayOutMatchingForm)
	else
		println("no objects selected")
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>F4" "SSSLayOutMatching()" )
