procedure( DILSmartArrayForm(objs es r c)
let( (field fields i j)
	fields = nil
	for(j 1 r
		for( i 1 c
			field = hiCreateButton(
				?name stringToSymbol( sprintf(nil "bArrayItem%d%d" i j) )
				?buttonText car(es)
				?callback sprintf(nil "DILSmartArrayBuildCB(elements %d %d)" i j)
			)
			fields = append1( fields list(field 30*i:30*j 30:30) )
		)
	)
	size = list(350 350)
	hiCreateAppForm(
		?name 'formSmartArray
		?formTitle "Smart Array"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?maxSize size
		?fields fields
		?callback sprintf(nil "DILSmartArrayCB(car(objs) %d %d)" r c)
	)
);let
);procedure
