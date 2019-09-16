procedure( SSSDefineMatchingCBBuild(insts)
let( (form field (fields nil) prevR prevC curR curC)
	form = sssDefineMatchingForm
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
			fields = append1( fields list(field 30*i:120+30*length(insts)+30*j 30:30) )
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

procedure( SSSDefineMatchingCBLayout(props isGrouped)
let(
    (
        cv name names pattern letter row inst (insts list())
        isFound pt ptX ptY x y dx dy i j bnd
        group (groupName "Group")
    )
    cv = geGetEditCellView()
    pattern = car(props)
    names = makeTable( "names" )
    foreach( name cadr(props)
        names[cadr(name)] = car(name)
        insts = append( insts setof(inst cv~>instances rexMatchp(sprintf(nil "^%s.*" car(name)) inst~>name)) )
    )
    pt = enterPoint(
        ?prompts list( "Pick a point in the layout")
        ?doneProc ""
    )
    when( isGrouped
        ;;foreach( name cadr(props) groupName = sprintf( nil "%s_%s" groupName car(name)) )
        ;;group = dbCreateFigGroup( cv groupName nil pt "R0")
        ;;foreach( inst insts dbAddFigToFigGroup(group inst) )
        geSelectFigs(insts)
        leHiCreateGroup()
    )
    ptX = car(pt)
    ptY = cadr(pt)
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
                    when( inst~>figGroup~>type == "syncClone"
                        inst~>figGroup~>xy = inst~>xy
                        inst = inst~>figGroup
                    )
                    inst~>matching = props
                    x = ptX - car(inst~>xy) + i*(abs(caadr(inst~>bBox)-caar(inst~>bBox)) + dx)
                    y = ptY - cadr(inst~>xy) + j*(abs(cadadr(inst~>bBox)-cadar(inst~>bBox)) + dy)
                    dbMoveFig( inst cv list(list(x y) "R0" 1) )
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
let( (cv cellName win wins form inst name string (props list()) pattern shift i j (isFound nil))
    form = sssDefineMatchingForm
    for( i 0 length(insts)-1
        name = car( parseString(nth(i insts~>name) "<>") )
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
    cellName = car(insts)~>cellView~>cellName
    wins = hiGetWindowList()
    wins = cdr(wins) ;; to remove CIW from the list
    foreach( win wins
        cv = geGetWindowCellView(win)
        when( cv~>cellName == cellName && cv~>viewName == "layout" hiSetCurrentWindow(win) isFound = t )
    )
    when( isFound SSSDefineMatchingCBLayout(props form~>bbGrouped~>value) )
);let
);prcoedure
