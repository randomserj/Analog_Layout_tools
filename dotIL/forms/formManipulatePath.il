procedure( DILManipulatePath(obj)
let( 	(
		form path ulX ulY dX dY sbW sbH bbW bbH size
		fMovePath bMoveUpDef bMoveDownDef bMoveLeftDef bMoveRightDef bMoveUp5x bMoveDown5x bMoveLeft5x bMoveRight5x
		fMoveX fMoveY fMoveW fMoveH
	)
	
	fMovePath = hiCreateFrameField(
		?name 'fMoveVIA
		?labelText "Move VIA"
	)
	bMoveUpDef = hiCreateButton(
		?name 'bMoveUpDef
		?buttonText "U"
		?callback "cbMovePath( obj \"h\" 1 )"
	)
	bMoveDownDef = hiCreateButton(
		?name 'bMoveDownDef
		?buttonText "D"
		?callback "cbMovePath( obj \"h\" -1 )"
	)
	bMoveLeftDef = hiCreateButton(
		?name 'bMoveLeftDef
		?buttonText "L"
		?callback "cbMovePath( obj \"v\" -1 )"
	)
	bMoveRightDef = hiCreateButton(
		?name 'bMoveRightDef
		?buttonText "R"
		?callback "cbMovePath( obj \"v\" 1 )"
	)
	bMoveUp5x = hiCreateButton(
		?name 'bMoveUp5x
		?buttonText "x5"
		?callback "cbMovePath( obj \"h\" 5 )"
	)
	bMoveDown5x = hiCreateButton(
		?name 'bMoveDown5x
		?buttonText "x5"
		?callback "cbMovePath( obj \"h\" -5 )"
	)
	bMoveLeft5x = hiCreateButton(
		?name 'bMoveLeft5x
		?buttonText "x5"
		?callback "cbMovePath( obj \"v\" -5 )"
	)
	bMoveRight5x = hiCreateButton(
		?name 'bMoveRight5x
		?buttonText "x5"
		?callback "cbMovePath( obj \"v\" 5 )"
	)
	
	ulX = 0
	ulY = 0
	dX = 10
	dY = 10
	sbW = 30
	sbH = 30
	bbW = 60
	bbH = 50
	
	fMoveX = ulX
	fMoveY = ulY
	fMoveW = 5*sbW + 2*dX
	fMoveH = 5*sbH + 3*dY
	
	size = list(350 500)
	hiCreateAppForm(
		?name 'viaManipulateForm
		?formTitle "VIA manipulate form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?maxSize size
		?fields list(
			list(fMovePath		fMoveX:fMoveY				fMoveW:fMoveH		30)
			
			list(bMoveUpDef		fMoveX+2*sbW+dX:fMoveY+1*sbH+dY		sbW:sbH)
			list(bMoveUp5x		fMoveX+2*sbW+dX:fMoveY+0*sbH+dY		sbW:sbH)
			list(bMoveDownDef	fMoveX+2*sbW+dX:fMoveY+3*sbH+dY		sbW:sbH)
			list(bMoveDown5x	fMoveX+2*sbW+dX:fMoveY+4*sbH+dY		sbW:sbH)
			list(bMoveLeftDef	fMoveX+1*sbW+dX:fMoveY+2*sbH+dY		sbW:sbH)
			list(bMoveLeft5x	fMoveX+0*sbW+dX:fMoveY+2*sbH+dY		sbW:sbH)
			list(bMoveRightDef	fMoveX+3*sbW+dX:fMoveY+2*sbH+dY		sbW:sbH)
			list(bMoveRight5x	fMoveX+4*sbW+dX:fMoveY+2*sbH+dY		sbW:sbH)	
		)
	)
	hiDisplayForm(viaManipulateForm)
);let
);procedure
