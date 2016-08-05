procedure( DILSyncFamiliesForm(obj)
let(	(
		cv families
		fSyncFamily
		fSyncFamiliesX fSyncFamiliesY fSyncFamiliesW fSyncFamiliesH
		bCreateSyncFamily bRemoveFromSyncFamily bUpdateSyncFamily
		bSyncFamilyX bSyncFamilyY bSyncFamilyW bSyncFamilyH	
	)
	
	fSyncFamily = hiCreateFrameField(
		?name 'fSyncFamily
		?labelText "SyncFamily"
	)
	
	bCreateSyncFamily = hiCreateButton(
		?name 'bCreateSyncFamily
		?buttonText "Create Family"
		?callback "DILSyncFamiliesCreate(obj)"
	)
	
	bRemoveFromSyncFamily = hiCreateButton(
		?name 'bRemoveFromSyncFamily
		?buttonText "Remove from Family"
		?callback "DILSyncFamiliesRemove(obj)"
	)
	
	bUpdateSyncFamily = hiCreateButton(
		?name 'bUpdateSyncFamily
		?buttonText "Update Family"
		?callback "DILSyncFamiliesUpdate(obj)"
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
			?name 'dilSyncFamiliesForm
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
);let
);procedure
