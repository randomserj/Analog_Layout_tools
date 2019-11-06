procedure( SSSNetShielding()
let( ()
	enterPoint(
		?prompts list("Enter starting point")
		?doneProc "SSSNetShieldingLayout"
	)
);let
);procedure

hiSetBindKey( "Layout" "<Key>/" "SSSNetShieldingLayout()" )

/*****************
segList = list(
            width
            (layer purpose)
            (beginPoint endPoint)
			direction -> (-1/1 x) down/up (x -1/1) right/left
			beginStyle
			endStyle
			db:0x...
        )
*****************/
procedure( SSSNetShiledingGetSegments(route)
let(
    (
        (segList list()) (segDirection list())
		x1 x2 y1 y2 bSt eSt
    )
    foreach( seg route
		when( seg~>objType == "pathSeg"
	        x1 = car(seg~>beginPt)
	        x2 = car(seg~>endPt)
	        y1 = cadr(seg~>beginPt)
	        y2 = cadr(seg~>endPt)
	        when( x1 == x2
	            if( y1 > y2 then segDirection = list(-1 0) else segDirection = list(1 0) )
	        )
	        when( y1 == y2
	            if( x1 > x2 then segDirection = list(0 1) else segDirection = list(0 -1) )
	        )
			bSt = "extend"
			eSt = "extend"
			when( seg == car(route) bSt = seg~>beginStyle )
			when( seg == car(reverse(route)) eSt = seg~>endStyle )
	        segList = append1(
	            segList
	            list(
	                seg~>width
	                seg~>layerName
	                list(seg~>beginPt seg~>endPt)
	                segDirection
	                bSt
	                eSt
					seg
	            )
	        )
		)
    )
    segList
);let
);prcodeure

procedure( SSSNetShieldingSortSegments(cv segments)
let( ((segList list()) seg obj curr prev pt dir)
	prev = nil
	foreach( seg segments
		curr = nth(2 seg)
		pt = car(curr)
		when( prev
			when( !member(obj dbProduceOverlap(cv list(pt pt)))
				dir = nth(3 seg)
				rplaca( member(curr seg) reverse(curr) )
				rplaca( member(dir seg) list(-1*car(dir) -1*cadr(dir)) )
			)
		)
		prev = curr
		obj = nth(6 seg)
		segList = append1(segList seg)
	)
	segList
);let
);procedure

procedure( SSSNetShieldingGetRoute(cv obj layer area)
let(
	(
		shape shapes viaUp viaDown shapesUp shapesDown
		ind sU sD llX llY urX urY
		(route list())
	)
	ind = lindex( sssBEOL layer ) - 1
	viaUp = nth( ind+1 sssCuts )
	viaDown = nth( ind sssCuts )
	shapes = dbGetTrueOverlaps( cv area )
	shapes = remove( obj shapes )
	foreach( shape shapes
		when( !member(shape sssRoute)
			when( car(shape~>lpp) == layer
				sssRoute = append1( sssRoute shape )
				SSSNetShieldingGetRoute(cv shape layer shape~>bBox)
			)
			when( car(shape~>viaHeader~>viaDef~>params) == viaUp
				sssRoute = append1( sssRoute shape )
				shapesUp = dbGetTrueOverlaps( cv shape~>bBox nth(ind+1 sssBEOL) )
				sU = car(shapesUp)
				sssRoute = append1( sssRoute sU )
				SSSNetShieldingGetRoute(cv sU nth(ind+1 sssBEOL) sU~>bBox)
			)
			when( car(shape~>viaHeader~>viaDef~>params) == viaDown
				sssRoute = append1( sssRoute shape )
				shapesDown = dbGetTrueOverlaps( cv shape~>bBox nth(ind-1 sssBEOL) )
				sD = car(shapesDown)
				sssRoute = append1( sssRoute sD )
				SSSNetShieldingGetRoute(cv sD nth(ind-1 sssBEOL) sD~>bBox)
			)
		)
	)
);let
);procedure

