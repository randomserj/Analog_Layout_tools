procedure( DILManipulateVIA(obj)
let( 	(
		form 
		lMoveVIA bMoveUpDef bMoveDownDef bMoveLeftDef bMoveRightDef
		bMoveX bMoveY bMoveW bMoveH
		lStackVIA bAddAboveStackVIA bAddBelowStackVIA bRemoveStackVIA
		bStackX bStackY bStackW bStackH
	)
	
	lMoveVIA = hiCreateLabel(
		?name 'lMoveVIA
		?labelText "Move VIA"
	)
	bMoveUpDef = hiCreateButton(
		?name 'bMoveUpDef
		?buttonText "U"
		?callback "cbVIAMove( obj \"u\" 1 )"
	)
	bMoveDownDef = hiCreateButton(
		?name 'bMoveDownDef
		?buttonText "D"
		?callback "cbVIAMove( obj \"d\" 1 )"
	)
	bMoveLeftDef = hiCreateButton(
		?name 'bMoveLeftDef
		?buttonText "L"
		?callback "cbVIAMove( obj \"l\" 1 )"
	)
	bMoveRightDef = hiCreateButton(
		?name 'bMoveRightDef
		?buttonText "R"
		?callback "cbVIAMove( obj \"r\" 1 )"
	)
	bMoveUp5x = hiCreateButton(
		?name 'bMoveUp5x
		?buttonText "x5"
		?callback "cbVIAMove( obj \"u\" 5 )"
	)
	bMoveDown5x = hiCreateButton(
		?name 'bMoveDown5x
		?buttonText "x5"
		?callback "cbVIAMove( obj \"d\" 5 )"
	)
	bMoveLeft5x = hiCreateButton(
		?name 'bMoveLeft5x
		?buttonText "x5"
		?callback "cbVIAMove( obj \"l\" 5 )"
	)
	bMoveRight5x = hiCreateButton(
		?name 'bMoveRight5x
		?buttonText "x5"
		?callback "cbVIAMove( obj \"r\" 5 )"
	)
	
	lStackVIA = hiCreateLabel(
		?name 'lStackVIA
		?labelText "Stack"
	)
	bAddAboveStackVIA = hiCreateButton(
		?name 'bAddAboveStackVIA
		?buttonText "Above"
		?callback "cbAddStackVIA( obj t )"
	)
	bAddBelowStackVIA = hiCreateButton(
		?name 'bAddBelowStackVIA
		?buttonText "Below"
		?callback "cbAddStackVIA( obj nil )"
	)
	bRemoveStackVIA = hiCreateButton(
		?name 'bRemoveStackVIA
		?buttonText "Remove"
		?callback "cbRemStackVIA( obj )"
	)
	
	bMoveX = 10
	bMoveY = 60
	bMoveW = 25
	bMoveH = 25
	
	hiCreateAppForm(
		?name 'viaManipulateForm
		?formTitle "VIA manipulate form"
		?buttonLayout 'OKCancel
		?fields list(
			list(lMoveVIA		bMoveX+1*bMoveW:bMoveY-1*bMoveH		3*bMoveW:bMoveH)
			list(bMoveUpDef		bMoveX+2*bMoveW:bMoveY+1*bMoveH		bMoveW:bMoveH)
			list(bMoveUp5x		bMoveX+2*bMoveW:bMoveY+0*bMoveH		bMoveW:bMoveH)
			list(bMoveDownDef	bMoveX+2*bMoveW:bMoveY+3*bMoveH		bMoveW:bMoveH)
			list(bMoveDown5x	bMoveX+2*bMoveW:bMoveY+4*bMoveH		bMoveW:bMoveH)
			list(bMoveLeftDef	bMoveX+1*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			list(bMoveLeft5x	bMoveX+0*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			list(bMoveRightDef	bMoveX+3*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			list(bMoveRight5x	bMoveX+4*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			
			list(lStackVIA		190:10 50:50)
			list(bAddAboveStackVIA	190:60 50:50)
			list(bAddBelowStackVIA	190:110 50:50)
			list(bRemoveStackVIA	190:160 50:50)
		)
	)
	hiDisplayForm(viaManipulateForm)
);let
);procedure
