procedure( DILGetTemplatesVIA(p)
let( (file line name (tmpls list()) )
	file = infile(path)
	when( file
		while( gets(line file)
			line = strncat( "" line strlen(line)-1 )
			when( rexMatchp("^name=" line)
				name = cadr(parseString( line "=" ))
				tmpls = append1(tmpls name)
			)
		)
	)
	tmpls
);
);procedure

procedure( DILManipulateVIA(obj)
let( 	(
		form path ulX ulY tabW tabH size
		fMoveVIA bMoveUpDef bMoveDownDef bMoveLeftDef bMoveRightDef bMoveUp5x bMoveDown5x bMoveLeft5x bMoveRight5x
		bMoveX bMoveY bMoveW bMoveH
		fStackVIA bAddAboveStackVIA bAddBelowStackVIA bRemoveStackVIA
		bStackX bStackY bStackW bStackH
		fTemplatesVIA cTemplatesVIA bSaveTemplatesVIA bLoadTemplatesVIA lLoadTemplatesVIA
		bTmplX bTmplY bTmplW bTmplH
		fLayerVIA bLayerX bLayerY bLayerW bLayerH
		fGeneralVIA sRowsVIA sColumnsVIA sRowsSpVIA sColumnsSpVIA
		fGenX fGenY fGenW fGenH
		fEncVIA sEncVVIA sEncHVIA
		fEncX fEncY fEncW fEncH
		bApplyVIA
	)
	
	path = strcat( getWorkingDir() "/.il/vias.tmpl" )
	
	fMoveVIA = hiCreateFrameField(
		?name 'fMoveVIA
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
	
	fStackVIA = hiCreateFrameField(
		?name 'fStackVIA
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
	
	fLayerVIA = hiCreateFrameField(
		?name 'fLayerVIA
		?labelText "Layer"
	)
	
	fTemplatesVIA = hiCreateFrameField(
		?name 'fTemplatesVIA
		?labelText "Template"
	)
	cTemplatesVIA = hiCreateComboField(
		?name 'cTemplatesVIA
		?items DILGetTemplatesVIA(path)
		?editable t
	)
	bSaveTemplatesVIA = hiCreateButton(
		?name 'bTest
		?buttonText "Save"
		?callback "cbSaveTemplatesVIA(viaManipulateForm~>cTemplatesVIA~>value) viaManipulateForm~>cTemplatesVIA~>items = DILGetTemplatesVIA(path)"
	)
	bLoadTemplatesVIA = hiCreateButton(
		?name 'bTestL
		?buttonText "Load"
		?callback "cbLoadTemplatesVIA(viaManipulateForm~>cTemplatesVIA~>value)"
	)
	lLoadTemplatesVIA = hiCreateLabel(
		?name 'lLoadTemplatesVIA
		?labelText "."
		?invisible t
	)
	
	fGeneralVIA = hiCreateFrameField(
		?name 'fGeneralVIA
		?labelText "General"
	)
	sRowsVIA = hiCreateSpinBox(
		?name 'sRowsVIA
		?prompt "Rows"
		?value obj~>cutRows
		?range list(0 100)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "cbApplyVIA(obj)"
	)
	sColumnsVIA = hiCreateSpinBox(
		?name 'sColumnsVIA
		?prompt "Columns"
		?value obj~>cutColumns
		?range list(0 100)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "cbApplyVIA(obj)"
	)
	sRowsSpVIA = hiCreateFloatSpinBox(
		?name 'sRowsSpVIA
		?prompt "Spacing"
		?value car(obj~>cutSpacing)
		?range list(0.0 100.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
		?callback "cbApplyVIA(obj)"
	)
	sColumnsSpVIA = hiCreateFloatSpinBox(
		?name 'sColumnsSpVIA
		?prompt "Spacing"
		?value cadr(obj~>cutSpacing)
		?range list(0.0 100.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
		?callback "cbApplyVIA(obj)"
	)
	
	fEncVIA = hiCreateFrameField(
		?name 'fEncVIA
		?labelText "Enclosures"
	)
	sEncVVIA = hiCreateFloatSpinBox(
		?name 'sEncVVIA
		?prompt "Vertical"
		?value cadr(obj~>layer1Enc)
		?range list(-10.0 10.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
		?callback "cbEncVVIA(obj)"
	)
	sEncHVIA = hiCreateFloatSpinBox(
		?name 'sEncHVIA
		?prompt "Horizontal"
		?value car(obj~>layer1Enc)
		?range list(-10.0 10.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
		?callback "cbEncHVIA(obj)"
	)
	
	bApplyVIA = hiCreateButton(
		?name 'bApplyVIA
		?buttonText "Apply"
		?callback ""
	)
	
	ulX = 0
	ulY = 0
	tabW = 10
	tabH = 10
	
	bMoveX = ulX + tabW
	bMoveY = ulY + 2*tabH
	bMoveW = 30
	bMoveH = 30
	
	bStackX = ulX + 4*tabW + 5*bMoveW
	bStackY = ulY + 2*tabH
	bStackW = 60
	bStackH = 50
	
	bLayerX = ulX + 7*tabW + 5*bMoveW + bStackW
	bLayerY = ulY + 2*tabH
	bLayerW = 60
	bLayerH = 50
	
	bTmplX = ulX +tabW
	bTmplY = ulY + 5*tabH + 5*bMoveH
	bTmplW = 60
	bTmplH = 30
	
	fGenX = ulX
	fGenY = bTmplY+bTmplH+tabH
	fGenW = 350
	fGenH = 90
	
	fEncX = ulX
	fEncY = fGenY+fGenH
	fEncW = 350
	fEncH = 60
	
	size = list(350 fEncY+fEncH+4*tabH)
	hiCreateAppForm(
		?name 'viaManipulateForm
		?formTitle "VIA manipulate form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?maxSize size
		?fields list(
			list(fMoveVIA		bMoveX-tabW:bMoveY-2*tabH		5*bMoveW+2*tabW:5*bMoveH+3*tabH		30)
			list(fStackVIA		bStackX-tabW:bStackY-2*tabH		bStackW+2*tabW:3*bStackH+3*tabH		30)
			list(fLayerVIA		bLayerX-tabW:bLayerY-2*tabH		bLayerW+2*tabW:3*bLayerH+3*tabH		30)
			list(fTemplatesVIA	bTmplX-tabW:bTmplY-2*tabH		5*bMoveW+2*bStackW+8*tabW:bTmplH+3*tabH	30)
			list(fGeneralVIA	fGenX:fGenY				fGenW:fGenH				30)
			list(fEncVIA		fEncX:fEncY				fEncW:fEncH				30)
			
			list(bMoveUpDef		bMoveX+2*bMoveW:bMoveY+1*bMoveH		bMoveW:bMoveH)
			list(bMoveUp5x		bMoveX+2*bMoveW:bMoveY+0*bMoveH		bMoveW:bMoveH)
			list(bMoveDownDef	bMoveX+2*bMoveW:bMoveY+3*bMoveH		bMoveW:bMoveH)
			list(bMoveDown5x	bMoveX+2*bMoveW:bMoveY+4*bMoveH		bMoveW:bMoveH)
			list(bMoveLeftDef	bMoveX+1*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			list(bMoveLeft5x	bMoveX+0*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			list(bMoveRightDef	bMoveX+3*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			list(bMoveRight5x	bMoveX+4*bMoveW:bMoveY+2*bMoveH		bMoveW:bMoveH)
			
			list(bAddAboveStackVIA	bStackX:bStackY+0*bStackH		bStackW:bStackH)
			list(bAddBelowStackVIA	bStackX:bStackY+1*bStackH		bStackW:bStackH)
			list(bRemoveStackVIA	bStackX:bStackY+2*bStackH		bStackW:bStackH)
			
			list(cTemplatesVIA	bTmplX:bTmplY-5				5*bMoveW:30				10)
			list(bSaveTemplatesVIA	bStackX:bTmplY				bTmplW:bTmplH)
			list(bLoadTemplatesVIA	280:bTmplY				bTmplW:bTmplH)
			list(lLoadTemplatesVIA	0:0					10:10					10)
			
			list(sRowsVIA		fGenX+tabW:fGenY+2*tabH			5*bMoveW:bTmplH				90)
			list(sColumnsVIA	fGenX+tabW:fGenY+5*tabH			5*bMoveW:bTmplH				90)
			list(sRowsSpVIA		fGenW-5*bMoveW-tabW:fGenY+2*tabH	5*bMoveW:bTmplH				90)
			list(sColumnsSpVIA	fGenW-5*bMoveW-tabW:fGenY+5*tabH	5*bMoveW:bTmplH				90)
			
			list(sEncVVIA		fEncX+tabW:fEncY+2*tabH			5*bMoveW:bTmplH				90)
			list(sEncHVIA		fEncW-5*bMoveW-tabW:fEncY+2*tabH	5*bMoveW:bTmplH				90)
			
			;list(bApplyVIA		280:bTmplY+7*bTmplH+tabH		bTmplW:bTmplH)	
		)
	)
	hiDisplayForm(viaManipulateForm)
);let
);procedure
