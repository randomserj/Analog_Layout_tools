procedure( DILSmartArrayCBGetGroupBoundary(group)
let( (fig figs boundary)
	figs = group~>figs
	foreach(fig figs
		when( fig~>objType == "rect" && fig~>layerName == "text"
			boundary = fig
		)
	)
	boundary
);let
);procedure

procedure( DILSmartArrayCBChange(row column)
let( (formName text o (index 0))
	formName = symbolToString( hiGetCurrentForm()~>hiFormSym )
	text = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" formName row column) )
	foreach( o dilSmartArrayElements
		if( o == text then
			when( index >= length(dilSmartArrayElements)-1 index = -1 )
			evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText=\"%s\"" formName row column nth(index+1 dilSmartArrayElements)) )
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
			fields = append1( fields list(field 30*i:30*(length(dilSmartArrayElements)+j) 30:30) )
		)
	)
	when( fields hiAddFields(form fields) )
);let
);procedure

procedure( DILSmartArrayCBLayout(p)
let( (string name names objs isFound (x 100) (y -100) dx dy bnd)
	dy = 0
	foreach( string p
		names = parseString(string "-")
		dx = 0
		foreach(name names
			isFound = nil
			foreach(obj dilSmartArrayObjs
				when( rexMatchp(sprintf(nil "^%s[. (]" name) car(obj~>figs~>baseName)) && !isFound
					dilSmartArrayObjs = remove(obj dilSmartArrayObjs)
					isFound = t
					x = -1 * car(obj~>origin) + dx
					y = -1 * cadr(obj~>origin) + dy
					dbMoveFig( obj obj~>cellView list(list(x y) "R0" 1) )
					bnd = DILSmartArrayCBGetGroupBoundary(obj)
					dx = dx + abs(caar(bnd~>bBox) - caadr(bnd~>bBox))
				)
			)
		)
		dy = dy + abs(cadar(bnd~>bBox) - cadadr(bnd~>bBox))
	)
);let
);procedure

procedure( DILSmartArrayCB()
let( (form formName obj r c i j string (pattern nil))
	form = hiGetCurrentForm()
	formName = symbolToString( hiGetCurrentForm()~>hiFormSym )
	r = form~>spRows~>value
	c = form~>spColumns~>value
	for(j 1 r
		string = ""
		for( i 1 c
			string = buildString( list( string evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" formName i j) ) ) "-" )
		)
		pattern = append1(pattern string)
	)
	pattern = reverse(pattern)		;; to layout array from top to bottom
	DILSmartArrayCBLayout(pattern)
);let
);procedure
