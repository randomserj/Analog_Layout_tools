procedure( SSSDefineMatchingCBSelectLetter(number count)
let( (form i field string name inst current)
	form = sssDefineMatchingForm
	current = evalstring( sprintf(nil "%s~>bbItem%d~>value" form number) )
	if( current then
		for( i 0 count-1 when(i != number evalstring(sprintf(nil "%s~>bbItem%d~>value = nil" form i))) )
		evalstring( sprintf(nil "%s~>cycItem%d~>enabled = t" form number) )
		evalstring( sprintf(nil "%s~>l_DEBUG_SelectedInst~>value = \"%d\"" form number) )
	else
		evalstring( sprintf(nil "%s~>cycItem%d~>enabled = nil" form number) )
		evalstring( sprintf(nil "%s~>l_DEBUG_SelectedInst~>value = \"-1\"" form) )
	)
);let
);procedure

procedure( SSSDefineMatchingCBChangeLetter()
let( (form number count current previous letter (letters list()) (toChange t))
	form = sssDefineMatchingForm
	number = atoi( evalstring(sprintf(nil "%s~>l_DEBUG_SelectedInst~>value" form)) )
	count = atoi( evalstring(sprintf(nil "%s~>l_DEBUG_NumberOfInst~>value" form)) )
	current = evalstring( sprintf(nil "%s~>cycItem%d~>value" form number) )
	previous = evalstring( sprintf(nil "%s~>cycItem%d~>lastValue" form number) )
	for( i 0 count-1
		letter = evalstring(sprintf(nil "%s~>cycItem%d~>value" form i))
		letters = append1( letters letter )
		when( letter == current && i != number toChange = nil )
	)
	when( toChange
		for( j 1 form~>sbRows~>value
			for( i 1 form~>sbColumns~>value
				letter = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" form j i))
				when( letter != " " && !member(letter letters)
					evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText = \"%s\"" form j i current))
				)
			)
		)
	)
	unless( toChange evalstring(sprintf(nil "%s~>cycItem%d~>value=\"%s\"" form number previous)) )
);let
);procedure

procedure( SSSDefineMatchingCBBuild(insts props)
let( (form pattern name total (letter " ") field (fields nil))
	form = sssDefineMatchingForm
	when( !props
		foreach( field form~>fieldList when(rexMatchp("^bArrayItem.*$" symbolToString(field)) hiDeleteField(form field)) )
		for( i 0 length(insts)-1
			total = evalstring( sprintf(nil "%s~>lNum%d~>value" form i) )
			evalstring( sprintf(nil "%s~>lNumLeft%d~>value = \"%s\"" form i total) )
		)
	)
	when( length(insts) == 1 letter = evalstring(sprintf(nil "%s~>cycItem0~>value" form)) )
	when( props pattern = car(props) )
	for(j 1 form~>sbRows~>value
		for( i 1 form~>sbColumns~>value
			when( pattern letter = nth(i-1 nth(j-1 pattern)) )
			unless( letter letter = " " )
			field = hiCreateButton(
				?name stringToSymbol( sprintf(nil "bArrayItem%d%d" j i) )
				?buttonText letter
				?callback sprintf(nil "SSSDefineMatchingCBChangePattern(%d %d)" j i)
			)
			fields = append1( fields list(field 30*i:180+30*length(insts)+30*j 30:30) )
		)
	)
	when( fields hiAddFields(form fields) )
);let
);procedure

procedure( SSSDefineMatchingCBChangePattern(row column)
let( (form i j choices current field left leftNew value (values list()) (states list()) (toChange nil))
    form = sssDefineMatchingForm
	foreach( field form~>fieldList
		when( rexMatchp("^cycItem.*$" symbolToString(field))
			states = append1( states evalstring(sprintf(nil "%s~>%s~>enabled" form field)) )
			values = append1( values evalstring(sprintf(nil "%s~>%s~>value" form field)) )
		)
	)
	when( lindex( states t )
		i = lindex( states t ) - 1
	    choices = list( evalstring(sprintf(nil "%s~>cycItem%d~>value" form i)) " " )
		current = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" form row column) )
		left = atoi( evalstring(sprintf(nil "%s~>lNumLeft%d~>value" form i)) )
		;when( left == 0 toChange = nil )
		when( current != car(choices) && left > 0
			toChange = t
			left--
			when( current != " "
				j = lindex( values current ) - 1
				leftNew = atoi( evalstring(sprintf(nil "%s~>lNumLeft%d~>value" form j)) ) + 1
				evalstring( sprintf(nil "%s~>lNumLeft%d~>value = \"%d\"" form j leftNew) )
			)
		)
		when( current == car(choices)
			toChange = t
			left++
			choices = reverse(choices)
		)
		when( toChange
			evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText = \"%s\"" form row column car(choices)) )
			evalstring( sprintf(nil "%s~>lNumLeft%d~>value = \"%d\"" form i left) )
		)
	)
);let
);procedure

