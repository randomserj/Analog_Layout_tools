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
	else
		printf("[WARNING] Selected group is not a SyncFamily member")
	)
);let
);procedure

procedure( DILUpdateFamily(o)
let( (cv family g gs f fig newFigs oldFigs orient dx dy)
	if( o~>dilFamily then
		cv = geGetEditCellView()
		family = o~>dilFamily
		gs = cv~>figGroups
		foreach( g gs
			when( g~>dilFamily == family && g != o
				orient = g~>orient
				dx = car(g~>origin) - car(o~>origin)
				dy = cadr(g~>origin) - cadr(o~>origin)
				newFigs = o~>figs
				oldFigs = g~>figs
				foreach( fig newFigs
					f = dbCopyFig( fig cv list(list(dx dy) orient 1) )
					dbAddFigToFigGroup(g f)	
				)
				foreach( fig oldFigs
					dbDeleteObject(fig)
				)
			)
		)
	else
		printf("[WARNING] Selected group is not a SyncFamily member")
	)
);let
);procedure

procedure( DILSyncFamiliesForm(obj)
let(	(
		cv families
		fSyncFamily
		fSyncFamiliesX fSyncFamiliesY fSyncFamiliesW fSyncFamiliesH
		bCreateSyncFamily bRemoveFromSyncFamily bUpdateSyncFamily
		bSyncFamilyX bSyncFamilyY bSyncFamilyW bSyncFamilyH	
	)
	
	cv = geGetEditCellView()
	families = cv~>dilFamilies
	
	fSyncFamily = hiCreateFrameField(
		?name 'fSyncFamily
		?labelText "SyncFamily"
	)
	
	bCreateSyncFamily = hiCreateButton(
		?name 'bCreateSyncFamily
		?buttonText "Create Family"
		?callback "DILCreateFamily(obj families)"
	)
	
	bRemoveFromSyncFamily = hiCreateButton(
		?name 'bRemoveFromSyncFamily
		?buttonText "Remove from Family"
		?callback "DILRemoveFromFamily(obj families)"
	)
	
	bUpdateSyncFamily = hiCreateButton(
		?name 'bUpdateSyncFamily
		?buttonText "Update Family"
		?callback "DILUpdateFamily(obj)"
	)
	
	bSyncFamilyX = dilSyncFamiliesFormTabH
	bSyncFamilyY = 3*dilSyncFamiliesFormTabV
	bSyncFamilyW = 150
	bSyncFamilyH = 60
	
	fSyncFamiliesX = 0
	fSyncFamiliesY = dilSyncFamiliesFormTabV
	fSyncFamiliesW = bSyncFamilyW + 2*dilSyncFamiliesFormTabV
	fSyncFamiliesH = 3*bSyncFamilyH + 3*dilSyncFamiliesFormTabH
	
	size = list(fSyncFamiliesW fSyncFamiliesH+4*dilSyncFamiliesFormTabH)
	
		hiCreateAppForm(
			?name 'syncFamiliesForm
			?formTitle "SyncFamily"
			?buttonLayout 'Close
			?initialSize size
			?minSize size
			?maxSize size
			?fields list(
				list( fSyncFamily			fSyncFamiliesX:fSyncFamiliesY							fSyncFamiliesW:fSyncFamiliesH	30	)
				list( bCreateSyncFamily			bSyncFamilyX:bSyncFamilyY							bSyncFamilyW:bSyncFamilyH		)
				list( bRemoveFromSyncFamily		bSyncFamilyX:bSyncFamilyY+1*bSyncFamilyH					bSyncFamilyW:bSyncFamilyH		)
				list( bUpdateSyncFamily			bSyncFamilyX:bSyncFamilyY+2*bSyncFamilyH					bSyncFamilyW:bSyncFamilyH		)
			)
		)
	hiDisplayForm(syncFamiliesForm)
);let
);procedure

/*procedure( DILSyncFamiliesForm(obj)
	if( boundp('syncFamiliesForm) && hiIsFormDisplayed(syncFamiliesForm)
		hiFormDone(syncFamiliesForm)
	)
	hiEnqueueCmd("DILCreateSyncFamiliesForm(obj)")
);procedure*/
