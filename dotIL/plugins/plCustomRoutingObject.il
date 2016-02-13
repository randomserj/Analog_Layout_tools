;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;		Custom routing objects
;;; v1.0
;;;	-key p for custom path
;;;	-key ctrl+p for custom wire
;;;	-key shift+p for multipart path !!! NOT WORKING
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printf("\tLoading custom routing objects...\n")

dilIsDrawing = nil
dilIsDrawingType = ""
procedure( DILCustomRoutingObject(type)
let( (l rls)
	dilIsDrawingType = type
	rls = append(dilPolys dilMetals) ;;; <--- valid routing layers
	if( type != "mpp" then
		l = car( leGetEntryLayer() )
		if( !member(l rls) then
			leSetEntryLayer( list(car(rls) "drawing"))
			printf("[WARNING] Layer has been change to the first routing layer (%s drawing)\n" l)
		)
	)
	dilIsDrawing = t
	if( type == "path" then
		leSetEnv( "pathWidth" techGetSpacingRule(dilTechFile "minWidth" list(l "drawing") ) )
		leHiCreatePath()
	)
	if( type == "wire" then
		leSetEnv( "wireWidth" techGetSpacingRule(dilTechFile "minWidth" list(l "drawing") ) )
		leHiCreateWire()
	)
	dilIsDrawing = nil
	dilIsDrawingType = ""
);let
);procedure

hiSetBindKey("Layout" "p" "DILCustomRoutingObject(\"path\")")
hiSetBindKey("Layout" "Ctrl<Key>p" "DILCustomRoutingObject(\"wire\")")
hiSetBindKey("Layout" "Shift<Key>p" "DILCustomRoutingObject(\"mpp\")")