;procedure( SSSNetShieldingLayout(window done point @optional isCoaxial)
procedure( SSSNetShieldingLayout(@optional isCoaxial)
let(
    (
        cv obj obj (route list()) segs space pitch i j (count t)
        seg segLayer segPts segCurrent segPrevious segNext
        shieldWidth shieldLayer shieldBegin shieldEnd shieldBeginPt shieldEndPt
        shiftBegin shiftEnd
        tt
		llX llY urX urY shapes pt w area
		layer ind objNext
    )

    ;;;;; temporary consts
    space = 0.31
    shieldWidth = 0.2
    ;;;;;

	cv = geGetEditCellView()
	obj = css()
	pt = obj~>endPt
	when( pt
		sssRoute = list( obj )
		w = obj~>width
		layer = car(obj~>lpp)
		llX = min(car(pt)+w/2, car(pt)-w/2)
	 	urX = max(car(pt)+w/2, car(pt)-w/2)
	 	llY = min(cadr(pt)+w/2, cadr(pt)-w/2)
	 	urY = max(cadr(pt)+w/2, cadr(pt)-w/2)
		area = list( llX:llY urX:urY )
		SSSNetShieldingGetRoute( cv obj layer area )
	)
	geSelectFigs(sssRoute)
	segs = SSSNetShiledingGetSegments(sssRoute)
	segs = SSSNetShieldingSortSegments(cv segs)
	dprint(segs)
	i = 0
   	foreach( segCurrent segs
  		shieldLayer = list(nth(1 segCurrent) "drawing")
        shieldBegin = nth(4 segCurrent)
        shieldEnd = nth(5 segCurrent)
        segPrevious = nil
        segNext = nil
        when( nth(i-1 segs) segPrevious = nth(i-1 segs) )
        when( nth(i+1 segs) segNext = nth(i+1 segs) )
        unless( segPrevious segPrevious = list(nil nil nil list(0 0)) )
        unless( segNext segNext = list(nil nil nil list(0 0)) )
        foreach( j list(1 -1)
            pitch = j * ( (nth(0 segCurrent) + shieldWidth)/2 + space )
            shiftBegin = mapcar( 'plus
                mapcar( 'times list(pitch pitch) nth(3 segPrevious) )
                mapcar( 'times list(pitch pitch) nth(3 segCurrent) )
            )
            shiftEnd = mapcar( 'plus
                mapcar( 'times list(pitch pitch) nth(3 segCurrent) )
                mapcar( 'times list(pitch pitch) nth(3 segNext) )
            )
            shieldBeginPt = mapcar( 'plus shiftBegin car(nth(2 segCurrent)) )
            shieldEndPt = mapcar( 'plus shiftEnd cadr(nth(2 segCurrent)) )
            dbCreatePathSeg(
                cv
                shieldLayer
                shieldBeginPt
                shieldEndPt
                shieldWidth
                shieldBegin
                shieldEnd
            )
        )
        when( isCoaxial
            when( nth( lindex(sssBEOL nth(1 segCurrent)) sssBEOL )
                dbCreatePathSeg(
                    cv
                    nth( lindex(sssBEOL nth(1 segCurrent)) sssBEOL )
                    car( nth(2 segCurrent) )
                    cadr( nth(2 segCurrent) )
                    nth(0 segCurrent) + 2*(space + shieldWidth)
                    nth(4 segCurrent)
                    nth(5 segCurrent)
                )
            )
            when( nth( lindex(sssBEOL nth(1 segCurrent))-2 sssBEOL )
                dbCreatePathSeg(
                    cv
                    nth( lindex(sssBEOL nth(1 segCurrent))-2 sssBEOL )
                    car( nth(2 segCurrent) )
                    cadr( nth(2 segCurrent) )
                    nth(0 segCurrent) + 2*(space + shieldWidth)
                    nth(4 segCurrent)
                    nth(5 segCurrent)
                )
            )
        )
        i++
    )
);let
);procedure
