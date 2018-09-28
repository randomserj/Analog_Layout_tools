procedure( uM( param )
	_parsed = parseString( car( parseString( param ) ) "" )
	_suffix = car( reverse( _parsed ) )
	case( _suffix
		( "m" _mult = 1e3 )
		( "u" _mult = 1e0 )
		( "n" _mult = 1e-3 )
		( t printf("\nUnknown suffix\n") _mult = 0 )
	)
	param = atof( param ) * _mult
);end of uM

procedure( uniquify( _list )
	let( ( uniqList )
		foreach( el _list
			unless( member( el car( uniqList ) ) uniqList = tconc( uniqList el ) )
		)
		car( uniqList )
	); let
); end of uniquify

procedure( isLarge( param )
	if( uM( param ) > 100 then _result = t else _result = nil )
	_result
); end of isLarge