procedure( SSSToggleLayerVisibilityCtrl(key)
let( (layer layers (state t))
	case( key
		( 0
			foreach( layer sssFEOL state = state && leIsLayerVisible( layer ) )
			foreach( layer sssFEOL
				leSetLayerVisible(layer !state)
				leSetLayerSelectable(layer !state)
			)
		)
		( t
			state = leIsLayerVisible( list(nth(key-1 sssBEOL) "drawing") )
			when( leGetEntryLayer() != list(nth(key-1 sssBEOL) "drawing")
				foreach( layers list(sssBEOL sssPins sssCuts)
					leSetLayerVisible(nth(key-1 layers) !state)
					leSetLayerSelectable(nth(key-1 layers) !state)
				)
			)
		)
	)
	sssLayersToToggle = list()
);let
);procedure

procedure( SSSToggleLayerVisibility(key)
let( (n s l ls beolLayers cutLayers pinLayers (isPressedKeyTheSame nil))
	if( car(sssLayersToToggle) == key isPressedKeyTheSame = t )
	beolLayers = append1( constar(car(sssBEOL) sssBEOL) car(reverse(sssBEOL)) )
	pinLayers = append1( constar(car(sssPins) sssPins) car(reverse(sssPins)) )
	cutLayers = append1( constar(car(sssCuts) sssCuts) car(reverse(sssCuts)) )
	if( !isPressedKeyTheSame then
		case( key
			( 0
				sssLayersToToggle = list( key
					list(
						sssFEOL
						append(beolLayers append(pinLayers cutLayers))
			)))
			( t
				sssLayersToToggle = list( key
					list(
						list( nth(key beolLayers) nth(key pinLayers) nth(key cutLayers) )
						list( nth(key   beolLayers) nth(key   pinLayers) nth(key   cutLayers)
						      nth(key+1 beolLayers) nth(key+1 pinLayers) nth(key+1 cutLayers)
						      nth(key-1 beolLayers) nth(key-1 pinLayers)
						)

			)))
		)
	else
		sssLayersToToggle = list( key reverse(cadr(sssLayersToToggle)))
	)
	leSetEntryLayer( car(caadr(sssLayersToToggle)) )
	leSetAllLayerVisible(nil)
	foreach( l caadr(sssLayersToToggle)
		leSetLayerVisible(l t)
		leSetLayerSelectable(l t)
	)
	leSetLayerVisible(list("instance" "drawing") t)
	hiRedraw(hiGetCurrentWindow())
);let
);procedure

let( (i limit)
	limit = min(9, length(sssBEOL) - 1)
	for( i 0 limit
		hiSetBindKey("Layout" sprintf(nil "<Key>%d" i) sprintf(nil "SSSToggleLayerVisibility(%d)" i))
		hiSetBindKey("Layout" sprintf(nil "Ctrl<Key>%d" i) sprintf(nil "SSSToggleLayerVisibilityCtrl(%d)" i))
		;hiSetBindKey("Layout" sprintf(nil "Shift<Key>%d" i) sprintf(nil "SSSToggleLayerVisibilityShift(%d)" i))
	)
	hiSetBindKey("Layout" "<Key>`" "leSetAllLayerVisible(t) leSetAllLayerSelectable(t) hiRedraw(hiGetCurrentWindow()) sssLayersToToggle = list()")
);let
