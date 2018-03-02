/*******************************************************************
/*
/*                                    *   *
/*                                        *
/*                                    *   *
/*                                *   *   *
/*
/*	Bindkeys:
/*
/*	- <Key>F4 to build an array from syncClones
/*	- <Key>; to load/save via templates and to add/remove stacks
/*	- <Key>Tab to change grid
/*	- <Key>1..9 to toggle metals+vias visiability
/*	- ctrl<Key>1..9 to add/remove metal+via to/from visiability list
/*	- <Key>0 to toggle FEOL/BEOL layers
/*	- ctrl<Key>0 to add/remove FEOL layers to/from visiability list
/*	- <Key>` to show all layers
/*	- <Key>\ to mark a net in the hierarchy
/*	- shift<Key>\ to remove all marked nets
/*
/*******************************************************************/


dilHome = strcat( skillHome "/dotil" )
dilPrefix = "[.il]"
dilFormGrid = 10
dilTechFile = nil
dilGrid = nil
dilBEOL = list()
dilFEOL = list()
dilCuts = list()
dilPins = list()
dilVias = list()
dilDummies = list()
dilLayersToToggle = list("")
dilSmartViaFile = strcat( getWorkingDir() "/.il/vias.tmpl" )
;dilConfigFile = strcat( getWorkingDir() "/.il/config" )
dilConfigFile = strcat( dilHome "/config" ) ;; for developing
dilAlphabet = list("A" "B" "C" "D" "E" "F" "G" "H" "I" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T")


procedure( DILPrint(message @optional messageType)
let( ()
	printf("%s\t*** %s ***\t\t%s\n" dilPrefix messageType message)
);let
);procedure

procedure( DILLoadSKILL()
let( (path dir dirs file files)
	dirs = list( "scripts")
	foreach( dir dirs
		path = strcat( dilHome "/" dir)
		DILPrint( strcat("Loading " dir) "INFO"  )
		files = cddr( sort( getDirFiles(path) nil ) )
		foreach( file files loadi(strcat(path "/" file)) )
	)
);let
);procedure

procedure( DILCleanUp()
let( (var func)
	foreach( var listVariables("^dil")
		if( var != "dilHome" || var != "dilConfigFile" var = 'unbound )
	)
	foreach( func listFunctions("^DILSmart" t) putd(func nil) )
	foreach( func listFunctions("^DILT" t) putd(func nil) )
	foreach( func listFunctions("^MISC" t) putd(func nil) )
);let
);procedure

procedure( DILEditConfig()
let( ()
	edit( sprintf( nil "%s" dilConfigFile) )
);let
);procedure

procedure( DILLoadConfig()
let( (file line (info "") (toRead nil) block pin layer layers dilVar)
	DILCleanUp()
	file = infile(dilConfigFile)
	when( file
		while( gets(line file)
			if( line != "\n" then line = car(parseString(line "\n")) else toRead = nil )
			when( toRead
				case( block
					( "tech" when( ddGetObj(line) dilTechFile = techGetTechFile(ddGetObj(line))) )
					( "grid" dilGrid = atof(line) )
					( "feol" dilFEOL = parseString(line) )
					( "beol" dilBEOL = parseString(line) )
					( "cut" dilCuts = parseString(line) )
					( "pin" foreach( pin parseString(line) dilPins = append1(dilPins parseString(pin "."))) )
					( "dummy" foreach( dum parseString(line) dilDummies = append1(dilDummies parseString(dum "."))) )
				)
			)
			when( rexMatchp("^[[].*[]]$" line)
				toRead = t
				block = car(parseString(line "[]"))
			)
		)
		if( dilTechFile then
			DILPrint( strcat("Getting informaition from " dilTechFile~>libName " tech file") "INFO")
			layers = techGetLayerFunctions(dilTechFile)
			foreach( layer layers
				if( cadr(layer) == "cut" then dilVias = append1(dilVias car(layer)) )
			)
			DILLoadSKILL()
		else
			DILPrint( "Tech library is missed" "ERROR" )
		)
	)
);let
);procedure

procedure( DILAbout()
let( (file line (info "") (endOfInfo nil))
	file = infile( strcat(dilHome "/.il") )
	when( file
		while( gets(line file) && !endOfInfo
			if( line == "\n" then endOfInfo = t else line = car(parseString(line "\n")) )
			when( rexMatchp("^/.*$" line)
				DILPrint( line "INFO" )
			)
		)
	)
);let
);procedure

/*** Adding main menu to CIW ***/

let( (items)
	createDir( strcat(getWorkingDir() "/.il") )
	ciwMenuInit()
	items = list(
			hiCreateMenuItem(
				?name 'itemEditConfig
				?itemText "Edit Config"
				?callback "DILEditConfig()"
			)
			hiCreateMenuItem(
				?name 'itemLoadConfig
				?itemText "Load Config"
				?callback "DILLoadConfig()"
			)
			hiCreateMenuItem(
				?name 'itemILog
				?itemText "About"
				?callback "DILAbout()"
			)
	)
	menuDIL = hiCreatePulldownMenu(
			'menuDIL
			".il"
			items
	)
	if( hiInsertBannerMenu( window(1) menuDIL hiGetNumMenus(window(1)) )
		DILPrint( "Menu \".il\" has been added to CIW" "INFO" )
	)
);let
