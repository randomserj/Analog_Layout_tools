procedure( SSSDefineMatchingForm(_objs)
let(
	(
		form size objs fields
		fieldP fieldC fieldD fieldN fieldM
	)
	objs = _objs
	size = list(350 350)

	fieldP = hiCreateCyclicField(
		?name 'fieldP
		?choices list( "---" "common centroid" "interdigitated" "grouped" )
		?prompt "Pattern"
		?defValue "---"
	)
	fieldC = hiCreateCyclicField(
		?name 'fieldC
		?choices list( "---" "single" "equal" "almost same" )
		?prompt "Current direction"
		?defValue "---"
	)
	fieldD = hiCreateCyclicField(
		?name 'fieldD
		?choices list( "---" "on sides" "all around" )
		?prompt "Dummies"
		?defValue "---"
	)
	fieldM = hiCreateCyclicField(
		?name 'fieldM
		?choices list( "---" "no coverage" "only top" "only symmetrical")
		?prompt "Metal"
		?defValue "---"
	)
	fieldPattern = hiCreateButton(
			?name 'fieldPattern
			?buttonText "Press here to define pattern"
			?callback "SSSDefineMatchingCBSetup(objs)"
	)

	fields = list(
		list( fieldP	 		30:30	120:30	120 )
		list( fieldC	 		30:60	120:30	120 )
		list( fieldD	 		30:90	120:30	120 )
		list( fieldM	 		30:120	120:30	120 )
		list( fieldPattern		90:150	210:30		)
	)

	form = hiCreateAppForm(
		?name 'sssDefineMatchingForm
		?formTitle "Some Form"
		?buttonLayout 'OKCancel
		?initialSize size
		?minSize size
		?fields fields
		?callback "SSSDefineMatchingCB(objs)"
	)
	/*
	when( car(objs)~>matching
		SSSPrint( "Loading matching parameters" "INFO" )
		form~>fieldP~>value = nth( 1 car(objs)~>matching)
		form~>fieldC~>value = nth( 2 car(objs)~>matching)
		form~>fieldD~>value = nth( 3 car(objs)~>matching)
		form~>fieldM~>value = nth( 4 car(objs)~>matching)
	)
	*/
);let
);procedure
