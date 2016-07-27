procedure( DILManipulateForm(cv obj)
let( 	(
		(field nil) (fields nil) (w 30) (h 30) (p 30) dx dy size
	)
	
	dx = dilFormTabV
	dy = dilFormTabH
	size = list(
			2*dx + 5*w
			4*dy + 8*h
		)

	field = list(
			hiCreateFrameField(
				?name 'fMove
				?labelText "Move"
			)
			0 :0
			5*w + 2*dx : 5*dy + 6*h
			p
		)
	fields = append1(fields field)
	
	
	field = list( hiCreateFloatField(
				?name 'flShift
				?defValue hiGetCurrentWindow()~>xSnapSpacing
				?prompt "Shift"
				?range list(0 1000)
			)
			dx + 1*w : dy
			3*w : 2*h
			p
	)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveUpDef
				?buttonText "U"
				?callback "DILManipulateFormMoveCB( cv obj \"u\" 1 )"
			)
			dx + 2*w : 3*dy + 2*h
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveDownDef
				?buttonText "D"
				?callback "DILManipulateFormMoveCB( cv obj \"d\" 1 )"
			)
			dx + 2*w : 3*dy + 4*h
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveLeftDef
				?buttonText "L"
				?callback "DILManipulateFormMoveCB( cv obj \"l\" 1 )"
			)
			dx + 1*w : 3*dy + 3*h
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveRightDef
				?buttonText "R"
				?callback "DILManipulateFormMoveCB( cv obj \"r\" 1 )"
			)
			dx + 3*w : 3*dy + 3*h
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveUp5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"u\" 5 )"
			)
			dx + 2*w: 3*dy + 1*h
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveDown5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"d\" 5 )"
			)
			dx + 2*w : 3*dy + 5*h
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveLeft5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"l\" 5 )"
			)
			dx : 3*dy + 3*h
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveRight5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"r\" 5 )"
			)
			dx + 4*w: 3*dy + 3*h
			w : h
		)
	fields = append1(fields field)
	
	hiCreateAppForm(
		?name 'dilManipulateForm
		?formTitle "Manipulate"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?maxSize size
		?fields fields
	)
);let
);procedure
