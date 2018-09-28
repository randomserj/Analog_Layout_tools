procedure( SSSDefineMatchingCBSetup(_objs)
let( (form obj objs field fields letters total cols rows i)
    form = sssDefineMatchingForm
    objs = _objs
    total = 0
    letters = list("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "R" "Q" "S" "T" "U" "V" "W" "X" "Y" "Z" "DMY")
    for( i 0 length(objs)-1
        field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lItem%d" i) )
			?labelText sprintf( nil "%s" nth(i objs)~>name )
		)
		fields = append1( fields list(field 30:180+30*i 30:30) )
        field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lNum%d" i) )
			?labelText sprintf( nil "%s" nth(i objs)~>simM )
		)
		fields = append1( fields list(field 90:180+30*i 30:30) )
		field = hiCreateCyclicField(
			?name stringToSymbol( sprintf(nil "cycItem%s" nth(i objs~>name)) )
			?choices letters
			?prompt ""
			?defValue nth(i letters)
		)
		fields = append1( fields list(field 240:180+30*i 30:30) )
        total = total + int( atof(nth(i objs)~>simM) )
    )
    if( sqrt(total) < int(sqrt(total)) + 0.5
    then
        cols = int(sqrt(total)) + 1
        rows = int(sqrt(total))
    else
        cols = int(sqrt(total)) + 1
        rows = int(sqrt(total)) + 1
    )
    when( sqrt(total) == int(sqrt(total))
        cols = int(sqrt(total))
        rows = int(sqrt(total))
    )
    field = hiCreateSpinBox(
		?name 'sbRows
		?prompt "Rows"
		?value rows
		?defValue 0
		?range list(0 25)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "SSSDefineMatchingCBBuild(objs)"
	)
	fields = append1( fields list(field 30:180+30*length(objs) 120:30	60) )
	field = hiCreateSpinBox(
		?name 'sbColumns
		?prompt "Columns"
		?value cols
		?defValue 0
		?range list(0 25)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "SSSDefineMatchingCBBuild(objs)"
	)
	fields = append1( fields list(field 180:180+30*length(objs) 120:30	60) )
    when( fields hiAddFields(form fields) )
    SSSDefineMatchingCBBuild(objs)
);let
);prcoedure

procedure( SSSDefineMatchingCBChange(row column)
let( (form current letter lettersfield o (index 0))
    form = sssDefineMatchingForm
	current = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" form row column) )
    letters = list(" ")
    foreach( field form~>fieldList
        when( rexMatchp("^cycItem.*$" symbolToString(field))
            letters = append1( letters evalstring(sprintf(nil "%s~>%s~>value" form field)) )
        )
    )
	foreach( letter letters
		if( letter == current then
			when( index >= length(letters)-1 index = -1 )
			evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText=\"%s\"" form row column nth(index+1 letters)) )
		)
		index++
	)
);let
);procedure

procedure( SSSDefineMatchingCBBuild(_objs)
let( (form objs field (fields nil) prevR prevC curR curC)
	form = sssDefineMatchingForm
    objs = _objs
	foreach( field form~>fieldList
        when( rexMatchp("^bArrayItem.*$" symbolToString(field)) hiDeleteField(form field) )
    )
	for(j 1 form~>sbRows~>value
		for( i 1 form~>sbColumns~>value
			field = hiCreateButton(
				?name stringToSymbol( sprintf(nil "bArrayItem%d%d" i j) )
				?buttonText " "
				?callback sprintf(nil "SSSDefineMatchingCBChange(%d %d)" i j)
			)
			fields = append1( fields list(field 30*i:180+30*length(objs)+30*j 30:30) )
		)
	)
	when( fields hiAddFields(form fields) )
);let
);procedure

procedure( SSSDefineMatchingCB(_objs)
let( (cv inst params form obj objs string pattern i j)
    form = sssDefineMatchingForm
    objs = _objs
	for(j 1 form~>sbRows~>value
		string = list()
		for( i 1 form~>sbColumns~>value
			string = append1( string evalstring(sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" form i j)) )
		)
		pattern = append1(pattern string)
	)
    cv = car(objs)~>cellView
    inst = dbCreateInstByMasterName(
        cv
        "zz_spakhomov"
        "matchingDef"
        "symbol"
        strcat( "mDef" buildString(objs~>name "") )
        list(-1 1)
        "R0"
        1
    )
    params = list()
    foreach(obj objs
        params = append1( params list(obj~>name evalstring( sprintf(nil "%s~>cycItem%s~>value" form obj~>name))) )
    )
    inst~>matching = list(
        objs~>name
        params
        form~>fieldP~>value
        form~>fieldC~>value
        form~>fieldD~>value
        form~>fieldM~>value
        pattern
    )
);let
);prcoedure
