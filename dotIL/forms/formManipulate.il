procedure( DILManipulateForm(cv obj)
let( 	(
		(field nil) (fields nil) (w 30) (h 30) (p 30) (x0 0) (y0 0) dx dy size
	)
	
	dx = dilFormTabV
	dy = dilFormTabH
	size = list(
			2*dx + 5*w
			9*h + 6*dy
		)

;;;;;;;; Frames

	field = list(
			hiCreateFrameField(
				?name 'fMove
				?labelText "Move"
			)
			x0 : y0
			5*w + 2*dx : 6*h + 5*dy
			p
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateFrameField(
				?name 'fRoteta
				?labelText "Rotate"
			)
			x0 : 6*h + 5*dy
			5*w + 2*dx : 1*h + 2*dy
			p
		)
	fields = append1(fields field)
	
;;;;;;;; Move
	
	field = list( hiCreateFloatField(
				?name 'flShift
				?defValue hiGetCurrentWindow()~>xSnapSpacing
				?prompt "Shift"
				?range list(0 1000)
			)
			1*w + dx : 0*h + 2*dy
			3*w : 1*h
			p
	)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveUpDef
				?buttonText "U"
				?callback "DILManipulateFormMoveCB( cv obj \"u\" 1 )"
			)
			2*w + dx : 2*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveDownDef
				?buttonText "D"
				?callback "DILManipulateFormMoveCB( cv obj \"d\" 1 )"
			)
			2*w + dx : 4*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveLeftDef
				?buttonText "L"
				?callback "DILManipulateFormMoveCB( cv obj \"l\" 1 )"
			)
			1*w + dx : 3*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveRightDef
				?buttonText "R"
				?callback "DILManipulateFormMoveCB( cv obj \"r\" 1 )"
			)
			3*w + dx : 3*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveUp5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"u\" 5 )"
			)
			2*w + dx: 1*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveDown5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"d\" 5 )"
			)
			2*w + dx : 5*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveLeft5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"l\" 5 )"
			)
			0*w + dx : 3*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
	field = list(
			hiCreateButton(
				?name 'bMoveRight5x
				?buttonText "x5"
				?callback "DILManipulateFormMoveCB( cv obj \"r\" 5 )"
			)
			4*w + dx: 3*h + 3*dy
			w : h
		)
	fields = append1(fields field)
	
;;;;;;;; Rotate
	
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
