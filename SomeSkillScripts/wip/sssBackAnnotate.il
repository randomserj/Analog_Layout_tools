procedure( SSSBackAnnotate()
let( ( cv sch obj objs inst instId nets pin pins )
    cv = geGetEditCellView()
    sch = dbOpenCellViewByType( cv~>libName cv~>cellName "schematic" )
    objs = geGetSelSet()
    obj = car(objs)
    inst = dbOpenCellViewByType( obj~>libName obj~>cellName "symbol" )
    instId = schCreateInst( sch inst obj~>name list(-2 0) "R0" 1 )
    pins = instId~>instTerms~>term~>pins
    dprint(pins)
    foreach( pin pins
        printf( "%L\n" pin~>fig~>bBox )
        printf( "%L\n" pin~>net~>name )
    )
);let
);procedure

hiSetBindKey( "Layout" "<Key>F5" "SSSBackAnnotate()" )
