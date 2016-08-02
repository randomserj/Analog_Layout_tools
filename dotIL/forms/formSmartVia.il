procedure( DILSmartViaGetTemplates(f)
let( (file line name (tmpls list()) )
	file = infile(f)
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

procedure( DILSmartViaForm(obj)
let( 	(
		form file templatesFile ulX ulY tabW tabH size
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
	
	fStackVIA = hiCreateFrameField(
		?name 'fStackVIA
		?labelText "Stack"
	)
	bAddAboveStackVIA = hiCreateButton(
		?name 'bAddAboveStackVIA
		?buttonText "Above"
		?callback "DILSmartViaCBAddStack( obj t )"
	)
	bAddBelowStackVIA = hiCreateButton(
		?name 'bAddBelowStackVIA
		?buttonText "Below"
		?callback "DILSmartViaCBAddStack( obj nil )"
	)
	bRemoveStackVIA = hiCreateButton(
		?name 'bRemoveStackVIA
		?buttonText "Remove"
		?callback "DILSmartViaCBRemoveStack( obj )"
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
		?items DILSmartViaGetTemplates(dilSmartViaFile)
		?editable t
	)
	bSaveTemplatesVIA = hiCreateButton(
		?name 'bTest
		?buttonText "Save"
		?callback "DILSmartViaCBSaveTemplate(obj dilSmartViaForm~>cTemplatesVIA~>value dilSmartViaFile) dilSmartViaForm~>cTemplatesVIA~>items = DILSmartViaGetTemplates(dilSmartViaFile)"
	)
	bLoadTemplatesVIA = hiCreateButton(
		?name 'bTestL
		?buttonText "Load"
		?callback "DILSmartViaCBLoadTemplate(obj dilSmartViaForm~>cTemplatesVIA~>value dilSmartViaFile)"
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
		?callback "DILSmartViaCBApply(obj)"
	)
	sColumnsVIA = hiCreateSpinBox(
		?name 'sColumnsVIA
		?prompt "Columns"
		?value obj~>cutColumns
		?range list(0 100)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "DILSmartViaCBApply(obj)"
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
		?callback "DILSmartViaCBApply(obj)"
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
		?callback "DILSmartViaCBApply(obj)"
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
	
	bMoveH = 30
	bMoveW = 30
	
	bStackX = ulX + tabW
	bStackY = ulY + 2*tabH
	bStackW = 80
	bStackH = 30
	
	bLayerX = ulX + 7*tabW + 5*bMoveW + bStackW
	bLayerY = ulY + 2*tabH
	bLayerW = 80
	bLayerH = 30
	
	bTmplX = ulX +tabW
	bTmplY = ulY + 6*tabH + 1*bStackH
	bTmplW = 80
	bTmplH = 30
	
	fGenX = ulX
	fGenY = bTmplY + 2*bTmplH + 3*tabH
	fGenW = 3*bStackW+4*tabW
	fGenH = 90
	
	fEncX = ulX
	fEncY = fGenY+fGenH
	fEncW = 3*bStackW+4*tabW
	fEncH = 60
	
	size = list(3*bStackW+4*tabW fEncY+fEncH+4*tabH)
	hiCreateAppForm(
		?name 'dilSmartViaForm
		?formTitle "Smart Via"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?maxSize size
		?fields list(
			list(fStackVIA		bStackX-tabW:bStackY-2*tabH		3*bStackW+4*tabW:bStackH+4*tabH		30)
			;list(fLayerVIA		bLayerX-tabW:bLayerY-2*tabH		bLayerW+2*tabW:3*bLayerH+3*tabH		30)
			list(fTemplatesVIA	bTmplX-tabW:bTmplY-2*tabH		3*bStackW+4*tabW:2*bTmplH+5*tabH	30)
			list(fGeneralVIA	fGenX:fGenY				3*bStackW+4*tabW:fGenH			30)
			list(fEncVIA		fEncX:fEncY				3*bStackW+4*tabW:fEncH			30)
			
			list(bAddAboveStackVIA	bStackX+0*bStackW+0*tabW:bStackY	bStackW:bStackH)
			list(bAddBelowStackVIA	bStackX+1*bStackW+1*tabW:bStackY	bStackW:bStackH)
			list(bRemoveStackVIA	bStackX+2*bStackW+2*tabW:bStackY	bStackW:bStackH)
			
			list(cTemplatesVIA	bTmplX:bTmplY				3*bStackW+2*tabW:bTmplH			10)
			list(bSaveTemplatesVIA	bStackX+0*bStackW+0*tabW:bTmplY+1*bTmplH+1*tabH		bTmplW:bTmplH)
			list(bLoadTemplatesVIA	bStackX+2*bStackW+2*tabW:bTmplY+1*bTmplH+1*tabH		bTmplW:bTmplH)
			list(lLoadTemplatesVIA	0:0					10:10					10)
			
			list(sRowsVIA		fGenX+tabW:fGenY+2*tabH			120:bTmplH				60)
			list(sColumnsVIA	fGenX+tabW:fGenY+5*tabH			120:bTmplH				60)
			list(sRowsSpVIA		fGenW-120-tabW:fGenY+2*tabH		120:bTmplH				60)
			list(sColumnsSpVIA	fGenW-120-tabW:fGenY+5*tabH		120:bTmplH				60)
			
			list(sEncVVIA		fEncX+tabW:fEncY+2*tabH			120:bTmplH				60)
			list(sEncHVIA		fGenW-120-tabW:fEncY+2*tabH		120:bTmplH				60)
			
			;list(bApplyVIA		280:bTmplY+7*bTmplH+tabH		bTmplW:bTmplH)	
		)
	)
);let
);procedure
