procedure( DILSmartViaCBAddStack(o action)
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

procedure( DILSmartViaCBRemoveStack(o)
let( (cv i is v vs)
	cv = geGetEditCellView()
	is = dbGetOverlaps( cv o~>bBox nil )
	vs = setof(i is i~>objType == "stdVia" && i != o)
	foreach( v vs dbDeleteObject(v) )

);let
);procedure

procedure( DILSmartViaCBSaveTemplate(o name f)
let( (file param params pName pType pValue)
	file = outfile(f "a")
	when( file && name != ""
		fprintf( file "name=%s\n" name)
		params = o~>viaHeader~>overrideParams
		foreach( param params
			pName = car(param)
			pValue = cadr(param)
			pType = type(pValue)
			fprintf( file "%s//%s//%L\n" pName pType pValue)
		)
		fprintf( file "\n" name)
		printf("[INFO] New VIA template %s has been saved\n" name)
	)
	close(file)
);let
);procedure

procedure( DILSmartViaCBLoadTemplate(o name f)
let( (file line param pName pType pValue pValues pV (read nil) form)
	file = infile(f)
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
				dbReplaceProp(o pName pType pValue)
			)
			when( line == strcat("name=" name) read = t )
		)
		form = hiGetCurrentForm()
		form~>lLoadTemplatesVIA~>labelText = "loading"
		form~>sRowsVIA~>value = o~>cutRows
		form~>sColumnsVIA~>value = o~>cutColumns
		form~>sRowsSpVIA~>value = car(o~>cutSpacing)
		form~>sColumnsSpVIA~>value = cadr(o~>cutSpacing)
		form~>sEncHVIA~>value = car(o~>layer1Enc)
		form~>sEncVVIA~>value = cadr(o~>layer1Enc)
		form~>lLoadTemplatesVIA~>labelText = ""
	)
	close(file)
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

procedure( DILSmartViaCBApply(o)
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
