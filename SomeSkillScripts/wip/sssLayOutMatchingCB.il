procedure( SSSLayOutMatchingCBLayout(mDef)
let( (props name names pattern temp_names letter row inst insts isFound x y dx dy bnd)
	props = mDef~>matching
	pattern = reverse(car(reverse(props)))
	names = makeTable( "names" )
	foreach( name cadr(props)
		names[cadr(name)] = car(name)
	)
	temp_names = list()
	foreach( row pattern
		dprint(row)
		foreach( letter row
			isFound = nil
			foreach( inst mDef~>cellView~>instances
				when( rexMatchp(sprintf(nil "^%s" names[letter]) inst~>name) && !isFound
					inst~>oldName = inst~>name
					inst~>name = strcat("mDef" inst~>name)
					temp_names = append1(temp_names inst~>name)
					isFound = t
				)
			)
		)
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
	)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; temporary solution to revert the names
	dprint(temp_names)
	foreach(name temp_names
		foreach(inst mDef~>cellView~>instances
			when( inst~>name == name inst~>name = car(parseString(name "mDef")))
		)
	)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

);let
);procedure
