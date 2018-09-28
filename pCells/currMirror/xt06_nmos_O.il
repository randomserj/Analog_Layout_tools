procedure( procMOSl( )
		when(cdfgData->l->value < 0.6
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate length\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.600 um " cdfgData->l->value)
			cdfgData->l->value = 0.6
		) 
)

procedure( procMOSw( )
		when(cdfgData->w->value < 6.0
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"gate width\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 6.0 um " cdfgData->w->value)
			cdfgData->w->value = 6.0
		) 
)

procedure( procMOSdcg( )
		when(cdfgData->dcg->value < 0.5
			printf("\n*WARNING* NMOS Pcell: Value of parameter \"drain contacts to gate space\" exceeds the limit - %.3f um\n*WARNING* Value will be reset to the limit - 0.500 um " cdfgData->dcg->value)
			cdfgData->dcg->value = 0.5
		)
)

pcDefinePCell(
        list(ddGetObj("PRIMLIB_RH") "nmos_O" "layout")
                (
						(mgl	float	0.6)		;minimum gate legth
						(cor	float	0.283)		;gate corner width
						(mew	float	1.2)		;metal width
						(dom	float	0.2)		;diff overlap metal
						(cg1	float	0.2)		;gate const
						(cont	float	0.6)		;cont size
						(drainh	float	1.2)		
						
						(dcg	float	0.5)		;drain cont to gate
						(ndc	int		1)			;number of drain cont
                        (w 		float 	6.0)
                        (l 		float 	0.6)
						(stype	string 	"both")
                )
				
				source = mew+2*dom
				drain = ndc*mew+2*dcg-0.6
				hedge = drain-cg1-cg1
				vedge = round(((w-2*hedge-4*cor)/2)*10)/10.0
				drainh = vedge+2*cg1-2*dcg+0.6
				
				diff = rodCreatePolygon(
                                    ?name "diff"
                                    ?cvId pcCellView
                                    ?layer "DIFF"
                                    ?pts list(
											source/2.0:0
											0:source/2.0
											0:source+l+cg1+vedge+cg1+l+source/2.0
											source/2.0:source+l+cg1+vedge+cg1+l+source
											source+drain+2*l+source/2.0:source+l+cg1+vedge+cg1+l+source
											2*source+drain+2*l:source+l+cg1+vedge+cg1+l+source/2.0
											2*source+drain+2*l:source/2.0
											2*source+drain+2*l-source/2.0:0
											)
                );end rod

                gate = rodCreatePolygon(
                                    ?name "gate"
                                    ?cvId pcCellView
                                    ?layer list("POLY1" "drawing")
                                    ?pts list(
											source+l+cg1+hedge/2.0:source+l
											source+l+cg1:source+l
											source+l:source+l+cg1
											source+l:source+l+cg1+vedge
											source+l+cg1:source+l+cg1+vedge+cg1
											source+l+cg1+hedge:source+l+cg1+vedge+cg1
											source+l+cg1+hedge+cg1:source+l+cg1+vedge
											source+l+cg1+hedge+cg1:source+l+cg1
											source+l+cg1+hedge:source+l
											source+l+cg1+hedge/2.0:source+l ;;inner end
											source+l+cg1+hedge/2.0:source
											source+l+cg1+hedge+l/2.0:source
											source+l+cg1+hedge+cg1+l:source+l+cg1-l/2.0
											source+l+cg1+hedge+cg1+l:source+l+cg1+vedge+l/2.0
											source+l+cg1+hedge+l/2.0:source+l+cg1+vedge+cg1+l
											source+l+cg1-l/2.0:source+l+cg1+vedge+cg1+l
											source:source+l+cg1+vedge+l/2.0
											source:source+l+cg1-l/2.0
											source+l+cg1-l/2.0:source
											source+l+cg1+hedge/2.0:source
											)
                );end rod
				poly = rodCreatePath(
                                    ?name "poly"
                                    ?cvId pcCellView
                                    ?layer list("POLY1" "drawing")
									?justification "center"
                                    ?width 0.6
									?pts list(
											source+l+drain/2.0:source+l+cg1+vedge+cg1+l
											source+l+drain/2.0:source+l+cg1+vedge+cg1+l+2.1
											)
                );end rod
				
				
                nimp = rodCreateRect(
                                    ?name "nimp"
                                    ?cvId pcCellView
                                    ?layer "NIMP"
                                    ?bBox list(-0.4:-0.4 2*source+drain+2*l+0.4:2*source+vedge+2*dom+2*l+0.4)
                );end rod
				
                srcl = rodCreatePath(
                                    ?name "source_l"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
									?justification "left"
                                    ?width mew+2*dom
									?pts list(
											0:source
											0:source+l+cg1+vedge+cg1+l
											)
									?offsetSubPath      list(
										list(
											?layer        	list("MET1" "drawing")
											?width			mew
											?sep			0            
											?beginOffset  	-1*dom
											?endOffset    	-1*dom
										);
									)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width cont
											?space cont
											?beginOffset -0.5
											?endOffset -0.5
										)
									)											
                );end rod
				srcr = rodCreatePath(
                                    ?name "source_r"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
									?justification "right"
                                    ?width mew+2*dom
									?pts list(
											2*source+2*l+drain:source
											2*source+2*l+drain:source+l+cg1+vedge+cg1+l
											)
									?offsetSubPath      list(
										list(
											?layer        	list("MET1" "drawing")
											?width			mew
											?sep			0            
											?beginOffset  	-1*dom
											?endOffset    	-1*dom
										);
									)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width cont
											?space cont
											?beginOffset -0.5
											?endOffset -0.5
										)
									)											
                );end rod
				when((stype == "both")||(stype == "bottom") 										; bottom part of source
					srcb = rodCreatePath(
                                    ?name "source_b"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
									?justification "right"
                                    ?width mew+2*dom
									?pts list(
											source:0
											source+2*l+drain:0
											)
									?offsetSubPath      list(
										list(
											?layer        	list("MET1" "drawing")
											?width			mew
											?sep			0            
											?beginOffset  	-1*dom
											?endOffset    	-1*dom
										);
									)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width cont
											?space cont
											?beginOffset -0.5
											?endOffset -0.5
										)
									)											
					);end rod
					srcb_ml = rodCreatePolygon(
                                    ?name "srcb_ml"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
                                    ?pts list(
											source+l+cg1-l/2.0-0.1:source-dom
											source-dom:source+l+cg1-l/2.0-0.1
											dom:source+l+cg1-l/2.0-0.1
											dom:source/2.0
											source/2.0:dom
											source+l+cg1-l/2.0-0.1:dom
											)
					);end rod
					srcb_mr = rodCreatePolygon(
                                    ?name "srcb_mr"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
                                    ?pts list(
											source+l+drain+l/2.0-0.1:source-dom
											source+l+drain+l+dom:source+l+cg1-l/2.0-0.1
											source+l+drain+l+source-dom:source+l+cg1-l/2.0-0.1
											source+l+drain+l+source-dom:source/2.0
											source+l+drain+l+source/2.0:dom
											source+l+drain+l/2.0-0.1:dom
											)
					);end rod
				)
				when((stype == "both")||(stype == "top") 											; top part of source
					srctl = rodCreatePath(
                                    ?name "source_tl"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
									?justification "left"
                                    ?width mew+2*dom
									?pts list(
											source:source+l+cg1+vedge+cg1+l+source
											source+l:source+l+cg1+vedge+cg1+l+source
											)
									?offsetSubPath      list(
										list(
											?layer        	list("MET1" "drawing")
											?width			mew
											?sep			0            
											?beginOffset  	-1*dom
											?endOffset    	-1*dom
										);
									)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width cont
											?space cont
											?beginOffset -0.5
											?endOffset -0.5
										)
									)											
					);end rod
					srctr = rodCreatePath(
                                    ?name "source_tr"
                                    ?cvId pcCellView
                                    ?layer list("DIFF" "drawing")
									?justification "left"
                                    ?width mew+2*dom
									?pts list(
											source+l+drain:source+l+cg1+vedge+cg1+l+source
											source+l+drain+l:source+l+cg1+vedge+cg1+l+source
											)
									?offsetSubPath      list(
										list(
											?layer        	list("MET1" "drawing")
											?width			mew
											?sep			0            
											?beginOffset  	-1*dom
											?endOffset    	-1*dom
										);
									)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width cont
											?space cont
											?beginOffset -0.5
											?endOffset -0.5
										)
									)											
					);end rod
					srct_ml = rodCreatePolygon(
                                    ?name "srct_ml"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
                                    ?pts list(
											source+l+cg1-l/2.0-0.1:source+l+cg1+vedge+cg1+l+dom
											source-dom:source+l+cg1+vedge+l/2.0+0.1
											dom:source+l+cg1+vedge+l/2.0+0.1
											dom:source+l+cg1+vedge+cg1+l+source/2.0
											source/2.0:source+l+cg1+vedge+cg1+l+source-dom
											source+l+cg1-l/2.0-0.1:source+l+cg1+vedge+cg1+l+source-dom
											)
					);end rod
					srct_mr = rodCreatePolygon(
                                    ?name "srct_mr"
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
                                    ?pts list(
											source+l+drain+l/2.0-0.1:source+l+cg1+vedge+cg1+l+dom
											source+l+drain+l+dom:source+l+cg1+vedge+l/2.0+0.1
											source+l+drain+l+source-dom:source+l+cg1+vedge+l/2.0+0.1
											source+l+drain+l+source-dom:source+l+cg1+vedge+cg1+l+source/2.0
											source+l+drain+l+source/2.0:source+l+cg1+vedge+cg1+l+source-dom
											source+l+drain+l/2.0-0.1:source+l+cg1+vedge+cg1+l+source-dom
											)
					);end rod
				)
				
				for(i 1 ndc
					name = sprintf(name "%d" i)
					drn = rodCreatePath(
                                    ?name name
                                    ?cvId pcCellView
                                    ?layer list("MET1" "drawing")
									?justification "left"
                                    ?width mew
									?pts list(
											source+l+dcg-0.3+mew*(i-1):source+l+dcg-0.3
											source+l+dcg-0.3+mew*(i-1):source+l+cg1+vedge+cg1-dcg+0.3
											)
									?subRect list(
										list(
											?layer list("CONT" "drawing")
											?width cont
											?space cont
											?beginOffset -0.3
											?endOffset -0.3
										)
									)											
					);end rod
				)
				
	t
)

let( (cellId cdfId)
	when(cellId = ddGetObj("PRIMLIB_RH" "nmos_O")
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
			?defValue 	6.0
			?type     	"float"
			?display 	"t"
			?callback	"procMOSw( )"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; create the number of drain cont parameters
		cdfCreateParam( cdfId
			?name     	"ndc"
			?prompt   	"number of drain cont"
			?defValue 	1
			?type     	"int"
			?display 	"t"
		)
;		cdfCreateParam( cdfId
;			?name     	"drainh"
;			?prompt   	"hegth of drain"
;			?defValue 	1.2
;			?type     	"float"
;			?display 	"nil"
;		)
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
;; create the rhtype parameters
		cdfCreateParam( cdfId
			?name     	"stype"
			?prompt   	"source connection"
			?defValue 	"both"
			?type     	"radio"
			?choices	list("none" "bottom" "top" "both")	
			?display 	"t"
		)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cdfSaveCDF(cdfId)
	)
) 