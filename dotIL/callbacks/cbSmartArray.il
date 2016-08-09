procedure( DILSmartArrayBuildCB(es row column)
let( (formName text e index)
	formName = symbolToString( hiGetCurrentForm()~>hiFormSym )
	text = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" formName row column) )
	index = 0
	foreach( e es
		if( e == text then
			when( index >= length(es)-1 index = -1 ) 
			evalstring( sprintf(nil "formSmartArray~>bArrayItem%d%d~>_buttonText=\"%s\"" row column nth(index+1 es)) )
		)
		index++
	)
);let
);procedure

procedure( DILSmartArrayCB(g r c)
let( (form formName cv text i (j 0) dx dy row (rows nil) item items bnd fig)
	form = hiGetCurrentForm()
	formName = symbolToString( hiGetCurrentForm()~>hiFormSym )
	cv = g~>cellView
	for(j 1 r
		row = ""
		for( i 1 c
			row = buildString( list( row evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" formName i j) ) ) "" )
		)
		rows = append1(rows row)
	)
	bnd = MISCGroupGetBoundary(g)
	dx = car( MISCCalcGetDimensions(bnd~>bBox) )
	dy = cadr( MISCCalcGetDimensions(bnd~>bBox) )
	foreach( row rows
		items = parseString(row "")
		i = 0
		foreach(item items
			when(item != " " && i - j != 0
				fig = dbCopyFig(
					g
					cv
					list(
						list(i*dx j*dy)
						"R0"
						1
					)
				)
				fig~>dilLabel = item
				MISCGroupAttachLabel(fig)
			)
			i++
		)
		j--
	)
	g~>dilLabel = substring( car(rows) 1 1 )
	MISCGroupAttachLabel(g)
);let
);procedure

