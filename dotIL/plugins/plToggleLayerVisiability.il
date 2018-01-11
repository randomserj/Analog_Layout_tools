;printf("\tLoading routing layers visiability bind keys...\n")

procedure( DILToggleLayerVisiability0(key @optional ctrl)
let( (mode l ls)
	if( !ctrl then leSetEntryLayer( "text" ) )
	mode = t
	if( key == dilLastPressedKey then
		if( ctrl then mode = nil else leSetAllLayerVisible(t) )
		dilLastPressedKey = ""
	else
		if( !ctrl then leSetAllLayerVisible(nil) )
		dilLastPressedKey = key
	)
	ls = append( dilPolys dilDiff )
	ls = append( ls dilImps)
	ls = append( ls dilWells)
	foreach( l ls
		leSetLayerVisible(l mode)
		leSetLayerSelectable(l mode)
	)
	hiRedraw(hiGetCurrentWindow())
);let
);procedure

procedure( DILToggleLayerVisiabilityCtrl(key)
let( ()
	if( !member(car(leGetEntryLayer()) list( nth(key-1 dilMetals) nth(key-1 dilVias) )) then
		leSetLayerVisible( nth(key-1 dilMetals) !leIsLayerVisible(nth(key-1 dilMetals)) )
		leSetLayerVisible( nth(key-1 dilVias) !leIsLayerVisible(nth(key-1 dilMetals)) )
	else
		DILPrint( sprintf(nil "[WARNING] Either %s or %s is selected\n" nth(key-1 dilMetals) nth(key-1 dilVias)) "WARNING" )
	)
	dilLastPressedKey = ""
);let
);procedure

procedure( DILToggleLayerVisiability(key)
let( (l ls)
	leSetEntryLayer( "text" )
	leSetEntryLayer( nth(key-1 dilMetals) )
	leSetAllLayerVisible(nil)
	ls = list( nth(key-1 dilMetals) nth(key-1 dilVias) )
	if( key == dilLastPressedKey then
		if( key == 1 then
			ls = append( ls dilPolys )
		)
		if( key > 1 then
			ls = constar( nth(key-2 dilMetals) nth(key-2 dilVias) ls )
		)
		if( key != length(dilMetals) then
			ls = constar( nth(key dilMetals) nth(key dilVias) nth(key dilMetals) nth(key dilVias) ls )
		)
		dilLastPressedKey = ""
	else
		dilLastPressedKey = key
	)
	foreach( l ls
		leSetLayerVisible(l t)
		leSetLayerSelectable(l t)
	)
	hiRedraw(hiGetCurrentWindow())
);let
);procedure

let( (i limit)
	dilLastPressedKey = ""
	limit = min(9, length(dilMetals) - 1)
	for( i 1 limit
		hiSetBindKey("Layout" sprintf(nil "<Key>%d" i) sprintf(nil "DILToggleLayerVisiability(%d)" i))
		hiSetBindKey("Layout" sprintf(nil "Ctrl<Key>%d" i) sprintf(nil "DILToggleLayerVisiabilityCtrl(%d)" i))
	)
	hiSetBindKey("Layout" "<Key>`" "leSetAllLayerVisible(t) leSetAllLayerSelectable(t) hiRedraw(hiGetCurrentWindow()) dilLastPressedKey = \"\"")
	hiSetBindKey("Layout" "<Key>0" "DILToggleLayerVisiability0(0)")
	hiSetBindKey("Layout" "Ctrl<Key>0" "DILToggleLayerVisiability0(0 t)")
);let
