procedure( SSSDefineMatchingForm(insts props)
let(
	(
		size inst field (fields list())
		name names letter letters (total 0) mult num numLeft cols rows i
		DEBUG_INVISIBLE
	)
	size = list(360 420)
    letters = list("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "R" "Q" "S" "T" "U" "V" "W" "X" "Y" "Z" "DMY")
	when( props names = foreach(mapcar name insts car(name)) )
	when( !props names = foreach(mapcar name insts~>name car(parseString(name "<>"))) )
	for( i 0 length(insts)-1
		when( props
			mult = car(reverse(nth(i cadr(props))))
			letter = cadr(nth(i cadr(props)))
			numLeft = 0
		)
		when( !props
			mult = 1
			when( cadr(parseString(nth(i insts)~>name "<>"))
				num = parseString( cadr(parseString(nth(i insts)~>name "<>")) ":" )
				mult = int( abs(atof(cadr(num)) - atof(car(num))) + 1 )
			)
			when( nth(i insts)~>m mult = mult * int(atof(nth(i insts)~>m)) )
			numLeft = mult
			total = total + mult
			letter = nth(i letters)
		)
		name = nth(i names)
		field = hiCreateBooleanButton(
			?name stringToSymbol( sprintf(nil "bbItem%d" i) )
			?buttonText name
			?value nil
			?defValue nil
			?buttonLocation 'left
			?callback sprintf(nil "SSSDefineMatchingCBSelectLetter(%d %d)" i length(insts))
		)
		fields = append1( fields list(field 30:30+30*i 30:30 30) )
        field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lNum%d" i) )
			?labelText sprintf( nil "%d" mult )
		)
		fields = append1( fields list(field 120:30+30*i 30:30) )
		field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lNumLeft%d" i) )
			?labelText sprintf( nil "%d" numLeft )
		)
		fields = append1( fields list(field 150:30+30*i 30:30) )
		field = hiCreateCyclicField(
			?name stringToSymbol( sprintf(nil "cycItem%d" i) )
			?choices letters
			?prompt ""
			?value letter
			?enabled nil
			?callback "SSSDefineMatchingCBChangeLetter()"
		)
		fields = append1( fields list(field 240:30+30*i 30:30) )
    )
	when( props rows = length(car(props)) cols = length(caar(props)) )
	when( !props cols = nth( length(SSSDivisors(total))/2 SSSDivisors(total) ) rows = total/cols )
    field = hiCreateSpinBox(
		?name 'sbRows
		?prompt "Rows"
		?value rows
		?defValue 0
		?range list(0 25)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "SSSDefineMatchingCBBuild(insts props)"
	)
	fields = append1( fields list(field 30:30+30*length(insts) 120:30	60) )
	field = hiCreateSpinBox(
		?name 'sbColumns
		?prompt "Columns"
		?value cols
		?defValue 0
		?range list(0 25)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "SSSDefineMatchingCBBuild(insts props)"
	)
	fields = append1( fields list(field 180:30+30*length(insts) 120:30	60) )
	field = hiCreateBooleanButton(
		?name 'bbGrouped
		?buttonText "Place as a group?"
		?defValue nil
	)
	fields = append1( fields list(field 30:60+30*length(insts) 240:30	120) )
	field = hiCreateFloatSpinBox(
		?name 'ffXSpacing
		?prompt "X Spacing"
		?value if( props then caar(reverse(props)) else sssGrid )
		?range list(-10.0 10.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
	)
	fields = append1( fields list(field 30:90+30*length(insts) 120:30	120) )
	field = hiCreateFloatSpinBox(
		?name 'ffYSpacing
		?prompt "Y Spacing"
		?value if( props then cadar(reverse(props)) else sssGrid )
		?range list(-10.0 10.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
	)
	fields = append1( fields list(field 180:90+30*length(insts) 120:30	120) )
	field = hiCreateCyclicField(
		?name 'cfFlipRows
		?choices list("none" "even" "odd")
		?prompt "Flip rows"
		?defValue "none"
	)
	fields = append1( fields list(field 30:120+30*length(insts) 30:30 60) )
	field = hiCreateCyclicField(
		?name 'cfFlipCols
		?choices list("none" "even" "odd")
		?prompt "Flip cols"
		?defValue "none"
	)
	fields = append1( fields list(field 180:120+30*length(insts) 30:30 60) )
	field = hiCreateButton(
		?name 'bFillEmpty
		?buttonText "Fill Empty"
		?callback "SSSDefineMatchingCBFillEmpty()"
	)
	fields = append1( fields list(field 30:150+30*length(insts) 90:30 60) )

/****DEBUGGING****/
	DEBUG_INVISIBLE = t
	field = hiCreateLabel(
		?name 'l_DEBUG_SelectedInst
		?labelText "-1"
		?invisible DEBUG_INVISIBLE
	)
	fields = append1( fields list(field 10:10 20:20) )
	field = hiCreateLabel(
		?name 'l_DEBUG_NumberOfInst
		?labelText sprintf( nil "%d" length(names) )
		?invisible DEBUG_INVISIBLE
	)
	fields = append1( fields list(field 30:10 20:20) )
/****************/

	form = hiCreateAppForm(
		?name 'sssDefineMatchingForm
		?formTitle "Some Form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?fields fields
		?callback '("SSSDefineMatchingCB(insts)" "")
		?mapCB "SSSDefineMatchingCBBuild(insts props)"
	)
);let
);procedure
