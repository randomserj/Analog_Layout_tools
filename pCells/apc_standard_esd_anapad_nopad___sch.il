let( (pCellLibrary pCellName)
	pCellLibrary = "zz_spakhomov"
	pCellName = "apc_standard_esd_anapad_nopad"

pcDefinePCell( list(ddGetObj(pCellLibrary) pCellName "schematic" "schematic")
	(
		(Up		"boolean"		t)
		(Down	"boolean"		nil)
		(mResW					25.0)
	)

	let(
	(
		cv
		instESD instMetRes
		netVSS netVDD netAIO netAIO200 netPAD
	)
		cv = pcCellView

		instESD = dbOpenCellViewByType("tph013bcdnv5gpio_c160429" "PDB3A_C160429" "symbol")
		instMetRes = dbOpenCellViewByType("tsmc013" "rmap" "symbol")

		netVSS = dbMakeNet(cv "VSS")
		netVDD = dbMakeNet(cv "VDD")
		netAIO = dbMakeNet(cv "netAIO")
		netAIO200 = dbMakeNet(cv "netAIO200")
		netPAD = dbMakeNet(cv "PAD")

		dbCreateInst( cv instESD "IESD" list(0 2) "R0" 1 )
		dbCreateParamInst( cv instMetRes "IMRES" list(0.75 0) "R0" 1 list(list("w" "string" "25.0u")))


	);let
);pcDefinePCell
);let
