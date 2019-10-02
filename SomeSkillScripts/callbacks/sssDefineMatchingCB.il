procedure( SSSDefineMatchingCBBuild(insts props)
let( (form pattern (letter " ") field (fields nil) prevR prevC curR curC)
	form = sssDefineMatchingForm
	foreach( field form~>fieldList
        when( rexMatchp("^bArrayItem.*$" symbolToString(field)) hiDeleteField(form field) )
    )
	when( length(insts) == 1 dprint(insts) )
	when( props pattern = car(props) )
	for(j 1 form~>sbRows~>value
		for( i 1 form~>sbColumns~>value
			when( pattern letter = nth(i-1 nth(j-1 pattern)) )
			unless( letter letter = " " ) ;; *************** temporary solution
			field = hiCreateButton(
				?name stringToSymbol( sprintf(nil "bArrayItem%d%d" i j) )
				?buttonText letter
				?callback sprintf(nil "SSSDefineMatchingCBChange(%d %d)" i j)
			)
			fields = append1( fields list(field 30*i:150+30*length(insts)+30*j 30:30) )
		)
	)
	when( fields hiAddFields(form fields) )
);let
);procedure

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
            ((name letter) (name letter) ...)
            (dx dy)
        )
*****************/
procedure( SSSDefineMatchingCB(insts)
let( (cv cellName win wins form inst (props list()) name string pattern shift i j (isEdit nil) (isFound nil))
    form = sssDefineMatchingForm
	when( type( car(insts) ) == 'list isEdit = t )
    for( i 0 length(insts)-1
        if( isEdit then name = car(nth(i insts)) else name = car(parseString(nth(i insts~>name) "<>")) )
        props = append1( props list(name evalstring(sprintf(nil "%s~>cycItem%s~>value" form name))) )
    )
	for( j 1 form~>sbRows~>value
		string = list()
		for( i 1 form~>sbColumns~>value
			string = append1( string evalstring(sprintf(nil "%s~>bArrayItem%d%d~>_buttonText" form i j)) )
		)
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
	        when( cv~>cellName == cellName && cv~>viewName == "layout" hiSetCurrentWindow(win) isFound = t )
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
