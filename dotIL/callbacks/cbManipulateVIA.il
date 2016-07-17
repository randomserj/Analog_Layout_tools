procedure( cbVIAMove(o action m)
let( (orig new s test)
	orig = o~>origin
	s = techGetMfgGridResolution(dilTechFile) * m
	case( action
		( "u" new = list(car(orig) cadr(orig)+s) )
		( "d" new = list(car(orig) cadr(orig)-s) )
		( "l" new = list(car(orig)-s cadr(orig)) )
		( "r" new = list(car(orig)+s cadr(orig)) )
	)
	obj~>origin = new
);let
);procedure

procedure( cbAddStackVIA(o action)
let( (cv techViaDefs techViaNames name stackViaNames i is vs newViaName n (add nil) (isCreated nil))	
	cv = geGetEditCellView()
	techViaDefs = lxGetValidViaDefs(dilTechFile "virtuosoDefaultSetup")
	if( action then techViaDefs = reverse(techViaDefs) )
	techViaNames = techViaDefs~>name
	is = dbGetOverlaps( cv o~>bBox nil )
	vs = setof(i is i~>objType == "stdVia" && i != o)
	stackViaNames = vs~>viaHeader~>viaDefName
	for( n 0 length(techViaNames)-1
		newViaName = nth( n techViaNames )
		when( newViaName && !member(newViaName stackViaNames) && add && !isCreated  
			dbCreateVia(
				cv
				nth( n techViaDefs )
				o~>origin
				o~>orient
				o~>viaHeader~>overrideParams
			)
			isCreated = t
		)
		if( newViaName == o~>viaHeader~>viaDefName then add = t )
	)
);let
);procedure

procedure( cbRemStackVIA(o)
let( (cv i is v vs)
	cv = geGetEditCellView()
	is = dbGetOverlaps( cv o~>bBox nil )
	vs = setof(i is i~>objType == "stdVia" && i != o)
	foreach( v vs dbDeleteObject(v) )

);let
);procedure

procedure( cbSaveTemplatesVIA(name)
let( (file v param params pName pType pValue)
	file = outfile( strcat( getWorkingDir() "/.il/vias.tmpl" ) "a" )
	v = car(geGetSelSet())
	when( file && name != ""
		fprintf( file "name=%s\n" name)
		params = v~>viaHeader~>overrideParams
		foreach( param params
			pName = car(param)
			pValue = cadr(param)
			pType = type(pValue)
			fprintf( file "%s//%s//%L\n" pName pType pValue)
		)
		fprintf( file "\n" name)
		close(file)
		printf("[INFO] New VIA template %s has been saved\n" name)
	)
);let
);procedure

procedure( cbLoadTemplatesVIA(name)
let( (file line v param pName pType pValue pValues pV (read nil) form)
	file = infile( strcat( getWorkingDir() "/.il/vias.tmpl" ) )
	v = car(geGetSelSet())
	when( file && name != ""
		while( gets(line file)
			line = strncat( "" line strlen(line)-1 )
			when( line == "" read = nil )
			when( read
				param = parseString( line "//" )
				pName = car(param)
				pType = cadr(param)
				pValue = buildString( parseString( caddr(param) "()" ) "" )
				if( pType == "list" then
					pValues = parseString(pValue)
					pValue = list()
					foreach(pV pValues
						pValue = append1(pValue evalstring(pV))
					)
				else
					pValue = evalstring(pValue)
				)
				dbReplaceProp(v pName pType pValue)
			)
			when( line == strcat("name=" name) read = t )
		)
		close(file)
		form = hiGetCurrentForm()
		form~>lLoadTemplatesVIA~>labelText = "loading"
		form~>sRowsVIA~>value = obj~>cutRows
		form~>sColumnsVIA~>value = obj~>cutColumns
		form~>sRowsSpVIA~>value = car(obj~>cutSpacing)
		form~>sColumnsSpVIA~>value = cadr(obj~>cutSpacing)
		form~>sEncHVIA~>value = car(obj~>layer1Enc)
		form~>sEncVVIA~>value = cadr(obj~>layer1Enc)
		form~>lLoadTemplatesVIA~>labelText = ""
	)
);let
);procedure

procedure( cbEncVVIA(o)
let( (form p)
	form = hiGetCurrentForm()
	p = form~>sEncVVIA~>value
	o~>layer1Enc = list( car(o~>layer1Enc) p )
	o~>layer2Enc = list( car(o~>layer2Enc) p )
	o~>layer1Offset = list( car(o~>layer1Offset) 0 )
	o~>layer2Offset = list( car(o~>layer2Offset) 0 )
);let
);procedure

procedure( cbEncHVIA(o)
let( (form p)
	form = hiGetCurrentForm()
	p = form~>sEncHVIA~>value
	o~>layer1Enc = list( p cadr(o~>layer1Enc) )
	o~>layer2Enc = list( p cadr(o~>layer2Enc) )
	o~>layer1Offset = list( 0 cadr(o~>layer1Offset) )
	o~>layer2Offset = list( 0 cadr(o~>layer2Offset) )
);let
);procedure

procedure( cbApplyVIA(o)
let( (form loading)
	form = hiGetCurrentForm()
	loading = form~>lLoadTemplatesVIA~>labelText
	when( loading != "loading"
		o~>cutRows = form~>sRowsVIA~>value
		o~>cutColumns = form~>sColumnsVIA~>value
		o~>cutSpacing = list( form~>sRowsSpVIA~>value form~>sColumnsSpVIA~>value )
	)
);let
);procedure
