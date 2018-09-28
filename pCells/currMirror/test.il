procedure( isVertical( _points )
	let( ( (isFirstPoint t) )
		foreach( _point _points
			if( isFirstPoint then
				x1 = car(_point)
				y1 = cadr(_point)
				isFirstPoint = nil
			else
				x2 = car(_point)
				y2 = car(_point)
			)
		)
		if( x1-x2 == 0 then _vert = t else _vert = nil )
	)
)

procedure( drawBus( w done points )
	unless( ! points
		num = optForm->number->value
		spc = 2*optForm->space->value
		sBegin = optForm->shiftBegin->value
		sEnd = optForm->shiftEnd->value
		w = optForm->width->value
		if( optForm->typeOfShift->value == "to higher" then typ = t else typ = nil )
		for( i 0 num-1
			isFirstPoint = t
			pathPoints = list()
			foreach( point points
				x = car(point)
				y = cadr(point)
				if( isVertical( points ) then
					if( typ then x = x + i*spc else x = x - i*spc )
					if( isFirstPoint then y = y + i*sBegin else y = y + i*sEnd )	
				else
					if( typ then y = y + i*spc else y = y - i*spc )
					if( isFirstPoint then x = x + i*sBegin else x = x + i*sEnd )
				)
				point = list(x y)
				pathPoints = append( pathPoints list(point) )
				isFirstPoint = nil
			)
			dbCreatePath(
				cvId
				list( layer purpose )
				pathPoints
				w
			)
		)
	)
)

procedure( testBus()
	let( ()
		enterPath(
			?prompts '( "Enter first point" "Enter next points" )
			?pathWidth 1.0
			?wantPoints 2
			?pathStyle "Truncate"
			?doneProc "drawBus"
			?form form
		)
	)
)

form = hiCreateOptionsForm(
        'optForm
        "options"
        list(
			hiCreateFloatField(
				?name 'width
				?prompt "Width"
				?value techGetSpacingRule(
					techGetTechFile(cvId)
					"minWidth"
					list( layer purpose )
				)
				?callback ""
            )
            hiCreateIntField(
				?name 'number
				?prompt "Number of wires"
				?value 1
				?callback ""
            )
			hiCreateFloatField(
				?name 'space
				?prompt "Space"
				?value techGetSpacingRule(
					techGetTechFile(cvId)
					"minSpacing"
					list( layer purpose )
				)
				?callback ""
            )
			hiCreateFloatField(
				?name 'shiftBegin
				?prompt "Shift of begin"
				?value 0.0
				?callback ""
            )
			hiCreateFloatField(
				?name 'shiftEnd
				?prompt "Shift of end"
				?value 0.0
				?callback ""
            )
			hiCreateCyclicField(
				?name 'typeOfShift
				?prompt "Type of shift"
				?choices list( "to lower" "to higher" )
				?callback ""
            )
        )

)

cvId=geGetEditCellView()
layer = car(leGetEntryLayer())
purpose = cadr(leGetEntryLayer())

hiToggleEnterForm( form )
hiSetBindKey( "Layout" "<Key>b" "testBus()" )