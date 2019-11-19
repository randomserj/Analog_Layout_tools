/*****************
segList = list(
            width
            (layer purpose)
            (beginPoint endPoint)
			direction -> (-1/1 0) down/up (0 -1/1) right/left
			beginStyle
			endStyle
			db:0x...
        )
*****************/
procedure( SSSNetShiledingCBGetSegments(route)
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

procedure( SSSNetShieldingCBAlignSegments(cv segments)
let( (
        (segList list()) seg obj ptCenter d
        curr currPts currPtBegin currDir currDirAbs
        prev prevPts prevPtEnd prevDir prevDirAbs
    )
	prev = nil
    obj = nil
	foreach( curr segments
        currDir = nth(3 curr)
        prevDir = nth(3 prev)
        currPts = nth(2 curr)
        prevPts = nth(2 prev)
		currPtBegin = car(currPts)
        prevPtEnd = cadr(prevPts)
		when( prev
			when( !member(obj dbProduceOverlap(cv list(currPtBegin currPtBegin)))
				rplaca( cddr(curr) reverse(currPts) )
				rplaca( cdddr(curr) list(-1*car(currDir) -1*cadr(currDir)) )
                currPts = reverse(currPts)
                currPtBegin = car(currPts)

			)
            currDirAbs = foreach( mapcar d currDir abs(d) )
            prevDirAbs = foreach( mapcar d prevDir abs(d) )
            ptCenter = mapcar( 'plus mapcar('times currPtBegin currDirAbs) mapcar('times prevPtEnd prevDirAbs) )
            rplaca( cddr(curr) list(ptCenter cadr(currPts)) )
            rplaca( cddr(prev) list(car(prevPts) ptCenter) )
		)
		prev = curr
		obj = nth(6 curr)
		segList = append1(segList curr)
	)
	segList
);let
);procedure

procedure( SSSNetShieldingCBGetRoute(cv obj layer area r)
let(
	(
		route shape shapes viaUp viaDown
		ind llX llY urX urY
	)
	route = append1( r obj )
	ind = lindex( sssBEOL layer ) - 1
	viaUp = nth( ind+1 sssCuts )
	viaDown = nth( ind sssCuts )
	shapes = dbGetTrueOverlaps( cv area )
	;when( obj~>objType == "stdVia" shapes = dbGetTrueOverlaps( cv area layer) )
	shapes = remove( obj shapes )
	foreach( shape shapes
		when( !member(shape route)
			when( car(shape~>lpp) == layer
				route = append( route SSSNetShieldingCBGetRoute(cv shape layer shape~>bBox route) )
			)
			when( car(shape~>viaHeader~>viaDef~>params) == viaUp
				route = append( route SSSNetShieldingCBGetRoute(cv shape nth(ind+1 sssBEOL) shape~>bBox route) )
			)
			when( car(shape~>viaHeader~>viaDef~>params) == viaDown
				route = append( route SSSNetShieldingCBGetRoute(cv shape nth(ind-1 sssBEOL) shape~>bBox route) )
			)
		)
	)
	route
);let
);procedure

procedure( SSSNetShieldingLayoutCB()
let(
    (
        form cv obj segs route area layer w
		space i j IsLeft IsRight (shieldSides list())
        seg segLayer segPts segCurrent segPrevious segNext
        shieldWidth shieldLayer shieldBegin shieldEnd shieldBeginPt shieldEndPt
        pitch pitchB pitchE shift shiftB shiftE
		pt llX llY urX urY
        isCoaxial shieldCoaxBegin shieldCoaxEnd shieldCoaxBeginPt shieldCoaxEndPt
    )
    form = sssNetShieldingForm
    shieldWidth = evalstring( sprintf(nil "%s~>fsbWidth~>value" form) )
    space = evalstring( sprintf(nil "%s~>fsbSpacing~>value" form) )
    IsLeft = evalstring( sprintf(nil "%s~>bbLeftSide~>value" form) )
    IsRight = evalstring( sprintf(nil "%s~>bbRightSide~>value" form) )
    isCoaxial = evalstring( sprintf(nil "%s~>bbIsCoaxial~>value" form) )
    foreach( obj geGetSelSet()
    	cv = geGetEditCellView()
    	pt = obj~>endPt
    	when( pt
    		w = obj~>width
    		layer = car(obj~>lpp)
    		llX = min(car(pt)+w/2, car(pt)-w/2)
    	 	urX = max(car(pt)+w/2, car(pt)-w/2)
    	 	llY = min(cadr(pt)+w/2, cadr(pt)-w/2)
    	 	urY = max(cadr(pt)+w/2, cadr(pt)-w/2)
    		area = list( llX:llY urX:urY )
    		route = SSSNetShieldingCBGetRoute(cv obj layer area list())
    	)
    	route = SSSGetUnique(route)
    	geSelectFigs(route)
    	segs = SSSNetShiledingCBGetSegments(route)
    	segs = SSSNetShieldingCBAlignSegments(cv segs)
    	i = 0
       	foreach( segCurrent segs
      		shieldLayer = list(nth(1 segCurrent) "drawing")
            shieldBegin = nth(4 segCurrent)
            shieldEnd = nth(5 segCurrent)
            segPrevious = nil
            segNext = nil
            when( nth(i-1 segs) segPrevious = nth(i-1 segs) )
            when( nth(i+1 segs) segNext = nth(i+1 segs) )
            unless( segPrevious segPrevious = list(0 nil nil list(0 0)) )
            unless( segNext segNext = list(0 nil nil list(0 0)) )
            when( IsLeft shieldSides = append1(shieldSides -1) )
            when( IsRight shieldSides = append1(shieldSides 1) )
            foreach( j shieldSides
                pitch = j * ( (nth(0 segCurrent) + shieldWidth)/2 + space )
                pitchB = j * ( (nth(0 segPrevious) + shieldWidth)/2 + space )
                pitchE = j * ( (nth(0 segNext) + shieldWidth)/2 + space )
                shift = mapcar( 'times list(pitch pitch) nth(3 segCurrent) )
                shiftB = mapcar( 'times list(pitchB pitchB) nth(3 segPrevious) )
                shiftE = mapcar( 'times list(pitchE pitchE) nth(3 segNext) )
                shieldBeginPt = mapcar( 'plus shift shiftB car(nth(2 segCurrent)) )
                shieldEndPt = mapcar( 'plus shift shiftE cadr(nth(2 segCurrent)) )
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
                shieldCoaxBegin = nth(4 segCurrent)
                shieldCoaxEnd = nth(5 segCurrent)
                shieldCoaxBeginPt = car( nth(2 segCurrent) )
                shieldCoaxEndPt = cadr( nth(2 segCurrent) )
                when( cadr(segCurrent) != cadr(segNext)
                    shieldCoaxEnd = "truncate"
                    shieldCoaxEndPt = mapcar( 'difference cadr(nth(2 segCurrent)) mapcar('times reverse(nth(3 segCurrent)) list(-space-car(segCurrent)/2 space+car(segCurrent)/2)) )
                )
                when( cadr(segCurrent) != cadr(segPrevious)
                    shieldCoaxBegin = "truncate"
                    shieldCoaxBeginPt = mapcar( 'plus car(nth(2 segCurrent)) mapcar('times reverse(nth(3 segCurrent)) list(-space-car(segCurrent)/2 space+car(segCurrent)/2)) )
                )
                when( nth( lindex(sssBEOL nth(1 segCurrent)) sssBEOL )
                    dbCreatePathSeg(
                        cv
                        nth( lindex(sssBEOL nth(1 segCurrent)) sssBEOL )
                        shieldCoaxBeginPt
                        shieldCoaxEndPt
                        nth(0 segCurrent) + 2*(space + shieldWidth)
                        shieldCoaxBegin
                        shieldCoaxEnd
                    )
                )
                when( nth( lindex(sssBEOL nth(1 segCurrent))-2 sssBEOL )
                    dbCreatePathSeg(
                        cv
                        nth( lindex(sssBEOL nth(1 segCurrent))-2 sssBEOL )
                        shieldCoaxBeginPt
                        shieldCoaxEndPt
                        nth(0 segCurrent) + 2*(space + shieldWidth)
                        shieldCoaxBegin
                        shieldCoaxEnd
                    )
                )
            )
            i++
        )
    )
);let
);procedure
