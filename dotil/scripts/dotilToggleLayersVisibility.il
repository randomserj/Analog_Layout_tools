procedure( DILToggleLayerVisibilityCtrl(key)
let( (layer layers (state t))
	case( key
		( 0
			foreach( layer dilFEOL state = state && leIsLayerVisible( layer ) )
			foreach( layer dilFEOL
				leSetLayerVisible(layer !state)
				leSetLayerSelectable(layer !state)
			)
		)
		( t
			state = leIsLayerVisible( list(nth(key-1 dilBEOL) "drawing") )
			when( leGetEntryLayer() != list(nth(key-1 dilBEOL) "drawing")
				foreach( layers list(dilBEOL dilPins dilCuts)
					leSetLayerVisible(nth(key-1 layers) !state)
					leSetLayerSelectable(nth(key-1 layers) !state)
				)
			)
		)
	)
	dilLayersToToggle = list()
);let
);procedure

procedure( DILToggleLayerVisibility(key)
let( (n s l ls beolLayers cutLayers pinLayers (isPressedKeyTheSame nil))
	if( car(dilLayersToToggle) == key isPressedKeyTheSame = t )
	beolLayers = append1( constar(car(dilBEOL) dilBEOL) car(reverse(dilBEOL)) )
	pinLayers = append1( constar(car(dilPins) dilPins) car(reverse(dilPins)) )
	cutLayers = append1( constar(car(dilCuts) dilCuts) car(reverse(dilCuts)) )
	if( !isPressedKeyTheSame then
		case( key
			( 0
				dilLayersToToggle = list( key
					list(
						dilFEOL
						append(beolLayers append(pinLayers cutLayers))
			)))
			( t
				dilLayersToToggle = list( key
					list(
						list( nth(key beolLayers) nth(key pinLayers) nth(key cutLayers) )
						list( nth(key   beolLayers) nth(key   pinLayers) nth(key   cutLayers)
						      nth(key+1 beolLayers) nth(key+1 pinLayers) nth(key+1 cutLayers)
						      nth(key-1 beolLayers) nth(key-1 pinLayers)
						)

			)))
		)
	else
		dilLayersToToggle = list( key reverse(cadr(dilLayersToToggle)))
	)
	leSetEntryLayer( car(caadr(dilLayersToToggle)) )
	leSetAllLayerVisible(nil)
	foreach( l caadr(dilLayersToToggle)
		leSetLayerVisible(l t)
		leSetLayerSelectable(l t)
	)
	hiRedraw(hiGetCurrentWindow())
);let
);procedure

let( (i limit)
	limit = min(9, length(dilBEOL) - 1)
	for( i 0 limit
		hiSetBindKey("Layout" sprintf(nil "<Key>%d" i) sprintf(nil "DILToggleLayerVisibility(%d)" i))
		hiSetBindKey("Layout" sprintf(nil "Ctrl<Key>%d" i) sprintf(nil "DILToggleLayerVisibilityCtrl(%d)" i))
		;hiSetBindKey("Layout" sprintf(nil "Shift<Key>%d" i) sprintf(nil "DILToggleLayerVisibilityShift(%d)" i))
	)
	hiSetBindKey("Layout" "<Key>``" "leSetAllLayerVisible(t) leSetAllLayerSelectable(t) hiRedraw(hiGetCurrentWindow()) dilLayersToToggle = list()")
);let
