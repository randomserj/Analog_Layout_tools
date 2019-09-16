procedure( SSSNetShiledingGetSegments(path)
let(
    (
        (segList list()) (segDirection list()) x1 x2 y1 y2
    )
    foreach( seg path~>route~>objects
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
        segList = append1(
            segList
            list(
                seg~>width
                seg~>layerName
                list(seg~>beginPt seg~>endPt)
                segDirection
                seg~>beginStyle
                seg~>endStyle
            )
        )
    )
    segList
);let
);prcodeure

procedure( SSSNetShieldingCB(isCoaxial)
let(
    (
        cv path segs space pitch i j (count t)
        seg segLayer segPts segCurrent segPrevious segNext
        shieldWidth shieldLayer shieldBegin shieldEnd shieldBeginPt shieldEndPt
        shiftBegin shiftEnd
        tt
    )

    ;;;;; temporary consts
    space = 0.31
    shieldWidth = 0.2
    ;;;;;

    cv = geGetEditCellView()
    path = css()
    i = 0
    when( path~>objType == "pathSeg"
        segs = SSSNetShiledingGetSegments(path)
        dprint(segs)
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
    )
);let
);procedure
