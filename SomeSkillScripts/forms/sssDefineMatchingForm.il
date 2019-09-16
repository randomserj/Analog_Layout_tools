procedure( SSSDefineMatchingForm(insts)
let( (size inst field fields letters total cols rows i mult num)
	size = list(350 400)
    total = 0
    letters = list("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "R" "Q" "S" "T" "U" "V" "W" "X" "Y" "Z" "DMY")
    for( i 0 length(insts)-1
		mult = 1
		when( cadr(parseString(nth(i insts)~>name "<>"))
			num = parseString( cadr(parseString(nth(i insts)~>name "<>")) ":" )
			mult = int( abs(atof(cadr(num)) - atof(car(num))) + 1 )
		)
		mult = mult * int( atof(nth(i insts)~>m) )
        field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lItem%d" i) )
			?labelText sprintf( nil "%s" nth(i insts)~>name )
		)
		fields = append1( fields list(field 30:30+30*i 30:30) )
        field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lNum%d" i) )
			?labelText sprintf( nil "%d" mult )
		)
		fields = append1( fields list(field 120:30+30*i 30:30) )
		field = hiCreateCyclicField(
			?name stringToSymbol( sprintf(nil "cycItem%s" car(parseString(nth(i insts~>name) "<>"))) )
			?choices letters
			?prompt ""
			?defValue nth(i letters)
		)
		fields = append1( fields list(field 240:30+30*i 30:30) )
        total = total + mult
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
		?callback "SSSDefineMatchingCBBuild(insts)"
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
		?callback "SSSDefineMatchingCBBuild(insts)"
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
		?value sssGrid
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
		?value sssGrid
		?range list(-10.0 10.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
	)
	fields = append1( fields list(field 180:90+30*length(insts) 120:30	120) )

	form = hiCreateAppForm(
		?name 'sssDefineMatchingForm
		?formTitle "Some Form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?fields fields
		?callback "SSSDefineMatchingCB(insts)"
		?mapCB "SSSDefineMatchingCBBuild(insts)"
	)
);let
);procedure
