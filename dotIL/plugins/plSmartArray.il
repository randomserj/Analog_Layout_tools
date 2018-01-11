procedure( DILSmartArray()
let(
	(
		obj (objs nil) elements nA nO
		baseName name (names nil) uniqName (uniqNames nil) p i tempList count
	)

	foreach( obj geGetSelSet()
		when( obj~>type == "syncClone"
			objs = append1(objs obj)
		)
	)
	if( objs then
		dilSmartArrayObjs = objs
		foreach(baseName objs~>figs~>baseName
			name = car(baseName)
			p = parseString(name ".")		;; check if it's a primitive
			i = parseString(name "()")		;; check if it's an instance
			when( !cdr(p) && !cdr(i) names = append1(names name) )
			when( !cdr(p) && cdr(i) names = append1(names car(i)) )
			when( cdr(p) && !cdr(i) names = append1(names car(p)) )
		)
		count = makeTable("count" 0)
		foreach(name names count[name] = count[name] + 1)
		uniqNames = setof(name names
			unless(member(name tempList) tempList = cons(name tempList))
		)
		dilSmartArrayElements = append(list(" " "dum") uniqNames)
		unless( boundp('dilSmartArrayForm) && hiIsFormDisplayed(dilSmartArrayForm)
			DILSmartArrayForm(uniqNames count)
		)
		hiDisplayForm(dilSmartArrayForm)
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>F4" "DILSmartArray()" )
