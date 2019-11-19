procedure( SSSNetShielding()
let( (obj)
	obj = css()
	if( obj~>objType == "pathSeg" then
		unless( boundp('sssNetShieldingForm) && hiIsFormDisplayed(sssNetShieldingForm)
			SSSNetShieldingForm()
		)
		hiDisplayForm(sssNetShieldingForm)
	else
		SSSPrint("no path selected" "w")
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>/" "SSSNetShielding()" )
