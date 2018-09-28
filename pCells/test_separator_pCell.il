let( ( pCellLibrary pCellName )
	pCellLibrary = "zz_spakhomov"
	pCellName = "separator"

	pcDefinePCell( list(ddGetObj(pCellLibrary) pCellName "layout" )
		(
			(width float 	0.2)
			(metal int		1)
		)
		let(
			(
				cv tf metalLayers validLayers validMetalLayers
				layer body x1 x2 y1 y2
				srcFig srcNet srcPin dstFig dstPin dstFig
			)

			cv = pcCellView
			tf = techGetTechFile(ddGetObj("FDRY_TECH"))
			metalLayers = mapcar('car setof(func techGetLayerFunctions(tf) cadr(func)=="metal"))
			validLayers = leGetValidLayerList(tf)
			validMetalLayers = setof(ml metalLayers member(list(ml "drawing") validLayers))

			x1 = 0
			x2 = 0.15
			y1 = 0
			y2 = width
			layer = nth( metal-1 validMetalLayers )

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
