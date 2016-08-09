;;;;;;;;;
;;; Gets a text boundary of a group
;;;;;;;;;
procedure( MISCGroupGetBoundary(group)
let( (fig figs boundary)
	figs = group~>figs
	foreach(fig figs
		when( fig~>objType == "rect" && fig~>layerName == "text"
			boundary = fig
		)
	)
	boundary
);let
);procedure

;;;;;;;;;
;;; Rotates a group
;;;;;;;;;
procedure( MISCGroupRotate(group orient)
let( (cv origin x0 y0 x1 y1 dx dy)
	when( orient
		cv = group~>cellview
		origin = group~>origin
		x0 = car( origin )
		y0 = cadr( origin )
		dbMoveFig( group cv list(list(0 0) orient 1) )
		origin = group~>origin
		x1 = car( origin )
		y1 = cadr( origin )
		dx = x0 - x1
		dy = y0 - y1
		dbMoveFig( group cv list(list(dx dy) "R0" 1) )
	)
);let
);procedure

;;;;;;;;;
;;; Sets group orient to R0
;;;;;;;;;
procedure(MISCGroupSetToR0(group)
let( (orient orients angle)
	orients = reverse( parseString(group~>orient "R") )
	when( cadr(orients) == "MX" MISCGroupRotate( group "MY" ) )
	when( cadr(orients) == "MY" MISCGroupRotate( group "MX" ) )
	angle = abs( evalstring( car(orients) ) - 360 )
	when( angle == 360 angle = 0 )
	orient = sprintf(nil "R%d" angle)
	MISCGroupRotate( group orient )
	
);let
);procedure

;;;;;;;;;
;;; Attaches a lable from the property to the group
;;;;;;;;;
procedure( MISCGroupAttachLabel(group)
let( (cv bnd bBox xC yC h label)
	cv = group~>cellView
	bnd = MISCGroupGetBoundary(group)
	bBox = bnd~>bBox
	xC = car(MISCCalcGetCenter(bBox))
	yC = cadr(MISCCalcGetCenter(bBox))
	h = atof(sprintf( nil "%.2f" car(MISCCalcGetDimensions(bBox))/2 ))
	label = dbCreateLabel(
		cv
		list("text" "drawing")
		list(xC yC)
		group~>dilLabel
		"centerCenter"
		"R0" 
		"roman"
		h
	)
	leAttachFig(
		label
		group
	)
);let
);procedure
