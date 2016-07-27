procedure( DILManipulate()
let( (cv obj)
	cv = geGetEditCellView()
	obj = car(geGetSelSet())
	unless( hiIsFormDisplayed(dilManipulateForm)
		DILManipulateForm(cv obj)
	)
	hiDisplayForm(dilManipulateForm)
);let
);procedure

hiSetBindKey( "Layout" "<Key>F3" "DILManipulate()" )
