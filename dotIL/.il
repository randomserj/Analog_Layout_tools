/*******************************************************************
***
***	    	   	    *   *
***	        		*
***	    	    	    *   *
***			*   *   *
***
***	Features:
***	- Added [ and ] bindkeys to change path or wire width 
***	  of either existed or during drawing;
***	- Added 1..9 bindkeys to toggle metals+vias visiability 
***	  and ctrl+1..9 to add/remove metal+via 
***	  to/from visiability list;
***	- Added 0 binkey to show/hide FEOL layers
***	  and ctrl+0 to add/remove FEOL latyers
***	  to/from visiability list;
***	- Added ` bindkey to show all layers;
***	- Added \ and shift+\ bindkeys to mark net
***	  in the hierarchy;
***
********************************************************************

********************************************************************
***	
***	v1.1.4.2 (18/09/2105)
***	- Added hierarchical mark the net.
***
*******************************************************************/

procedure( DILChangesLog()
let( ()
	edit( strcat( dilHome "/changes.log" ) )
);let
);procedure

procedure( DILLoadSKILL()
let( (path dir dirs file files)
	dirs = list( "/menus/" "/items/" "/plugins/" )
	foreach( dir dirs
		path = strcat( dilHome dir)
		files = cddr( sort( getDirFiles(path) nil ) )
		foreach( file files
			;printf("[INFO] Loading %s%s\n" path file)
			if( !cdr(parseString(file "-")) then load(strcat(path file)) )
		)
	)	
);let
);procedure

procedure( DILInit()
let(
(
	tLibName layer layers
	tf viaDefs viaDef via vias params i a b c d
)
	printf("[INFO] Initializing .il plugins\n")
	tLibName = getShellEnvVar("TLIB_NAME")
	if( tLibName then
		printf("\tGetting informaition from %s tech file...\n" tLibName)
		dilTechFile = techGetTechFile(ddGetObj(tLibName))
		layers = techGetLayerFunctions(dilTechFile)
		dilDiff = list()
		dilImps = list()
		dilPolys = list()
		dilWells = list()
		dilMetals = list()
		dilVias = list()
		foreach( layer layers
			if( cadr(layer) == "poly" then dilPolys = append1(dilPolys car(layer)) )
			if( cadr(layer) == "metal" then dilMetals = append1(dilMetals car(layer)) )
			if( cadr(layer) == "cut" then dilVias = append1(dilVias car(layer)) )
			if( cadr(layer) == "diff" then dilDiff = append1(dilDiff car(layer)) )
			if( cadr(layer) == "nplus" || cadr(layer) == "pplus" then dilImps = append1(dilImps car(layer)) )
			if( cadr(layer) == "nwell" then dilWells = append1(dilWells car(layer)) )
		)
		
		dilMetalWidthList = list()	;;; <----- list with metal name, minWidth=width of Mx to Mx+1 VIA and VIA + step to increse width, e.g. list( list(0.13 0.07+0.09) )
		vias = cdr(dilVias)		;;; <----- we don't need to keep "CO"
		viaDefs = lxGetValidViaDefs(dilTechFile "virtuosoDefaultSetup")
		for( i 0 length(vias)-1
			via = nth(i vias)
			foreach( viaDef viaDefs
				params = viaDef~>params
				if( car(params) == via && nth(i dilMetals) != c then
					a = nth(1 params) + 2*car(nth(6 params))
					b = nth(1 params) + car(nth(5 params))
					c = nth(i dilMetals)
					dilMetalWidthList = append1(dilMetalWidthList list(c a b))
				)
			)
		)
		dilMetalWidthList = append1(dilMetalWidthList list(car(reverse(dilMetals)) a b) )
		
	else
		printf("[ERROR] Tech library is missed\n")
	)
);let
);procedure

