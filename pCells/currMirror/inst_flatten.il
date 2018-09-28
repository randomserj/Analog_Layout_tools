procedure( getInfoFromInst( _mosType _diffLayer _polyLayer _metSDLayer )
let( ( cvId bBoxLL diffLL polyLL )
	cvId = geGetEditCellView()
	inst = dbCreateParamInst(
		cvId
		dbOpenCellViewByType( "PRIMLIB" _mosType "layout" )
		nil
		list(0 0)
		"R0"
		1
		list(
			list( "w" "string" "5u" )
			list( "l" "string" "1u" )
		)
	)
	
	bBoxLL = caar( inst~>bBox )
	flatInst = leFlattenInst( inst 32 t )
	
	foreach( shape cvId~>shapes
		if( shape~>layerName==_diffLayer then diffLL = cons( caar( shape~>bBox) diffLL ) )
		if( shape~>layerName==_polyLayer then polyLL = cons( caar( shape~>bBox) polyLL ) )
	)
	testVal1 = abs( bBoxLL - car( sort( diffLL 'lessp ) ) )
	testVal2 = abs( bBoxLL - car( sort( polyLL 'lessp ) ) )
	printf( "%f %f \n" testVal1 testVal2 )
	foreach( shape cvId~>shapes dbDeleteObject( shape ) )
)
)

mosType = "ne"
diffLayer = "DIFF"
polyLayer = "POLY1"
metSDLayer = "MET1"

hiSetBindKey( "Layout" "<Key>[" "getInfoFromInst( mosType diffLayer polyLayer metSDLayer )" )