procedure( SSSLayOutMatchingForm(mDef)
let(
	(
		form size fields i j text
		pattern names rows cols
		fieldL
	)
	fields = list()
	props = mDef~>matching
	names = car(props)
	pattern = car(reverse(props))
	rows = length(car(pattern))
	cols = length(pattern)
	field = hiCreateButton(
			?name 'bLayout
			?buttonText "Press here to lay out pattern"
			?callback sprintf( nil "SSSLayOutMatchingCBLayout(mDef)" )
	)
	fields = list( list(field 30:30 210:30) )
	for(j 1 rows
		for( i 1 cols
			text = nth(i-1 nth(j-1 pattern))
			field = hiCreateButton(
				?name stringToSymbol( sprintf(nil "bArrayItem%d%d" i j) )
				?buttonText text
			)
			fields = append1( fields list(field 30*i:60+30*j 30:30) )
		)
	)
	size = list(350 350)
	form = hiCreateAppForm(
		?name 'sssLayOutMatchingForm
		?formTitle "Some Form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?fields fields
	)

);let
);procedure
