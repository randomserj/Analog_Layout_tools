procedure( DILSwitchGrid( @optional mult )
let( (window mfg curGridX curGridY )
    mfg = techGetMfgGridResolution(dilTechFile)
    window = hiGetCurrentWindow()
    curGridX = window~>xSnapSpacing
    curGridY= window~>ySnapSpacing
    if(curGridX == mfg then
        window->xSnapSpacing = dilGrid
    else
        window->xSnapSpacing = mfg
    )
    if(curGridY == mfg then
        window->ySnapSpacing = dilGrid
    else
        window->ySnapSpacing = mfg
    )
    DILPrint(sprintf(nil "X grid set to %1.3f" window->xSnapSpacing) "INFO")
    DILPrint(sprintf(nil "Y grid set to %1.3f" window->ySnapSpacing) "INFO")
);let
);procedure

hiSetBindKey( "Layout" "<Key>F5" "DILSwitchGrid()" )
