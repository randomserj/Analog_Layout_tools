procedure( DILSmartArray()
let( (objs rows columns elements)
	objs = geGetSelSet()
	rows = 4
	columns = 4
	elements = list("d" "A" "B" "C" "D")
	;unless( boundp('formSmartArray)
		DILSmartArrayForm(objs elements rows columns)
	;)
	hiDisplayForm(formSmartArray)
);let
);procedure

hiSetBindKey( "Layout" "<Key>F4" "DILSmartArray()" )
