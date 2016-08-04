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

procedure( DILSmartViaCBSaveTemplate(o f)
let( (form name names file param params pName pType pValue)
	form = dilSmartViaForm
	names = DILSmartViaGetTemplates(dilSmartViaFile)
	name = form~>cTemplatesVIA~>value
	file = outfile(f "a")
	when( file && name != "" && !member(name names)
		fprintf( file "name=%s\n" name)
		params = o~>viaHeader~>overrideParams
		foreach( param params
			pName = car(param)
			pValue = cadr(param)
			pType = type(pValue)
			fprintf( file "%s//%s//%L\n" pName pType pValue)
		)
		fprintf( file "\n" name)
		DILPrintInfo( strcat("New VIA template " name " has been saved") )
	)
	close(file)
	form~>cTemplatesVIA~>items = names
);let
);procedure

procedure( DILSmartViaCBLoadTemplate(o f)
let( (form name file line param pName pType pValue pValues pV (read nil))
	form = dilSmartViaForm
	name = form~>cTemplatesVIA~>value
	file = infile(f)
	form~>lLoadTemplatesVIA~>value = "loading"
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
		form~>sRowsVIA~>value = o~>cutRows
		form~>sColumnsVIA~>value = o~>cutColumns
		form~>sRowsSpVIA~>value = car(o~>cutSpacing)
		form~>sColumnsSpVIA~>value = cadr(o~>cutSpacing)
		form~>sEncHVIA~>value = car(o~>layer1Enc)
		form~>sEncVVIA~>value = cadr(o~>layer1Enc)
	)
	close(file)
	form~>lLoadTemplatesVIA~>value = "loaded"
);let
);procedure

procedure( DILSmartViaCBEnclosuresApply(o)
let( (form h v)
	form = dilSmartViaForm
	when( form~>lLoadTemplatesVIA~>value == "loaded"
		h = form~>sEncHVIA~>value
		v = form~>sEncVVIA~>value
		o~>layer1Enc = list( h v )
		o~>layer2Enc = list( h v )
		form~>cTemplatesVIA~>value = ""
	)
);let
);procedure

procedure( DILSmartViaCBGeneralApply(o)
let( (form loading)
	form = dilSmartViaForm
	when( form~>lLoadTemplatesVIA~>value == "loaded"
		o~>cutRows = form~>sRowsVIA~>value
		o~>cutColumns = form~>sColumnsVIA~>value
		o~>cutSpacing = list( form~>sRowsSpVIA~>value form~>sColumnsSpVIA~>value )
		form~>cTemplatesVIA~>value = ""
	)
);let
);procedure
