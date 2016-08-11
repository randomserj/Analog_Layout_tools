procedure( DILSmartArrayCBChange(row column)
let( (formName text e es (index 0))
	formName = symbolToString( hiGetCurrentForm()~>hiFormSym )
	text = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" formName row column) )
	es = append( list(" " "d") dilElements )
	foreach( e es
		if( e == text then
			when( index >= length(es)-1 index = -1 ) 
			evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText=\"%s\"" formName row column nth(index+1 es)) )
		)
		index++
	)
);let
);procedure

procedure( DILSmartArrayCBBuild()
let( (form formName field (fields nil) prevR prevC curR curC)
	form = hiGetCurrentForm()
	formName = symbolToString( hiGetCurrentForm()~>hiFormSym )
	prevR = form~>spRows~>prevValue
	prevC = form~>spColumns~>prevValue
	unless( prevR prevR = 0)
	unless( prevC prevC = 0)
	curR = form~>spRows~>value
	curC = form~>spColumns~>value
	form~>spRows~>prevValue = curR
	form~>spColumns~>prevValue = curC
	for(j 1 prevR
		for( i 1 prevC
			field = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>hiFieldSym" formName i j) )
			when( field hiDeleteField(form field) )
		)
	)
	for(j 1 curR
		for( i 1 curC
			field = hiCreateButton(
				?name stringToSymbol( sprintf(nil "bArrayItem%d%d" i j) )
				?buttonText " "
				?callback sprintf(nil "DILSmartArrayCBChange(%d %d)" i j)
			)
			fields = append1( fields list(field 30*i:150+30*j 30:30) )
		)
	)
	when( fields hiAddFields(form fields) )
);let
);procedure

procedure( DILSmartArrayCBLayout(g p)
let( (form formName cv text i (j 0) dx dy s item items bnd fig)
	cv = g~>cellView
	bnd = MISCGroupGetBoundary(g)
	dx = car( MISCCalcGetDimensions(bnd~>bBox) )
	dy = cadr( MISCCalcGetDimensions(bnd~>bBox) )
	foreach( s p
		items = parseString(s "")
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
	g~>dilLabel = substring( car(p) 1 1 )
	MISCGroupAttachLabel(g)
);let
);procedure

procedure( DILSamrtArrayCBSetWindow(win)
	geSetEnterFunctionSelectionMode(win 4)
)

procedure( DILSmartArrayCB()
let( (form formName obj r c i j string (pattern nil) index point window)
	form = hiGetCurrentForm()
	formName = symbolToString( hiGetCurrentForm()~>hiFormSym )
	r = form~>spRows~>value
	c = form~>spColumns~>value
	for(j 1 r
		string = ""
		for( i 1 c
			string = buildString( list( string evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" formName i j) ) ) "" )
		)
		pattern = append1(pattern string)
	)
	window = hiPickWindow()
	when( window 
		hiSetCurrentWindow(window)
		geDeselectAll()
		point = enterPoint( ?prompts list("Select a group") )
		when( point geAddSelectPoint(window nil point) )
	)
	obj = car(geGetSelSet())
	if( obj~>objType == "figGroup" then
		hiFormClose(form)
		DILSmartArrayCBLayout(obj pattern)
	else
		DILPrintInfo("WARNING! You need to select a group")
	)
);let
);procedure
