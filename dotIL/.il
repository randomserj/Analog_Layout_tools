/*******************************************************************
	
                                    *   *
                                        *
                                    *   *
                                *   *   *
	
	Features:
	- bindkeys [ and ] to change path or wire width 
	  of either existed or during drawing;
	- bindkeys 1..9 to toggle metals+vias visiability 
	  and ctrl+1..9 to add/remove metal+via 
	  to/from visiability list;
	- bindkey 0 to show/hide FEOL layers
	  and ctrl+0 to add/remove FEOL layers
	  to/from visiability list;
	- bindkey ` to show all layers;
	- bindkeys \ and shift+\ bindkeys to mark a net
	  in the hierarchy;
	- bindkey ; to manipulate an object

*******************************************************************/



dilPrefix = "[.il]"
dilFormGrid = 10
dilTechFile = nil
dilDiff = list()
dilImps = list()
dilPolys = list()
dilWells = list()
dilMetals = list()
dilVias = list()
dilMetalWidthList = list()	;;; <----- list with metal name, minWidth=width of Mx to Mx+1 VIA and VIA + step to increse width, e.g. list( list(0.13 0.07+0.09) )
dilSmartViaFile = strcat( getWorkingDir() "/.il/vias.tmpl" )



procedure( DILPrintInfo(s)
let( ()
	printf("%s %s\n" dilPrefix s)
);let
);procedure

procedure( DILLoadSKILL()
let( (path dir dirs file files)
	dirs = list( "plugins" "forms" "callbacks" "misc")
	foreach( dir dirs
		path = strcat( dilHome "/" dir)
		DILPrintInfo( strcat("Loading " dir) )
		files = cddr( sort( getDirFiles(path) nil ) )
		foreach( file files
			if( !cdr(parseString(file "-")) then loadi(strcat(path "/" file)) )
		)
	)	
);let
);procedure

procedure( DILAbout()
let( (file line (info "") (endOfInfo nil))
	file = infile( strcat(dilHome "/.il") )
	when( file
		while( gets(line file)
			when( line == "\n" endOfInfo = t )
			when( !endOfInfo && !rexMatchp("^/.*$" line) sprintf(info "%s%s" info line) )
		)
	)
	hiDisplayAppDBox( 
		?name 'About 
		?dboxText info
		?buttonLayout 'Close
 	)
);let
);procedure

procedure( DILInit()
let(
(
	tLibName layer layers
	tf viaDefs viaDef via vias params i a b c d
)
	createDir( strcat(getWorkingDir() "/.il") )
	tLibName = getShellEnvVar("TLIB_NAME")
	if( tLibName then
		DILPrintInfo( strcat("Getting informaition from " tLibName " tech file") )
		dilTechFile = techGetTechFile(ddGetObj(tLibName))
		layers = techGetLayerFunctions(dilTechFile)
		foreach( layer layers
			if( cadr(layer) == "poly" then dilPolys = append1(dilPolys car(layer)) )
			if( cadr(layer) == "metal" then dilMetals = append1(dilMetals car(layer)) )
			if( cadr(layer) == "cut" then dilVias = append1(dilVias car(layer)) )
			if( cadr(layer) == "diff" then dilDiff = append1(dilDiff car(layer)) )
			if( cadr(layer) == "nplus" || cadr(layer) == "pplus" then dilImps = append1(dilImps car(layer)) )
			if( cadr(layer) == "nwell" then dilWells = append1(dilWells car(layer)) )
		)
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

