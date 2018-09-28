let( ( file dir dirs l path )
	file = simplifyFilename( get_filename( piport ) )
	l = parseString( file "/" )
	cellName = car( parseString( car( reverse(l) ) "." ) )
	dirs = reverse( cdr( reverse(l) ) )
	foreach(dir dirs
		path = strcat( path "/" dir )
	)
	pathToLoad = path
)