procedure( DILSmartArrayForm(objs c)
let( (obj field (fields nil) (i 0) (ns nil) m)
	foreach( obj objs
		m = c[obj]
		field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lItem%d" i) )
			?labelText sprintf(nil "%s\t\ttotal %d\tleft %d" obj m m)
		)
		fields = append1( fields list(field 30:30*i 30:30) )
		i++
	)
	field = hiCreateSpinBox(
		?name 'spRows
		?prompt "Rows"
		?value 0
		?defValue 0
		?range list(0 8)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "DILSmartArrayCBBuild()"
	)
	fields = append1( fields list(field 30:30*i 120:30	60) )
	field = hiCreateSpinBox(
		?name 'spColumns
		?prompt "Columns"
		?value 0
		?defValue 0
		?range list(0 8)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "DILSmartArrayCBBuild()"
	)
	fields = append1( fields list(field 180:30*i 120:30	60) )
	size = list(350 350)
	hiCreateAppForm(
		?name 'dilSmartArrayForm
		?formTitle "Random Form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?maxSize size
		?fields fields
		?callback "DILSmartArrayCB()"
	)
);let
);procedure
