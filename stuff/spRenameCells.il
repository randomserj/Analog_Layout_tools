procedure( spCopyViews()
let(
    ( libName view oldPrefix newPrefix cell cells name names newName oldCell newCell )

    libName = "zz_spakhomov"
    view = "schematic"
    oldPrefix = "AVUS_ADC_TS"
    newPrefix = "apc_adc"

    cells = ddGetObj(libName)~>cells
    names = cells~>name
    foreach( name names
        if( rexMatchp("^AVUS_ADC_TS.*$" name) then
            rexCompile("^AVUS_ADC_TS")
            newName = rexReplace(name newPrefix 1)
            printf("%s\t\t\t%s\n" newName name)

            oldCell = dbOpenCellViewByType(libName name view)
            newCell= dbCopyCellView( oldCell libName newName view nil nil t )
            unless(newCell error("Unable to copy %s" newName))
            dbClose(oldCell)
            dbClose(newCell)
        )
    )
);let
);procedure


procedure( spCopyCells()
let(

    (dest_library_name src_library_name prefix_name suffix_name list_libid list_cellid destList new_name dest srcList src res_copy)

    src_library_name = "zz_spakhomov"
    dest_library_name = "zz_spakhomov"
    prefix_old = "AVUS_ADC_TS"
    prefix_new = "apc_adc"

    list_cellid = ddGetObj(src_library_name)~>cells
    foreach( cellid list_cellid
        if( rexMatchp("^AVUS_ADC_TS.*$" cellid~>name) then
            destList = gdmCreateSpecList();
            rexCompile("^AVUS_ADC_TS")
            new_name = rexReplace(cellid~>name prefix_new 1)
            dest = gdmCreateSpec(dest_library_name new_name "" "" "CDBA");
            gdmAddSpecToSpecList(dest destList);

            srcList = gdmCreateSpecList();
            src = gdmCreateSpec(src_library_name cellid~>name "" "" "CDBA");
            println(gdmInspectSpec(src))
            gdmAddSpecToSpecList(src srcList);

            res_copy = ccpCopy( srcList destList t 'CCP_EXPAND_ALL nil nil "" "CDBA" )
        )
    )
);let
);procedure

procedure( spCellUpdate(cell_name)
let( (lib_name_old lib_name_new prefix_old cell list_cells cellid prefix_new inst_header new_name)
    lib_name_old = "AVUS_ADC_TS"
    lib_name_new = "zz_spakhomov"
    prefix_old = "AVUS_ADC_TS"
    prefix_new = "apc_adc"

    list_cells = ddGetObj(lib_name_new)~>cells
    ;foreach( cell list_cells
        ;;dprint(cell)
        cellid = dbOpenCellViewByType(lib_name_new cell_name "schematic" "schematic" "a")
        printf("\t\t--->\tUpdating %s\n" cellid~>cellName)
        foreach( inst_header cellid~>instHeaders
            when( inst_header~>libName == lib_name_old
                rexCompile("^AVUS_ADC_TS")
                new_name = rexReplace(inst_header~>cellName prefix_new 1)
                dprint(new_name)
                dbSetInstHeaderMasterName(inst_header lib_name_new new_name inst_header~>viewName)
            )
        )
        dbSave(cellid)
        dbClose(cellid)
    ;)
);let
);procedure
