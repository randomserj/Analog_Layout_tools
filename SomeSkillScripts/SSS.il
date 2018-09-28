/*******************************************************************
/*
/*					Some SKILL Scripts features
/*
/*	Bindkeys:
/*
/*	- <Key>F4 to build an array from either devices or groups
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

procedure( _SSSLoadConfig()
let( (file line (info "") (toRead nil) block pin layer layers dilVar)
	file = infile(sssConfigFile)
	SSSCleanUp()
	load( strcat(sssHome "/SSS.defaults") )
	when( file
		while( gets(line file)
			if( line != "\n" then line = car(parseString(line "\n")) else toRead = nil )
			when( toRead
				case( block
					( "tech" when( ddGetObj(line) sssTechFile = techGetTechFile(ddGetObj(line))) )
					( "grid" sssGrid = atof(line) )
					( "feol" sssFEOL = parseString(line) )
					( "beol" sssBEOL = parseString(line) )
					( "cut" sssCuts = parseString(line) )
					( "pin" foreach( pin parseString(line) sssPins = append1(sssPins parseString(pin "."))) )
					( "dummy" foreach( dum parseString(line) sssDummies = append1(sssDummies parseString(dum "."))) )
				)
			)
			when( rexMatchp("^[[].*[]]$" line)
				toRead = t
				block = car(parseString(line "[]"))
			)
		)
		if( sssTechFile then
			SSSPrint( strcat("Getting informaition from " sssTechFile~>libName " tech file") "INFO")
			layers = techGetLayerFunctions(sssTechFile)
			foreach( layer layers
				if( cadr(layer) == "cut" then sssVias = append1(sssVias car(layer)) )
			)
			SSSLoadSKILL()
		else
			SSSPrint( "Tech library is missed" "ERROR" )
		)
	)
);let
);procedure

procedure( _SSSEditConfig()
let( ()
	edit( sprintf( nil "%s" sssConfigFile) )
);let
);procedure

procedure( _SSSAbout()
let( (file line (info "") (endOfInfo nil))
	file = infile( strcat(sssHome "/SSS.il") )
	when( file
		while( gets(line file) && !endOfInfo
			if( line == "\n" then endOfInfo = t else line = car(parseString(line "\n")) )
			when( rexMatchp("^/.*$" line)
				SSSPrint( line "INFO" )
			)
		)
	)
);let
);procedure

/*** Adding main menu to CIW ***/

let( (items)
	createDir( strcat(getWorkingDir() "/.SSS") )
	ciwMenuInit()
	items = list(
			hiCreateMenuItem(
				?name 'itemEditConfig
				?itemText "Edit Config"
				?callback "_SSSEditConfig()"
			)
			hiCreateMenuItem(
				?name 'itemLoadConfig
				?itemText "Load Config"
				?callback "_SSSLoadConfig()"
			)
			hiCreateMenuItem(
				?name 'itemILog
				?itemText "About"
				?callback "_SSSAbout()"
			)
	)
	sssMenu = hiCreatePulldownMenu(
			'sssMenu
			"SSS"
			items
	)
	if( hiInsertBannerMenu( window(1) sssMenu hiGetNumMenus(window(1)) )
		SSSPrint( "Some SKILL Scripts menu has been added to CIW" "INFO" )
	)
);let
