procedure( procMOSl( )
		when(cdfgData->l->value < 0.18
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate length\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.180 um " cdfgData->l->value)
			cdfgData->l->value = 0.18
		) 
)

procedure( procMOSw( )
		when(cdfgData->w->value < 0.9
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate width\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.900 um " cdfgData->w->value)
			cdfgData->w->value = 0.9
		) 
)

procedure( procMOSscg( )
		when(cdfgData->scg->value < 0.16
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"source contacts to gate space\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.160 um " cdfgData->scg->value)
			cdfgData->scg->value = 0.16
		) 
)

procedure( procMOSdcg( )
		when(cdfgData->dcg->value < 0.16
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"drain contacts to gate space\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.160 um " cdfgData->dcg->value)
			cdfgData->dcg->value = 0.16
		) 
)

procedure( procMOStype( )
		when(cdfgData->rhtype->value == "RH_GAD"
			printf("\n*NOTE* NMOS Pcell: Rad-hard transistor is GAD")
		)
		when(cdfgData->rhtype->value == "RH_HB"
			printf("\n*NOTE* NMOS Pcell: Rad-hard transistor is HB")
		) 
)

pcDefinePCell(
        list(ddGetObj("rs485_500k") "ne_GAD" "layout")
                (
						(mil	float	0.18)		;minimum gate legth
						(pod	float	0.22)		;poly over diff
						(iod	float	0.26)		;imp over diff
						(dc1	float	0.10)		;some diff constant #1
						(dc2	float	0.24)		;some diff constant #2 for rh
						
						(dcg	float	0.16)		;drain contact to gate
						(scg	float	0.16)		;source contact to gate
						(ddw	float	0.42)		;drain diff width
						(sdw	float	0.42)		;source diff width
						(dmw	float	0.34)		;drain metal width
						(smw	float	0.34)		;source metal width
						
                        (w 		float 	0.9)
                        (l 		float 	0.18)
						(rhtype	string 	"RH_GAD")	;for GAD creation
                )

                gate = rodCreateRect(
                                    ?name "gate"
                                    ?cvId pcCellView
                                    ?layer "POLY1"
                                    ?bBox list(sdw+scg-dc1:-1*pod sdw+scg-dc1+l:w+pod)
                );end rod
				
                nimp = rodCreateRect(
                                    ?name "nimp"
                                    ?cvId pcCellView
                                    ?layer "NIMP"
                                    ?bBox list(-1*iod:-1*iod-0.09 sdw+scg-dc1+l+ddw+dcg-dc1+mil+dcg-dc1+iod:w+iod+0.09)	;0.09 is just because nimp have not equal extensions
                );end rod
				
                src = rodCreatePath(
                                    ?name "source"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
									?justification "left"
                                    ?width sdw
									?pts list(0:0 0:w)
									?offsetSubPath      list(
										list(
											?layer        	list("MET1" "drawing")
											?width			smw
											?sep			0            
											?beginOffset  	-0.04
											?endOffset    	-0.04
										);
									)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width 0.22
											?space 0.22
											?beginOffset -0.1
											?endOffset -0.1
										)
									)											
                );end rod
				
                drn = rodCreatePath(
                                    ?name "drain"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
									?justification "left"
                                    ?width ddw
									?pts list(sdw+scg-dc1+l+dcg-dc1:dc2 sdw+scg-dc1+l+dcg-dc1:w-dc2)
									?offsetSubPath      list(
										list(
											?layer        	list("MET1" "drawing")
											?width			dmw
											?sep			0            
											?beginOffset  	-0.04
											?endOffset    	-0.04
										);
									)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width 0.22
											?space 0.22
											?beginOffset -0.1
											?endOffset -0.1
										)
									)											
                );end rod
				
			when((rhtype == "RH_GAD")
			
                diff =  rodCreateRect(
                                    ?name "diff"
                                    ?cvId pcCellView
                                    ?layer "DIFF"
                                    ?bBox list(0:0 sdw+scg-dc1+l+dcg+ddw-dc1+dc2:w)
                );end rod			
			
				gad = rodCreatePolygon(
					?name "gad"
					?cvId pcCellView
					?layer "POLY1"
					?pts list(	
								sdw+scg-dc1+l:w-mil
								sdw+scg-dc1+l+ddw+dcg-dc1+scg-dc1:w-mil 
								sdw+scg-dc1+l+ddw+dcg-dc1+scg-dc1:mil 
								sdw+scg-dc1+l:mil 
								sdw+scg-dc1+l:-1*pod 
								sdw+scg-dc1+l+ddw+dcg-dc1+scg-dc1+mil+pod:-1*pod 
								sdw+scg-dc1+l+ddw+dcg-dc1+scg-dc1+mil+pod:w+pod 
								sdw+scg-dc1+l:w+pod
					)
				);end rod
			)
				
			when((rhtype == "RH_HB")
			
                diff =  rodCreateRect(
                                    ?name "diff"
                                    ?cvId pcCellView
                                    ?layer "DIFF"
                                    ?bBox list(0:0 sdw+scg-dc1+l+dcg+ddw-dc1:w)
                );end rod			
			
				hbu = rodCreateRect(
					?name "hbu"
					?cvId pcCellView
					?layer "POLY1"
					?bBox list(	sdw+scg-dc1+l:w-mil	sdw+scg-dc1+l+ddw+dcg-dc1+pod:w+pod )
				);end rod
				
				hbd = rodCreateRect(
					?name "hbd"
					?cvId pcCellView
					?layer "POLY1"
					?bBox list(	sdw+scg-dc1+l:mil	sdw+scg-dc1+l+ddw+dcg-dc1+pod:0-pod )
				);end rod
			)
	t
)

let( (cellId cdfId)
	when(cellId = ddGetObj("test" "ne_GAD")
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
			?defValue 	0.18
			?type     	"float"
			?display  	"t"
			?callback	"procMOSl( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the width parameters
		cdfCreateParam( cdfId
			?name     	"w"
			?prompt   	"gate width"
			?defValue 	0.9
			?type     	"float"
			?display 	"t"
			?callback	"procMOSw( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the drain cont to gate space parameters
		cdfCreateParam( cdfId
			?name     	"dcg"
			?prompt   	"drain cont to gate space"
			?defValue 	0.16
			?type     	"float"
			?display 	"t"
			?callback	"procMOSdcg( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the source cont to gate space parameters
		cdfCreateParam( cdfId
			?name     	"scg"
			?prompt   	"source cont to gate space"
			?defValue 	0.16
			?type     	"float"
			?display 	"t"
			?callback	"procMOSscg( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the rhtype parameters
		cdfCreateParam( cdfId
			?name     	"rhtype"
			?prompt   	"type of transistor"
			?defValue 	"RH_GAD"
			?type     	"radio"
			?choices	list("RH_GAD" "RH_HB")	
			?display 	"t"
			?callback	"procMOStype( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cdfSaveCDF(cdfId)
	)
) 