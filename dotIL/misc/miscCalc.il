;;;;;;;;;
;;; Gets width and lenght of a rectangle
;;;;;;;;;
procedure( MISCCalcGetDimensions(rect)
let( (w l)
	w = abs(caar(rect) - caadr(rect))
	l = abs(cadar(rect) - cadadr(rect))
	list(w l)
	
);let
);procedure

;;;;;;;;;
;;; Gets coords of a rectangle centre
;;;;;;;;;
procedure( MISCCalcGetCenter(rect)
let( (xC yC)
	xC = atof(sprintf( nil "%.2f" (caar(rect) + caadr(rect))/2 ))
	yC = atof(sprintf( nil "%.2f" (cadar(rect) + cadadr(rect))/2 ))
	list(xC yC)
);let
);procedure
