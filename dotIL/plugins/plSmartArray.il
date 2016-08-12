procedure( DILSmartArray()
let( (obj (objs nil) elements nA nO (names nil))
	foreach( obj geGetSelSet()
		when( obj~>objType == "inst" objs = append1(objs obj) )
	)
	when( objs
		nA = length(dilAlphabet)
		nO = length(objs)
		dilElements = reverse(nthcdr(nA-nO reverse(dilAlphabet)))
		unless( boundp('dilSmartArrayForm) && hiIsFormDisplayed(dilSmartArrayForm)
			DILSmartArrayForm(objs)
		)
		hiDisplayForm(dilSmartArrayForm)
	)
);let
);procedure

hiSetBindKey( "Schematics" "<Key>F4" "DILSmartArray()" )
