pcDefinePCell(
	list( ddGetObj("TEST_CHIP_RES") "metBuses" "layout")
	(
		(width float 0.5)
		(lenght float 5.0)
		(shift float 0.0)
		(space float 0.5)
		(number int 1)
		(layer string "MET1")
		(fixed boolean t)
	)

	if( fixed then
		f = 1
	else
		f = 0
	)
	
	for( i 1 number
		dbCreatePath(
			pcCellView 
			list(layer "drawing") 
			list(
				((width + space) * (i - 1)):(shift * (i - 1)) 
				((width + space) * (i - 1)):(f * shift * (i - 1) + lenght)
			)
			width
		)
	)

	return(t)
)

let( (cellId cdfId)
	when(cellId = ddGetObj("TEST_CHIP_RES" "metBuses")

		when( cdfId = cdfGetBaseCellCDF(cellId)
			cdfDeleteCDF(cdfId)
		)

		cdfId = cdfCreateBaseCellCDF(cellId)
		
		cdfCreateParam( cdfId
			?name		"width"
			?prompt   	"width"
			?defValue 	0.5
			?type     	"float"
			?display  	"t"
			?callback	""
		)
		
		cdfCreateParam( cdfId
			?name		"lenght"
			?prompt   	"lenght"
			?defValue 	5
			?type     	"float"
			?display  	"t"
			?callback	""
		)
		
		cdfCreateParam( cdfId
			?name		"number"
			?prompt   	"number"
			?defValue 	1
			?type     	"int"
			?display  	"t"
			?callback	""
		)
		
		cdfCreateParam( cdfId
			?name		"space"
			?prompt   	"space"
			?defValue 	0.5
			?type     	"float"
			?display  	"t"
			?callback	""
		)
		
		cdfCreateParam( cdfId
			?name		"shift"
			?prompt   	"shift"
			?defValue 	0.0
			?type     	"float"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"layer"
			?prompt   	"object layer"
			?defValue 	"MET1"
			?type     	"cyclic"
			?choices	list("MET1" "MET2" "MET3" "MET4" "MET5")
			?display  	"t"
			?callback	""
		)
		
		cdfCreateParam( cdfId
			?name		"fixed"
			?prompt   	"fixed lenght"
			?defValue 	t
			?type     	"boolean"
			?display  	"t"
			?callback	""
		)
	)
)