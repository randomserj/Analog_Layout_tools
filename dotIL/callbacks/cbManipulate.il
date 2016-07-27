procedure( DILManipulateFormMoveCB(cv obj action m)
let( (origin shift s test)
	origin = obj~>origin
	s = m * dilManipulateForm~>flShift~>value
	case( action
		( "u" shift = list(0 s) )
		( "d" shift = list(0 -s) )
		( "l" shift = list(-s 0) )
		( "r" shift = list(s 0) )
	)
	dbMoveFig( obj cv list(shift "R0" 1) )
);let
);procedure

