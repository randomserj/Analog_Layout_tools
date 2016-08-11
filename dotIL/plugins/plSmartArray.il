procedure( DILSmartArray()
let( (obj objs alphabet elements nA nO (names nil))
	alphabet = list("A" "B" "C" "D" "E" "F" "G" "H")
	objs = geGetSelSet()
	nA = length(alphabet)
	nO = length(objs)
	dilElements = reverse(nthcdr(nA-nO reverse(alphabet)))
	unless( boundp('dilSmartArrayInitForm) && hiIsFormDisplayed(dilSmartArrayInitForm)
		DILSmartArrayInitForm(objs)
	)
	hiDisplayForm(dilSmartArrayInitForm)
);let
);procedure

hiSetBindKey( "Schematics" "<Key>F4" "DILSmartArray()" )
