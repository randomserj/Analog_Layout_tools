load( "~/skill/pCells/currMirror/stuff.il" )
libName = "zz_spakhomov"

scriptPath = simplifyFilename( get_filename( piport ) )
scriptPathList = parseString( scriptPath "/" )
cellName = car( parseString( car( reverse( scriptPathList ) ) "." ) )
dirs = reverse( cdr( reverse( scriptPathList ) ) )
pathToLoad = ""
foreach(dir dirs
	pathToLoad = strcat( pathToLoad "/" dir )
)
pathToLoad = strcat( pathToLoad "/" )

load( strcat( pathToLoad cellName ".migrate" ) )
load( strcat( pathToLoad cellName ".cdf" ) )
load( strcat( pathToLoad cellName ".cb" ) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Geometry ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
procedure( layMOS( _pcCellView _instParams _width _length _w _l _x _p _prevp)
	_inst = dbCreateParamInst(
		_pcCellView
		instCellView
		nil
		list(bBoxOverGate + _x 0)
		"R0"
		1
		_instParams
	)
	dbCreateLabel(
		_pcCellView
		list( "text" "drawing" )
		list( _x + ( caadr( _inst~>bBox ) - caar( _inst~>bBox ) )/2 _w/4 )
		p
		"centerCenter"
		"R0"
		"stick"
		_w/5
	)

	;;; sources
	when( busPower
		if( _prevp == " " then
			_sPathX = caar( _inst~>bBox ) + bBoxOverDiff + diffOverCenterOfCont
		else
			_sPathX = caadr( _inst~>bBox ) - bBoxOverDiff - diffOverCenterOfCont
		)
		_sPathY = cadar( _inst~>bBox ) - sP
		dbCreatePath(
			_pcCellView
			sdMetLayer
			list( _sPathX:_w/2 _sPathX:_sPathY )
			sdMetWidth
		)
	);end of sources

	;;; drains
	if( _prevp != " " then
		_dPathX = caar( _inst~>bBox ) + bBoxOverDiff + diffOverCenterOfCont
	else
		_dPathX = caadr( _inst~>bBox ) - bBoxOverDiff - diffOverCenterOfCont
	)
	if( _p == "d" then
		if( busPower then _dPathY = _sPathY else _dPathY = w/4 )
		_layer = list( "METAL1" "drawing" )
	else
		_dPathY = cadadr( _inst~>bBox ) + sGTMs + wG + sDsTG + drainsCount*(wDs + sDs) - sDs
		_layer = list( "METAL2" "drawing" )
	)
	dbCreatePath(
		_pcCellView
		_layer
		list( _dPathX:_w/2 _dPathX:_dPathY )
		sdMetWidth
	);end of drains

	;;; gates
	when( busGate
		gPathX = caar( _inst~>bBox ) + bBoxOverGate
		gPathY = cadadr( _inst~>bBox ) + sGTMs + wG
		rodCreatePath(
			?layer polyLayer
			?pts list( gPathX:_w/2 gPathX:gPathY )
			?width _l
			?justification "left"
		)
	)
	;end of gates

	_inst = _inst
);end of layMOS

procedure( layPowerBus( _pcCellView _x _y )
	_pBusY = _y - sP
	rodCreatePath(
		?layer	sdMetLayer
		?pts list( 0:_pBusY _x:_pBusY )
		?width wP
		?justification "left"
	)
);end of layPowerBus

procedure( layGateBus( _pcCellView _x _y )
	_gBusY = _y + sGTMs
	rodCreatePath(
		?layer	sdMetLayer
		?pts list( 0:_gBusY _x:_gBusY )
		?width wG
		?justification "right"
	)
);end of layPowerBus

procedure( layDrainBus( _pcCellView _x _y _i )
	_dBusY = _y + sGTMs + wG + sDsTG + (_i - 1)*(sDs + wDs)
	when( layerDrains != "---"
		_layer = list( layerDrains "drawing" )
		rodCreatePath(
			?layer	_layer
			?pts list( 0:_dBusY _x:_dBusY )
			?width wDs
			?justification "right"
		)
	)
);end of layDrainBus
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PCell ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pcDefinePCell(
	list( ddGetObj( libName ) cellName "layout" )

	(
		( wMOS string "1u M" )
		( lMOS string "180n M" )
		( pattern string "A R")
		( spaceDiff string "0u M" )
		( sdShare boolean t )
		( widthPower string "1u M" )
		( spacePower string "0u M" )
		( busPower boolean t )
		( spaceGateToMOSes string "0.5u M")
		( widthGate string "0.5u M" )
		( busGate boolean t )
		( spaceDrainsToGate string "0.5u M" )
		( widthDrains string "0.5u M" )
		( spaceDrains string "0u M" )
		( layerDrains string "---" )
	)

	w = uM( wMOS )
	l = uM( lMOS )
	sD = uM( spaceDiff )
	wP = uM( widthPower)
	sP = uM( spacePower)
	sGTMs = uM( spaceGateToMOSes )
	wG = uM( widthGate )
	sDsTG = uM( spaceDrainsToGate )
	wDs = uM( widthDrains )
	sDs = uM( spaceDrains )

	elements = uniquify( parseString( pattern "") ) ; create list of uniq elements of pattern
	drainsCount = length( remove( " " remove( "d" remove( "R" elements ) ) ) )

;;;;;;; Create MOSes
	instParams = list(
		list( "w" "string" car( parseString( wMOS ) ) )
		list( "l" "string" car( parseString( lMOS ) ) )
	)
	x = 0
	prevp = ""
	if( sdShare then share = 1 else share = 0)
	foreach(p parseString( pattern "" )
		case( p
			( " "
				x = x + sD
				if( prevp != " " then x = x + 2*diffOverCenterOfCont*share )
			)
			( "d"
				inst = layMOS( pcCellView instParams wMOS lMOS w l x p prevp )
			)
			( t
				inst = layMOS( pcCellView instParams wMOS lMOS w l x p prevp )
			)
		)
		if( p != " " then x = x + ( caadr( inst~>bBox ) - caar( inst~>bBox ) ) - 2*bBoxOverDiff - 2*diffOverCenterOfCont*share )
		prevp = p
	)
;;;;;;; End of Create MOSes

;;;;;;; Create buses
	x = caadr( inst~>bBox )
	y = cadadr( inst~>bBox )
	for( i 1 drainsCount
		layDrainBus( pcCellView x y i )
	)
	when( busGate
		layGateBus( pcCellView x y )
	)
	when( busPower
		y = cadar( inst~>bBox )
		layPowerBus( pcCellView x y )
	)
;;;;;;; End of Create Buses

) ; End of PCEll
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
