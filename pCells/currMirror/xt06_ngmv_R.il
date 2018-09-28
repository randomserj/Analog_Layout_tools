procedure( procMOSl( )
		when(cdfgData->l->value < 1.4
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate length\" exceeds the limit - %.2f um\n*WARNING* Value will be reset to the limit - 1.4 um " cdfgData->l->value)
			cdfgData->l->value = 1.4
		) 
)

procedure( procMOSw( )
		when(cdfgData->w->value < 5.0
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate width\" exceeds the limit - %.2f um\n*WARNING* Value will be reset to the limit - 3.0 um " cdfgData->w->value)
			cdfgData->w->value = 5.0
		) 
)

procedure( procMOSscg( )
		when(cdfgData->scg->value < 0.5
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"source contacts to gate space\" exceeds the limit - %.2f um\n*WARNING* Value will be reset to the limit - 0.5 um " cdfgData->scg->value)
			cdfgData->scg->value = 0.5
		) 
)

procedure( procMOSdcg( )
		when(cdfgData->dcg->value < 0.8
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"drain contacts to gate space\" exceeds the limit - %.2f um\n*WARNING* Value will be reset to the limit - 0.8 um " cdfgData->dcg->value)
			cdfgData->dcg->value = 0.8
		) 
)

pcDefinePCell(
        list(ddGetObj("PRIMLIB_RH") "ngmv_R" "layout")
                (
						(mil	float	1.4)		;minimum gate legth
						(pod	float	0.6)		;poly over diff
						(iod	float	0.4)		;imp over diff
						(con	float	0.6)		;cont size
						(moc	float	0.3)		;metal over cont
						(dom	float	0.2)		;diff over metal
						(rho	float	0.3)		;width offset for rh
						
						(dcg	float	0.8)		;drain contact to gate
						(scg	float	0.5)		;source contact to gate
						(dmw	float	1.2)		;drain metal width
						(smw	float	1.2)		;source metal width
						
                        (w 		float 	5.0)
                        (l 		float 	1.4)
						(gclose	string 	"yes")	;for GAD creation
                )
				
				source = dom+smw+scg-moc
				drain = dcg-moc+dmw+0.5
				width = w-2*rho
				
                gate = rodCreateRect(
                                    ?name "gate"
                                    ?cvId pcCellView
                                    ?layer list("POLY1" "drawing")
                                    ?bBox list(source:-1*pod source+l:w+pod)
                );end rod
				
				nimp = rodCreateRect(
                                    ?name "nimps"
                                    ?cvId pcCellView
                                    ?layer list("NIMP" "drawing")
                                    ?bBox list(-1*iod:-1*iod source+0.7:w+iod)
				);end rod
				
				nimp = rodCreateRect(
                                    ?name "nimpd"
                                    ?cvId pcCellView
                                    ?layer list("NIMP" "drawing")
                                    ?bBox list(source+l+0.6:mil+dom+0.6+0.1-moc source+l+dcg-0.2+dmw-0.2:w-mil-dom-0.6-0.1+moc)
				);end rod
				
                src = rodCreatePath(
                                    ?name "source"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
									?justification "left"
                                    ?width smw
									?pts list(dom:dom dom:w-dom)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width con
											?space con
											?beginOffset -moc
											?endOffset -moc
										)
									)											
                );end rod
				
                drn = rodCreatePath(
                                    ?name "drain"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
									?justification "right"
                                    ?width dmw
									?pts list(source+l+drain-0.5:dom+mil+0.6-moc source+l+drain-0.5:w-dom-mil-0.6+moc)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width con
											?space con
											?beginOffset -moc
											?endOffset -moc
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
					
					ngd = rodCreateRect(
                                    ?name "nimpn"
                                    ?cvId pcCellView
                                    ?layer list("NGD" "drawing")
                                    ?bBox list(-1*iod:-1*iod source+l+drain+iod:w+iod)
					);end rod
					
					mv = rodCreateRect(
                                    ?name "mvn"
                                    ?cvId pcCellView
                                    ?layer list("MV" "drawing")
                                    ?bBox list(-1*iod-0.6:-1*iod-0.6 source+l+drain+iod+0.6:w+iod+0.6)
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
					
					ngd = rodCreateRect(
                                    ?name "nimpy"
                                    ?cvId pcCellView
                                    ?layer list("NGD" "drawing")
                                    ?bBox list(-1*iod:-1*iod source+l+drain+mil+iod:w+iod)
					);end rod
					
					mv = rodCreateRect(
                                    ?name "mvy"
                                    ?cvId pcCellView
                                    ?layer list("MV" "drawing")
                                    ?bBox list(-1*iod-0.6:-1*iod-0.6 source+l+drain+mil+iod+0.6:w+iod+0.6)
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
	when(cellId = ddGetObj("PRIMLIB_RH" "ngmv_R")
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
			?defValue 	1.4
			?type     	"float"
			?display  	"t"
			?callback	"procMOSl( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the width parameters
		cdfCreateParam( cdfId
			?name     	"w"
			?prompt   	"gate width"
			?defValue 	5.0
			?type     	"float"
			?display 	"t"
			?callback	"procMOSw( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the drain cont to gate space parameters
		cdfCreateParam( cdfId
			?name     	"dcg"
			?prompt   	"drain cont to gate space"
			?defValue 	0.8
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
    cdfSaveCDF(cdfId)
	)
) 