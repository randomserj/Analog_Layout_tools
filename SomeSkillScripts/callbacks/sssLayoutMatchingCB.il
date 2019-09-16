procedure( SSSLayOutMatchingCBLayout(mDef)
let(
	(
		cv props name names pattern temp_names letter row inst insts
		isFound mDefX mDefY x y dx dy i j bnd
	)
	props = mDef~>matching
	pattern = reverse(car(reverse(props)))
	names = makeTable( "names" )
	foreach( name cadr(props)
		names[cadr(name)] = car(name)
	)
	temp_names = list()
	cv = mDef~>cellView
	i = 0
	j = 0
	mDefX = car(mDef~>xy)
	mDefY = cadr(mDef~>xy)
	foreach( row pattern
		i = 0
		foreach( letter row
			isFound = nil
			foreach( inst cv~>instances
				when( rexMatchp(sprintf(nil "^%s" names[letter]) inst~>name) && !isFound
					inst~>oldName = inst~>name
					inst~>name = strcat("mDef" inst~>name)
					temp_names = append1(temp_names inst~>name)
					isFound = t
					dx = abs(caadr(inst~>bBox) - caar(inst~>bBox))
					dy = abs(cadadr(inst~>bBox) - cadar(inst~>bBox))
					x = mDefX - 1 * car(inst~>xy) + i*dx
					y = mDefY - 1 * cadr(inst~>xy) + j*dy
					dbMoveFig( inst cv list(list(x y) "R0" 1) )
				)
			)
			i++
		)
		j++
	)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; temporary solution to revert the names
	foreach(name temp_names
		foreach(inst cv~>instances
			when( inst~>name == name inst~>name = car(parseString(name "mDef")))
		)
	)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

);let
);procedure
