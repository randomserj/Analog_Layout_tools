procedure( DILSyncFamiliesCBCreate(o)
let( (cv fs)
	cv = o~>cellView
	fs = cv~>dilFamilies
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

procedure( DILSyncFamiliesCBRemove(o)
let( ()
	if( o~>dilFamily then
		dbDeletePropByName(
			o
			"dilFamily"
		)
	else
		printf("[WARNING] Selected group is not a SyncFamily member")
	)
);let
);procedure

procedure( DILSyncFamiliesCBUpdate(o)
let( (cv family g gs fig newFig newFigs oldFigs orient dx dy)
	cv = o~>cellView
	family = o~>dilFamily
	if( family then
		gs = cv~>figGroups
		foreach( g gs
			when( g~>dilFamily == family && g != o
				orient = g~>orient
				dx = car(g~>origin) - car(o~>origin)
				dy = cadr(g~>origin) - cadr(o~>origin)
				newFigs = o~>figs
				oldFigs = g~>figs
				foreach( fig newFigs
					newFig = dbCopyFig( fig cv list(list(dx dy) "R0" 1) )
					dbAddFigToFigGroup(g newFig)	
				)
				foreach( fig oldFigs
					dbDeleteObject(fig)
				)
				g~>orient = o~>orient
				MISCGroupSetToR0(g)
				MISCGroupRotate(g orient)
				g~>orient = orient
			)
		)
	else
		printf("[WARNING] Selected group is not a SyncFamily member")
	)
);let
);procedure
