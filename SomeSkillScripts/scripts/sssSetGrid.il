procedure( SSSSwitchGrid( @optional mult )
let( (window mfg curGridX curGridY )
    mfg = techGetMfgGridResolution(sssTechFile)
    window = hiGetCurrentWindow()
    curGridX = window~>xSnapSpacing
    curGridY= window~>ySnapSpacing
    if(curGridX == mfg then
        window->xSnapSpacing = sssGrid
    else
        window->xSnapSpacing = mfg
    )
    if(curGridY == mfg then
        window->ySnapSpacing = sssGrid
    else
        window->ySnapSpacing = mfg
    )
    SSSPrint(sprintf(nil "X grid set to %1.3f" window->xSnapSpacing) "INFO")
    SSSPrint(sprintf(nil "Y grid set to %1.3f" window->ySnapSpacing) "INFO")
);let
);procedure

hiSetBindKey( "Layout" "<Key>Tab" "SSSSwitchGrid()" )
hiSetBindKey( "Layout" "<Key>Tab EF" "SSSSwitchGrid()" )
