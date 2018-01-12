procedure( DILGetShapeAndHierarchy(shape)
prog( (s h)
	s = shape
	h = nil
	if( type(s) == 'list then
		while( type(s) == 'list
			h = append1( h list(car(s) 0 0 0) )
			s = cadr(s)
		)
	)
	return( list(s h) )
);prog
);procedure

procedure( DILCopyFigToCurrentLayer(cv shape)
prog( (ans s h)
	ans = DILGetShapeAndHierarchy(shape)
	s = car(ans)
	h = cadr(ans)
	s = dbCopyFig( s cv dbGetInstTransform(h) )
	return(s)
);prog
);procedure

procedure( DILTrueOverlaps(cv shape layer)
prog( (s ss temp temps tS1 tS2 overlapedShapes)
	overlapedShapes = nil
	tS1 = DILCopyFigToCurrentLayer(cv shape)
	ss = dbGetTrueOverlaps( cv tS1~>bBox list(layer "drawing") 32 )
	ss = setof( s ss s != shape && s != tS1 )
	foreach( s ss
		tS2 = DILCopyFigToCurrentLayer(cv s)
		temps = dbLayerAnd(cv layer list(tS1) list(tS2))
		when( temps
			foreach( temp temps dbDeleteObject(temp) )
			overlapedShapes = append1(overlapedShapes s)
		)
		dbDeleteObject(tS2)
	)
	dbDeleteObject(tS1)
	return(overlapedShapes)
);prog
);procedure

procedure( DILMarkNet(cv shape layer hierarchy)
let( (obj objs b s l h)
	unless( member(shape dilMarkedShapes)
		dilMarkedShapes = append1( dilMarkedShapes shape )
		s = shape
		l = layer
		h = nil
		if( type(s) == 'list then
			while( type(s) == 'list
				if( car(s)~>objType == "stdVia" then
					l = car(s)~>viaHeader~>viaDef~>layer1~>name
					if( l == layer then l = car(s)~>viaHeader~>viaDef~>layer2~>name )
				)
				h = append1( h list(car(s) 0 0 0) )
				s = cadr(s)
			)
		)
		geAddHilightFig( dilHilightSet s nil h )
		if( h then b = dbTransformBBox( s~>bBox dbGetInstTransform(h) ) else b = s~>bBox )
		objs = DILTrueOverlaps(cv shape l)
		foreach( obj objs DILMarkNet(cv obj l h) )
	)
);let
);procedure

procedure( DILPickNetCB(window done point)
let( (cv llX llY urX urY shapes)
	cv = geGetEditCellView()
	llX = min(caar(point)+0.001, caar(point)-0.001)
	urX = max(caar(point)+0.001, caar(point)-0.001)
	llY = min(cadar(point)+0.001, cadar(point)-0.001)
	urY = max(cadar(point)+0.001, cadar(point)-0.001)
	shapes = dbGetTrueOverlaps( cv list( llX:llY urX:urY ) )
	dilHilightSet = geCreateHilightSet( cv list("y6" "flight") )
	dilHilightSet->enable = t
	if( car(shapes)~>layerName then 
		DILMarkNet(cv car(shapes) car(shapes)~>layerName nil)
	else
		printf("[WARNING] There is no net in the point you clicked")
	)
);let
);procedure

procedure( DILPickNet()
let( ()
	dilMarkedShapes = list()
	enterPoint(
		?prompts list("Enter point")
		?doneProc "DILPickNetCB"
	)
);let
);procedure

hiSetBindKey("Layout" "<Key>\\" "DILPickNet()")
hiSetBindKey("Layout" "Shift<Key>\\" "geDeleteAllHilightSet(geGetEditCellView())")
