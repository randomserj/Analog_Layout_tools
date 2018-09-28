procedure( procMOSl( )
		when(cdfgData->l->value < 0.6
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate length\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.6 um " cdfgData->l->value)
			cdfgData->l->value = 0.6
		) 
)

procedure( procMOSw( )
		when(cdfgData->w->value < 3.0
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate width\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 3.0 um " cdfgData->w->value)
			cdfgData->w->value = 3.0
		) 
)

procedure( procMOSscg( )
		when(cdfgData->scg->value < 0.5
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"source contacts to gate space\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.5 um " cdfgData->scg->value)
			cdfgData->scg->value = 0.5
		) 
)

procedure( procMOSdcg( )
		when(cdfgData->dcg->value < 0.5
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"drain contacts to gate space\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.5 um " cdfgData->dcg->value)
			cdfgData->dcg->value = 0.5
		) 
)

procedure( procMOSsm3( )
		when((cdfgData->srcme2->value == nil) && (cdfgData->srcme3->value == t)
			cdfgData->srcme2->value = t
		) 
)

procedure( procMOSdm3( )
		when((cdfgData->drnme2->value == nil) && (cdfgData->drnme3->value == t)
			cdfgData->drnme2->value = t
		) 
)

procedure( procMOScts( )
		when((cdfgData->contsrc->value == "no")
			cdfgData->srcme2->value = nil
			cdfgData->srcme3->value = nil
		) 
)

