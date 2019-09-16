procedure( SSSToggleLayerVisibility(key)
let( (n s l ls beolLayers cutLayers pinLayers dumLayers (isPressedKeyTheSame nil))
	if( car(sssLayersToToggle) == key isPressedKeyTheSame = t )
	beolLayers = append1( constar(car(sssBEOL) sssBEOL) car(reverse(sssBEOL)) )
	pinLayers = append1( constar(car(sssPins) sssPins) car(reverse(sssPins)) )
	dumLayers = append1( constar(car(sssDummies) sssDummies) car(reverse(sssDummies)) )
	cutLayers = append1( constar(car(sssCuts) sssCuts) car(reverse(sssCuts)) )
	when( length(sssDummies) < length(sssBEOL) dumLayers = reverse(cdr(reverse(dumLayers))) )
	if( !isPressedKeyTheSame then
		case( key
			( 0
				sssLayersToToggle = list( key
					list( sssFEOL
						append( beolLayers
							append( pinLayers
								append( dumLayers cutLayers )))
					)
				)
			)
			( t
				sssLayersToToggle = list( key
					list(
						list( nth(key beolLayers) nth(key pinLayers) nth(key dumLayers) nth(key cutLayers) )
						list( nth(key   beolLayers) nth(key   pinLayers) nth(key dumLayers) nth(key cutLayers)
						      nth(key+1 beolLayers) nth(key+1 pinLayers) nth(key+1 dumLayers) nth(key+1 cutLayers)
						      nth(key-1 beolLayers) nth(key-1 pinLayers) nth(key-1 dumLayers)
						)
					)
				)
			)
		)
	else
		sssLayersToToggle = list( key reverse(cadr(sssLayersToToggle)))
	)
	leSetEntryLayer( car(caadr(sssLayersToToggle)) )
	leSetAllLayerVisible(nil)
	foreach( l caadr(sssLayersToToggle)
		when( l
			leSetLayerVisible(l t)
			leSetLayerSelectable(l t)
		)
	)
	leSetLayerVisible(list("instance" "drawing") t)
	hiRedraw(hiGetCurrentWindow())
);let
);procedure

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

procedure( SSSToggleLayerVisibilityShift(key)
let( (layer layers (state t))
	case( key
		( 0
			foreach( layer sssDummies state = state && leIsLayerVisible( layer ) )
			foreach( layer sssDummies
				leSetLayerVisible(layer !state)
				leSetLayerSelectable(layer !state)
			)
		)
		( t
			when( nth(key-1 sssDummies)
				state = leIsLayerVisible( list(car(nth(key-1 sssDummies)) cadr(nth(key-1 sssDummies))) )
				when( leGetEntryLayer() != list(car(nth(key-1 sssDummies)) cadr(nth(key-1 sssDummies)))
					leSetLayerVisible(nth(key-1 sssDummies) !state)
					leSetLayerSelectable(nth(key-1 sssDummies) !state)
				)
			)
		)
	)
	sssLayersToToggle = list()
);let
);procedure

procedure( SSSToggleLayerVisibilityALL()
let( ()
	leSetAllLayerSelectable(t)
	leSetAllLayerVisible(t)
	hiRedraw(hiGetCurrentWindow())
	sssLayersToToggle = list()
);let
);procedure

let( (i limit)
	limit = min( 9, length(sssBEOL) )
	for( i 0 limit
		hiSetBindKey("Layout" sprintf(nil "<Key>%d" i) sprintf(nil "SSSToggleLayerVisibility(%d)" i))
		hiSetBindKey("Layout" sprintf(nil "Ctrl<Key>%d" i) sprintf(nil "SSSToggleLayerVisibilityCtrl(%d)" i))
		hiSetBindKey("Layout" sprintf(nil "Shift<Key>%d" i) sprintf(nil "SSSToggleLayerVisibilityShift(%d)" i))
	)
	hiSetBindKey("Layout" "<Key>`" "SSSToggleLayerVisibilityALL()")
	hiSetBindKey("Layout" "<Key>sterling" "SSSToggleLayerVisibilityShift(3)") ;;; silly shift+3 = £
);let
