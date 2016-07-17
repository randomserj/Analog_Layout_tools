procedure( DILManipulateGroup(obj)
let( 	(
		fMoveGroup bMoveUpDef bMoveDownDef bMoveLeftDef bMoveRightDef bMoveUp5x bMoveDown5x bMoveLeft5x bMoveRight5x
		bMoveX bMoveY bMoveW bMoveH
		fPattern tPattern
		tPatternX tPatternY tPatternW tPatternH
	)
	
	fMoveGroup = hiCreateFrameField(
		?name 'fMoveGroup
		?labelText "Move Group"
	)
	bMoveUpDef = hiCreateButton(
		?name 'bMoveUpDef
		?buttonText "U"
		?callback "cbGroupMove( obj \"u\" 1 )"
	)
	bMoveDownDef = hiCreateButton(
		?name 'bMoveDownDef
		?buttonText "D"
		?callback "cbGroupMove( obj \"d\" 1 )"
	)
	bMoveLeftDef = hiCreateButton(
		?name 'bMoveLeftDef
		?buttonText "L"
		?callback "cbGroupMove( obj \"l\" 1 )"
	)
	bMoveRightDef = hiCreateButton(
		?name 'bMoveRightDef
		?buttonText "R"
		?callback "cbGroupMove( obj \"r\" 1 )"
	)
	bMoveUp5x = hiCreateButton(
		?name 'bMoveUp5x
		?buttonText "x5"
		?callback "cbGroupMove( obj \"u\" 5 )"
	)
	bMoveDown5x = hiCreateButton(
		?name 'bMoveDown5x
		?buttonText "x5"
		?callback "cbGroupMove( obj \"d\" 5 )"
	)
	bMoveLeft5x = hiCreateButton(
		?name 'bMoveLeft5x
		?buttonText "x5"
		?callback "cbGroupMove( obj \"l\" 5 )"
	)
	bMoveRight5x = hiCreateButton(
		?name 'bMoveRight5x
		?buttonText "x5"
		?callback "cbGroupMove( obj \"r\" 5 )"
	)
	
	fPattern = hiCreateFrameField(
		?name 'fPattern
		?labelText "Pattern"
	)
	tPattern = hiCreateMLTextField(
		?name 'tPattern
		?prompt ""
		?defValue ""
		?hasVerticalScrollbar t
		?hasHorizontalScrollbar t	
	)
	
	bMoveX = dilFormULX + dilFormTabW
	bMoveY = dilFormULY + 2*dilFormTabH
	bMoveW = 30
	bMoveH = 30
	
	tPatternX = 5*bMoveW + 4*dilFormTabW
	tPatternY = bMoveY
	tPatternW = 5*bMoveW
	tPatternH = 5*bMoveH
	
	size = list(350 tPatternY+tPatternH+4*dilFormTabH)
	hiCreateAppForm(
		?name 'groupManipulateForm
		?formTitle "Group manipulate form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?maxSize size
		?fields list(
				list(fMoveGroup		bMoveX-dilFormTabW:bMoveY-2*dilFormTabH		5*bMoveW+2*dilFormTabW:5*bMoveH+3*dilFormTabH		30)
				list(fPattern		tPatternX-dilFormTabW:tPatternY-2*dilFormTabH	tPatternW+2*dilFormTabW:tPatternH+3*dilFormTabH		30)

				list(bMoveUpDef		bMoveX+2*bMoveW:bMoveY+1*bMoveH		bMoveW:bMoveH)
				list(bMoveUp5x		bMoveX+2*bMoveW:bMoveY+0*bMoveH		bMoveW:bMoveH)
				list(bMoveDownDef	bMoveX+2*bMoveW:bMoveY+3*bMoveH		bMoveW:bMoveH)
				list(bMoveDown5x	bMoveX+2*bMoveW:bMoveY+4*bMoveH		bMoveW:bMoveH)
				list(bMoveLeftDef	bMoveX+1*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
				list(bMoveLeft5x	bMoveX+0*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
				list(bMoveRightDef	bMoveX+3*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
				list(bMoveRight5x	bMoveX+4*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
				
				list(tPattern		tPatternX:tPatternY			tPatternW:tPatternH)
		)
		?callback "cbPlaceGroup(obj groupManipulateForm~>tPattern~>value)"
	)
	hiDisplayForm(groupManipulateForm)
);let
);procedure