pcDefinePCell(
        list(ddGetObj("PRIMLIB_RH") "nmos_R" "layout")
                (
						(mil	float	0.6)		;minimum gate legth
						(pod	float	0.6)		;poly over diff
						(iod	float	0.4)		;imp over diff
						(con	float	0.6)		;cont size
						(via	float	0.7)		;via size
						(moc	float	0.3)		;metal over cont
						(dom	float	0.2)		;diff over metal
						(rho	float	0.3)		;width offset for rh
						
						(dcg	float	0.5)		;drain contact to gate
						(scg	float	0.5)		;source contact to gate
						(dmw	float	1.2)		;drain metal width
						(smw	float	1.2)		;source metal width
						
                        (w 		float 	3.0)
                        (l 		float 	0.6)
						(gclose string "yes")
						(srcme2 boolean	nil)
						(srcme3 boolean	nil)
						(drnme2 boolean	nil)
						(drnme3 boolean	nil)
						(contsrc string "yes")
                )
				
				source = 0.1+smw+scg-moc
				drain = dom+dmw+dcg-moc
				width = w-2*rho
				
                gate = rodCreateRect(
									?name "gate"
                                    ?cvId pcCellView
                                    ?layer list("POLY1" "drawing")
                                    ?bBox list(source:-1*pod source+l:w+pod)
                );end rod
			
			when((contsrc == "yes")
				when((srcme2 == t)
					src = rodCreatePath(
                                    ?name "sourceme2"
                                    ?cvId pcCellView
                                    ?layer list("MET2" "drawing")
									?justification "left"
                                    ?width 1.5
									?pts list(-0.05:dom-0.1 -0.05:w-dom+0.1)
					) ;end rod
				)
				when((srcme2 == t) && (srcme3 == t)
					src = rodCreatePath(
                                    ?name "sourceme3"
                                    ?cvId pcCellView
                                    ?layer list("MET3" "drawing")
									?justification "left"
                                    ?width 1.5
									?pts list(-0.05:dom-0.1 -0.05:w-dom+0.1)
					) ;end rod
				)
                src = rodCreatePath(
                                    ?name "source"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
									?justification "left"
                                    ?width if((srcme2 == nil) then smw else 1.5)
									?pts if((srcme2 == nil) then list(0.1:dom-0.1 0.1:w-dom+0.1) else list(-0.05:dom-0.1 -0.05:w-dom+0.1))
									?subRect if((srcme2 == nil) then
										list(
											list(
												?layer list("CONT" "drawing")
												?width con
												?space con
												?beginOffset -moc
												?endOffset -moc
											)
										) else if((srcme3 == nil) then
										list(
											list(
												?layer list("CONT" "drawing")
												?width con
												?space con+0.1
												?beginOffset -moc-0.15
												?endOffset -moc-0.15
											)
											list(
												?layer list("VIA" "drawing")
												?width via
												?space con
												?beginOffset -moc-0.1
												?endOffset -moc-0.1
											)
										) else
										list(
											list(
												?layer list("CONT" "drawing")
												?width con
												?space con+0.1
												?beginOffset -moc-0.15
												?endOffset -moc-0.15
											)
											list(
												?layer list("VIA" "drawing")
												?width via
												?space con
												?beginOffset -moc-0.1
												?endOffset -moc-0.1
											)
											list(
												?layer list("VIA2" "drawing")
												?width via
												?space con
												?beginOffset -moc-0.1
												?endOffset -moc-0.1
											)
										)
										)
									)
                );end rod
			)
			
				when((drnme2 == t)
					drn = rodCreatePath(
                                    ?name "drainme2"
                                    ?cvId pcCellView
                                    ?layer list("MET2" "drawing")
									?justification "right"
                                    ?width 1.5
									?pts list(source+l+drain-dom+0.15:dom+mil source+l+drain-dom+0.15:w-dom-mil)
					) ;end rod
				)
				when((drnme2 == t) && (drnme3 == t)
					drn = rodCreatePath(
                                    ?name "drainme3"
                                    ?cvId pcCellView
                                    ?layer list("MET3" "drawing")
									?justification "right"
                                    ?width 1.5
									?pts list(source+l+drain-dom+0.15:dom+mil source+l+drain-dom+0.15:w-dom-mil)
					) ;end rod
				)
                drn = rodCreatePath(
                                    ?name "drain"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
									?justification "right"
                                    ?width if((drnme2 == nil) then dmw else 1.5)
									?pts if((drnme2 == nil) then list(source+l+drain-dom:dom+mil source+l+drain-dom:w-dom-mil) else list(source+l+drain-dom+0.15:dom+mil source+l+drain-dom+0.15:w-dom-mil))
									?subRect if((drnme2 == nil) then
										list(
											list(
												?layer list("CONT" "drawing")
												?width con
												?space con
												?beginOffset -moc
												?endOffset -moc
											)
										) else if((drnme3 == nil) then
										list(
											list(
												?layer list("CONT" "drawing")
												?width con
												?space con+0.1
												?beginOffset -moc-0.15
												?endOffset -moc-0.15
											)
											list(
												?layer list("VIA" "drawing")
												?width via
												?space con
												?beginOffset -moc-0.1
												?endOffset -moc-0.1
											)
										) else
										list(
											list(
												?layer list("CONT" "drawing")
												?width con
												?space con+0.1
												?beginOffset -moc-0.15
												?endOffset -moc-0.15
											)
											list(
												?layer list("VIA" "drawing")
												?width via
												?space con
												?beginOffset -moc-0.1
												?endOffset -moc-0.1
											)
											list(
												?layer list("VIA2" "drawing")
												?width via
												?space con
												?beginOffset -moc-0.1
												?endOffset -moc-0.1
											)
										)
										)
									)											
                );end rod
				
				when((gclose == "no")
					diff =  rodCreateRect(
                                    ?name "diffn"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
                                    ?bBox list(0:0 source+l+drain:w)
					);end rod
					
					nimp = rodCreateRect(
                                    ?name "nimpn"
                                    ?cvId pcCellView
                                    ?layer list("NIMP" "drawing")
                                    ?bBox list(-1*iod:-1*iod source+l+drain+iod:w+iod)
					);end rod
				
					gpt = rodCreateRect(
						?name "top"
						?cvId pcCellView
						?layer list("POLY1" "drawing")
						?bBox list(	source+l:w-mil	source+l+drain+pod:w+pod )
					);end rod
				
					gpb = rodCreateRect(
						?name "bottom"
						?cvId pcCellView
						?layer list("POLY1" "drawing")
						?bBox list(	source+l:0-pod	source+l+drain+pod:mil )
					);end rod
				)
				
				when((gclose == "yes")
					diff =  rodCreateRect(
                                    ?name "diffy"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
                                    ?bBox list(0:0 source+l+drain+mil:w)
					);end rod
					
					nimp = rodCreateRect(
                                    ?name "nimpy"
                                    ?cvId pcCellView
                                    ?layer list("NIMP" "drawing")
                                    ?bBox list(-1*iod:-1*iod source+l+drain+mil+iod:w+iod)
					);end rod
					
					gpt = rodCreateRect(
						?name "top"
						?cvId pcCellView
						?layer list("POLY1" "drawing")
						?bBox list(	source+l:w-mil	source+l+drain+mil+pod:w+pod )
					);end rod
				
					gpb = rodCreateRect(
						?name "bottom"
						?cvId pcCellView
						?layer list("POLY1" "drawing")
						?bBox list(	source+l:0-pod	source+l+drain+mil+pod:mil )
					);end rod
					
					gpc = rodCreateRect(
						?name "center"
						?cvId pcCellView
						?layer list("POLY1" "drawing")
						?bBox list(	source+l+drain:mil	source+l+drain+mil+pod:w-mil )
					);end rod
				)
	t
)

