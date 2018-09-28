let( (pCellLibrary pCellName)
	pCellLibrary = "apc_standard"
	pCellName = "apc_standard_esd_anapad"

pcDefinePCell( list(ddGetObj(pCellLibrary) pCellName "layout" )
	(
		(pMRes	cdfFindParamByName(cdfGetCellCDF(ddGetObj(pCellLibrary pCellName)) "pMRes")~>defValue)
		(wMRes	cdfFindParamByName(cdfGetCellCDF(ddGetObj(pCellLibrary pCellName)) "wMRes")~>defValue)
	)

	let(
	(
		cv
		instESD instMetRes instId orient
		xC yC l h
		wRV sRV moRV
		w nRV oRV x1 y1 x2 y2 label layer term terms
		i k
		netPAD figPAD figPADX1 figPADX2 figPADY1 figPADY2 pinPAD labelPAD
		netAIO200 figAIO200 figAIO200X1 figAIO200X2 figAIO200Y1 figAIO200Y2 pinAIO200 labelAIO200
		netAIO figAIO figAIOX1 figAIOX2 figAIOY1 figAIOY2 pinAIO labelAIO
		netVSS figVSS figVSSX1 figVSSX2 figVSSY1 figVSSY2 pinVSS labelVSS
		netVDD figVDD figVDDX1 figVDDX2 figVDDY1 figVDDY2 pinVDD labelVDD
	)
		;; Constants of M6 rect in ESD cell to connect AP
		xC = 3.44
		yC = 86.5
		wM6Conn = 48.12
		hM6Conn = 7.0
		resTerm = 3.0
		resBody = 3.0
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;; Tech constants
		wRV = 3.0
		sRV = 3.0
		moRV = 1.6
		;;;;;;;;;;;;;;;;;

		cv = pcCellView
		w = atof(wMRes)

		instESD = dbOpenCellViewByType("tph013bcdnv5gpio_c160429" "PDB3A_C160429" "layout")
		instMetRes = dbOpenCellViewByType("tsmc013" "rmap" "layout")

		;; placing ESD cell
		instId = dbCreateInst( cv instESD "IESD" list(0 0) "R0" 1 )

		;; placeing AP connection
		layer = list("AP" "drawing")
		x1 = xC + (wM6Conn - w)/2
		y1 = yC
		x2 = x1 + w
		y2 = yC + hM6Conn
		dbCreateRect( cv layer list(x1:y1 x2:y2) )

		;; placing RV
		layer = list("RV" "drawing")
		nRV = int( ((w - 2*moRV) + sRV) / (wRV + sRV) )
		x1 = xC + (wM6Conn - w)/2 + (w - (nRV*(wRV + sRV) - sRV))/2
		y1 = yC + (hM6Conn - wRV)/2
		x2 = x1 + wRV
		y2 = y1 + wRV
		for( i 0 nRV-1 dbCreateRect(cv layer list(x1 + i*(sRV+wRV):y1 x2 + i*(sRV+wRV):y2)) )

		;;placing AP metal resistor
		if( pMRes == "Up" then
			orient = "R90"
			x1 = xC + (wM6Conn - w)/2 + w ;; +w because of R90
			y1 = yC + hM6Conn + resTerm
		else
			orient = "R270"
			x1 = xC + (wM6Conn - w)/2
			y1 = yC - resTerm
		)

		dbCreateParamInst( cv instMetRes "IMRES" list(x1 y1) orient 1 list(list("w" "string" wMRes)))

		;; placing PAD pin
		when( pMRes == "Up"
			netPAD = dbCreateNet(cv "PAD")
			layer = list("AP" "pin")
			figPADX1 = x1 - w ;; -w because of R90
			figPADY1 = y1 + resBody
			figPADX2 = figPADX1 + w
			figPADY2 = figPADY1 + resTerm
			figPAD = dbCreateRect( cv layer list(figPADX1:figPADY1 figPADX2:figPADY2) )
			pinPAD = dbCreatePin( netPAD figPAD "PAD" )
			labelPAD = dbCreateLabel( cv layer figPADX1+w/2:figPADY1+resTerm/2 "PAD" "centerCenter" "R0" "roman" 3 )
		)
		when( pMRes == "Down"
			netPAD = dbCreateNet( cv "PAD" )
			layer = list("AP" "pin")
			figPADX1 = x1 ;; -w because of R90
			figPADY1 = y1 - resBody
			figPADX2 = figPADX1 + w
			figPADY2 = figPADY1 - resTerm
			figPAD = dbCreateRect( cv layer list(figPADX1:figPADY1 figPADX2:figPADY2) )
			pinPAD = dbCreatePin( netPAD figPAD "PAD" )
			labelPAD = dbCreateLabel( cv layer figPADX1+w/2:figPADY1-resTerm/2 "PAD" "centerCenter" "R0" "roman" 3 )
		)

		;; placing AIO in AP
		netAIO = dbCreateNet( cv "AIO" )
		layer = list("AP" "pin")
		figAIOX1 = xC + (wM6Conn - w)/2
		figAIOY1 = yC
		figAIOX2 = figAIOX1 + w
		figAIOY2 = figAIOY1 + hM6Conn
		figAIO = dbCreateRect( cv layer list(figAIOX1:figAIOY1 figAIOX2:figAIOY2) )
		pinAIO = dbCreatePin( netAIO figAIO )
		labelAIO = dbCreateLabel( cv layer figAIOX1+w/2:figAIOY1+hM6Conn/2 "AIO" "centerCenter" "R0" "roman" 3 )

		;; placing AIO and AIO200 pin in M1..M4
		netAIO200 = dbCreateNet( cv "AIO200" )
		for( i 1 4
			layer = list(sprintf(nil "METAL%d" i) "pin")
			figAIO200X1 = 48.450
			figAIO200Y1 = 178.500
			figAIO200X2 = figAIO200X1 + 1.2
			figAIO200Y2 = figAIO200Y1 + 1.5
			figAIO200 = dbCreateRect( cv layer list(figAIO200X1:figAIO200Y1 figAIO200X2:figAIO200Y2) )
			pinAIO200 = dbCreatePin( netAIO200 figAIO200 )
			labelAIO200 = dbCreateLabel( cv layer figAIO200X1+0.6:figAIO200Y1+0.75 "AIO200" "centerCenter" "R0" "roman" 1 )

			layer = list(sprintf(nil "METAL%d" i) "pin")
			figAIOX1 = 17.650
			figAIOY1 = 178.500
			figAIOX2 = figAIOX1 + 19.7
			figAIOY2 = figAIOY1 + 1.5
			figAIO = dbCreateRect( cv layer list(figAIOX1:figAIOY1 figAIOX2:figAIOY2) )
			pinAIO = dbCreatePin( netAIO figAIO )
			labelAIO = dbCreateLabel( cv layer figAIOX1+9.85:figAIOY1+0.75 "AIO" "centerCenter" "R0" "roman" 1 )
		)

		;; placing VSS in M6
		label = "VSS"
		layer = list("METAL6" "pin")
		netVSS = dbCreateNet( cv label )
		figVSSX1 = 0
		figVSSY1 = 37.750
		figVSSX2 = figVSSX1 + 55
		figVSSY2 = figVSSY1 + 8.5
		figVSS = dbCreateRect( cv layer list(figVSSX1:figVSSY1 figVSSX2:figVSSY2) )
		pinVSS = dbCreatePin( netVSS figVSS )
		labelVSS = dbCreateLabel( cv layer 27.5:42 label "centerCenter" "R0" "roman" 6 )

		;; placing VDD in M6
		label = "VDD"
		layer = list("METAL6" "pin")
		netVDD = dbCreateNet( cv label )
		figVDDX1 = 0
		figVDDY1 = 133.750
		figVDDX2 = figVDDX1 + 55
		figVDDY2 = figVDDY1 + 8.5
		figVDD = dbCreateRect( cv layer list(figVDDX1:figVDDY1 figVDDX2:figVDDY2) )
		pinVDD = dbCreatePin( netVDD figVDD )
		labelVDD = dbCreateLabel( cv layer 27.5:138 label "centerCenter" "R0" "roman" 6 )

		dbCreatePRBoundary( cv  list(0:0 0:180 55:180 55:0) )
	);let
);pcDefinePCell
);let
