procedure( DILSmartArrayForm(objs c)
let( (obj form field (fields nil) (i 0) (ns nil) m (total 1) l letters prevR prevC curR curC)
	l = length(objs)
	letters = list(" " "DMY" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "R" "Q" "S" "T" "U" "V" "W" "X" "Y" "Z")
	foreach( obj objs
		m = c[obj]
		total = total + m
		field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lItem%d" i) )
			?labelText sprintf(nil "%s\t\ttotal %d\tleft %d" obj m m)
		)
		fields = append1( fields list(field 30:30*i 30:30) )
		field = hiCreateCyclicField(
			?name stringToSymbol( sprintf(nil "cycItem%d" i) )
			?choices letters
			?prompt ""
			?defValue car(letters)
			?callback sprintf(nil "DILSmartArrayCBLetters(%d)" l)
		)
		fields = append1( fields list(field 240:30*i 30:30) )
		i++
	)
	field = hiCreateSpinBox(
		?name 'spRows
		?prompt "Rows"
		;?value int(sqrt(total))
		?defValue 0
		?range list(0 25)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "DILSmartArrayCBBuild()"
	)
	fields = append1( fields list(field 30:30*i 120:30	60) )
	field = hiCreateSpinBox(
		?name 'spColumns
		?prompt "Columns"
		;?value int(sqrt(total))+1
		?defValue 0
		?range list(0 25)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "DILSmartArrayCBBuild()"
	)
	fields = append1( fields list(field 180:30*i 120:30	60) )

	size = list(350 350)
	form = hiCreateAppForm(
		?name 'dilSmartArrayForm
		?formTitle "Random Form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		;?maxSize size
		?fields fields
		?callback "DILSmartArrayCB()"
	)

	form->spColumns->value = int(sqrt(total))+1
	form->spRows->value = int(sqrt(total))
);let
);procedure
