procedure( DILNetShiledingGetSegments(path)
let(
    (
        (segList list()) segDirection x1 x2 y1 y2
    )
    foreach( seg path~>route~>objects
        x1 = car(seg~>beginPt)
        x2 = car(seg~>endPt)
        y1 = cadr(seg~>beginPt)
        y2 = cadr(seg~>endPt)
        when( x1 == x2
            if( y1 > y2 then segDirection = "down" else segDirection = "up" )
        )
        when( y1 == y2
            if( x1 > x2 then segDirection = "left" else segDirection = "right" )
        )
        segList = append1( segList list(seg~>width seg~>layerName segDirection) )
    )
    segList
);let
);prcodeure

procedure( DILNetShileding(isCoaxial)
let(
    (
        cv path segs
        segCurrent segPrevious segNext
        seg seg_layer seg_pts layer i (count t)
        space shieldWidth
        shape
    )

    ;;;;; temporary consts
    space = 0.31
    shieldWidth = 0.29
    ;;;;;

    cv = geGetEditCellView()
    path = css()
    i = 0
    foreach( layer dilBEOL
        when( layer == path~>layerName count = nil )
        when( count i++ )
    )
    i = 0
    when( path~>objType == "pathSeg"
        segs = DILNetShiledingGetSegments(path)
        dprint(segs)
        foreach( segCurrent segs
            when( nth(i-1 segs)
                segPrevious = nth(i-1 segs)
            )
            when( nth(i+1 segs) segNext = nth(i+1 segs) )
            dprint( segPrevious )
            i++
        )
    )
        /*
        foreach( seg path~>route~>objects
            if( seg~>width >= 5 then space = 0.6 else space = 0.31 )
            when( is_coaxial
                when( nth(i-1 dilBEOL)
                    dbCreatePathSeg(
                        cv
                        list(nth(i-1 dilBEOL) "drawing")
                        seg~>beginPt
                        seg~>endPt
                        seg~>width + 2*(shield_width + space)
                        "extend"
                        "extend"
                    )
                )
                when( nth(i+1 dilBEOL)
                    dbCreatePathSeg(
                        cv
                        list(nth(i+1 dilBEOL) "drawing")
                        seg~>beginPt
                        seg~>endPt
                        seg~>width + 2*(shield_width + space)
                        "extend"
                        "extend"
                    )
                )
            )

            dbCreatePathSeg(
                cv
                list(nth(i dilBEOL) "drawing")
                list( car(seg~>beginPt) cadr(seg~>beginPt) )
                seg~>endPt
                shield_width
                "extend"
                "extend"
            )

        )
        */
);let
);procedure
