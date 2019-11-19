procedure( SSSNetShieldingForm()
let(
	(
		form size field (fields list())
	)
	field = hiCreateFloatSpinBox(
		?name 'fsbWidth
		?prompt "Width"
		?value 0.1
		?range list(0.0 10.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
	)
	fields = append1( fields list(field 30:30 	120:30	120) )
	field = hiCreateFloatSpinBox(
		?name 'fsbSpacing
		?prompt "Spacing"
		?value 0.1
		?range list(0.0 10.0)
		?step 0.005
		?precision 3
		?wrapAround nil
		?editable t
	)
	fields = append1( fields list(field 30:60 	120:30	120) )
	field = hiCreateBooleanButton(
		?name 'bbIsCoaxial
		?buttonText "Coaxial"
		?value nil
		?defValue nil
		?buttonLocation 'left
	)
	fields = append1( fields list(field 30:90 	90:30) )
	field = hiCreateBooleanButton(
		?name 'bbLeftSide
		?buttonText "Left side"
		?value t
		?defValue t
		?buttonLocation 'left
	)
	fields = append1( fields list(field 120:90 	90:30) )
	field = hiCreateBooleanButton(
		?name 'bbRightSide
		?buttonText "Right side"
		?value t
		?defValue t
		?buttonLocation 'left
	)
	fields = append1( fields list(field 210:90	90:30) )
	size = list(350 350)
	form = hiCreateAppForm(
		?name 'sssNetShieldingForm
		?formTitle "Some Form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?fields fields
		?callback '("SSSNetShieldingLayoutCB()" "")
	)

);let
);procedure
