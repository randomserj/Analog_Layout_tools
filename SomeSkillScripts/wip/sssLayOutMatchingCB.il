procedure( SSSLayOutMatchingCBLayout(_objs)
let( (props pattern row string name names objs isFound (x 100) (y -100) dx dy bnd)
	objs = _objs
	props = car(objs)~>matching
	dprint(props)
	pattern = reverse(car(reverse(props)))
	string = ""
	dy = 0
	foreach( row pattern
		dprint(row)
		string = strcat( string buildString(row "") )
		/*
		names = parseString(string "-")
		dx = 0
		foreach(name names
			isFound = nil
			foreach(obj dilSmartArrayObjs
				when( rexMatchp(sprintf(nil "^%s[. (]" name) car(obj~>figs~>baseName)) && !isFound
					dilSmartArrayObjs = remove(obj dilSmartArrayObjs)
					isFound = t
					x = -1 * car(obj~>origin) + dx
					y = -1 * cadr(obj~>origin) + dy
					dbMoveFig( obj obj~>cellView list(list(x y) "R0" 1) )
					bnd = DILSmartArrayCBGetGroupBoundary(obj)
					dx = dx + abs(caar(bnd~>bBox) - caadr(bnd~>bBox))
				)
			)
		)
		dy = dy + abs(cadar(bnd~>bBox) - cadadr(bnd~>bBox))
		*/
		string = strcat(string "/")
	)
	dprint(string)
);let
);procedure
