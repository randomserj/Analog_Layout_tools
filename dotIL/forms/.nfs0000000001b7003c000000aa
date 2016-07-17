procedure( DILCreateFamily(o fs)
let( (cv)
	if( !o~>dilFamily then
		cv = geGetEditCellView()
		if( fs then fs++ else fs = 1	)
		o~>dilFamily = fs
		cv~>dilFamilies = fs
	else
		printf("[WARNING] Selected group is a SyncFamily already")
	)
);let
);procedure

procedure( DILRemoveFromFamily(o fs)
let( (cv)
	if( o~>dilFamily then
		dbDeletePropByName(
			o
			"dilFamily"
		)
		cv = geGetEditCellView()
		if( fs <= 1 then fs = 0 else fs-- )
		cv~>dilFamilies = fs
	else
		printf("[WARNING] Selected group is not a SyncFamily member")
	)
);let
);procedure

procedure( DILUpdateFamily(o)
let( (cv family g gs fig figs origin orient dx dy)
	if( o~>dilFamily then
		cv = geGetEditCellView()
		family = o~>dilFamily
		gs = cv~>figGroups
		foreach( g gs
			when( g~>dilFamily == family && g != o
				orient = g~>orient
				dx = car(g~>origin) - car(o~>origin)
				dy = cadr(g~>origin) - cadr(o~>origin)
				origin = list(dx dy)
				figs = g~>figs
				foreach( fig figs
					dbDeleteObject(fig)
				)
				dbDeleteObject(g)
				dbCopyFig(o cv list(origin orient 1))
			)
		)
	else
		printf("[WARNING] Selected group is not a SyncFamily member")
	)
);let
);procedure

procedure( DILSyncFamiliesForm(obj families)
let(	(
		bCreateFamily
		bRemoveFromFamily
		bUpdateFamily
	)
	
	bCreateFamily = hiCreateButton(
		?name 'bConvertToClone
		?buttonText "Create Family"
		?callback "DILCreateFamily(obj families)"
	)
	
	bRemoveFromFamily = hiCreateButton(
		?name 'bRemoveFromFamily
		?buttonText "Remove from Family"
		?callback "DILRemoveFromFamily(obj families)"
	)
	
	bUpdateFamily = hiCreateButton(
		?name 'bUpdateFamily
		?buttonText "Update Family"
		?callback "DILUpdateFamily(obj)"
	)
	
	hiCreateAppForm(
		?name 'syncFamiliesForm
		?buttonLayout 'OKCancel
		?fields list(
			bCreateFamily
			bRemoveFromFamily
			bUpdateFamily
		)
	)
	
	hiDisplayForm(syncFamiliesForm)
	
);let
);procedure
