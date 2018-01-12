;;;;;;;;;
;;; Rotates an object
;;;;;;;;;
procedure( MISCTransformRotate(object orient)
let( (cv bBox x0 y0 x1 y1 dx dy)
	when( orient
		cv = object~>cellview
		bBox = object~>bBox
		x0 = car( MISCCalcGetCenter(bBox) )
		y0 = cadr( MISCCalcGetCenter(bBox) )
		dbMoveFig( object cv list(list(0 0) orient 1) )
		bBox = object~>bBox
		x1 = car( MISCCalcGetCenter(bBox) )
		y1 = cadr( MISCCalcGetCenter(bBox) )
		dx = x0 - x1
		dy = y0 - y1
		dbMoveFig( object cv list(list(dx dy) "R0" 1) )
	)
);let
);procedure