let( (cellId cdfId)
	when(cellId = ddGetObj("PRIMLIB_RH" "nmos_R")
;; if the cell CDF already exists, delete it
		when( cdfId = cdfGetBaseCellCDF(cellId)
			cdfDeleteCDF(cdfId)
		)
;; create the base cell CDF
		cdfId = cdfCreateBaseCellCDF(cellId)
	
;; create the length parameters
		cdfCreateParam( cdfId
			?name		"l"
			?prompt   	"gate length"
			?defValue 	0.6
			?type     	"float"
			?display  	"t"
			?callback	"procMOSl( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the width parameters
		cdfCreateParam( cdfId
			?name     	"w"
			?prompt   	"gate width"
			?defValue 	3.0
			?type     	"float"
			?display 	"t"
			?callback	"procMOSw( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the drain cont to gate space parameters
		cdfCreateParam( cdfId
			?name     	"dcg"
			?prompt   	"drain cont to gate space"
			?defValue 	0.5
			?type     	"float"
			?display 	"t"
			?callback	"procMOSdcg( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the source cont to gate space parameters
		cdfCreateParam( cdfId
			?name     	"scg"
			?prompt   	"source cont to gate space"
			?defValue 	0.5
			?type     	"float"
			?display 	"t"
			?callback	"procMOSscg( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the gclose parameters
		cdfCreateParam( cdfId
			?name     	"gclose"
			?prompt   	"Close type of gate ?"
			?defValue 	"yes"
			?type     	"radio"
			?choices	list("yes" "no")	
			?display 	"t"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the me2 over source parameters
		cdfCreateParam( cdfId
			?name     	"srcme2"
			?prompt   	"Metal 2 over source"
			?defValue 	nil
			?type     	"boolean"	
			?display 	"t"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the me3 over source parameters
		cdfCreateParam( cdfId
			?name     	"srcme3"
			?prompt   	"Metal 3 over source"
			?defValue 	nil
			?type     	"boolean"	
			?display 	"t"
			?callback	"procMOSsm3( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the me2 over source parameters
		cdfCreateParam( cdfId
			?name     	"drnme2"
			?prompt   	"Metal 2 over drain"
			?defValue 	nil
			?type     	"boolean"	
			?display 	"t"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the me3 over source parameters
		cdfCreateParam( cdfId
			?name     	"drnme3"
			?prompt   	"Metal 3 over drain"
			?defValue 	nil
			?type     	"boolean"	
			?display 	"t"
			?callback	"procMOSdm3( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the cont to source parameters
		cdfCreateParam( cdfId
			?name     	"contsrc"
			?prompt   	"cont to source"
			?defValue 	"yes"
			?type     	"radio"
			?choices	list("yes" "no")
			?display 	"t"
			?callback	"procMOScts( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cdfSaveCDF(cdfId)
	)
) 