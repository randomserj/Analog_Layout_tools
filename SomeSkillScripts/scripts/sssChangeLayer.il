procedure( SSSChangeLayer(dir)
let( (obj objs layer ind viaDefs viaNames newVia)
    objs = geGetSelSet()
    when( objs
        foreach( obj objs
            when( obj~>lpp
                ind = lindex( sssBEOL car(obj~>lpp) )
                when( nth(ind+dir-1 sssBEOL)
                    obj~>lpp = list( nth(ind+dir-1 sssBEOL) cadr(obj~>lpp) )
                )
            )
            when( obj~>viaHeader
                viaDefs = reverse( lxGetValidViaDefs(sssTechFile "WLCSP_stack") )
                viaNames = viaDefs~>name
                ind = lindex( viaNames obj~>viaHeader~>viaDefName )
                dprint(ind)
                dprint(viaNames)
                when( nth(ind+dir-1 viaNames)
                    newVia = dbCreateVia(
                        obj~>cellView
                        nth(ind+dir-1 viaDefs)
                        obj~>origin
                        obj~>orient
                        obj~>viaHeader~>overrideParams
                    )
                    geSelectFigs( append1(geGetSelSet() newVia) )
                    dbDeleteObject(obj)
                )
            )
        )
    )
);let
);procedure