procedure( SSSDefineMatchingCBFillEmpty()
let( (form number current letter i j)
	form = sssDefineMatchingForm
	number = atoi( evalstring(sprintf(nil "%s~>l_DEBUG_SelectedInst~>value" form)) )
	when( number >= 0
		current = evalstring( sprintf(nil "%s~>cycItem%d~>value" form number) )
		for(j 1 form~>sbRows~>value
			for( i 1 form~>sbColumns~>value
				letter = evalstring( sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" form j i))
				when( letter == " " SSSDefineMatchingCBChangePattern(j i) )
			)
		)
	)
);let
);procedure

procedure( SSSDefineMatchingCBLayout(props isGrouped flipRows flipCols mode)
let(
    (
        cv name names pattern letter row inst (insts list())
        isFound pt ptX ptY l h x y llx lly dx dy i j label
        group (groupName "Group")
    )
    cv = geGetEditCellView()
    pattern = car(props)
    names = makeTable( "names" )
    foreach( name cadr(props)
        names[cadr(name)] = car(name)
        insts = append( insts setof(inst cv~>instances rexMatchp(sprintf(nil "^%s.*" car(name)) inst~>name)) )
    )
	if( mode then
		ptX = car(sort(foreach(mapcar bb insts~>bBox caar(bb)) 'lessp))
		ptY = car(sort(foreach(mapcar bb insts~>bBox cadar(bb)) 'lessp))
	else
	    pt = enterPoint(
	        ?prompts list( "Pick a point in the layout")
	        ?doneProc ""
	    )
		ptX = car(pt)
		ptY = cadr(pt)
	)
	when( isGrouped
        foreach( name cadr(props) groupName = sprintf( nil "%s_%s" groupName car(name)) )
		group = dbCreateFigGroup( cv groupName nil ptX:ptY "R0")
    )
    dx = car( nth(2 props) )
    dy = cadr( nth(2 props) )
    i = 0
    j = 0
    foreach( row pattern
        i = 0
        foreach( letter row
            isFound = nil
            foreach( inst insts
                when( rexMatchp(sprintf(nil "^%s.*$" names[letter]) inst~>name) && !isFound
                    isFound = t
                    insts = remove(inst insts)
                    when( inst~>figGroup~>type == "syncClone" inst = inst~>figGroup )
					when( isGrouped dbAddFigToFigGroup(group inst) )
                    inst~>matching = props
                    llx = caar(inst~>bBox)
                    lly = cadar(inst~>bBox)
                    l = abs(caadr(inst~>bBox)-caar(inst~>bBox))
                    h = abs(cadadr(inst~>bBox)-cadar(inst~>bBox))
                    unless( member("label" inst~>children~>objType)
                        label = dbCreateLabel(
                            cv
                            list( "text" "drawing" )
                            list( llx+l/2 lly+h/2 )
                            names[letter]
                            "centerCenter"
                            "R0"
                            "roman"
                            round(min(l/2 h/2)/4/0.1)*0.1
                        )
                        leAttachFig(label inst)
                    )
                    x = ptX - llx + i*(l + dx)
                    y = ptY - lly + j*(h + dy)
                    dbMoveFig( inst cv list(list(x y) "R0" 1) )
                    if( remainder(i+1 2) == 0 then
                        when( flipRows == "even" geDeselectAll() geSelectFig(inst) _leRotateOrFlip("MY"))
                    else
                        when( flipRows == "odd" geDeselectAll() geSelectFig(inst) _leRotateOrFlip("MY"))
                    )
                    if( remainder(j+1 2) == 0 then
                        when( flipCols == "even" geDeselectAll() geSelectFig(inst) _leRotateOrFlip("MX"))
                    else
                        when( flipCols == "odd" geDeselectAll() geSelectFig(inst) _leRotateOrFlip("MX"))
                    )
                )
            )
            i++
        )
        j++
    )
);let
);procedure

/*****************
props = list(
            (pattern)
            ((name letter count) (name letter count) ...)
            (dx dy)
        )
*****************/
procedure( SSSDefineMatchingCB(insts)
let(
	(
		cv cellName win wins form
		(props list()) name letter count string pattern shift
		i j (isEdit nil) (isFound nil)
	)
    form = sssDefineMatchingForm
	when( type( car(insts) ) == 'list isEdit = t )
    for( i 0 length(insts)-1
		name = evalstring(sprintf(nil "%s~>bbItem%d~>_buttonText" form i))
		letter = evalstring(sprintf(nil "%s~>cycItem%d~>value" form i))
		count = atoi( evalstring(sprintf(nil "%s~>lNum%d~>value" form i)) )
        props = append1( props list(name letter count) )
    )
	for( j 1 form~>sbRows~>value
		string = list()
		for( i 1 form~>sbColumns~>value string = append1(string evalstring(sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" form j i))) )
		pattern = append1(pattern string)
	)
    shift = list( form~>ffXSpacing~>value form~>ffYSpacing~>value )
    props = list( pattern props shift )
	unless( isEdit
	    cellName = car(insts)~>cellView~>cellName
	    wins = hiGetWindowList()
	    wins = cdr(wins) ;; to remove CIW from the list
	    foreach( win wins
	        cv = geGetWindowCellView(win)
	        when( cv~>cellName == cellName && cv~>viewName == "layout"
				hiSetCurrentWindow(win)
				isFound = t
			)
	    )
	)
    when( isFound || isEdit
        SSSDefineMatchingCBLayout(
            props
            form~>bbGrouped~>value
            form~>cfFlipRows~>value
            form~>cfFlipCols~>value
			isEdit
        )
	)
);let
);prcoedure
