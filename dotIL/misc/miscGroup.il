;;;;;;;;;
;;; Gets a text boundary of a group
;;;;;;;;;
procedure( MISCGroupGetBoundary(group)
let( (fig figs boundary)
	figs = group~>figs
	foreach(fig figss
		when( fig~>objType == "rect" && fig~>layerName == "text"
			boundary = fig
		)
	)
	boundary
);let
);procedure
