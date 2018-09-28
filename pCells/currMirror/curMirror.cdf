let( (cellId cdfId)

	when( cellId = ddGetObj( libName cellName )

		when( cdfId = cdfGetBaseCellCDF(cellId) cdfDeleteCDF(cdfId) )
		cdfId = cdfCreateBaseCellCDF(cellId)

		cdfCreateParam( cdfId
			?name		"wMOS"
			?prompt   	"Width of finger"
			?defValue 	"1u M"
			?type     	"string"
			?display  	"t"
			?callback	"cb_wMOS(cdfgData->wMOS->value)"
		)
		
		cdfCreateParam( cdfId
			?name		"lMOS"
			?prompt   	"Length of finger"
			?defValue 	"180n M"
			?type     	"string"
			?display  	"t"
			?callback	"cb_lMOS(cdfgData->wMOS->value)"
		)

		cdfCreateParam( cdfId
			?name		"pattern"
			?prompt   	"Pattern"
			?defValue 	"A R"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"spaceDiff"
			?prompt   	"Space between diffusion"
			?defValue 	"0u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"sdShare"
			?prompt   	"Allow S/D sharing"
			?defValue 	t
			?type     	"boolean"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"widthPower"
			?prompt   	"Power bus width"
			?defValue 	"1u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"spacePower"
			?prompt   	"Power bus space to MOSes"
			?defValue 	"0u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"busPower"
			?prompt   	"Power bus"
			?defValue 	t
			?type     	"boolean"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"spaceGateToMOSes"
			?prompt   	"Gate bus space to MOSes"
			?defValue 	"0.5u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"widthGate"
			?prompt   	"Gate bus width"
			?defValue 	"0.5u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"busGate"
			?prompt   	"Gate bus"
			?defValue 	t
			?type     	"boolean"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"spaceDrainsToGate"
			?prompt   	"Drain buses space to Gate"
			?defValue 	"0.5u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"widthDrains"
			?prompt   	"Drain buses width"
			?defValue 	"0.5u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"spaceDrains"
			?prompt   	"Drain buses space"
			?defValue 	"0.5u M"
			?type     	"string"
			?display  	"t"
			?callback	""
		)

		cdfCreateParam( cdfId
			?name		"layerDrains"
			?prompt   	"Drain buses layer"
			?defValue 	car( techLayers )
			?type     	"cyclic"
			?choices	techLayers
			?display  	"t"
			?callback	""
		)

	)
); let