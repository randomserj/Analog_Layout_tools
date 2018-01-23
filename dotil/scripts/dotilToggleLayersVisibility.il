/*
procedure( DILToggleLayerVisibilityCtrl(key)
let( ()

);let
);procedure
*/

procedure( DILToggleLayerVisibility(key)
let( (n s l ls beolLayers cutLayers pinLayers k (isPressedKeyTheSame nil))
	sprintf(k "%d" key)
	if( car(dilLayersToToggle) == k isPressedKeyTheSame = t )
	beolLayers = append1( constar(car(dilBEOL) dilBEOL) car(reverse(dilBEOL)) )
	pinLayers = append1( constar(car(dilPins) dilPins) car(reverse(dilPins)) )
	cutLayers = append1( constar(car(dilCuts) dilCuts) car(reverse(dilCuts)) )
	if( !isPressedKeyTheSame then
		case( key
			( 0
				dilLayersToToggle = list( k
					list(
						dilFEOL
						append(beolLayers append(pinLayers cutLayers))
			)))
			( t
				dilLayersToToggle = list( k
					list(
						list( nth(key beolLayers) nth(key pinLayers) nth(key cutLayers) )
						list( nth(key   beolLayers) nth(key   pinLayers) nth(key   cutLayers)
						      nth(key+1 beolLayers) nth(key+1 pinLayers) nth(key+1 cutLayers)
						      nth(key-1 beolLayers) nth(key-1 pinLayers)
						)

			)))
		)
	else
		dilLayersToToggle = list( k reverse(cadr(dilLayersToToggle)))
	)
	leSetEntryLayer( "text" )
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
		;hiSetBindKey("Layout" sprintf(nil "Ctrl<Key>%d" i) sprintf(nil "DILToggleLayerVisibilityCtrl(%d)" i))
	)
	hiSetBindKey("Layout" "<Key>`" "leSetAllLayerVisible(t) leSetAllLayerSelectable(t) hiRedraw(hiGetCurrentWindow()) dilLastPressedKey = \"\"")
);let
