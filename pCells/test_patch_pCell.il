let( ( pCellLibrary pCellName )
	pCellLibrary = "zz_spakhomov"
	pCellName = "patch"

	pcDefinePCell( list(ddGetObj(pCellLibrary) pCellName "layout" )
		( (metalWidth string "200n") (metalLayer string "METAL1") )
		let( ( cv cdf layer body x1 x2 y1 y2 srcFig srcNet srcPin dstFig dstPin dstFig )

			cv = pcCellView
			
			x1 = 0
			x2 = 0.15
			y1 = 0
			y2 = 1e6 * cdfParseFloatString(metalWidth)
			layer = metalLayer

			body = dbCreateRect( cv layer list(x1:y1 x2:y2) )

			srcNet = dbCreateNet( cv "src" )
			srcFig = dbCreateRect( cv layer list(x1-0.15:y1 x1:y2) )
			srcPin = dbCreatePin( srcNet srcFig )

			dstNet = dbCreateNet( cv "dst" )
			dstFig = dbCreateRect( cv layer list(x2:y1 x2+0.15:y2) )
			dstPin = dbCreatePin( dstNet dstFig )
		);let
	);pcDefinePCell
);let

let(
	(
		pCellLibrary pCellName cdfId
		tf ml metalLayers validLayers validMetalLayers
	)
	pCellLibrary = "zz_spakhomov"
	pCellName = "patch"
	tf = techGetTechFile(ddGetObj("FDRY_TECH"))
	metalLayers=mapcar('car setof(func techGetLayerFunctions(tf) cadr(func)=="metal"))
	validLayers = leGetValidLayerList(tf)
	validMetalLayers = setof(ml metalLayers member(list(ml "drawing") validLayers))

	unless( cellId = ddGetObj( pCellLibrary pCellName ) error( "Could not get cell %s." pCellName ) )
	when( cdfId = cdfGetBaseCellCDF( cellId ) cdfDeleteCDF( cdfId ) )

	cdfId = cdfCreateBaseCellCDF( cellId )

	cdfCreateParam( cdfId
		?name 		"metalLayer"
		?prompt 	"Metal layer"
		?defValue 	car(validMetalLayers)
		?type 		"cyclic"
		?choices 	validMetalLayers
	)

	cdfCreateParam( cdfId
		?name 		"metalWidth"
		?prompt 	"Metal width"
		?units 		"lengthMetric"
		?defValue 	"0.5u"
		?type 		"string"
		?parseAsNumber "yes"
		?parseAsCEL "yes"
	)

);let
