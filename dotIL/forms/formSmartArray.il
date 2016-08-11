procedure( DILSmartArrayInitForm(os)
let( (o field (fields nil) (i 0) (ns nil) m)
	foreach( o os
		m = o~>numInst
		m = m * atof(o~>m)
		m = truncate(m)
		field = hiCreateLabel(
			?name stringToSymbol( sprintf(nil "lItem%d" i) )
			?labelText sprintf(nil "%s\t%s\ttotal %d\tleft %d" o~>name nth(i dilElements) m m)
		)
		fields = append1( fields list(field 30:30*i 30:30) )
		i++
	)
	field = hiCreateSpinBox(
		?name 'spRows
		?prompt "Rows"
		?value 0
		?defValue 0
		?range list(0 4)
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
		?range list(0 4)
		?wrapAround nil
		?editable t
		?obeyWidth t
		?callback "DILSmartArrayCBBuild()"
	)
	fields = append1( fields list(field 180:30*i 120:30	60) )
	size = list(350 350)
	hiCreateAppForm(
		?name 'dilSmartArrayInitForm
		?formTitle "Smart Array"
		?buttonLayout '(Close (SelectSyncFamily "DILSmartArrayCB()"))
		?initialSize size
		?minSize size
		?maxSize size
		?fields fields
	)
);let
);procedure
