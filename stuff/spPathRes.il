procedure( wireRes()
	let( (cv sqrtRes res width n x y prevPoint)
		printf("\n*** Wire resistance *** \n")
		cv = geGetEditCellView()
		wires = geGetSelectedSet()
		sheetRes = wireResOptForm->sheetResField->value
		foreach( wire wires
			prevPoint = nil
			res = 0
			n = 0
			wireName = wire~>name
			width = wire~>width
			wirePoints = wire~>points
			dprint(width)
			dprint(wirePoints)
			foreach( wirePoint wirePoints
				if( !prevPoint then
					prevPoint = wirePoint
				else
					x = abs( car(wirePoint) - car(prevPoint) )
					y = abs( cadr(wirePoint) - cadr(prevPoint) )
					res = res + sheetRes*sqrt( expt(x 2) + expt(y 2) )/width
					prevPoint = wirePoint
				)
			)
			n = length(wirePoints) - 2 ;;number of bends equal number of points substract 2
			res = res - 0.45*n*sheetRes ;;substract resistance of bends
			if( wireName then
				printf("Resistance of path named \"%s\" is %n Ohm\n", wireName, res)
			else
				printf("Resistance of selected path is %n Ohm\n", res)
			)
		)
	)
)

procedure( wireResOpt()
	let( ()
		if( boundp('wireResOptForm) then
			hiFormCancel(wireResOptForm)
			;;hiDeleteForm(wireResOptForm)
		)
		wireResOptForm = hiCreateAppForm(
			?name     'wireResOptForm
			?formTitle   "Options"
			?buttonLayout 'OKCancel
			?callback "wireRes()"
			?fields list(
					list(
						hiCreateFloatField(
							?name 'sheetResField
							?prompt  "Sheet resistance"
							?callback ""
							?value   1.0
                        			)
						10:10
                        			350:25
                        			120
					)
				)
			)
		hiDisplayForm( wireResOptForm )
	);let
)	 ;procedure
