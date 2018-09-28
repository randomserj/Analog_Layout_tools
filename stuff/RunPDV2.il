
/*******************************************************************************
*                         Copyright (C) 2017                                   *
*                  Apple, Inc. Silicon Engineering Group                       *
*                        All Rights Reserved.                                  *
*******************************************************************************/
/*******************************************************************************

Author:		Rewati Deo
Group:		SEG-CAD & CSG
Language:	SKILL
Date:		02 Feb 2012
Modified By:	Lawrence Davis
Modified even more By: Colin Sutlieff
Modified Date:	April 24th, 2018
Lint Score:	
Description:

A graphical user interface for the RunPDV command line utility/script.
Main entry function: RunPDV_GUI2()

Usage:
	RunPDV_GUI2()

*******************************************************************************/
; triggers
;
;	foreach(layoutTier list("maskLayout" "maskLayoutXL" "maskLayoutGXL")
;		unless(memq('ApplePDV_GUI3
;			deGetAppInfo(layoutTier)->userPostInstallTrigList)
;			deRegUserTriggers(layoutTier nil nil 'ApplePDV_GUI3)
;		); unless
;	); foreach
;procedure(ApplePDV_GUI2()
;	let(()
/*******************************************************************************/
; Insert the banner menu
/*******************************************************************************/
;        num = hiGetNumMenus(hiGetCIWindow())
;        menuItemOne = hiCreateMenuItem(
;        	?name 'PDVGUI2_menuItem
;        	?itemText "PDV2"
;        		?callback "RunPDV_GUI2()"
;        		)
;		hiCreatePulldownMenu('PDV2 "PDV2" list( menuItemOne ))
;		hiInsertBannerMenu(hiGetCIWindow() 'PDV2 9 )
;		); let
;);ApplePDV_GUI2 

procedure(ApplePDV_GUI3(@optional args)
	let((menuItemTwo)
/*******************************************************************************/
; Insert the banner menu
/*******************************************************************************/
        ;num = hiGetNumMenus(hiGetCIWindow())
        menuItemTwo = hiCreateMenuItem(
        	?name 'PDVGUI2_menuItem
        	?itemText "PDV2 (Beta)"
        		?callback "RunPDV_GUI2()"
        		)
		hiCreatePulldownMenu('PDV2 "PDV2" list( menuItemTwo ))
		hiInsertBannerMenu(getCurrentWindow() 'PDV2 18 )
		); let
);ApplePDV_GUI2 

procedure(RunPDV_GUI2()
let(( home_dir runDirectory AppleRunPDVLayPathName activewin AppleRunPDVReportFileViewExtBtn
    AppleRunPDVLayPath AppleRunPDVLayPathOpt AppleRunPDVReportFileName lines
    AppleRunPDVHcellFile mode_list project_dir project AppleRunPDVHcellFileName
    AppleRunPDVLVSExcludeCells AppleRunPDVLVSPower AppleRunPDVLVSGround AppleRunPDVPERCMode
    AppleRunPDVResultsFile AppleRunPDVNoAudit AppleRunPDVChecker AppleRunPDVNone
    AppleRunPDVShort_equiv_nets AppleRunPDVOpdcap AppleRunPDVRelease_lay AppleRunPDVReportFileViewLogBtn
    libraryName viewName cellName AppleRunPDVRunDirectory AppleRunPDVWorkspace
    AppleRunPDVMegacell AppleRunPDVNumProc AppleRunPDVAllMode AppleRunPDVOptions
    AppleRunPDVNo_ip_tighten AppleGdsWaiver AppleRunLVSFXOption AppleRunPDVOtherOpt
    AppleRunPDVFormInitFileDef debug AppleRunPDVRunPDVcmd mode_list_callback
    AppleRunPDVRunPDVcmdBtn AppleRunPDVStopBtn AppleRunPDVStopLabel AppleRunPDVOvdirPath
    workspace_dir project_home AppleRunPDVAll AppleRunPDVPost AppleRunPDVModes
    AppleRunPDVNoWaivers AppleRunPDVNoWaiversGds AppleRunPDVNoAutoHcells AppleRunPDVQueue
    AppleRunPDVLef appDpColoredGdsOut appDpColoredView AppleRunPDVDfm_guideline
    AppleRunPDVLayViewName AppleRunPDVLayCellName AppleRunPDVLayLibraryName AppleRunPDVRunFlat
    AppleRunPDVSchViewName AppleRunPDVSchCellName AppleRunPDVSchPathOpt2 AppleGenPDVWaiverBtn
    AppleRunPDVSchPath AppleRunPDVViewRunLog AppleRunPDVRunQueue colorArray AppleRunPDVRunChoiceDefault
    AppleRunPDVImage AppleStartRunPDVImage diskPath mode_list_value mode_name mode_name_tmp
    AppleRunPDVMaxErrors AppleRunPDVLoadOptionsBtn AppleRunPDVRefreshOptionsBtn AppleRunPDVSaveOptionsBtn
    AppleRunPDVHcellFileViewBtn editor_list formName win uq AppleGenPDFWithSnapBtn
    AppleRunPDVMegaReleaseVersion appleRunPDVBAGds ovdirPath AppleAPSUBOtherOpt AppleRunPDVRulesName
    appleRunPDVMapAllColorsToLock applRunPDVLockAllBAData AppleGenPDFBtn 
    applRunPDVGenBAData SchViewName AppleRunPDVExtraCmdOpts AppleRunDummyBtn AppleRunPDVReportFileViewBtn
	AppleRunPDVSchLibraryName AppleRunPDVLayPathName AppleRunPDVSchPathName AppleRunPDVSchPathOpt
	AppleRunPDVSchTopCell AppleRunPDVScoreFileViewBtn AppleRunPDVStartBtn AppleRunPDVStartRVEBtn
	AppleRunPDVUseOvdir AppleRunPDVVirtualConnColon AppleRunPDVVirtualConnName AppleRunPdvLayoutViewSelect
	AppleRunPdvSchViewSelect GlobalPDVButtons iconRoot)

;; RunPDVModesList DRC LVS DPGDSOUT LVS_EXTRACT MEGB LEF LVS_EXTRACT_SKIPBOX BIASCHK ERC ANT LVSERC CHECKER IPLVS PERCTP
;; RunPDVModesList Not in the GUI IPLVSERC LVS_EXTRACT_CLKBOX

	debug=0
	if(onep(debug) then printf("\n\n DEBUG MODE : RunPDV"))
	home_dir = getShellEnvVar("HOME")
	formName = "Running RunPDV GUI "
	AppleRunPDVRulesName = "Rules File"
	AppleRunPDVRunChoiceDefault = "DRC"
	AppleRunPDVSchTopCell = ""
	AppleRunPDVReportFile = ""
	AppleRunPDVLVSPower = ""
	AppleRunPDVLVSGround = ""
	AppleRunPDVFormInitFileDef = strcat(home_dir "/.RunPDV")
	project = getShellEnvVar("PROJECT")
	unless(geGetEditCellView()
		fprintf(errport "\nERROR: No layout open to run RunPDV GUI\n") )
		libraryName = geGetEditCellView()~>lib~>name
		cellName =  geGetEditCellView()~>cellName
		if(cellName == nil then
			printf("\nError: Cannot find a currently edited cell view\n")
			);if
	viewName =  geGetEditCellView()~>viewName
	SchViewName = "schematic"

	unless(hiGetCurrentWindow() error("No design window is open currently\n"))
	win=sprintf(nil "%s" hiGetCurrentWindow()) 
	;; This is unique number derived from window number added to form symbol AppleRunPDVForm 
	uq=substring(win 8 strlen(win))
	formName=strcat(formName "Window ID: " uq)
	printf("\nformName %s " formName)
	project_dir = getShellEnvVar("PROJECT_DIR")
	iconRoot = simplifyFilename("$GLOBAL_PATH/bin/CDM/data_management/icons")
	workspace_dir = car(last(parseString(getWorkingDir() "/")))
	diskPath = getShellEnvVar("ECS_DISK_PATH")
	runDirectory=  strcat(diskPath "/PDV/" cellName)
	;runDirectory = strcat(diskPath "/PDV/" cellName "/drc")

	AppleRunPDVReportFile = runDirectory

	if(cellName == "" then
		printf("\n\nERROR: No cell name found") )
		if(libraryName == "" then
			printf("\n\nERROR: No library name found") 
			);if
	AppleRunPDVLayPathName = "  gds Path"
	AppleRunPDVSchPathName = "  cdl Path"
	AppleRunPDVReportFileName = "Report/Summary File"
	AppleRunPDVHcellFileName = "Hcell File"
	if(onep(debug) 
		printf("\n DEBUG MODE : AppleRunPDVFormInitFileDef=%L formName=%L" AppleRunPDVFormInitFileDef formName)
		);if

	formName=strcat(formName "  Library Name: " libraryName " Cell Name: " cellName " View Name: " viewName) 
	printf("\nformName :: %s\n" formName)
    
;;printf("\nInfo:: %L and %L and %L\n" AppleRunPDVForm2 concat('AppleRunPDVForm2 uq) 'AppleRunPDVForm2)

	AppleRunPDVOptions = hiCreateFormButton(
		?name 'AppleRunPDVOptions2
		?buttonText "Advanced options ..."
		?callback "AppleRunPDVOptionsCB2(AppleOptsForm)"
		)
	AppleRunPDVOptions->hiToolTip = "Further options"

;	AppleRunInputOptions = hiCreateFormButton(
;		?name 'AppleRunInputOptions2
;		?buttonText "Input options..."
;		?callback "AppleRunInputOptionsCB(hiGetCurrentForm())"
;		)
;       AppleRunInputOptions->hiToolTip = "Input options"

;	AppleRunOutputOptions = hiCreateFormButton(
;		?name 'AppleRunOutputOptions2
;		?buttonText "Output options..."
;		?callback strcat("AppleRunOutputOptionsCB2(hiGetCurrentForm())")
;		)
;        AppleRunOutputOptions->hiToolTip = "Output options"

;	AppleRunDataOptions = hiCreateFormButton(
;		?name 'AppleRunDataOptions2
;		?buttonText "Run data options..."
;		?callback strcat("AppleRunDataOptionsCB2(hiGetCurrentForm())")
;		)
;        AppleRunDataOptions->hiToolTip = "Run data options"

	AppleRunPDVAll = hiCreateFormButton(
		?name 'AppleRunPDVAll2
		?buttonText "All checks"
		?callback strcat("RunPDBV2SelectAll2(AppleRunPDVForm2" uq ") ")
		)
        ;AppleRunOutputOptions->hiToolTip = "Select all run options"	
	
	AppleRunPdvLayoutViewSelect = hiCreateFormButton(
		?name 'AppleRunPdvLayoutViewSelect
		?buttonText ". . ."
		?callback strcat("AppleRunPdvThumbnailForm(\"layout\")")
		)
        ;AppleRunOutputOptions->hiToolTip = "Deselect all run options"

	AppleRunPdvSchViewSelect = hiCreateFormButton(
		?name 'AppleRunPdvSchViewSelect
		?buttonText ". . ."
		?callback strcat("AppleRunPdvThumbnailForm(\"schematic\")")
		)

	AppleRunPDVNone = hiCreateFormButton(
		?name 'AppleRunPDVNone2
		?buttonText "No checks"
		?callback strcat("RunPDBV2SelectNone2(optForm AppleRunPDVForm2" uq ")")
		)

        ;AppleRunOutputOptions->hiToolTip = "Deselect all run options"

	AppleRunPDVPost =  hiCreateBooleanButton(
		?name   'AppleRunPDVPost2
		?buttonText "Post mode"	
		?buttonLocation 'left
		?invisible nil	
		?callback strcat("AppleRunPDVRunChoicesCallback_12(AppleRunPDVForm2" uq ")")
		)

	AppleRunPDVAllMode =  hiCreateBooleanButton(
        ?buttonText "All mode"
        ?name   'AppleRunPDVAllMode2
        ?defValue nil
        ?enabled t
		?buttonLocation 'left
		?callback strcat("AppleRunPDVRunChoicesCallback_12(AppleRunPDVForm2" uq ")")
		)

	AppleRunPDVPERCMode =  hiCreateBooleanButton(
        ?buttonText "PERC mode"
        ?name   'AppleRunPDVPERCMode2
        ?defValue nil
        ?enabled t
		?buttonLocation 'left
		?callback strcat("AppleRunPDVRunChoicesCallback_12(AppleRunPDVForm2" uq ")")
		)


;	AppleRunPDVPost =  hiCreateBooleanButton(
;        ?buttonText "POST"
;        ?name   'AppleRunPDVPost2
;       ?defValue nil
;       ?enabled t
;        ?buttonLocation 'left
;		?callback strcat("AppleRunPDVRunChoicesCallback_12(AppleRunPDVForm2" uq ")")
;      )

	AppleRunPDVLef =  hiCreateBooleanButton(
        ?buttonText "LEF"
        ?name   'AppleRunPDVLef2
        ?defValue nil
        ?enabled t
        ?callback strcat("AppleRunPDVRunChoicesCallback_12(AppleRunPDVForm2" uq ")")
        ?invisible t
        ?buttonLocation 'left
       )

	AppleRunPDVRunDirectory = hiCreateFileSelectorField(
        ?name 'AppleRunPDVRunDirectory2
        ?prompt "Run Directory"
        ?defValue runDirectory
		?mode	'directoryOnly
		?editable t 
        ?callback strcat("AppleUpdateCommandLine(AppleRunPDVForm2)")
		)

	AppleRunPDVWorkspace = hiCreateFileSelectorField(
        ?name 'AppleRunPDVWorkspace2
        ?prompt "Workspace"
        ?defValue workspace_dir 
		?mode	'directoryOnly
		?callback	strcat("AppleRunPDVWorkspaceCB2(AppleRunPDVForm2" uq ")")
		)

	AppleRunPDVLayLibraryName  = hiCreateStringField(
        ?name 'AppleRunPDVLayLibraryName2
        ?prompt "Library "
        ?defValue libraryName
        ?callback strcat("AppleUpdateCommandLine(AppleRunPDVForm2)")
       )

	AppleRunPDVLayCellName  = hiCreateStringField(
        ?name 'AppleRunPDVLayCellName2
        ?prompt "Cell"
        ?defValue cellName
        ?callback strcat("AppleUpdateCommandLine(AppleRunPDVForm2)")
        )

	AppleRunPDVLayViewName  = hiCreateStringField(
        ?name 'AppleRunPDVLayViewName2
        ?prompt "View"
        ?defValue viewName
        ?callback strcat("AppleUpdateCommandLine(AppleRunPDVForm2)")
		)

	AppleRunPDVLayPathOpt = hiCreateBooleanButton(
        ?buttonText "Use gds"
        ?name   'AppleRunPDVLayPathOpt2
		?buttonLocation 'left
        ?defValue nil
        ?callback strcat("AppleRunPDVLayPathOptCallback2(optForm AppleRunPDVForm2" uq ")")
        ?enabled t
		)

	AppleRunPDVLayPath = hiCreateFileSelectorField(
        ?name 'AppleRunPDVLayPath2
        ?prompt AppleRunPDVLayPathName 
        ?defValue "" 
		?enabled nil
		?editable nil
        )
	AppleRunPDVLayPath->hiFileDialogCaption = "Select GDS layout file"
	AppleRunPDVLayPath->hiFileDialogMode = 'existingFile
	AppleRunPDVLayPath->hiFileDialogFilter = "GDS (*.gds);;All Files (*)"
	AppleRunPDVLayPath->hiFileDialogWorkingDir = runDirectory

	AppleRunPDVSchLibraryName  = hiCreateStringField(
        ?name 'AppleRunPDVSchLibraryName2
        ?prompt "Library "
        ?defValue libraryName
		?editable nil
        ?callback strcat("AppleUpdateCommandLine(AppleRunPDVForm2)")
	)
	AppleRunPDVSchCellName  = hiCreateStringField(
        ?name 'AppleRunPDVSchCellName2
        ?prompt "Cell"
        ?defValue cellName
		?editable nil
        ?callback strcat("AppleUpdateCommandLine(AppleRunPDVForm2)")
	)
	AppleRunPDVSchViewName  = hiCreateStringField(
        ?name 'AppleRunPDVSchViewName2
        ?prompt "View"
        ?defValue SchViewName 
        ?editable nil
        ?callback strcat("AppleUpdateCommandLine(AppleRunPDVForm2)")
	)

	AppleRunPDVSchPathOpt = hiCreateBooleanButton(
        ?buttonText "Use cdl"
        ?name   'AppleRunPDVSchPathOpt2
		?buttonLocation 'left
        ?defValue nil
        ?callback strcat("AppleRunPDVSchPathOptCallback2(AppleRunPDVForm2" uq ")")
        ?enabled nil 
	)

	AppleRunPDVSchPath = hiCreateFileSelectorField(
        ?name 'AppleRunPDVSchPath2
        ?prompt AppleRunPDVSchPathName
        ?defValue ""
        ?editable nil
        ?enabled nil
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
	)
	AppleRunPDVSchPath->hiFileDialogCaption = "Select CDL File Name"
	AppleRunPDVSchPath->hiFileDialogMode = 'existingFile
	AppleRunPDVSchPath->hiFileDialogFilter = "CDL (*.cdl);;All Files (*)"
	AppleRunPDVSchPath->hiFileDialogWorkingDir = runDirectory

	AppleRunPDVReportFile = hiCreateFileSelectorField(
        ?name 'AppleRunPDVReportFile2
        ?prompt AppleRunPDVReportFileName
        ?defValue runDirectory
        )
	AppleRunPDVReportFile->hiFileDialogCaption = "Select a Report file"
	AppleRunPDVReportFile->hiFileDialogMode = 'existingFile
	AppleRunPDVReportFile->hiFileDialogFilter = "Summary (*.sum);;All Files (*)"
	AppleRunPDVReportFile->hiFileDialogWorkingDir = runDirectory

	AppleRunPDVReportFileViewBtn = hiCreateFormButton(
    ?name 'AppleRunPDVReportFileViewBtn2
    ?buttonText "View Report"
    ?callback strcat("AppleRunPDVSOpenFile2(optForm" uq ")")
    )

	AppleRunPDVScoreFileViewBtn = hiCreateFormButton(
    ?name 'AppleRunPDVScoreFileViewBtn2
    ?buttonText "View DFM Score"
    ?callback strcat("AppleRunPDVDFMScoreOpenFile2(optForm" uq ")")
    )


	AppleRunPDVReportFileViewExtBtn = hiCreateFormButton(
    ?name 'AppleRunPDVReportFileViewExtBtn2
    ?buttonText "View Extraction Report"
    ?callback strcat("AppleRunPDVSOpenFileExt2(optForm AppleRunPDVForm2" uq ")")
    )

	AppleRunPDVReportFileViewLogBtn = hiCreateFormButton(
    ?name 'AppleRunPDVReportFileViewLogBtn2
    ?buttonText "View Log"
    ?callback "AppleRunPDVSOpenFileViewLog2(AppleOptsForm)"
    )

	AppleRunPDVHcellFile = hiCreateFileSelectorField(
        ?name 'AppleRunPDVHcellFile2
        ?prompt AppleRunPDVHcellFileName
;        ?defValue AppleRunPDVHcellFile
        ?defValue ""
		?editable nil
		?enabled nil
        )

	AppleRunPDVHcellFileViewBtn = hiCreateFormButton(
    	?name 'AppleRunPDVHcellFileViewBtn2
    	?buttonText "View"
    	;?callback strcat("AppleOpenFile2(AppleRunPDVForm2" uq "optForm->AppleRunPDVHcellFile2->value \"r\" AppleRunPDVForm2" uq "->editor_list->value)")
    	?callback strcat("AppleOpenFile2(optForm->AppleRunPDVHcellFile2->value " "\"r\" " "optForm->editor_list2->value)" )
    	?enabled nil
    	)

	AppleRunPDVLVSExcludeCells  = hiCreateStringField(
        ?name 'AppleRunPDVLVSExcludeCells2
        ?prompt "LVS Exclude Cells" 
        ?defValue "" 
		?editable nil
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )
	AppleRunPDVLVSPower  = hiCreateStringField(
        ?name 'AppleRunPDVLVSPower2
        ?prompt "LVS Power "
        ?defValue ""
		?editable nil
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )
	AppleRunPDVLVSGround  = hiCreateStringField(
        ?name 'AppleRunPDVLVSGround2
        ?prompt "LVS Ground"
        ?defValue ""
		?editable nil
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )
	AppleRunLVSFXOption =  hiCreateBooleanButton(
        ?buttonText "LVS detailed analysis option"
        ?name   'AppleRunLVSFXOption2
		?buttonLocation 'left
        ?defValue nil
        ?enabled t
       )
	AppleRunPDVResultsFile = hiCreateFileSelectorField(
        ?name 'AppleRunPDVResultsFile2
        ?prompt "RVE Results File" 
       ; ?defValue runDirectory
		?defValue ""
		?editable t 
        )

	AppleRunPDVMaxErrors  = hiCreateStringField(
        ?name 'AppleRunPDVMaxErrors2
        ?prompt "Max Errors per Check"
        ?defValue ""
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )

	AppleRunPDVNumProc  = hiCreateStringField(
        ?name 'AppleRunPDVNumProc2
        ?prompt "Num Processors"
        ?defValue "4"
		;?callback strcat("AppleRunPDVNumProcCallback2(optForm)")
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )
	AppleRunPDVRunFlat =  hiCreateBooleanButton(
        ?buttonText "Flat"
        ?name   'AppleRunPDVRunFlat2
		?buttonLocation 'left
        ?defValue nil 
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
       )
	AppleRunPDVQueue  = hiCreateStringField(
        ?name 'AppleRunPDVQueue2
        ?prompt "Queue"
        ?defValue "NA"
		?editable nil
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )

	AppleRunPDVOtherOpt =  hiCreateStringField(
        ?name 'AppleRunPDVOtherOpt2
        ?prompt "Other Options"
        ?defValue ""
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )

	AppleAPSUBOtherOpt =  hiCreateStringField(
        ?name 'AppleAPSUBOtherOpt2
        ?prompt "Queue options"
        ?defValue ""    
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )

	AppleRunPDVVirtualConnColon =  hiCreateBooleanButton(
        ?buttonText "Virtual Connect Colon"
        ?name   'AppleRunPDVVirtualConnColon2
		?buttonLocation 'left
        ?defValue nil 
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
       )

	AppleRunPDVVirtualConnName  = hiCreateStringField(
        ?name 'AppleRunPDVVirtualConnName2
        ?prompt "Virtual Connect By Name"
        ?defValue ""
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        )

	appDpColoredGdsOut =  hiCreateBooleanButton(
        ?buttonText "Create Decomposed GDS"
        ?name   'appDpColoredGdsOut2
        ?defValue nil 
        ?invisible t 
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
       )

	appleRunPDVBAGds = hiCreateFormButton(
    	?name 'appleRunPDVBAGds2
    	?buttonText "BA GDS Data"
    	?callback strcat("appleRunPDVBAGdsCallback2(AppleRunPDVForm2" uq ")")
    	?invisible t
    	)

	appleRunPDVMapAllColorsToLock =  hiCreateBooleanButton(
        ?buttonText "Map All Colors to Lock"
        ?name   'appleRunPDVMapAllColorsToLock2
        ?defValue nil
        ?enabled t
        ?callback strcat("appleRunPDVMapAllColorsToLockCallback2(AppleRunPDVForm2" uq ")")
		?invisible t
       )

	applRunPDVLockAllBAData =  hiCreateBooleanButton(
        ?buttonText "Lock All BA Data"
        ?name   'applRunPDVLockAllBAData2
        ?defValue nil
        ?enabled t
		?invisible t
       )

	applRunPDVGenBAData =  hiCreateBooleanButton(
        ?buttonText "Generate BA Data"
        ?name   'applRunPDVGenBAData2
        ?defValue nil
        ?enabled t
        ?callback strcat("AppleRunPDVRunChoicesCallback_12(AppleRunPDVForm2" uq ")")
		?invisible t
       )

	appDpColoredView =  hiCreateBooleanButton(
        ?buttonText "Generate Decomposed Layout"
        ?name   'appDpColoredView2
        ?defValue nil 
        ?invisible t 
       )

;	AppleRunPDVDfm_guideline =  hiCreateBooleanButton(
;        ?buttonText "drc dfm guideline"
;        ?name   'AppleRunPDVDfm_guideline2
;		?buttonLocation 'left
;        ?defValue nil 
;        ?invisible nil
;       )

	AppleRunPDVChecker =  hiCreateBooleanButton(
        ?buttonText "Run checker"
		?buttonLocation 'left
        ?name   'AppleRunPDVChecker2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue t
       )

	AppleRunPDVNoWaivers =  hiCreateBooleanButton(
        ?buttonText "Waivers"
		?buttonLocation 'left
        ?name   'AppleRunPDVNoWaivers2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue t 
       )

	AppleRunPDVNoWaiversGds =  hiCreateBooleanButton(
        ?buttonText "GDS Waivers"
		?buttonLocation 'left
        ?name   'AppleRunPDVNoWaiversGds2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue t
       )

	AppleRunPDVNoAutoHcells =  hiCreateBooleanButton(
        ?buttonText "Auto Hcells"
		?buttonLocation 'left
        ?name   'AppleRunPDVNoAutoHcells2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue t
       )

	AppleRunPDVNoAudit =  hiCreateBooleanButton(
        ?buttonText "Audit"
		?buttonLocation 'left
        ?name   'AppleRunPDVNoAudit2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue nil
       )

	AppleRunPDVShort_equiv_nets =  hiCreateBooleanButton(
        ?buttonText "Short Equiv Nodes"
		?buttonLocation 'left
        ?name   'AppleRunPDVShort_equiv_nets2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue nil
       )

	AppleRunPDVOpdcap =  hiCreateBooleanButton(
        ?buttonText "opdcap"
		?buttonLocation 'left
        ?name   'AppleRunPDVOpdcap2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue t
		?invisible t
       )

	AppleRunPDVRelease_lay =  hiCreateBooleanButton(
        ?buttonText "release_lay"
        ?name   'AppleRunPDVRelease_lay2
		?buttonLocation 'left
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue t 
       )

	AppleRunPDVMegacell =  hiCreateBooleanButton(
        ?buttonText "megacell"
        ?name   'AppleRunPDVMegacell2
		?buttonLocation 'left
        ;?defValue 	equal(libraryName cellName)
		?defValue nil
        ?callback strcat("AppleRunPDVRunChoicesCallback_12( AppleRunPDVForm2" uq ")")
       )

	AppleRunPDVNo_ip_tighten =  hiCreateBooleanButton(
        ?buttonText "ip_tighten"
		?buttonLocation 'left
        ?name   'AppleRunPDVNo_ip_tighten2
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue t
       )

	AppleRunPDVStartRVEBtn = hiCreateFormButton(
    ?name 'AppleRunPDVStartRVEBtn2
    ?buttonText "Start RVE"
    ?callback strcat("AppleRunPDVcalibre_start_rve_with_data_new2(AppleRunPDVForm2" uq ")")
    )
	AppleGenPDVWaiverBtn = hiCreateFormButton(
    ?name 'AppleGenPDVWaiverBtn2
    ?buttonText "Export waivers"
    ?enabled nil
     ?callback strcat("AppleGenPDVwaiver_with_data2(AppleRunPDVForm2" uq ")")
    )
	AppleGenPDFBtn = hiCreateFormButton(
    ?name 'AppleGenPDFBtn2
    ?buttonText "Generate PDF"
    ?callback strcat("AppleGenPDF_with_data2(AppleRunPDVForm2" uq ")")
    )
	AppleGenPDFWithSnapBtn = hiCreateFormButton(
    ?name 'AppleGenPDFWithSnapBtn2
    ?buttonText "PDF (w/Layout)"
    ?callback strcat("AppleGenPDFWithSnap_with_data2(AppleRunPDVForm2" uq ")")
    )

	AppleGdsWaiver =  hiCreateCyclicField(
        ?name   'AppleGdsWaiver2
		?choices '("None" "New" "Incremental" "None(cell-based)")
		?prompt "RVE report file for waiver flow "
		?callback strcat("AppleSetPDVwaiverActive_with_data2(AppleRunPDVForm2" uq ")")
	)

	editor_list=hiCreateCyclicField(
		?name	'editor_list2
		?choices	list("gvim" "nedit")
		?prompt	"Editor"
	)

	AppleRunPDVExtraCmdOpts = hiCreateStringField(
		?name	'AppleRunPDVExtraCmdOpts2
		?prompt	"MIE Extra Options"
		?editable nil
	)

	AppleRunPDVRunPDVcmd  = hiCreateStringField(
        ?name 'AppleRunPDVRunPDVcmd2
        ?prompt "RunPDV Command"
        ?defValue ""
		?editable nil
	)

	AppleRunPDVRunPDVcmdBtn = hiCreateFormButton(
    	?name 'AppleRunPDVRunPDVcmdBtn2
    	?buttonText "Review"
    	?callback strcat("AppleRunPDVShowMeCommand_wrap2(AppleRunPDVEnableAll2" uq " debug)")
    )

	AppleRunPDVStopBtn = hiCreateFormButton(
    	?name 'AppleRunPDVStopBtn2
    	?buttonText "STOP"
    	?callback strcat("AppleRunPDVStopCallback2(AppleRunPDVForm2" uq ")")
    	?enabled nil
		;?buttonIcon hiLoadIconFile(strcat("/home/csutlieff/skill/icons/PDVGUI_stop2.png") 800 30)
		?buttonIcon hiLoadIconFile(strcat(iconRoot "/PDVGUI_stop.png") 800 30)
    )

	AppleRunPDVStartBtn = hiCreateFormButton(
    	?name 'AppleRunPDVStartBtn2
    	?buttonText "START"
    	?callback strcat("AppleRunPDVFormCB2(optForm AppleRunPDVForm2" uq ")" )
    	?enabled t
		?buttonIcon hiLoadIconFile(strcat(iconRoot "/PDVGUI_start.png") 800 30)
    )

	AppleRunDummyBtn = hiCreateFormButton(
    	?name 'AppleRunDummyBtn
    	?buttonText "N/A"
		?invisible t
    	?enabled nil
    )

	AppleRunPDVStopLabel = hiCreateLabel(
		?name    'AppleRunPDVStopLabel2
		?labelText "Press to STOP ->"
    )

	AppleRunPDVViewRunLog =  hiCreateBooleanButton(
        ?buttonText "View Run Log "
        ?name   'AppleRunPDVViewRunLog2
        ?defValue nil 
		?invisible t 
	)

	AppleRunPDVRunQueue =  hiCreateBooleanButton(
        ?buttonText "Submit to queue"
        ?name   'AppleRunPDVRunQueue2
		?buttonLocation 'left
        ?callback strcat("AppleUpdateCommandLineFromOptForm(optForm AppleRunPDVForm2)")
        ?defValue nil 
       )
	AppleRunPDVFormInitFile = hiCreateStringField(
        ?name 'AppleRunPDVFormInitFile2
        ?prompt "Options file"
		?editable t
        ?defValue AppleRunPDVFormInitFileDef
        )

	AppleRunPDVMegaReleaseVersion = hiCreateStringField(
        ?name 'AppleRunPDVMegaReleaseVersion2
        ?prompt "Mega Release Version"
        ?defValue ""
		?editable nil
        )

	AppleRunPDVSaveOptionsBtn = hiCreateFormButton(
    	?name 'AppleRunPDVSaveOptionsBtn2
    	?buttonText "Save Options"
    	?callback strcat("AppleRunPDVSaveOptionsBtnCallback2(optForm AppleRunPDVForm2" uq ")")
    )

	AppleRunPDVLoadOptionsBtn = hiCreateFormButton(
    	?name 'AppleRunPDVLoadOptionsBtn2
    	?buttonText "Load Options"
    	?callback strcat("AppleRunPDVLoadOptionsBtnCallback2(optForm AppleRunPDVForm2" uq ")")
    )

	AppleRunPDVRefreshOptionsBtn = hiCreateFormButton(
    	?name 'AppleRunPDVRefreshOptionsBtn2
    	?buttonText "Refresh"
    	?callback strcat("AppleRunPDVRefreshOptionsBtnCallback(AppleRunPDVForm2" uq ")")
    )

	AppleRunPDVUseOvdir = hiCreateBooleanButton(
		?buttonText	"Use OvDir"
		?name		'AppleRunPDVUseOvdir2
		?buttonLocation 'left
		?callback	strcat("AppleRunPDVUseOvdirCallback2(optForm AppleRunPDVForm2" uq ")")
		?defValue	nil
	)

	AppleRunPDVFTMode = hiCreateBooleanButton(
		?buttonText	"Use Flowtracer"
		?name		'AppleRunPDVFTMode
		?buttonLocation 'left
		?defValue	nil
	)
	ovdirPath = strcat(project_dir "/cad/ovdir")

	AppleRunPDVOvdirPath  = hiCreateFileSelectorField(
        ?name 'AppleRunPDVOvdirPath2
        ?prompt "Ovdir Path"
		?mode	'directoryOnly
        ?defValue ovdirPath
		?enabled nil 
        )

/*
AppleRunPDVCalibreVersion = hiCreateStringField(
        ?name 'AppleRunPDVCalibreVersion2
        ?prompt "Calibre Version"
        ?defValue "" 
        ?editable nil
        )

AppleRunPDVRuledeckVersion = hiCreateStringField(
        ?name 'AppleRunPDVRuledeckVersion2
        ?prompt "Ruledeck Version"
        ?defValue "" 
        ?editable nil
        )
*/
;; Get the project-specific modes
	when(!boundp('GlobalPDVModes) || !boundp('GlobalPDVButtons)
  		GlobalPDVModes = AppleRunPDVGetPDVModesFromPDVConfigNew2()
  		GlobalPDVButtons = cadr(GlobalPDVModes)
  		GlobalPDVModes = car(GlobalPDVModes)
  		;; check if GlobalPDVModes is a blank string, if so force an error
  		;; and ask the user to try again
  		when(blankstrp(GlobalPDVModes)
    		GlobalPDVModes = 'unbound
    		error("%s: PDV modes were not obtained correctly, please try again.\n"
      		getCallingFunction())
  			); when
		);when
	lines = (parseString GlobalPDVModes " ")
	mode_list=list()
	mode_list_value=list()
	mode_list_callback=list(strcat("AppleRunPDVRunChoicesCallback_42( AppleRunPDVForm2" uq ")"))

	foreach(key lines
  	mode_name=sprintf(nil "mode_%s" key)
  	mode_name_tmp = concat(mode_name)
  	mode_list=append(mode_list list(list(mode_name_tmp key)))
	if(key == "DRC" then
		mode_list_value = append1(mode_list_value t)
	else 
		mode_list_value = append1(mode_list_value nil)
	)
)

AppleRunPDVModes = hiCreateToggleField(
    ?name 'AppleRunPDVModes2
    ?choices mode_list
    ?value mode_list_value 
    ?itemsPerRow min(8 length(mode_list))
    ?callback mode_list_callback 
)

;; Main Form

	project = strcat("checks for " project)
	runPDVTopFrame = hiCreateFormLayout(
		'runPDVMainForm2
		?frame "Run PDV"
		?horiz_align 'left
		?items list(
				hiCreateGridLayout('checks
				?frame project
				?items list(
	  				list(AppleRunPDVAll 				'row 0 'col 0 'vert_align 'top)					
					list(AppleRunPDVModes 				'row 0 'col 1)
					list(AppleRunPDVNone				'row 0 'col 2 'vert_align 'top)
					list(AppleRunPDVPost				'row 2 'col 0)
					list(AppleRunPDVAllMode				'row 2 'col 1)				
					list(AppleRunPDVPERCMode			'row 2 'col 2)
					list(AppleRunPDVLef					'row 2 'col 3)
					);list
				);hiCreateGridLayout
				hiCreateGridLayout('inputrunlayOptions
				?frame "layout"
				?items list(
					list(AppleRunPDVLayLibraryName 		'horiz_align 'left	'row 0 'col 0)
					list(AppleRunPDVLayCellName 		'horiz_align 'left	'row 0 'col 1)
					list(AppleRunPDVLayViewName  		'horiz_align 'left	'row 0 'col 2)
					list(AppleRunPdvLayoutViewSelect	'horiz_align 'right	'row 0 'col 3)
					list(AppleRunPDVLayPathOpt 			'horiz_align 'left	'row 1 'col 0)
					list(AppleRunPDVLayPath 			'horiz_align 'left	'row 1 'col 1 'col_span 3)
					list('col_min_width 0 180)
					list('col_min_width 1 180)
					list('col_min_width 2 180)
					);list
				);hiCreateGridLayout
				hiCreateGridLayout('inputrunSchOptions
				?frame "schematic"
				?items list(
					list(AppleRunPDVSchLibraryName	'horiz_align 'left 'row 0 'col 0)
	  				list(AppleRunPDVSchCellName		'horiz_align 'left 'row 0 'col 1)
	  				list(AppleRunPDVSchViewName	 	'horiz_align 'left 'row 0 'col 2)	
					list(AppleRunPdvSchViewSelect	'horiz_align 'left 'row 0 'col 3)	
					list(AppleRunPDVSchPathOpt		'horiz_align 'left 'row 1 'col 0)
	  				list(AppleRunPDVSchPath			'horiz_align 'left 'row 1 'col 1 'col_span 3)		
					list('col_min_width 0 180)
					list('col_min_width 1 180)
					list('col_min_width 2 180)
					);list
				);hiCreateGridLayout
				hiCreateGridLayout('inputDataOptions
				?frame "options"
				?items list(
					list(AppleRunPDVUseOvdir 		'horiz_align 'left 'row 0 'col 0)
					list(AppleRunPDVOvdirPath 		'horiz_align 'left 'row 0 'col 1 'col_span 5)
					list(AppleRunPDVExtraCmdOpts	'horiz_align 'left 'row 1 'col 0 'col_span 5)
					list(AppleRunPDVOtherOpt		'horiz_align 'right 'row 2 'col 0 'col_span 5)
					list(AppleRunPDVFormInitFile	'horiz_align 'left 'row 3 'col 0 'col_span 5)
					list(AppleRunPDVLoadOptionsBtn	'horiz_align 'left 'row 4 'col 0)
					list(AppleRunPDVOptions 		'horiz_align 'left 'row 4 'col 1 'col_span 2)      
					list(AppleRunPDVSaveOptionsBtn	'horiz_align 'left 'row 4 'col 4)
					list('col_min_width 0 180)
					list('col_min_width 1 180)
					list('col_min_width 2 180)
					;list('col_min_width 3 180)
					);list
				);hiCreateGridLayout
				hiCreateGridLayout('runButtons
				?items list(				
					;list(AppleRunDummyBtn		'horiz_align 'left 'row 0 'col 0  )
	 				list(AppleRunPDVStartBtn 	'horiz_align 'left 'row 0 'col 0  )
					list(AppleRunPDVStopBtn		'horiz_align 'right 'row 0 'col 4 )			
					list(AppleRunPDVFTMode		'horiz_align 'right 'row 0 'col 5)
					;list('col_min_width 1 380)
					);list
				);hiCreateGridLayout
				hiCreateGridLayout('RVEButtons
				?frame "RVE"
				?items list(
					list(AppleRunPDVStartRVEBtn				'horiz_align 'left 'row 0 'col 0)
					list(AppleGenPDVWaiverBtn				'horiz_align 'left 'row 0 'col 1)					
					list(AppleGenPDFBtn						'horiz_align 'left 'row 0 'col 2)
					list(AppleGenPDFWithSnapBtn				'horiz_align 'left 'row 0 'col 3)	
	  				list(AppleGdsWaiver						'horiz_align 'left 'row 1 'col 0)
					list(AppleRunPDVReportFileViewLogBtn 	'horiz_align 'left 'row 1 'col 3)
					);list
				);hiCreateGridLayout
				list(AppleRunPDVRunPDVcmd)	
		);list
	);hiCreateFormLayout

	AppleRunPDVForm2 = hiCreateLayoutForm(
		concat('AppleRunPDVForm2 uq)
		formName
		runPDVTopFrame
		?sizePolicy 'expanding
		?minSize list(600 500)
		?buttonLayout 'OKCancelDef
		)

  ;; The below sets AppleRunPDVForm2->button->invisible=nil for each button
  (when (boundp 'GlobalPDVButtons)
    (foreach button (mapcar 'stringToSymbol GlobalPDVButtons)
	     (if (get AppleRunPDVForm2 button)
		 (putprop (get AppleRunPDVForm2 button) nil 'invisible))))

	AppleOptsForm = AppleOptsForm(AppleRunPDVForm2)
	AppleRunPDVForm2->AppleRunPDVExtraCmdOpts2->value = AppleRunPDVGetExtraCmdOptions2() || ""	
	hiEnqueueCmd("AppleRunPDVWorkspaceCB2(AppleOptsForm)")
	;Call the main form
	activewin = concat('AppleRunPDVForm2 uq)
	hiDisplayForm(activewin)
	putprop(activewin 'AppleRunPDVFormHelpCB2 'hiHelpAction)
	;Update the display of the "RunPDV Command" field
	AppleRunPDVShowMeCommand_wrap2(AppleRunPDVForm2 nil)
	; Load tooltips
	AppleAPDVGUI2Help(AppleRunPDVForm2)
	AppleAPDVGUI2OptionsHelp(AppleOptsForm)
	;Load the options defined in the users home directory
	AppleRunPDVLoadOptionsBtnCallback2(AppleOptsForm AppleRunPDVForm2)
); let
); procedure RunPDV_GUI2

procedure(AppleRunPDVFormHelpCB2(@rest _args)
  let( (helpPage)
    helpPage = "https://seg-confluence.csg.apple.com/display/CAD/New+RunPDV+GUI"
    printf("Attempting to open help page for RunPDV GUI: %s\n" helpPage)
    system(sprintf(nil "firefox --new-tab %s &" helpPage))
    t
  ); let
); procedure AppleRunPDVFormHelpCB2

;procedure(AppleRunPDVNameCB2(  @key (form hiGetCurrentForm()) (lib "") (cell "")  "rtt"  )
;  lib = blankstrp(lib) && form->AppleRunPDVLayLibraryName2->value
;  cell = blankstrp(cell) && form->AppleRunPDVLayCellName2->value
;  form->AppleRunPDVMegacell2->value = (lib==cell)
;); procedure AppleRunPDVNameCB2

procedure(AppleRunPDVWorkspaceCB2(form @optional (event 'done))
  let( (field)
	unless(hiIsForm(form) form = hiGetCurrentForm())
    field = 'AppleRunPDVWorkspace2
    when(event=='done
		unless(blankstrp(getq(get(form field) value))
			putpropq(get(form field)
			car(last(parseString(getq(get(form field) value) "/"))) value
			)
	if(pcreExecute(pcreCompile("A0_Release") getq(get(form field) value))
	then
	  ;; mark this field as an error
		if(!boundp('AppleRunPDVWSErrorAlreadySeen) then AppleRunPDVWSErrorAlreadySeen = nil)
 			hiHighlightField(form 'AppleRunPDVWorkspace2 hicError)
	  		;; pop up an error dialog next to the field explaining the issue
			if(AppleRunPDVWSErrorAlreadySeen == nil then
	  			hiDisplayAppDBox(?name 'AppleRunPDVReleaseErr
	    			?dboxBanner	"Release workspace detected"
	    			?dboxText	strcat("A release workspace has been detected,\n"
			  		"please consider using the release_lay GUI instead.\nThis form will not be displayed again")
	    			?dialogType	hicErrorDialog
	    			?dialogStyle 'modal
	    			?buttonLayout 'Close
	    			?location	mapcar('plus hiGetFormLocation(form)
				      	'(850 290))
	  				)
				AppleRunPDVWSErrorAlreadySeen = t
				);if
				else
	  				;; restore default field coloring
	  				hiHighlightField(form 'AppleRunPDVWorkspace2 hicBackground)
				); if
      ); unless
    ); when
  ); let
); procedure AppleRunPDVWorkspaceCB2

procedure(RunPDBV2SelectAll2( mainForm)
	;; Turns on all the checkboxes in the AppleRunPDVModes (at top of form)
	let((mode_list_value )
    	mode_list_value = list()	
    	foreach(key mainForm->AppleRunPDVModes2->_toggleItems
      		mode_list_value = append1(mode_list_value t)
    	)
    mainForm->AppleRunPDVModes2->value = mode_list_value	)
	mainForm->AppleRunPDVModes2->enabled= t
	mainForm->AppleRunPDVPost2->value = nil
	mainForm->AppleRunPDVAllMode2->enabled= t
	mainForm->AppleRunPDVAllMode2->value = nil
	AppleUpdateCommandLine( mainForm)
);RunPDBV2SelectAll2

procedure(AppleUpdateCommandLine( mainForm)
	;;Calls the procedure to update the command line field (when a top-level form item is clicked)
	let(()
	;; Do some sanity checking for the form
		AppleDoSanityChecks(mainForm)
		AppleRunPDVShowMeCommand_wrap2(mainForm nil)
	);let
);AppleUpdateCommandLine

procedure(AppleDoSanityChecks(mainForm)
	prog((laylib laycell layview schlib schcell schview)
		;;Check if lib, cell, view exists for layout and schematic
		if(mainForm->AppleRunPDVLayPathOpt2->value == nil then
			;gds not selected. L/C/V should be checked
			laylib = mainForm->AppleRunPDVLayLibraryName2->value
			laycell = mainForm->AppleRunPDVLayCellName2->value
			layview = mainForm->AppleRunPDVLayViewName2->value
			if(!AppleDoesCellExist(laylib laycell layview) then
				AppleItemExistError(laylib laycell layview)
				);if
			);if
		if(mainForm->AppleRunPDVSchPathOpt2->value == nil then
			;cdl not selected. L/C/V should be checked
			if(mainForm->AppleRunPDVSchLibraryName2->editable == t then
				schlib = mainForm->AppleRunPDVSchLibraryName2->value
				schcell = mainForm->AppleRunPDVSchCellName2->value
				schview = mainForm->AppleRunPDVSchViewName2->value
				if(!AppleDoesCellExist(schlib schcell schview) then
					AppleItemExistError(schlib schcell schview)
					);if
				);if
			);if
		return(t)
		);prog
);AppleDoSanityChecks

procedure(AppleItemExistError(lib cell view)
	prog(()
		;show error form
		hiDisplayAppDBox(
	  		?name 'AppleItemExistsError
	  		?dboxBanner "Item not found"
	  		?dboxText strcat("Error: " lib ":" cell ":" view " not found.")
	  		?buttonLayout 'Close
			);		
		return(t)
	);prog
);AppleItemExistError


procedure(AppleDoesCellExist(lib cell view)
	prog(()
		;look for the existence of a cell (lib:cell:view)
		if(!dbOpenCellViewByType(lib cell list(view) nil "r" nil) then
			return(nil)
			else
				return(t)
			);if
	);prog
);AppleDoesCellExist

procedure(AppleUpdateCommandLineFromOptForm(optform form)
	;;Calls the procedure to update the command line field (when an optForm item is clicked) 
	let(()

		AppleRunPDVShowMeCommand_wrap2(form nil)
	);let
);AppleUpdateCommandLineFromOptForm

procedure(RunPDBV2SelectNone2(optform mainForm)
	;Turns off all the checkboxes in the AppleRunPDVModes (at top of form)
	let((mode_list_value )
    	mode_list_value = list()	
    	foreach(key mainForm->AppleRunPDVModes2->_toggleItems
      		mode_list_value = append1(mode_list_value nil)
    	)
    mainForm->AppleRunPDVModes2->value = mode_list_value	)
	mainForm->AppleRunPDVModes2->enabled= t
	mainForm->AppleRunPDVPost2->value = nil
	mainForm->AppleRunPDVAllMode2->enabled= t
	mainForm->AppleRunPDVAllMode2->value = nil
	AppleUpdateCommandLine( mainForm)
);RunPDBV2SelectNone2

procedure(AppleRunPDVRunChoicesCallback_12( theForm)
	let(( runDirectory using_lvs project_home mode_arg
    	cellName diskPath NewrunDirectory i mode_list_items mode_list_value
    	mode_list_value_new runpdv_mode runpdv_mode_item)
  	cellName = theForm->AppleRunPDVLayCellName2->value
    mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
    mode_list_value=theForm->AppleRunPDVModes2->value
	;; all boxes 
    mode_list_value_new = list()	
    foreach(key theForm->AppleRunPDVModes2->_toggleItems
		mode_list_value_new = append1(mode_list_value_new nil)
	);foreach

    theForm->AppleRunPDVModes2->value = mode_list_value_new
	if(theForm->AppleRunPDVAllMode2->value == nil then
		; user has turned off "all mode".
		theForm->AppleRunPDVPost2->enabled = t
		); if	
	if(theForm->AppleRunPDVPERCMode2->value == t then
		; user has turned on "perc mode".
		;
   	 	mode_list_value_new = list()	
    	foreach(key theForm->AppleRunPDVModes2->_toggleItems
			if(rexMatchp("mode_PERCTP" symbolToString(key)) then
				mode_list_value_new = append1(mode_list_value_new t)
				else		
					if(rexMatchp("mode_PERCCD" symbolToString(key)) then
						mode_list_value_new = append1(mode_list_value_new t)
						else
							if(rexMatchp("mode_PERCP2P" symbolToString(key)) then
								mode_list_value_new = append1(mode_list_value_new t)
								else	
									mode_list_value_new = append1(mode_list_value_new nil)
									);
							);			
				);if
			);foreach
   		 theForm->AppleRunPDVModes2->value = mode_list_value_new
		); if
  if(theForm->AppleRunPDVAllMode2->value == t || theForm->AppleRunPDVLef2->value == t || theForm->AppleRunPDVPost2->value == t then
    ;; not used workspace_dir = car(last(parseString(getWorkingDir() "/")))
    diskPath = getShellEnvVar("ECS_DISK_PATH")
    runDirectory=  strcat(diskPath "/PDV/" cellName "/drc")
	if(theForm->AppleRunPDVAllMode2->value == t then 
		theForm->AppleRunPDVPost2->value = nil
		theForm->AppleRunPDVPost2->enabled = nil
	 	else
			theForm->AppleRunPDVPost2->enabled = t
			if(theForm->AppleRunPDVPost2->value == t then 
				theForm->AppleRunPDVAllMode2->value = nil
			);if
		);if
    theForm->AppleRunPDVModes2->value = mode_list_value_new
    theForm->AppleRunPDVModes2->enabled= nil

    AppleOptsForm->AppleRunPDVChecker2->value = t
    AppleOptsForm->AppleRunPDVNoAudit2->value = t

    theForm->AppleRunPDVSchLibraryName2->editable = t
    theForm->AppleRunPDVSchCellName2->editable = t
    theForm->AppleRunPDVSchViewName2->editable = t
    theForm->AppleRunPDVSchPath2->editable = nil
    theForm->AppleRunPDVSchPath2->enabled = nil
    theForm->AppleRunPDVSchPathOpt2->enabled= t
	theForm->AppleRunPDVSchPath2->hiFileDialogCaption = "Select CDL File Name"
	theForm->AppleRunPDVSchPath2->hiFileDialogMode = 'existingFile
	theForm->AppleRunPDVSchPath2->hiFileDialogFilter = "CDL (*.cdl);;All Files (*)"
	theForm->AppleRunPDVSchPath2->hiFileDialogWorkingDir = runDirectory

    AppleOptsForm->AppleRunPDVHcellFile2->editable = t
    AppleOptsForm->AppleRunPDVHcellFile2->enabled = t
    AppleOptsForm->AppleRunPDVHcellFileViewBtn2->enabled = t
    AppleOptsForm->AppleRunPDVLVSExcludeCells2->editable = t
    AppleOptsForm->AppleRunPDVLVSPower2->editable = t
    AppleOptsForm->AppleRunPDVLVSGround2->editable = t
    AppleOptsForm->AppleRunPDVReportFileViewExtBtn2->enabled = t

    AppleOptsForm->AppleRunPDVRelease_lay2->value = t
    AppleOptsForm->AppleRunPDVMaxErrors2->value = ""
    AppleOptsForm->AppleRunPDVOpdcap2->value = nil
    AppleOptsForm->AppleRunPDVNoWaivers2->value = nil
    AppleOptsForm->AppleRunPDVNoWaiversGds2->value = t
    AppleOptsForm->AppleRunPDVNoAutoHcells2->value = t
	else
		theForm->AppleRunPDVModes2->enabled= t
    	AppleOptsForm->AppleRunPDVHcellFileViewBtn2->enabled = nil
    	AppleOptsForm->AppleRunPDVHcellFileViewBtn2->enabled = nil
    	AppleOptsForm->AppleRunPDVLVSExcludeCells2->editable = nil
    	AppleOptsForm->AppleRunPDVLVSPower2->editable = nil
    	AppleOptsForm->AppleRunPDVLVSGround2->editable = nil
  ) ;; if any of ALL,LEF,POST are TRUE

	using_lvs = "no"
	mode_list_value_new = list()
	foreach(key theForm->AppleRunPDVModes2->_toggleItems
		if(rexMatchp("mode_LVS" symbolToString(key)) then
			using_lvs = "yes"
			);if
		);foreach

;; Handle LVS related operations here
;; 
if(theForm->AppleRunPDVAll2->value == nil || theForm->AppleRunPDVLef2->value == nil ||  theForm->AppleRunPDVPost2->value == nil then
    if(rexMatchp("yes" using_lvs) then
	      cellName = theForm->AppleRunPDVLayCellName2->value
	      project_home = getShellEnvVar("PROJECT_HOME")
      unless(project_home project_home = getShellEnvVar("PROJECT_DIR"))
      diskPath = getShellEnvVar("ECS_DISK_PATH")
      runDirectory= strcat(diskPath "/PDV/" cellName )

      if(theForm->AppleRunPDVSchPathOpt2->value == t then
	theForm->AppleRunPDVSchLibraryName2->editable = nil
	theForm->AppleRunPDVSchPath2->editable = t
	theForm->AppleRunPDVSchPath2->enabled = t
	theForm->AppleRunPDVSchPath2->value=strcat( runDirectory "/netlists/" theForm->AppleRunPDVSchCellName2->value ".cdl")
      else
	theForm->AppleRunPDVSchLibraryName2->editable = t
	theForm->AppleRunPDVSchPath2->editable = nil
	theForm->AppleRunPDVSchPath2->enabled = nil
	theForm->AppleRunPDVSchPath2->value=""
      )
    )
    if(AppleOptsForm->AppleRunPDVMegacell2->value == t then
		AppleOptsForm->AppleRunPDVChecker2->value = t
		);if

  ) ;; if ALL,LEF,POST is FALSE
  if(theForm->AppleRunPDVLef2->value == t then
    ;; not used workspace_dir = car(last(parseString(getWorkingDir() "/")))
    diskPath = getShellEnvVar("ECS_DISK_PATH")
    runDirectory=  strcat(diskPath "/PDV/" cellName "/lef")

    ;AppleOptsForm->AppleRunPDVDfm_guideline2->value = nil
    AppleOptsForm->appDpColoredView2->value = nil
    AppleOptsForm->appDpColoredGdsOut2->value = nil

    AppleOptsForm->AppleRunPDVChecker2->value = t
    AppleOptsForm->AppleRunPDVNoAudit2->value = t

    mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
    mode_list_value=theForm->AppleRunPDVModes2->value
    mode_list_value_new = list()
    foreach(key theForm->AppleRunPDVModes2->_toggleItems
      mode_list_value_new = append1(mode_list_value_new t)
    )
    theForm->AppleRunPDVModes2->value = mode_list_value_new

    theForm->AppleRunPDVSchLibraryName2->editable = nil 
    theForm->AppleRunPDVSchCellName2->editable = nil 
    theForm->AppleRunPDVSchViewName2->editable = nil
    theForm->AppleRunPDVSchPath2->editable = nil
    theForm->AppleRunPDVSchPath2->enabled = nil
    theForm->AppleRunPDVSchPathOpt2->enabled= nil 

    AppleOptsForm->AppleRunPDVHcellFile2->editable = nil 
    AppleOptsForm->AppleRunPDVHcellFile2->enabled = nil 
    AppleOptsForm->AppleRunPDVHcellFileViewBtn2->enabled = nil 
    AppleOptsForm->AppleRunPDVLVSExcludeCells2->editable = nil 
    AppleOptsForm->AppleRunPDVLVSPower2->editable =  nil
    AppleOptsForm->AppleRunPDVLVSGround2->editable = nil 
    AppleOptsForm->AppleRunPDVReportFileViewExtBtn2->enabled = nil 
   	AppleOptsForm->AppleRunPDVMegaReleaseVersion2->editable = t
    AppleOptsForm->AppleRunPDVChecker2->value = t
    AppleOptsForm->AppleRunPDVNoAudit2->value = t
    AppleOptsForm->AppleRunPDVMegacell2->value = nil
    AppleOptsForm->AppleRunPDVRelease_lay2->value = nil
    AppleOptsForm->AppleRunPDVMaxErrors2->value = ""
    AppleOptsForm->AppleRunPDVOpdcap2->value = nil
    AppleOptsForm->AppleRunPDVNoWaivers2->value = t
    AppleOptsForm->AppleRunPDVNoWaiversGds2->value = t
    AppleOptsForm->AppleRunPDVNoAutoHcells2->value = t

  ) ;; IF LEF IS TRUE

;  if(theForm->AppleRunPDVLef->value == nil then
;    theForm->AppleRunPDVMegaReleaseVersion->editable = nil 
 ; ) ;; IF LEF IS FALSE
  project_home = getShellEnvVar("PROJECT_HOME")
  if( project_home == nil then project_home = getShellEnvVar("PROJECT_DIR") )

  ;; not used workspace_dir = car(last(parseString(getWorkingDir() "/")))
  diskPath = getShellEnvVar("ECS_DISK_PATH")
  runDirectory=  strcat(diskPath "/PDV/" cellName "/drc")
  cellName = theForm->AppleRunPDVLayCellName2->value
  NewrunDirectory=  strcat(diskPath "/PDV/" cellName "/")
  mode_arg = "drc"
  mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
  mode_list_value=theForm->AppleRunPDVModes2->value
  i=0
  foreach(key theForm->AppleRunPDVModes2->_toggleItems
    if(nth(i mode_list_value) == t then
      runpdv_mode_item =  symbolToString(nth(i mode_list_items))
      runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
      mode_arg = runpdv_mode
    )
    i++
  )
	;printf("\nSetting ReportFile %s" NewrunDirectory)
	AppleOptsForm->AppleRunPDVReportFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
	AppleOptsForm->AppleRunPDVResultsFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
	;  theForm->AppleRunPDVRunDirectory->value = strcat( NewrunDirectory "/" lowerCase(mode_arg))
	AppleUpdateCommandLine( theForm)
	;;Commenting out for the moment. Not clear what this is doing	AppleRunPDVRunChoicesCallback_32(theForm)
	); let
) ;; procedure AppleRunPDVRunChoicesCallback_12  

procedure( AppleRunPDVcalibre_start_rve_with_data_new2(theForm)
	let((myLibName myCellName myViewName)
  	printf("\n AppleRunPDVcalibre_start_rve_with_data_new :: %L" theForm)
  	myLibName= theForm->AppleRunPDVLayLibraryName2->value
  	myCellName= theForm->AppleRunPDVLayCellName2->value
  	myViewName= theForm->AppleRunPDVLayViewName2->value
  	printf("\n AppleRunPDVcalibre_start_rve_with_data_new lib:: %s cell:: %s"
    myLibName myCellName)
  	AppleRunPDVrun_calibre_start_rve2(theForm myCellName myLibName myViewName)
	); let
); procedure AppleRunPDVcalibre_start_rve_with_data_new2

;; Main form callbacks

(defun AppleRunPDVGetSelectedModes2 (theForm)
  (let (mode_list_items mode_list_value	runpdv_mode_item runpdv_mode mode_arg i)
    mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
    mode_list_value=theForm->AppleRunPDVModes2->value
    i=0
    (foreach key mode_list_items
	     (when (nth i mode_list_value)==t 
		   runpdv_mode_item =  (symbolToString (nth i mode_list_items))
		   runpdv_mode = (substring runpdv_mode_item 6 (strlen runpdv_mode_item)-4)
		   mode_arg = (tconc mode_arg (lowerCase runpdv_mode)))
	     i++)
    mode_arg = (car mode_arg)
    
    (if theForm->AppleRunPDVLef2->value == t 
	mode_arg ='("lef") )
    (if theForm->AppleRunPDVAll2->value == t
	mode_arg ='("all") )
    (if theForm->AppleRunPDVPost2->value == t 
	mode_arg ='("post") )
    mode_arg))
    ;procedure AppleRunPDVGetSelectedModes2 

(defun AppleGenPDVwaiver_with_data2 (theForm)
  (let ((cellName theForm->AppleRunPDVLayCellName2->value)
        runpdv_mode diskPath NewrunDirectory
        use_rve_file pid data (output "") cmd)
    runpdv_mode = (mapcar 'lowerCase (AppleRunPDVGetSelectedModes2 theForm))
    diskPath = getShellEnvVar("ECS_DISK_PATH")
    NewrunDirectory= strcat(diskPath "/PDV/" cellName)
    use_rve_file = AppleRunPDVGetPDVModesRVEFromPDVModesConfig2(runpdv_mode theForm->AppleGdsWaiver2->value NewrunDirectory)
    (foreach file (parseString use_rve_file)
             cmd=(sprintf nil "pdv_results.pl -gen_waiver %s.waived" file)
             (ipcWait pid=(ipcBeginProcess cmd))
             (rexCompile "Converting.* \\([^ ]+\\.[^\\.]+\\.waived\\.[a-z]+\\) was successful")
             (while data=(ipcReadProcess pid)
                    (if (rexExecute data)
                        output=(strcat output (rexSubstitute "\\1") "\n"))))
    (when output
      (hiDisplayForm (hiCreateAppForm
                      ?name 'AppleGenPDVWaiverDone
                      ?fields (list (hiCreateMLTextField
                                     ?name 'AppleGenPDVWaiverOutputField ?value output ?editable nil))
                      ?buttonLayout 'Close
                      ?formTitle "Created Waiver DBs"))))
);procedure AppleGenPDVwaiver_with_data2

(defun AppleGenPDF_with_data_new2 (theForm with_snap)
  (let ((cellName theForm->AppleRunPDVLayCellName2->value)
	runpdv_mode mode diskPath NewrunDirectory
	use_rve_file pid data newdata cmd suffix rptFile)
	
    runpdv_mode = (mapcar 'lowerCase (AppleRunPDVGetSelectedModes2 theForm))

    diskPath = getShellEnvVar("ECS_DISK_PATH")
    (foreach mode runpdv_mode
	     NewrunDirectory= strcat(diskPath "/PDV/" cellName "/" mode "/html_reports")
	     
	     (if with_snap
		 cmd=(strcat "cd " NewrunDirectory " && unset MGC_CALIBRE_DB_DIR && ./cr8DrcRpt_wpic")
	     ;else
		 cmd=(strcat "cd " NewrunDirectory " && unset MGC_CALIBRE_DB_DIR && ./cr8DrcRpt"))

	     ;; suffix=(case theForm->AppleGdsWaiver->value
	     ;; 	      ("New" ".no_waiver")
	     ;; 	      ("Incremental" ".waived")
	     ;; 	      ("None(cell-based)" ".cell_based")
	     ;; 	      (t ""))

	     ;; cmd=(strcat cmd suffix)
	     suffix=""
	     (ipcWait pid=(ipcBeginProcess cmd))
	     data=""
	     (while newdata=(ipcReadProcess pid)
		    data=(strcat data newdata))
	     rptFile=(strcat NewrunDirectory "/" cellName "_HTML_DRC_dir" (if with_snap "_wpic" "") suffix "/report.pdf")
	     (ipcBatchProcess (strcat "/usr/bin/firefox --new-tab " rptFile) "" "/dev/null"))))

(defun AppleGenPDF_with_data2 (theForm)
  (AppleGenPDF_with_data_new2 theForm nil))

(defun AppleGenPDFWithSnap_with_data2 (theForm)
  (AppleGenPDF_with_data_new2 theForm t))

(defun AppleSetPDVwaiverActive_with_data2 (theForm)
  (if (substring theForm->AppleGdsWaiver2->value 1 4)=="None"
    (hiSetFieldEnabled theForm->AppleGenPDVWaiverBtn2 nil)
    ;else
    (hiSetFieldEnabled theForm->AppleGenPDVWaiverBtn2 t)))

procedure(AppleRunPDVFormCB2(optform theForm )
	prog((cmd_argument libraryName cellName viewname mode_arg RunDir
    	home_dir debug diskPath i statsfile
    	mode_list_items mail_file mail_port thisuser
    	results_file runpdv_mode runpdv_mode_item project_home
    	runDirectoryPDVLog runDirectoryPDVLogOld runDirectoryPDVLogOlder newCV
    	mode_list_value cid command projectname)
	;save the current settings in the users home directory
	AppleRunPDVSaveOptionsBtnCallback2(optform theForm)
	i = 0
	if(theForm->AppleRunPDVFTMode->value == t then
		;; do something
		;Create a Flowtracer Project if it doesn't already exist
		projectname = AppleOptsForm->AppleRunPDVWorkspace2->value
		; FlowTracer doesn't like project names containing the"+" character. Replace with "_"
		exp = rexCompile("[+]")
		projectname = rexReplace(projectname "_" 0)
		setShellEnvVar("VOV_PROJECT_NAME" projectname)
		theForm->AppleRunPDVStartBtn2->enabled=nil
		theForm->AppleRunPDVStopBtn2->enabled=t
		AppleRunPDVFT(theForm)
		return(nil)
	);if
	runDirectoryPDVLogOld = runDirectoryPDVLogOlder = runDirectoryPDVLog=""
 ;; Construct arguments to pass RunPDV script:
	libraryName = theForm->AppleRunPDVLayLibraryName2->value
	cellName = theForm->AppleRunPDVLayCellName2->value
	viewname = theForm->AppleRunPDVLayViewName2->value
	RunDir= optform->AppleRunPDVRunDirectory2->value
	home_dir = getShellEnvVar("HOME")
	project_home = getShellEnvVar("PROJECT_HOME") || getShellEnvVar("PROJECT_DIR")
	mail_file =strcat(home_dir "/RunPDVDebug.mail")
	mail_port = outfile(mail_file "w")
	when(portp(mail_port)
		fprintf(mail_port "\nhome_dir=%s" home_dir)
		fprintf(mail_port "\nlibraryName=%s" libraryName)
		fprintf(mail_port "\ncellName=%s" cellName)
		fprintf(mail_port "\nRunDir=%s" RunDir)
		close(mail_port)
		); when
	mode_arg = "drc"
	mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
	mode_list_value=theForm->AppleRunPDVModes2->value
	foreach(key theForm->AppleRunPDVModes2->_toggleItems
		if(nth(i mode_list_value) == t then
			runpdv_mode_item =  symbolToString(nth(i mode_list_items))
        	;runpdv_mode = substring(runpdv_mode_item 6 length(runpdv_mode_item)-4)
			runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
 			mode_arg = runpdv_mode
  			)
    	i++
		)
	cmd_argument = AppleRunPDVShowMeCommand2(theForm debug)
	if(cmd_argument == nil then return(nil))
	printf("\n\n RunPDV command : %L\n" cmd_argument)
	;; Display the command on the form
	theForm->AppleRunPDVRunPDVcmd2->value = cmd_argument
	if(isDir(RunDir) then
  		printf("\n Found run directory %L" RunDir)
		else
  		printf("\nNot able to find the run directory %L" RunDir) 
		)
	printf("\n\n Launching: %s \n" cmd_argument)
	results_file = strcat(RunDir "/" mode_arg "_all.sum")
	if(isFile(results_file) then
		printf("\nRemoving old results file")
		sh(strcat("rm -rf " results_file))
		)
	diskPath = getShellEnvVar("ECS_DISK_PATH")
	runDirectoryPDVLog=  strcat(diskPath "/PDV/" cellName "/RunPDV.log")
	runDirectoryPDVLogOld=  strcat(diskPath "/PDV/" cellName "/RunPDV.log.old")
	runDirectoryPDVLogOlder=  strcat(diskPath "/PDV/" cellName "/RunPDV.log.older")
	if(isFile(runDirectoryPDVLogOlder) then
		printf("\nRemoving older RunPDV log file")
		sh(strcat("rm -rf " runDirectoryPDVLogOlder ))
		)
	if(isFile(runDirectoryPDVLogOld) then
		printf("\nMoving old RunPDV log file")
		sh(strcat("mv " runDirectoryPDVLogOld " " runDirectoryPDVLogOlder))
		)
	if(isFile(runDirectoryPDVLog) then
		printf("\nMoving RunPDV log file")
		sh(strcat("mv " runDirectoryPDVLog " " runDirectoryPDVLogOld))
		)
	newCV = dbOpenCellViewByType(libraryName cellName viewname "maskLayout" "r" nil)
	if(newCV~>modifiedButNotSaved == t then
		printf("\n Saving the layout before PDV run.")
		dbSave(newCV)
		);; if
	theForm->AppleRunPDVStartBtn2->enabled=nil
	theForm->AppleRunPDVStopBtn2->enabled=t
	RunPDVProcessID=ipcBeginProcess(cmd_argument "" 'AppleRunPDVDataHandler2 nil 'AppleRunPDVExitHandler2)
	;;Update system stats file. Temporary....remove later
	thisuser = getLogin()
	statsfile= strcat(project_home "/cad/ovdir/PDVGUI2/RunPDVGUI2_run_stats.log")
	system(sprintf(nil "echo %s %L  >> %s" thisuser getCurrentTime() statsfile))
	;system(sprintf(nil "echo %s  >> %s" thisuser statsfile))
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	theForm->processId2 = RunPDVProcessID
	;hiSetFormButtonEnabled(theForm 'Apply nil)
	results_file = strcat(RunDir "/" mode_arg "_all.sum")
	if(isFile(results_file) then
		printf("\nFound results file is %s\n" results_file)
		)
	when(isFile(results_file)
		theForm->AppleRunPDVStopBtn2->enabled=nil
		printf("Background RunPDV job done.\n")
		) ;; when
	if(mode_arg == "drc" then
		printf("\nSetting the Report file DRC  %s" strcat(RunDir "/" mode_arg "_all.sum"))       
		AppleOptsForm->AppleRunPDVReportFile2->value=strcat(RunDir "/" mode_arg "_all.sum")
		)
	if(mode_arg == "lvs" then
		printf("\nSetting the Report file LVS %s" strcat(RunDir "/" mode_arg ".rep"))
		AppleOptsForm->AppleRunPDVReportFile2->value=strcat(RunDir "/" mode_arg ".rep")
		)
	if(mode_arg == "iplvs" then
		printf("\nSetting the Report file IPLVS %s" strcat(RunDir "/" mode_arg ".rep"))
		AppleOptsForm->AppleRunPDVReportFile2->value=strcat(RunDir "/" mode_arg ".rep")
		)
;; Email for better debugging
;; system(strcat("mail -s " "\"RunPDV GUI is Launched - " getLogin() " " getCurrentTime() "\" rdeo@apple.com < " mail_file))
	if(theForm->AppleRunPDVLef2->value == t then 
		theForm->AppleRunPDVAll2->value = nil 
		theForm->AppleRunPDVPost2->value = nil 
		)
	if(theForm->AppleRunPDVAll2->value == t then 
		theForm->AppleRunPDVLef2->value = nil 
		theForm->AppleRunPDVPost2->value = nil 
		)
	if(theForm->AppleRunPDVPost2->value == t then 
		theForm->AppleRunPDVAll2->value = nil 
		theForm->AppleRunPDVLef2->value = nil 
		)
	); let
); procedure AppleRunPDVFormCB2

procedure(AppleRunPDVSOpenFile2(optform)
  let((files pathroot)
    ;; use the Report File field to either specify the desired file or
    ;; use it as a starting directory for which to search for *.sum files
    cond(
      (isFile(optform->AppleRunPDVReportFile->value
	files = optform->AppleRunPDVReportFile->value)
      )
      (isDir(optform->AppleRunPDVReportFile->value)
	pathroot = optform->AppleRunPDVReportFile->value
	files = setof(file foreach(mapcar candidate getDirFiles(pathroot)
			      strcat(pathroot "/" candidate))
		      rexMatchp("\\.sum$" file))
      )
    ); cond
    ;; open the file or files in read mode with the editor selected
    AppleOpenFile2(files "r" optform->editor_list2->value)
  ); let
); procedure AppleRunPDVSOpenFile2

procedure(AppleRunPDVDFMScoreOpenFile2(form)
  let((file diskPath NewrunDirectory cellName)
    diskPath = getShellEnvVar("ECS_DISK_PATH")
    cellName = form->AppleRunPDVLayCellName->value
    NewrunDirectory= strcat(diskPath "/PDV/" cellName)
    file = strcat(NewrunDirectory "/dfm/DFM_Score.rep")
    if(!isFile(file) then
      fprintf(errport "\n**ERROR** There is no DFM Score file found %s.\n" file)
    else
      printf("\nViewing the file %s\n" file)
      AppleOpenFile2(file "r" form->editor_list2->value)
    ); if
  ); let
); procedure AppleRunPDVDFMScoreOpenFile2

procedure(AppleRunPDVGetPDVModes2(@optional (form hiGetCurrentForm()))
	;; return a string containing a list of the modes selected
  cond(
    (form->AppleRunPDVAllMode2->value	"all")
    (form->AppleRunPDVPost2->value	"post")
    (form->AppleRunPDVLef2->value	"lef")
    (t
      setof(mode
      	foreach(mapcar item form->AppleRunPDVModes2->_toggleItems
		and(getq(get(getq(form AppleRunPDVModes2) item) value)
	  	lowerCase(substring(item 6))))
		stringp(mode))
    	)
  	); cond
); procedure AppleRunPDVGetPDVModes2

procedure(AppleOpenFile2(file @optional (mode "r") (edittool "gvim") "gtt")
  let( (modeflag (multiflag "") editcmd files)
    cond(
      (listp(file) && forall(entry file stringp(entry)) files = file)
      (stringp(file) && length(parseString(file))>1
	files = setof(f parseString(file) isFile(f)))
      (stringp(file) files = setof(f list(file) isFile(f)))
      (t error(strcat("%s Argument 'file' must be a string, a space separated"
	    " string, or a list of strings\n") getCallingFunction(0)))
    ); cond
    case(edittool
      ("nedit"
	when(length(files)>1 multiflag = "-tabbed")
	modeflag  = case(mode (("r" "R") "-read") (t ""))
      )
      ("gvim"
	when(length(files)>1 multiflag = "-p")
	cond(
	  (mode =="r" || mode == "R"
	    modeflag="-R"
	    edittool = "gview")
	  (t
	    modeflag=""
	    edittool ="gvim"
	  )
	);cond
      )
      (t edittool="gview" modeflag="-R" multiflag=length(files)>1&&"-p"||"")
    ); case
    ;; when files is a non-empty list
    when(dtpr(files)
      sprintf(editcmd "%s %s %s %s &" edittool modeflag multiflag
	buildString(files " "))
      ipcBeginProcess(editcmd)
    ); when
  ); let
); procedure AppleOpenFile2

procedure(AppleRunPDVSOpenFileViewLog2(optForm)
	let((pathroot modes files)
		cond(
			(isDir(optForm->AppleRunPDVReportFile2->value)
				pathroot = optForm->AppleRunPDVReportFile2->value)
			(isDir(optForm->AppleRunPDVRunDirectory2->value)
			pathroot = optForm->AppleRunPDVRunDirectory2->value)
			); cond
		modes = AppleRunPDVGetPDVModes2()
		unless(listp(modes) modes = list(modes))
			files = setof(file foreach(mapcar mode modes
			strcat(pathroot "/RunPDV." upperCase(mode) ".log"))
			if(!isFile(file) then 
				printf("Log file:%s not found" file)
				);if
		);unless
		when(listp(modes) && length(modes)>1 
			when(isFile(strcat(pathroot "/RunPDV.multi.log"))
			files = append(files list(strcat(pathroot "/RunPDV.multi.log")))
			);when
		);when
	AppleOpenFile2(files "r" optForm->editor_list2->value)
	); let
); procedure AppleRunPDVSOpenFileViewLog2

procedure(AppleRunPDVSOpenFileExt2(optform form)
let((pathroot modes mode_arg files)

  modes = AppleRunPDVGetPDVModes2()
  mode_arg = cond(
    (modes=="lef"	"lef")
    (modes=="all"	"drc")
    (modes=="post"	"drc")
    (dtpr(modes)	modes)
    (t			"drc")
  ); cond
  unless(listp(mode_arg) mode_arg = list(mode_arg))
  cond(
    (isFile(optform->AppleRunPDVReportFile2->value)
      files = list(optform->AppleRunPDVReportFile2->value)
    )
    (and(isDir(optform->AppleRunPDVReportFile2->value)
      pathroot = optform->AppleRunPDVReportFile2->value
      files = setof(file foreach(mapcar candidate getDirFiles(pathroot)
		strcat(pathroot "/" candidate))
		rexMatchp("\\.rep\\.ext$" file))
      ); and
    )
    (and(isDir(optform->AppleRunPDVReportFile2->value)
      pathroot = optform->AppleRunPDVReportFile2->value
      files = foreach(mapcan mode mode_arg 
		setof(file foreach(mapcar candidate
		    setof(dir getDirFiles(strcat(pathroot "/" mode)) isDir(dir))
		    strcat(pathroot "/" mode "/" candidate))
		  rexMatchp("\\.rep\\.ext$" file))
	      ); foreach mapcan
      ); and
    )
    (and(isDir(optform->AppleRunPDVRunDirectory2->value)
      pathroot = optform->AppleRunPDVRunDirectory2->value
      files = setof(file foreach(mapcar candidate getDirFiles(pathroot)
			    strcat(pathroot "/" candidate))
		  rexMatchp("\\.rep\\.ext$" file))
      ); and
    )
    (and(isDir(optform->AppleRunPDVRunDirectory2->value)
      pathroot = optform->AppleRunPDVRunDirectory2->value
      files = foreach(mapcan mode mode_arg 
		setof(file foreach(mapcar candidate
		    setof(dir getDirFiles(strcat(pathroot "/" mode)) isDir(dir))
		    strcat(pathroot "/" mode "/" candidate))
		  rexMatchp("\\.rep\\.ext$" file))
	      ); foreach
      ); and
    )
    (t		files = nil)
  ); cond
  when(dtpr(files)
    printf("Attempting to open: %s\n" buildString(files "\n"))
    AppleOpenFile2(files "r" optform->editor_list2->value)
  ); when
); let
); procedure AppleRunPDVSOpenFileExt2

procedure(AppleRunPDVSaveOptionsBtnCallback2(optform theForm)
	let((fileName fport)
		;;crs: not tested yet
    	fileName=optform->AppleRunPDVFormInitFile2->value
		; printf("\n\n %L\n\n" fileName)
       when(fileName==""
            error("Must specify template filename")
            )
        fport=outfile(fileName)
        unless(fport
            c
            )
		printf("Saving the RunPDV Form values in %L \n" fileName)
        fprintf(fport "formKeys='(nil\n")
        ; output all of the main form keys 
		foreach(key '(AppleRunPDVAllMode2 AppleRunPDVPost2 AppleRunPDVPERCMode2 			
			AppleRunPDVLayPathOpt2 AppleRunPDVLayPath2 
			AppleRunPDVSchPathOpt2 AppleRunPDVSchPath2
			AppleRunPDVUseOvdir2  AppleRunPDVOvdirPath2  
			AppleRunPDVOtherOpt2  AppleRunPDVFormInitFile2 	AppleGdsWaiver2		  
			)
			fprintf(fport "  %s %L\n" key get(theForm key)->value)
			);foreach
        ; output all of the advanced options form keys
		foreach(key '(
			AppleRunPDVChecker2 AppleRunPDVShort_equiv_nets2 AppleRunPDVNoAudit2 
			AppleRunPDVNo_ip_tighten2 AppleRunPDVRelease_lay2 AppleRunPDVNoWaivers2 
			AppleRunPDVMegacell2 AppleRunPDVNoWaiversGds2 AppleRunPDVNoAutoHcells2
			AppleRunPDVVirtualConnColon2 AppleRunPDVRunFlat2 AppleRunPDVVirtualConnName2
			AppleRunPDVHcellFile2 AppleRunPDVLVSExcludeCells2 AppleRunPDVLVSPower2 AppleRunPDVLVSGround2
			AppleRunLVSFXOption2 AppleRunPDVQueue2 AppleAPSUBOtherOpt2 
			AppleRunPDVMaxErrors2 AppleRunPDVNumProc2 AppleRunPDVRunQueue2
			editor_list2  AppleRunPDVOtherOpt2					    
			)
			;Removed  AppleRunPDVRunDirectory2 AppleRunPDVReportFile2  AppleRunPDVResultsFile2	
			fprintf(fport "  %s %L\n" key get(optform key)->value)
			);foreach 
        ; end of the file
        fprintf(fport ")\n")
        close(fport)
	); let
); procedure AppleRunPDVSaveOptionsBtnCallback2  

procedure(AppleRunPDVLoadOptionsBtnCallback2(optform theForm )
	prog((fileName formKeys )
		fileName=optform->AppleRunPDVFormInitFile2->value
        when(fileName==""
            error("Must specify template filename")
            )
        ; load it, and trap any errors. The file is just skill
        ; code, so can be loaded.
		if(!isFile(fileName) then
			return()
			);if
        errset(load(fileName) t)
        ; the keys are all in a disembodied property list called formKeys
        ; input all of the main form keys
        ; use get(), because formKeys->key won't work, because the key variable
        ; needs to be evaluated.
		printf("Loading the RunPDV Form values in %L \n" fileName)
		foreach(key '(AppleRunPDVAllMode2 AppleRunPDVPost2 AppleRunPDVPERCMode2 			
			AppleRunPDVLayPathOpt2 AppleRunPDVLayPath2 
			AppleRunPDVSchPathOpt2 AppleRunPDVSchPath2
			AppleRunPDVUseOvdir2 AppleRunPDVOvdirPath2  
			AppleRunPDVOtherOpt2 AppleGdsWaiver2		  
			AppleRunPDVChecker2 AppleRunPDVShort_equiv_nets2 AppleRunPDVNoAudit2 
			AppleRunPDVNo_ip_tighten2 AppleRunPDVRelease_lay2 AppleRunPDVNoWaivers2 
			AppleRunPDVMegacell2 AppleRunPDVNoWaiversGds2 AppleRunPDVNoAutoHcells2
			AppleRunPDVVirtualConnColon2 AppleRunPDVRunFlat2 AppleRunPDVVirtualConnName2
			AppleRunPDVHcellFile2 AppleRunPDVLVSExcludeCells2 AppleRunPDVLVSPower2 AppleRunPDVLVSGround2
			AppleRunLVSFXOption2 AppleRunPDVQueue2 AppleAPSUBOtherOpt2 
			AppleRunPDVMaxErrors2 AppleRunPDVNumProc2 AppleRunPDVRunQueue2
			editor_list2  AppleRunPDVOtherOpt2 AppleRunPDVFormInitFile2			  
   			)
			; removed: AppleRunPDVRunDirectory2 AppleRunPDVReportFile2 AppleRunPDVResultsFile2
		if(get(theForm key) then 
		;key is in the main form
			get(theForm key)->value = get(formKeys key)
			else
				get(optform key)->value = get(formKeys key)
				);if            	
        	);foreach 
	); prog
); procedure AppleRunPDVLoadOptionsBtnCallback2

procedure( AppleRunPDVrun_calibre_start_rve2(theForm rveCellName rveLibName rveViewName)
	prog( (cv cellName use_rve_file use_pdvtype messages mgc_home calibre_path
    	rve_process_id mode_arg i mode_list_items mode_list_value
    	project_home NewrunDirectory diskPath runpdv_mode runpdv_mode_item
		mgc_calibre_rve_process_id_list)
	cellName = theForm->AppleRunPDVLayCellName2->value
	project_home = getShellEnvVar("PROJECT_HOME")
  	if( project_home == nil then project_home = getShellEnvVar("PROJECT_DIR") )
	mode_arg = "drc"
	mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
	mode_list_value=theForm->AppleRunPDVModes2->value
	i=0
	foreach(key theForm->AppleRunPDVModes2->_toggleItems
  		if(nth(i mode_list_value) == t then
        	runpdv_mode_item =  symbolToString(nth(i mode_list_items))
        	runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
        	mode_arg = runpdv_mode
  		);if
    i++
	)
	if(theForm->AppleRunPDVLef2->value == t then mode_arg ="lef" )
	if(theForm->AppleRunPDVAll2->value == t then mode_arg ="drc" )
	if(theForm->AppleRunPDVPost2->value == t then mode_arg ="drc" )
	printf("\nInside AppleRunPDVrun_calibre_start_rve %s \n" mode_arg)
	diskPath = getShellEnvVar("ECS_DISK_PATH")
	cellName = theForm->AppleRunPDVLayCellName2->value
	NewrunDirectory= strcat(diskPath "/PDV/" cellName "/")
;       theForm->AppleRunPDVRunDirectory->value = strcat( NewrunDirectory "/" lowerCase(mode_arg))
	if(!(cv = dbOpenCellViewByType(rveLibName rveCellName rveViewName "" "r" nil)) then
		hiGetAttention()
        printf("ERROR! Please open/activate a cell ...\n")
        sprintf(messages "ERROR! Please open/activate a cell ...")
      	;  add_rveForm~>jobmessages~>value = messages
        return()
    else
      ;  use_rve_file = add_rveForm~>database~>value
		use_pdvtype =mode_arg = '("drc")
		cellName = theForm->AppleRunPDVLayCellName2->value
		diskPath = getShellEnvVar("ECS_DISK_PATH")
	 	NewrunDirectory= strcat(diskPath "/PDV/" cellName)
	 	use_pdvtype = (AppleRunPDVGetSelectedModes2 theForm)
	 	use_rve_file = (AppleRunPDVGetPDVModesRVEFromPDVModesConfig2 use_pdvtype theForm->AppleGdsWaiver2->value NewrunDirectory)
     );if
      ;; Support for loading multiple tabs in RVE
      ;; To provide the correct arguments to RVE, we format them as follows:
      ;; -lvs lvs/svdb -rdb lvs/erc.db drc/drc.rep ant/ant.rep 
      ;; OR 
      ;; -dfmdb perctp/dfmdb -rdb lvs/erc.db drc/drc.rep ant/ant.rep 
      ;; OR
      ;; -drc lvs/erc.db drc/drc.rep ant/ant.rep 
      ;; To do this, separate the command line into two parts and update them dynamically as we go through all the RVE files, then join
      ;; the command together.
	(if !use_rve_file
	    use_rve_file = (strcat NewrunDirectory "/drc/drc_all.rep")
	    ;else
	    ;; Start with the simple -drc type command
	    (let ((part1 "-drc ") (part2 "") (mode_p use_pdvtype))
	      (foreach file (parseString use_rve_file)
		       ;; Warn the user that we can only load one svdb/dfmdb directory
		       (when (and (isDir file) part1 != "-drc ")
			 hiGetAttention()
			 printf("WARNING! Can't load multiple svdb/dfmdb. Database %s can't be loaded right now.\n" file))
		       ;; For dfmdb, prepend the -dfmdb part and then append -rdb
		       (if (and (substring file (strlen file)-5)=="/dfmdb" part1=="-drc " (isDir file))
			   part1=(strcat "-perc " file " -rdb "))
		       ;; For svdb, prepend the -lvs part and then append -rdb
		       (if (and (substring file (strlen file)-4)=="/svdb" part1=="-drc " (isDir file))
			   (if (or (car mode_p)=="drcerc" (car mode_p)=="biaschk")
			       part1=(strcat "-perc " file " -rdb ")
			       ;else
			       part1=(strcat "-lvs " file " -rdb ")))
		       (when (isFile file)
			 ;; Set an environment variable pointing to the directory of the first RDB result file
			 (when part2==""
			       (rexCompile "\\(.*\\)\\(/[^/]*\\)$")
			       (rexExecute file)
			       (setShellEnvVar (strcat "MGC_CALIBRE_DB_DIR=" (rexSubstitute "\\1"))))
			 part2=(strcat part2 file " "))
		       mode_p = (cdr mode_p))
	      (if part1!="-drc " && part2 == ""
		  part1=(substring part1 1 (strlen part1)-6))
	      use_rve_file = (strcat part1 part2))
		)
        if(use_rve_file=="-drc " || (substring(use_rve_file 1 1) !="-" && !isFile(use_rve_file) && !isDir(use_rve_file)) then
           hiGetAttention()
           printf("WARNING! equivalent %L database\n" use_pdvtype)
           sprintf(messages "WARNING! Can't find DATABASE ...")
           ;add_rveForm~>jobmessages~>value = messages
           return()
        )
	if(use_rve_file then
		printf("\nuse_rve_file %L " use_rve_file)
        )

      sprintf(messages "Start RVE for %s ..." rveCellName)
      printf("\nStart RVE for %s ..." rveCellName)

        mgc_home = getShellEnvVar("MGC_HOME")
				printf("\n mgc_home %s " mgc_home)
        unless(mgc_home
                mgcErrorDialog("MGC_HOME environment variable needs to be set to run Calibre-RVE!")
                return()
        )

        unless(mgc_rve_init_server_socket()
                return()
        )

        if( mgc_rve_check_process_list(mgc_calibre_rve_process_id_list)!=nil then
                unless(mgc_yesno_dialog("Calibre-RVE is already running!\nDo you want to start another RVE session?")
		    mgc_calibre_send_cmd( car(mgc_calibre_rve_process_id_list) "rve_PopWindows" )
		    return()
                )
        )
		; Make sure that the results are loaded into the correct layout view window
		; Has the Calibre "current library" been set?. If not, set it.
		;if(!getd('mgc_rve_set_current_library) then
			mgc_rve_set_current_library(list(cv))
		;	);if
        mgc_rve_set_window_mapping_rd2(cv)
        setShellEnvVar(sprintf(nil "MGC_CALIBRE_LAYOUT_SERVER=:%d" mgc_rve_globals->socket_number))
        setShellEnvVar("MGC_CALIBRE_LAYOUT_SERVER_NAME=Cadence:Virtuoso")
        setShellEnvVar("MGC_CGI_MONITOR_STDIN=1")
        setShellEnvVar("MGC_RVE_NEED_TOP_CELL_CONTEXT=1")
        printf("rve file %s\n" use_rve_file)
        calibre_path = strcat(mgc_home "/bin/calibre -gui -rve ")
        calibre_path = strcat(calibre_path use_rve_file)
		printf("\n calibre_path %s" calibre_path)
        if( mgc_rve_globals->run_cb_rve then
                calibre_path = strcat(calibre_path " -cb")
        )
        if( mgc_rve_globals->run_64_rve then
                calibre_path = strcat(calibre_path " -64")
        )

        if( rve_process_id=mgc_calibre_start_process(calibre_path '_rve_data_handler '_rve_close_handler) then
                mgc_calibre_rve_process_id_list = append1(mgc_calibre_rve_process_id_list rve_process_id)
                mgc_calibre_register_exit_proc()
        else
                mgcErrorDialog( sprintf(nil "Could not start Calibre-RVE.\n(%s)" calibre_path) )
         )

        return(rve_process_id)
  ); prog
); procedure AppleRunPDVrun_calibre_start_rve2

procedure(AppleRunPDVUseOvdirCallback2(optform form)
	let(()
		when(form && hiIsForm(form)
			form->AppleRunPDVOvdirPath2->enabled = form->AppleRunPDVUseOvdir2->value
			;;
		); when
        AppleUpdateCommandLineFromOptForm(optform AppleRunPDVForm2)
	);let
); procedure AppleRunPDVUseOvdirCallback2

procedure(AppleRunPDVShowMeCommand_wrap2(theForm debug)
;; Display the command on the form
	let((cmdline)
		cmdline = AppleRunPDVShowMeCommand2(theForm debug)
		;if(cmdline != nil then theForm->AppleRunPDVRunPDVcmd2->value = cmdline)
		if(cmdline != nil then AppleRunPDVForm2->AppleRunPDVRunPDVcmd2->value = cmdline)
	);let
); procedure AppleRunPDVShowMeCommand_wrap2

procedure(AppleRunPDVShowMeCommand2(theForm debug)
	prog((libraryName cellName RunDir OtherRunPDVOpt_arg jobclass pat
		OtherAPSUBOpt_arg StopEquivNets_arg Release_lay_arg AppleRunPDVMegacell_arg
		No_ip_tighten_arg fPort useNumProc diskPath NewrunDirectory i newkey
		mode_list_items Opdcap_arg NoChecker_arg mode_arg workspace_dir cmd_argument
		NoWaivers_arg NoWaiversGds_arg NoAutoHcells_arg appDpColoredGdsOut_arg includefilename
		appDpColoredView_arg RunPDVLogFileName runDirectory token tmpFile modifiedPDVOpt
		RunPDVLogDirName using_lvs ovdir_arg NoAudit_arg otherMode_arg sub lvsopt
		appleRunPDVMapAllColorsToLock_arg mode_list_value runpdv_mode runpdv_mode_item)
		
		libraryName = theForm->AppleRunPDVLayLibraryName2->value
		cellName = theForm->AppleRunPDVLayCellName2->value
		RunDir= AppleOptsForm->AppleRunPDVRunDirectory2->value
		diskPath = getShellEnvVar("ECS_DISK_PATH")
		runDirectory= strcat(diskPath "/PDV/" cellName "/drc")
		RunPDVLogDirName = strcat(diskPath "/PDV/" cellName )
		ovdir_arg = "" 
		OtherRunPDVOpt_arg = theForm->AppleRunPDVOtherOpt2->value
		OtherAPSUBOpt_arg = AppleOptsForm->AppleAPSUBOtherOpt2->value	
	
		if(theForm->appDpColoredGdsOut2->value == t then
        	appDpColoredGdsOut_arg = " -drc_auto_dpgds"
			else
        	appDpColoredGdsOut_arg = ""
			);if

		if(theForm->appDpColoredView2->value == t then
        	appDpColoredView_arg = " -dp_colored_view"
			else
        		appDpColoredView_arg = ""
			);if
		when(rexMatchp("-chip" theForm->AppleRunPDVExtraCmdOpts2->value)
  			AppleOptsForm->AppleRunPDVChecker2->value = t
			;AppleOptsForm->AppleRunPDVMegacell2->value = nil
  			printf("RunPDV_GUI2: -chip option detected, turning \"run checker\" on and turning \"megacell\" off.\n")
		); when

		if(AppleOptsForm->AppleRunPDVChecker2->value == nil then
        	NoChecker_arg = " -no_checker "
			else
        	NoChecker_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVNoWaivers2->value == nil then
        	NoWaivers_arg = " -no_waivers "
			else
        	NoWaivers_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVNoWaiversGds2->value == nil then
        	NoWaiversGds_arg = " -no_waivergds "
			else
        		NoWaiversGds_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVNoAutoHcells2->value == nil then
        	NoAutoHcells_arg = " -no_auto_hcells"
			else
        		NoAutoHcells_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVNoAudit2->value == nil then
        	NoAudit_arg = " -noaudit "
			else
        		NoAudit_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVShort_equiv_nets2->value == t then
        	StopEquivNets_arg = " -short_equivalent "
			else
        		StopEquivNets_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVOpdcap2->value == t then
        	Opdcap_arg = " -opdcap "
			else
        	Opdcap_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVRelease_lay2->value == t then
        	Release_lay_arg = " -release_lay "
			else
        		Release_lay_arg = ""
			);if

		if(AppleOptsForm->AppleRunPDVMegacell2->value == t then
        	AppleRunPDVMegacell_arg = " -megacell "
			else
        		AppleRunPDVMegacell_arg = ""
			);if

		if(AppleOptsForm~>applRunPDVGenBAData2~>value == t then
        	AppleRunPDVMegacell_arg = " -genBAData "
			;AppleLockColors(geGetEditCellView())	
		);if

		if(AppleOptsForm->AppleRunPDVNo_ip_tighten2->value == nil then
        	No_ip_tighten_arg = " -no_ip_tighten "
			else
        	No_ip_tighten_arg = ""
			);if
		mode_arg = "drc"
		mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
		mode_list_value=theForm->AppleRunPDVModes2->value
		i=0
		foreach(key theForm->AppleRunPDVModes2->_toggleItems
  			if(nth(i mode_list_value) == t then
        		runpdv_mode_item =  symbolToString(nth(i mode_list_items))
        		runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
        		mode_arg = runpdv_mode
  			);if
  	  		i++
		);foreach

        if(theForm->AppleRunPDVLef2->value == t then mode_arg ="lef" )
        if(theForm->AppleRunPDVAllMode2->value == t then mode_arg ="all" )
        if(theForm->AppleRunPDVPost2->value == t then mode_arg ="drc" )

		workspace_dir = AppleOptsForm->AppleRunPDVWorkspace2->value

		if(theForm->AppleRunPDVUseOvdir2->value == nil then
   			ovdir_arg = ""
			else
   				ovdir_arg = strcat(" -ovdir " theForm->AppleRunPDVOvdirPath2->value)
		);if

		otherMode_arg = " "
		if(theForm->AppleRunPDVAllMode2->value == t otherMode_arg = strcat(otherMode_arg " -mode all " ))
		if(theForm->AppleRunPDVPost2->value == t otherMode_arg = strcat(otherMode_arg " -mode post " ))
		mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
		mode_list_value=theForm->AppleRunPDVModes2->value
		i=0
		foreach(key theForm->AppleRunPDVModes2->_toggleItems
  			if(nth(i mode_list_value) == t then
        		runpdv_mode_item =  symbolToString(nth(i mode_list_items))
        		;runpdv_mode = substring(runpdv_mode_item 6 length(runpdv_mode_item)-4)
        		runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
				otherMode_arg = strcat(otherMode_arg " -mode " runpdv_mode ) 
        		mode_arg = runpdv_mode
  				);if
    		i++
		);foreach

		diskPath = getShellEnvVar("ECS_DISK_PATH")
		cellName = theForm->AppleRunPDVLayCellName2->value
		NewrunDirectory= strcat(diskPath "/PDV/" cellName)
		AppleOptsForm->AppleRunPDVReportFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
		AppleOptsForm->AppleRunPDVResultsFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
		;theForm->AppleRunPDVRunDirectory->value = strcat( NewrunDirectory "/" lowerCase(mode_arg))

		if(theForm->AppleRunPDVLef2->value == t then
   			if(AppleOptsForm->AppleRunPDVMegaReleaseVersion2->value == "" then
        		hiDisplayAppDBox(
        			?name 'rdRunPDVLefInfo
        			?dboxBanner "RunPDV Lef Info."
        			?dboxText "Please specify Megacell Release Version (in Advanced Options form)."
        			?buttonLayout 'Close
        		);hiDisplayAppDBox
				return(nil)
				else
					mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
					mode_list_value=theForm->AppleRunPDVModes2->value
					i=0
					foreach(key theForm->AppleRunPDVModes2->_toggleItems
  						if(nth(i mode_list_value) == t then
        			;;crs: appears to do nothing		runpdv_mode_item =  symbolToString(nth(i mode_list_items))
							theForm->AppleRunPDVModes2->value = nil
  						);if
 				   	i++
					);foreach
     			theForm->AppleRunPDVAll2->value = nil
     			theForm->AppleRunPDVPost2->value = nil
     			AppleOptsForm->AppleRunPDVChecker2->value = t
     			AppleOptsForm->AppleRunPDVNoAudit2->value = t
     			AppleOptsForm->AppleRunPDVMegacell2->value = nil 
     			AppleOptsForm->AppleRunPDVRelease_lay2->value = nil 
     			AppleOptsForm->AppleRunPDVMaxErrors2->value = ""
     			AppleOptsForm->AppleRunPDVOpdcap2->value = nil
     			AppleOptsForm->AppleRunPDVNoWaivers2->value = t
     			AppleOptsForm->AppleRunPDVNoWaiversGds2->value = t
     			AppleOptsForm->AppleRunPDVNoAutoHcells2->value = t
     			AppleOptsForm->appDpColoredGdsOut2->value = nil
     			AppleOptsForm->appDpColoredView2->value = nil
     			;AppleOptsForm->AppleRunPDVDfm_guideline2->value = nil
     			otherMode_arg = strcat(otherMode_arg " -mode lef -check_release_lef " AppleOptsForm->AppleRunPDVMegaReleaseVersion2->value ) 
     			mode_arg = "lef"
   			);if
		);if

		if( AppleOptsForm->AppleRunPDVVirtualConnName2->value != "" then
			otherMode_arg = strcat(otherMode_arg " --connectByName '" AppleOptsForm->AppleRunPDVVirtualConnName2->value "'")
			);if

		if(onep(debug) then
			printf("\nYou have other mode argument as %L\n" otherMode_arg) )
			useNumProc = AppleOptsForm->AppleRunPDVNumProc2->value
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;; Submit to queue options
			if(AppleOptsForm->AppleRunPDVRunQueue2->value == t then
	 			theForm->AppleRunPDVStopBtn2->enabled=t
				AppleOptsForm->AppleAPSUBOtherOpt2->enabled = t
				;   cmd_argument = "nc run -I RunPDV "
				;  cmd_argument = strcat("nc run -I " getShellEnvVar("GLOBAL_PATH") "/../latest/bin/RunPDV ")
				;  cmd_argument = strcat("nc run -I " getShellEnvVar("SEG_TOP_GLOBAL_PATH") "/bin/RunPDV ")
 				;; set the default jobclass to 'virtuoso', use a regular expression to detect
 				;; if user supplies an alternative jobclass - if so capture the alternative
 				;; value and then remove that whole section from the OtherAPSUB options -
 				;; the captured jobclass will override the default jobclass value "virtuoso"
   				jobclass = "virtuoso"
				pat = pcreCompile("(--jobclass ([a-z0-9_]+))")
				if(OtherAPSUBOpt_arg != "" then
					when(pcreExecute(pat OtherAPSUBOpt_arg)
						jobclass = pcreSubstitute(pat "\\2")
						OtherAPSUBOpt_arg = pcreReplace(pat OtherAPSUBOpt_arg "" 1)
 						);when
					);if
				cmd_argument = strcat("apsub --jobclass " jobclass " --show_output --slots " useNumProc " " OtherAPSUBOpt_arg " --cmd " getShellEnvVar("SEG_TOP_GLOBAL_PATH") || getShellEnvVar("GLOBAL_PATH") "/bin/RunPDV ")
			else
   				;cmd_argument = "RunPDV "
  				;cmd_argument = strcat(getShellEnvVar("GLOBAL_PATH") "/../latest/bin/RunPDV ")
   				cmd_argument = strcat(getShellEnvVar("SEG_TOP_GLOBAL_PATH") "/bin/RunPDV ")
				AppleOptsForm->AppleAPSUBOtherOpt2->enabled = nil
			);if
			;; Endof "submit to queue" options
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		if(theForm->AppleRunPDVSchPathOpt2->value == nil then
			cmd_argument = strcat(cmd_argument " " libraryName " " cellName)
			);if
		unless(blankstrp(RunDir)
  			cmd_argument = strcat(cmd_argument " -w " RunDir)
			);unless
		;; CRS If there is no include file specified, add a temporary one so that the new "LVS REPORT OPTION FX" can be used 
		tmpFile = strcat("/tmp/" getLogin() "_PDV_include_file.txt")
		if(isFile(tmpFile) 	
			system(sprintf(nil "rm %s" tmpFile)
			);if just in case an old file is lying around from a previous run
		);if
	if(AppleOptsForm->AppleRunLVSFXOption2->value == t then
		lvsopt = "LVS REPORT OPTION FX"
		modifiedPDVOpt = strcat("-include_file " tmpFile)
		if(OtherRunPDVOpt_arg == "" then
			system(sprintf(nil "echo \"%s\"  >> %s" lvsopt  tmpFile))
			OtherRunPDVOpt_arg = modifiedPDVOpt
			else
				; if an include file already exists. Take that file and append this option/.		
				token = car(parseString(OtherRunPDVOpt_arg))
				if(token =="-include_file" then	
					includefilename = nth(1 parseString(OtherRunPDVOpt_arg))
					newkey = strcat(token " " includefilename)
					system(sprintf(nil "echo %s  >> %s" newkey  tmpFile))
					;modifiedPDVOpt = strcat("-include_file " tmpFile)	
					else	
						system(sprintf(nil "echo %s  >> %s" OtherRunPDVOpt_arg  tmpFile))		
					);if
					system(sprintf(nil "echo \"%s\"  >> %s" lvsopt  tmpFile))			
			; change OtherRunPDVOpt_arg to the temporary file
			; Note. RunPDV is invoked with the "-include_file" option, even if the file is empty.
			OtherRunPDVOpt_arg = modifiedPDVOpt
			);if
		);if
		cmd_argument = strcat(cmd_argument " -workspace " workspace_dir)
		cmd_argument = strcat(cmd_argument " " NoChecker_arg NoAudit_arg StopEquivNets_arg Opdcap_arg Release_lay_arg AppleRunPDVMegacell_arg No_ip_tighten_arg )
		cmd_argument = strcat(cmd_argument " " appDpColoredGdsOut_arg appDpColoredView_arg)	;; AppleRunPDVDfm_guideline_arg 
		cmd_argument = strcat(cmd_argument " " NoWaivers_arg " " NoWaiversGds_arg " " NoAutoHcells_arg " " otherMode_arg " " OtherRunPDVOpt_arg ) 
		cmd_argument = strcat(cmd_argument " " ovdir_arg )

		;; Read the MIE Extra Options field and add any command-line switches, as necessary
		when(rexMatchp("-chip" theForm->AppleRunPDVExtraCmdOpts2->value)
			;if "-chip" is specified, make sure the checker is turned on,  megacell is turned off and lib and cell names match
  			cmd_argument = strcat(cmd_argument "-chip")
			AppleOptsForm->AppleRunPDVMegacell2->value = nil
			); when

		if(theForm->AppleRunPDVLayPathOpt2->value == t then
			cmd_argument = strcat(cmd_argument " -gds " theForm->AppleRunPDVLayPath2->value " -layTop " theForm->AppleRunPDVLayCellName2->value )
			cmd_argument = strcat(cmd_argument " -lay '" theForm->AppleRunPDVLayLibraryName2->value " " theForm->AppleRunPDVLayCellName2->value " " theForm->AppleRunPDVLayViewName2->value "'")
			else
				cmd_argument = strcat(cmd_argument " -lay '" theForm->AppleRunPDVLayLibraryName2->value " "  theForm->AppleRunPDVLayCellName2->value " " theForm->AppleRunPDVLayViewName2->value "'")
			);if
		using_lvs = "no"
		;mode_list_value_new = list()
		foreach(key theForm->AppleRunPDVModes2->_toggleItems
			if(rexMatchp("mode_LVS" symbolToString(key)) then
				using_lvs = "yes"
			);if
		);foreach
		if(theForm->AppleRunPDVSchPathOpt2->value == t then
			cmd_argument = strcat(cmd_argument " -cdl " theForm->AppleRunPDVSchPath2->value " -schTop " theForm->AppleRunPDVSchCellName2->value )
			else
				if(rexMatchp("yes" using_lvs) then
					cmd_argument = strcat(cmd_argument " -sch '" theForm->AppleRunPDVSchLibraryName2->value  " "  theForm->AppleRunPDVSchCellName2->value " " theForm->AppleRunPDVSchViewName2->value "'")
				);if
			);if
		if(AppleOptsForm->AppleRunPDVHcellFile2->value != "" then
			cmd_argument = strcat(cmd_argument " -hcells '" AppleOptsForm->AppleRunPDVHcellFile2->value "'")
			else
				;cmd_argument = strcat(cmd_argument " -no_auto_hcell " theForm->AppleRunPDVHcellFile->value)		;; ??? more info here
				cmd_argument = strcat(cmd_argument " ")             ;; ??? more info here
			);if
		if(AppleOptsForm->AppleRunPDVLVSExcludeCells2->value != "" then
			cmd_argument = strcat(cmd_argument " -exclude_cells " AppleOptsForm->AppleRunPDVLVSExcludeCells2->value)
			);if
		if(AppleOptsForm->AppleRunPDVLVSPower2->value != "" then
			cmd_argument = strcat(cmd_argument " -additional_power '" AppleOptsForm->AppleRunPDVLVSPower2->value "'")
			);if
		if(AppleOptsForm->AppleRunPDVLVSGround2->value != "" then
			cmd_argument = strcat(cmd_argument " -additional_ground '" AppleOptsForm->AppleRunPDVLVSGround2->value "'")
			);if
		if(AppleOptsForm->AppleRunPDVRunFlat2->value == t then 
			cmd_argument = strcat(cmd_argument " -flat") 
			);if
		if(AppleOptsForm->AppleRunPDVVirtualConnColon2->value == t then 
			cmd_argument = strcat(cmd_argument " -vconn_colon") 
			);if
		if(AppleOptsForm->AppleRunPDVMaxErrors2->value != ""  then 
			cmd_argument = strcat(cmd_argument " -max_drc_errors " AppleOptsForm->AppleRunPDVMaxErrors2->value " ")
			);if
		if(onep(debug) then
			printf("\nNumProc==%s" AppleOptsForm->AppleRunPDVNumProc2->value) 
			);if
		if(rexMatchp("-turbo " OtherRunPDVOpt_arg) then
			printf("Using turbo option from other options field\n")
			else 
  				if(AppleOptsForm->AppleRunPDVNumProc2->value !="" then
    				cmd_argument = strcat(cmd_argument " -turbo " AppleOptsForm->AppleRunPDVNumProc2->value  " ")
  				);if
			);if
		/* Construct the log file name depending on the mode here */
    	cond(
      		(pcreMatchp("-mode.*-mode" cmd_argument)
			;More than one "-mode" found.
			RunPDVLogFileName = strcat(RunPDVLogDirName "/RunPDV.multi.log")
			RetireThisFile2(RunPDVLogFileName)
      		)
      		(pcreExecute(pcreCompile("-mode[ \t]*([^ ]*)") cmd_argument)
			;TODO  fix the next line
			sub = pcreSubstitute("\\1")
			RunPDVLogFileName = strcat(RunPDVLogDirName "/RunPDV." sub ".log")
			;RunPDVLogFileName = strcat(RunPDVLogDirName "/RunPDV." pcreSubstitute("\\1") ".log")
			RetireThisFile2(RunPDVLogFileName)
      		)
      		(t
			RunPDVLogFileName = strcat(RunPDVLogDirName "/RunPDV.all.log")
			RetireThisFile2(RunPDVLogFileName)
      		)
    	);cond

		if(isFile(strcat(RunPDVLogDirName "/.logInfo")) then
			printf("Remove old .logInfo file\n")
        	sh(strcat("rm " RunPDVLogDirName "/.logInfo"))
			); if
		printf("\nRunPDVLogDirName =%s\n" RunPDVLogDirName)
		sh(strcat("mkdir -p " RunPDVLogDirName))
		fPort = outfile(strcat(RunPDVLogDirName "/.logInfo"))
		fprintf(fPort RunPDVLogFileName)
		close(fPort)
		cmd_argument = strcat(cmd_argument " -log " RunPDVLogFileName )
		cmd_argument = strcat(cmd_argument " -gui " )
		appleRunPDVMapAllColorsToLock_arg = " -strOptions 'mapAllColorToLocked' "
		if(theForm~>appleRunPDVMapAllColorsToLock2~>value == t then
			cmd_argument = strcat(cmd_argument appleRunPDVMapAllColorsToLock_arg )
		);if
	if(onep(debug) then
		printf("\n\n Info::RunPDV command AppleRunPDVShowMeCommand :: %L\n" cmd_argument) 
		)
	;; return the command
	return(cmd_argument)
	); let
); procedure AppleRunPDVShowMeCommand2

procedure(AppleRunPDVLayPathOptCallback2(optform theForm)
	;;Called when the option "Use gds" is clicked
	;; Layout,cell,view fields should then be greyed-out
	let((project_home diskPath runDirectory cellName)
  		cellName = theForm->AppleRunPDVLayCellName2->value
  		project_home = getShellEnvVar("PROJECT_HOME")
  		if( project_home == nil then project_home = getShellEnvVar("PROJECT_DIR") )
  		diskPath = getShellEnvVar("ECS_DISK_PATH")
  		runDirectory= strcat(diskPath "/PDV/" cellName )
		if(theForm->AppleRunPDVLayPathOpt2->value == t then
			theForm->AppleRunPDVLayLibraryName2->enabled = nil
			theForm->AppleRunPDVLayCellName2->enabled = nil
			theForm->AppleRunPDVLayViewName2->enabled = nil
			theForm->AppleRunPDVLayPath2->enabled = t 
			theForm->AppleRunPDVLayPath2->editable = t 
			theForm->AppleRunPDVLayPath2->value=strcat( runDirectory "/gds/" theForm->AppleRunPDVLayCellName2->value ".gds")
			else
        	theForm->AppleRunPDVLayLibraryName2->enabled = t 
        	theForm->AppleRunPDVLayCellName2->enabled = t 
        	theForm->AppleRunPDVLayViewName2->enabled = t 
        	theForm->AppleRunPDVLayLibraryName2->editable = t 
        	theForm->AppleRunPDVLayCellName2->editable = t 
        	theForm->AppleRunPDVLayViewName2->editable = t 
			theForm->AppleRunPDVLayPath2->editable = nil 
        	theForm->AppleRunPDVLayPath2->enabled = nil 
			;theForm->AppleRunPDVLayPath->value=""
		)
		AppleUpdateCommandLine( theForm)	
	); let
); procedure AppleRunPDVLayPathOptCallback2

procedure(AppleRunPDVSchPathOptCallback2(theForm)
	;;User has pressed the "Use cdl" check box
	;; The schematic lib/cell/view fields should be disabled
	let((project_home diskPath runDirectory cellName )
  		cellName = theForm->AppleRunPDVLayCellName2->value
  		project_home = getShellEnvVar("PROJECT_HOME")
  		if( project_home == nil then 
			project_home = getShellEnvVar("PROJECT_DIR")
 			);if
  		diskPath = getShellEnvVar("ECS_DISK_PATH")
  		runDirectory= strcat(diskPath "/PDV/" cellName )
		if(theForm->AppleRunPDVSchPathOpt2->value == t then
        	theForm->AppleRunPDVSchLibraryName2->editable = nil
        	theForm->AppleRunPDVSchLibraryName2->enabled = nil
        	theForm->AppleRunPDVSchCellName2->editable = nil
        	theForm->AppleRunPDVSchCellName2->enabled = nil
        	theForm->AppleRunPDVSchViewName2->editable = nil
        	theForm->AppleRunPDVSchViewName2->enabled = nil
        	theForm->AppleRunPDVSchPath2->enabled = t
         	theForm->AppleRunPDVSchPath2->editable = t
			theForm->AppleRunPDVSchPath2->value=strcat( runDirectory "/netlists/" theForm->AppleRunPDVSchCellName2->value ".cdl")
			else
        		theForm->AppleRunPDVSchLibraryName2->enabled = t
        		theForm->AppleRunPDVSchLibraryName2->editable = t
       			theForm->AppleRunPDVSchCellName2->enabled = t
        		theForm->AppleRunPDVSchCellName2->editable = t
       			theForm->AppleRunPDVSchViewName2->enabled = t
        		theForm->AppleRunPDVSchViewName2->editable = t
        		theForm->AppleRunPDVSchPath2->editable = nil
        		theForm->AppleRunPDVSchPath2->enabled = nil
				;theForm->AppleRunPDVSchPath->value=""
			);if
			AppleUpdateCommandLine( theForm)	
		); let
); procedure AppleRunPDVSchPathOptCallback2

procedure(AppleRunPDVNumProcCallback2(optform)
	let(()
		case(optform->AppleRunPDVNumProc2->value
			("1" printf("\nThe number of processes is 1") )
			("2" printf("\nThe number of processes is 2") )
			("3" printf("\nThe number of processes is 3") )
			("4" printf("\nThe number of processes is 4") )
			("5" printf("\nThe number of processes is 5") )
			("6" printf("\nThe number of processes is 6") )
			("7" printf("\nThe number of processes is 7") )
			("8" printf("\nThe number of processes is 8") )
			("9" printf("\nThe number of processes is 9") )
			("10" printf("\nThe number of processes is 10") )
			("11" printf("\nThe number of processes is 11") )
			("12" printf("\nThe number of processes is 12") )
			(t
				printf("\nsetting the number of processes to 1,valid values are from 1-12. If you like to use more than 12, cut&paste command and modify,submit from xterm.\n")
    			optform->AppleRunPDVNumProc2->value = "1"
				)
			); case
		);let
); procedure AppleRunPDVNumProcCallback2

procedure(AppleRunPDVDataHandler2(pid data)
  let( (diskPath project_home cellName forms runDirectoryPDVLog fPort line theForm)
	;;theForm->AppleRunPDVStartBtn->enabled = t
	;;theForm->AppleRunPDVStopBtn->enabled = nil
    cond(
      (rexMatchp("-I- RunPDV Begins " data)
		project_home = getShellEnvVar("PROJECT_HOME") ||
		      getShellEnvVar("PROJECT_DIR")
		cellName = hiGetCurrentForm()->AppleRunPDVLayCellName2->value
		when(cellName
	  		diskPath = getShellEnvVar("ECS_DISK_PATH")
	  		runDirectoryPDVLog= strcat(diskPath "/PDV/" cellName "/RunPDV.log")
	  		fPort = infile(strcat(diskPath "/PDV/" cellName "/.logInfo"))
	  		while(gets(line fPort)
				runDirectoryPDVLog = line
	  			); while
	  		close(fPort)
		); when
	view(runDirectoryPDVLog nil nil t)
      ); begin of run condition

      (rexMatchp("RunPDV -F- Unknown Switch " data)
	;; find the appropriate form so that we can retrieve data from it
	;; such as the cellname, and so we can change status of STOP and Apply
	forms = rexMatchList("^AppleRunPDVForm2[0-9]" oblist)
	if(onep(length(forms)) then
	  theForm = symeval(car(forms))
	else
	  foreach(form forms
	    form = symeval(form)
	    when(form->processId == pid
	      theForm = form
	    ); when
	  ); foreach
	  when(theForm
	    ;; re-enable the Apply button and disable the STOP button
	    hiSetFormButtonEnabled(theForm 'Apply t)
	    theForm->AppleRunPDVStartBtn2->enabled = t
	    theForm->AppleRunPDVStopBtn2->enabled = nil
	  ); when
	); if
	hiDisplayAppDBox(
	  ?name 'AppleRunPDVRunPDVExit
	  ?dboxBanner "RunPDV Error."
	  ?dboxText "RunPDV command has error, check all the switches."
	  ?buttonLayout 'Close
	)
      ); unknown switch condition

      (rexMatchp("RunPDV -F- Exiting with status " data)
	printf("%s\n" data)
      ); exit condition
    ); cond
  ); let
); procedure AppleRunPDVDataHandler2

procedure(AppleRunPDVExitHandler2(pid status)
  let((forms found)
    if(zerop(status) then
      fprintf(woport "RunPDV: Job %L has exited with status %L.\n" pid status)
    else
      fprintf(errport "RunPDV: Job %L has exited with status %L.\n" pid status)
    ); if
    ;; find the appropriate form so that we can re-enable the Apply
    forms = rexMatchList("^AppleRunPDVForm2[0-9]" oblist)
    foreach(form forms
      form = symeval(form)
      when(form->processId2 == pid
	found = t
     ); when
    ); foreach
    hiDisplayAppDBox(
      ?name		'AppleRunPDVRunPDVExit
      ?dboxBanner	"RunPDV Done."
      ?dboxText		sprintf(nil "RunPDV Done, status %L." status)
      ?buttonLayout	'Close
    )
	;; re-enable the Apply button and disable the STOP button
	;hiSetFormButtonEnabled(form 'Apply t)
	AppleRunPDVForm2->AppleRunPDVStartBtn2->enabled = t
	AppleRunPDVForm2->AppleRunPDVStopBtn2->enabled = nil

    unless(found
      fprintf(woport strcat("RunPDV: If Apply button is inactive press STOP "
      "(if active) or Refresh to re-enable it.\n"))
    ); unless
  ); let
); procedure AppleRunPDVExitHandler2

procedure(AppleRunPDVStopCallback2(theForm)
prog((dir proj file fid cellName libName cmd command_used newpid ftjob)
	if(!boundp('RunPDVProcessID) then 
		; pressing stop when using FlowTracer
		AppleRunPDVForm2->AppleRunPDVStartBtn2->enabled = t
		AppleRunPDVForm2->AppleRunPDVStopBtn2->enabled = nil
		ftjob = getShellEnvVar("VOV_PROJECT_NAME")
		command = sprintf(nil "vovproject stop -force %s" ftjob)
		command = sprintf(nil "ls" )
		xxx= ipcBeginProcess(command)
		ipcWait(xxx)
		return(nil)
		);if

  if(getShellEnvVar("SEG_PROJECT_BRANCH") then
    proj=strcat(getShellEnvVar("PROJECT") "." getShellEnvVar("SEG_PROJECT_BRANCH"))
  else
    proj=getShellEnvVar("PROJECT")
  )

  cellName = theForm->AppleRunPDVLayCellName2->value
  libName = theForm->AppleRunPDVLayLibraryName2->value
  if(theForm->AppleRunPDVRunQueue2->value == t then
    printf("Job is submitted to the queue\n")
    dir = getWorkingDir()

    fid = outfile(file = sprintf(nil "/tmp/%s_%s_%s_stopRunPDVGUI.%s.csh" cellName libName getShellEnvVar("USER") proj)) || error("Unable to create file: %s\n" file)
    fprintf(fid "#!/bin/csh\n")
    fprintf(fid "setup_project elba ;\n set_work_environment %s ;\n" getShellEnvVar("GLOBAL_PATH"))
    fprintf(fid "echo 'Going to stop following nc jobs that are running (if any)';\n")
    fprintf(fid "nc list -l -dir %s -r | grep RunPDV | grep %s | grep %s | grep Running | awk '{print $1}' | xargs -n1 nc stop;\n" dir cellName libName)
    fprintf(fid "sleep 30;\n")
    fprintf(fid "exit");
    close(fid)
    shell(sprintf(nil "chmod +x %s" file))
		printf("file %s" file)

    cmd = sprintf(nil "xterm -geometry 150x30 -e '%s %s_RunPDVGUI'" file getShellEnvVar("USER") )
    newpid = ipcBeginProcess(cmd)
    ipcWait(newpid)

    printf("\nRunPDV stopped by user.")
    hiDisplayAppDBox(
      ?name 'AppleRunPDVStop
      ?dboxBanner "RunPDV STOP."
      ?dboxText "RunPDV STOPPED."
      ?buttonLayout 'Close
    )
    ;theForm->AppleRunPDVStopBtn->enabled=nil
  else
    cellName = theForm~>AppleRunPDVLayCellName2~>value
    command_used = RunPDVProcessID~>command
    if(rexMatchp(cellName command_used) then
      ipcKillProcess(RunPDVProcessID)
      hiDisplayAppDBox(
	?name 'AppleRunPDVStop
	?dboxBanner "RunPDV STOP."
	?dboxText "RunPDV STOPPED."
	?buttonLayout 'Close
      )
      printf("\nRunPDV stopped by user %s." cellName)
      theForm->AppleRunPDVStopBtn2->enabled=nil
      theForm->AppleRunPDVStartBtn2->enabled=t
    ) ; if command matches the cell name
  ); if submitted to the queue
  ;; re-enable the form Apply button
  hiSetFormButtonEnabled(theForm 'Apply t)
); let
); procedure AppleRunPDVStopCallback2

procedure( mgc_rve_set_window_mapping_rd2(cell_id)
	prog( (win_id key cellname hl_sets)
		unless( win_id = hiGetCurrentWindow()
			return(list("" ""))
			);unless
			;;cell_id = win_id->editCellView
		mgc_rve_init_streamout_keys()
		;streamOutKeys->viewName = cell_id->viewName
		cellname = mgc_rve_set_cellname_case(cell_id->cellName)
		mgc_rve_set_lcell_mapping(cellname cell_id->libName cell_id->cellName cell_id->viewName win_id)
		mgc_rve_append_to_schematic_libpath(cell_id->libName)
		mgc_rve_add_layout_libs(win_id)
		key = list(cellname cell_id->cellViewType cell_id->viewName)
		;; key = list(mgc_calibre_map_cell_name(cellname) cell_id->cellViewType cell_id->viewName)
		mgc_rve_globals->current_lcell = key
		unless(mgc_rve_globals->cell_table[key]
			hiUnregCloseProc( win_id 'mgc_rve_on_close_window )
			hiRegCloseProc( win_id 'mgc_rve_on_close_window )
			); unless
		hl_sets = mgc_rve_globals->cell_table[key]->hl_sets
		mgc_rve_globals->cell_table[key] = mgc_rve_init_table_element(win_id cell_id hl_sets)
		return( list(cellname cell_id->cellName) )
		); prog
); procedure mgc_rve_set_window_mapping_rd2

procedure(AppleRunPDVRunChoicesCallback_32(optform theForm)
	let((cellName runMode project_home runDirectory mode_arg NewrunDirectory
    	diskPath i mode_list_items mode_list_value runpdv_mode runpdv_mode_item
    	mode_list_value_new)
		cellName = theForm->AppleRunPDVLayCellName2->value

		if(theForm->AppleRunPDVAll2->value == t || theForm->AppleRunPDVLef2->value == t || theForm->AppleRunPDVPost2->value == t then
			optform->AppleRunPDVChecker2->value = t
			optform->AppleRunPDVNoAudit2->value = t
			else
				if(optform->AppleRunPDVMegacell2->value then
					optform->AppleRunPDVChecker2->value = t
					else
						optform->AppleRunPDVChecker2->value = nil
    				); if
  
  			);if

		if(theForm->AppleRunPDVAll2->value == nil || theForm->AppleRunPDVLef2->value == nil || theForm->AppleRunPDVPost2->value == nil then
			if(optform->AppleRunPDVMegacell2->value then
				optform->AppleRunPDVChecker2->value = t
				else
					optform->AppleRunPDVChecker2->value = t
				);if
    				;theForm->AppleRunPDVNoAudit->value = nil 
  			);if

		project_home = getShellEnvVar("PROJECT_HOME")
		if( project_home == nil then 
			project_home = getShellEnvVar("PROJECT_DIR") 
			);if
		diskPath = getShellEnvVar("ECS_DISK_PATH")
		runDirectory= strcat(diskPath "/PDV/" cellName "/drc")
		cellName = theForm->AppleRunPDVLayCellName2->value
		NewrunDirectory= strcat(diskPath "/PDV/" cellName "/")

		runMode = "DRC"
		mode_arg = "drc"
		mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
		mode_list_value=theForm->AppleRunPDVModes2->value
		i=0
		foreach(key theForm->AppleRunPDVModes2->_toggleItems
  			if(nth(i mode_list_value) == t then
        		runpdv_mode_item =  symbolToString(nth(i mode_list_items))
        		;runpdv_mode = substring(runpdv_mode_item 6 length(runpdv_mode_item)-4)
        		runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
        		runMode = runpdv_mode 
				mode_arg = runpdv_mode
				;printf("\n\n runMode ===> %s mode_arg ===> %s \n\n" runMode mode_arg)
  				);if
    			i++
			);foreach

		if(theForm->AppleRunPDVLef2->value == t then mode_arg ="lef" runMode = "LEF")
		if(theForm->AppleRunPDVAll2->value == t then mode_arg ="drc" runMode = "ALL" )
		if(theForm->AppleRunPDVPost2->value == t then mode_arg ="drc" runMode = "POST" )

		theForm->AppleRunPDVReportFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
		optform->AppleRunPDVResultsFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
		;theForm->AppleRunPDVRunDirectory->value = strcat( NewrunDirectory "/" lowerCase(mode_arg))

		;printf("Debug :: runMode %s and mode_arg %s " runMode mode_arg)
		;printf("Debug :: selected  %L %s %s " theForm runMode mode_arg )

		if(lowerCase(runMode) == "drc" then
			mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
			mode_list_value=theForm->AppleRunPDVModes2->value
			i=0
			foreach(key theForm->AppleRunPDVModes2->_toggleItems
  				if(nth(i mode_list_value) == t then
        			runpdv_mode_item =  lowerCase(symbolToString(nth(i mode_list_items)))
        			;runpdv_mode = substring(runpdv_mode_item 6 length(runpdv_mode_item)-4)
        			runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
					theForm->AppleRunPDVModes2->enabled = t
					);if
	    			i++
				);foreach

        	theForm->AppleRunPDVLef2->enabled = t
        	optform->AppleRunPDVRelease_lay2->value = t

        	theForm->AppleRunPDVSchLibraryName2->editable = nil
        	theForm->AppleRunPDVSchCellName2->editable = nil
        	theForm->AppleRunPDVSchViewName2->editable = nil
        	theForm->AppleRunPDVSchPath2->editable = nil
        	theForm->AppleRunPDVSchPath2->enabled = nil
        	theForm->AppleRunPDVSchPathOpt2->enabled= nil

        	optform->AppleRunPDVHcellFile2->editable = nil
        	optform->AppleRunPDVHcellFile2->enabled = nil
        	optform->AppleRunPDVHcellFileViewBtn2->enabled = nil
        	optform->AppleRunPDVLVSExcludeCells2->editable = nil
        	optform->AppleRunPDVLVSPower2->editable = nil
        	optform->AppleRunPDVLVSGround2->editable = nil
        	optform->AppleRunPDVReportFileViewExtBtn2->enabled = nil

        	project_home = getShellEnvVar("PROJECT_HOME")
        	if( project_home == nil then project_home = getShellEnvVar("PROJECT_DIR") )
			diskPath = getShellEnvVar("ECS_DISK_PATH")
        	runDirectory= strcat(diskPath "/PDV/" cellName "/drc")
        	if(theForm->rdRunerc2->value == t then
          		runDirectory= strcat(diskPath "/PDV/" cellName "/erc")
        		);if
        	if(theForm->rdRunbiaschk2->value == t then
          		runDirectory= strcat(diskPath "/PDV/" cellName "/biaschk")
        		);if
        	if(theForm->rdRunmegb2->value == t then
          		runDirectory= strcat(diskPath "/PDV/" cellName "/megb")
        		);if		

			optform->AppleRunPDVReportFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
			optform->AppleRunPDVResultsFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
;			theForm->AppleRunPDVRunDirectory->value = strcat( NewrunDirectory "/" lowerCase(mode_arg))

;       	 theForm->AppleRunPDVRunDirectory->value = runDirectory
        	optform->AppleRunPDVReportFile2->value = runDirectory
        	optform->AppleRunPDVResultsFile2->value = runDirectory
			) ;; if DRC

		if(lowerCase(runMode) == "lvs" || runMode == "lvserc" || runMode == "lvs_extract" || lowerCase(runMode) == "iplvs" then
			printf(" USING LVS LVSERC AND LVS_EXTACCT IPLVS MODES ARE USIGNED\n\n")
			theForm->AppleRunPDVModes2->enabled = t
        	theForm->AppleRunPDVLef2->enabled = t
        	theForm->AppleRunPDVSchLibraryName2->editable = t
        	theForm->AppleRunPDVSchCellName2->editable = t
        	theForm->AppleRunPDVSchViewName2->editable = t
        	theForm->AppleRunPDVSchPath2->editable = nil
        	theForm->AppleRunPDVSchPath2->enabled = nil
        	theForm->AppleRunPDVSchPathOpt2->enabled= t

        	theForm->AppleRunPDVRelease_lay2->value = t
        	optform->AppleRunPDVHcellFile2->editable = t
        	optform->AppleRunPDVHcellFile2->enabled = t
        	theForm->AppleRunPDVHcellFileViewBtn2->enabled = t
        	optform->AppleRunPDVLVSExcludeCells2->editable = t
        	optform->AppleRunPDVLVSPower2->editable = t
        	optform->AppleRunPDVLVSGround2->editable = t
        	theForm->AppleRunPDVReportFileViewExtBtn2->enabled = t

        	project_home = getShellEnvVar("PROJECT_HOME")
        	if( project_home == nil then project_home = getShellEnvVar("PROJECT_DIR") )
			diskPath = getShellEnvVar("ECS_DISK_PATH")
        	runDirectory= strcat(diskPath "/PDV/" cellName "/lvs")
;        theForm->AppleRunPDVRunDirectory->value = runDirectory
        	optform->AppleRunPDVReportFile2->value = runDirectory
        	optform->AppleRunPDVResultsFile2->value = runDirectory

			) ;; mode LVS

		if(runMode == "ALL" then
			theForm->AppleRunPDVLef2->value = nil
  			theForm->AppleRunPDVPost2->value = nil
  			theForm->AppleRunPDVAll2->value = t
  			theForm->AppleRunPDVAll2->enabled = t
			else 
				theForm->enabled = t
				theForm->AppleRunPDVPost2->enabled = t
				);if
		if(runMode == "LEF" then
  			theForm->AppleRunPDVAll2->value = nil
  			theForm->AppleRunPDVPost2->value = nil
  			theForm->AppleRunPDVLef2->value = t 
  			theForm->AppleRunPDVLef2->enabled = t 
			else 
  				theForm->AppleRunPDVAll2->enabled = t
  				theForm->AppleRunPDVPost2->enabled = t
			);if
		if(runMode == "POST" then
  			theForm->AppleRunPDVLef2->value = nil
  			theForm->AppleRunPDVAll2->value = nil
  			theForm->AppleRunPDVPost2->value = t
  			theForm->AppleRunPDVPost2->enabled = t
			else 
  				theForm->AppleRunPDVLef2->enabled = t
  				theForm->AppleRunPDVAll2->enabled = t
			);if


		if(runMode == "ALL" || runMode == "POST" || runMode == "LEF" then
     		mode_list_value_new = list()
      		foreach(key theForm->AppleRunPDVModes2->_toggleItems
				mode_list_value_new = append1(mode_list_value_new nil)
      			);foreach
      		theForm->AppleRunPDVModes2->value = mode_list_value_new
      		theForm->AppleRunPDVModes2->enabled = nil

      		theForm->AppleRunPDVSchLibraryName2->editable = t
      		theForm->AppleRunPDVSchCellName2->editable = t
      		theForm->AppleRunPDVSchViewName2->editable = t
      		theForm->AppleRunPDVSchPath2->editable = nil
      		theForm->AppleRunPDVSchPath2->enabled = nil
      		theForm->AppleRunPDVSchPathOpt2->enabled= t

      		optform->AppleRunPDVHcellFile2->editable = t
      		optform->AppleRunPDVHcellFile2->enabled = t
      		optform->AppleRunPDVHcellFileViewBtn2->enabled = t
      		optform->AppleRunPDVLVSExcludeCells2->editable = t
      		optform->AppleRunPDVLVSPower2->editable = t
      		optform->AppleRunPDVLVSGround2->editable = t
      		optform->AppleRunPDVReportFileViewExtBtn2->enabled = t

      		optform->AppleRunPDVNoAudit2->value = nil
      		if(optform->AppleRunPDVMegacell2->value then
				optform->AppleRunPDVChecker2->value = t
      			else
					optform->AppleRunPDVChecker2->value = nil
      			); if
      		optform->AppleRunPDVRelease_lay2->value = t
      		optform->AppleRunPDVMaxErrors2->value = ""
      		optform->AppleRunPDVOpdcap2->value = nil
      		optform->AppleRunPDVNoWaivers2->value = t
      		optform->AppleRunPDVNoWaiversGds2->value = t
      		optform->AppleRunPDVNoAutoHcells2->value = t
      		;optform->AppleRunPDVDfm_guideline2 = t
			optform->AppleRunPDVReportFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
			optform->AppleRunPDVResultsFile2->value = strcat(NewrunDirectory "/" lowerCase(mode_arg))
			;theForm->AppleRunPDVRunDirectory->value = strcat( NewrunDirectory "/" lowerCase(mode_arg))

			) ; if ALL

		diskPath = getShellEnvVar("ECS_DISK_PATH")

		mode_list_items=theForm->AppleRunPDVModes2->_toggleItems
		mode_list_value=theForm->AppleRunPDVModes2->value
		i=0
		foreach(key theForm->AppleRunPDVModes2->_toggleItems
  			if(nth(i mode_list_value) == t then
        		runpdv_mode_item =  symbolToString(nth(i mode_list_items))
        		;runpdv_mode = substring(runpdv_mode_item 6 length(runpdv_mode_item)-4)
        		runpdv_mode = substring(runpdv_mode_item 6 strlen(runpdv_mode_item)-4)
				mode_arg = runpdv_mode
				runDirectory= strcat(diskPath "/PDV/" cellName "/" lowerCase(mode_arg))
				);if
   			 i++
			);foreach
;        theForm->AppleRunPDVRunDirectory->value = runDirectory
        optform->AppleRunPDVReportFile2->value = runDirectory
        optform->AppleRunPDVResultsFile2->value = runDirectory
	); let
); procedure AppleRunPDVRunChoicesCallback_32

/* Suppose to function like the perl subroutine we have to retire a file */
procedure(RetireThisFile2(myFileName)
  when(isFile(strcat(myFileName ".older"))
	 printf("\nRemoving older RunPDV log file %s" myFileName)
	 sh(strcat("rm -rf " myFileName ".older"))
  ); when
  when(isFile(strcat(myFileName ".old"))
	 printf("\nMoving old RunPDV log file")
	 sh(strcat("mv " myFileName ".old " myFileName ".older "))
  ); when
  when(isFile(myFileName)
	 printf("\nMoving RunPDV log file %s" myFileName)
	 sh(strcat("mv " myFileName " " myFileName ".old "))
  ); when
); procedure RetireThisFile2

/* Back Annotate the GDS data created by DP Merge utility */
procedure(appleRunPDVBAGdsCallback2(myForm)
	let((diskPath gdsFile cellName libraryName logFileName layerMapFileName newCV
		ba_cmd_argument RunPDVBAProcessID)
	libraryName = myForm->AppleRunPDVLayLibraryName2->value
	cellName = myForm->AppleRunPDVLayCellName2->value

; Add property on all locked data.
;AppleAddColorProp(t)
	diskPath = getShellEnvVar("ECS_DISK_PATH")
	gdsFile =  strcat(diskPath "/PDV/" cellName "/dpgdsout/mask_gen.gds")
	logFileName = strcat(diskPath "/PDV/" cellName "/dpgdsout/mask_gen.gds.colorAnnotate.log")
	layerMapFileName = strcat(getShellEnvVar("PROJECT_DIR") "/global/latest/tech/" getShellEnvVar("PROJECT_PROCESS") "/CDM/layout/virtuoso/apple2apple.map")
	printf("\ngdsFile=%s" gdsFile)
	if(! isFile(gdsFile) then 
   		hiDisplayAppDBox(
        	?name 'appleRunPDVBAGdsNotFound
        	?dboxBanner "Mask GDS to run BA flow not Found."
        	?dboxText "Mask  to run BA flow not Found.\nRun dpgdsout mode with 'Generate BA Data' option, to generate mask_gen.gds file."
        	?buttonLayout 'Close
       		)
		else 
			printf("\nRunning BA Flow.")
			 newCV = dbOpenCellViewByType(libraryName cellName "layout" "maskLayout" "r" nil)
			if(newCV~>mode != "r"  then
			printf("\n Change the cellview to read mode.")
			geChangeEditMode("r")
			);if
		ba_cmd_argument = strcat("colorAnnotate -logFile " logFileName " -strmFile " gdsFile " -library " libraryName " -topCell " cellName " -layerMap " layerMapFileName " -createColorsOnTopLevel")
		RunPDVBAProcessID=ipcBeginProcess(ba_cmd_argument "" 'myBADataHandler2 'myBADataErrorHandler2 'myBADataPostHandler)
		) ; if
	); let
); procedure appleRunPDVBAGdsCallback2

procedure(myBADataHandler2(_pid data)
let( (project_home diskPath runDirectoryPDVLog cellName )
	project_home = getShellEnvVar("PROJECT_HOME")
	unless(project_home	project_home = getShellEnvVar("PROJECT_DIR") )
	diskPath = getShellEnvVar("ECS_DISK_PATH")
	runDirectoryPDVLog= strcat(diskPath "/PDV/" cellName
    "/dpgdsout/mask_gen.gds.colorAnnotate.log")
	if(rexMatchp("Running: colorAnnotate " data) then
	view(runDirectoryPDVLog nil nil t)
	)
  );let
); procedure myBADataHandler2

procedure( myBADataErrorHandler2(_pid _data)
  fprintf(errport "\nAn error occured during the BA flow.\n")
);procedure myBADataErrorHandler2

;; Following commented-out. Not being called anywhere
;;procedure( myBADataDoneHandler(_pid _data)
;;  printf("\nDone running BA flow.")
;;  AppleRunPDV_libMgrRefresh2()
;;);procedure myBADataDoneHandler

procedure(appleRunPDVMapAllColorsToLockCallback2(myForm)
  when(myForm~>appleRunPDVMapAllColorsToLock~>value
    myForm~>AppleRunPDVMegacell~>value = nil		
  ); when	
); procedure appleRunPDVMapAllColorsToLockCallback2

procedure(AppleRunPDV_libMgrRefresh2()
	let(()
	; Refresh lib manager and close the popup
  	;; In 1 second, if a "No Data to Refresh" dialog box
  	;; appears, dismiss it. Also in 1 second, when the
  	;; "Refresh Data From Disk" appears, OK the form.
  	hiRegTimer("and(boundp('ddsDBox) ddsDBox hiDBoxOK(ddsDBox))
              and(boundp('geDBox) geDBox hiDBoxOK(geDBox))
              and(boundp('ddsRefreshForm) ddsRefreshForm
              hiFormDone(ddsRefreshForm))" 10)
  	;; Call the Refresh function
  	ddsHiRefresh()
	);let
); procedure AppleRunPDV_libMgrRefresh2

procedure(AppleRunPDVGetExtraCmdOptions2(@optional (form hiGetCurrentForm()))
  let( (cell fptr file cmd cid extra)
    cell = form->AppleRunPDVLayCellName->value || geGetEditCellView()~>cellName
    fptr = outfile(sprintf(file "/tmp/%s_%s_RunPDVGetExtraCmdOpts"
	    getShellEnvVar("USER") getShellEnvVar("PROJECT"))) ||
      error("%s: Unable to create file %L\n" getCallingFunction(0) file)
    fprintf(fptr "#!/bin/env perl\nuse PAconfig;\n
    ReadConfig(\"pdv.$ENV{PROJECT}.user\");\n
    printf \"EXTRA:$USER_PDV_OPTIONS{%s}{EXTRA_CMD_OPTIONS}\";\n" cell)
    close(fptr)
    when(isFile(file)
      cid = ipcBeginProcess(strcat("perl " file))
      ipcWait(cid)
      extra = ipcReadProcess(cid)
      extra = cadr(parseString(extra ":\n"))
    ); when
  ); let
); procedure AppleRunPDVGetExtraCmdOptions2

procedure(AppleRunPDVGetPDVModesFromPDVConfigNew2()
  let(( fid proj file (modes "") buttons pid (data "") newdata)
	proj=getShellEnvVar("PROJECT")
	;;Create the file which will contain the Perl script (to get the modes)
	fid = outfile(file = sprintf(nil "/tmp/%s_%s_RunPDVGetPdvModes" getShellEnvVar("USER") proj)) ||
		error("Unable to create file: %L\n" file)
  	;; The script
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	fprintf(fid "#!/bin/env perl\n
    use PAconfig;\n
    use perlSubs;\n
    \n
    ReadConfig(\"pdv\", \"optional\");\n
    my @pdv_modes = (); \n
    my @configModes = @{$PDV_CONFIG{PDVINFO_GLOBAL}{PDV_ALL_MODE}};\n
        foreach $m (@{configModes}) { push(@pdv_modes,$m); }\n
        @configModes = @{$PDV_CONFIG{PDVINFO_GLOBAL}{PDV_MACRO_MODE}{extra}};\n
        foreach $m (@{configModes}) { push(@pdv_modes,$m); }\n
                printf \"MODES: @pdv_modes\"; \n
    \n
    my @configButtons = @{$PDV_CONFIG{PDVINFO_GLOBAL}{PDV_GUI_BUTTONS}};\n
    print \"\nBUTTONS: @configButtons\"; \n
    \n
    " )
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    close(fid)
    info("Reading project pdv config to figure out the list of ALL PDV modes to check.\n")
    ipcWait(pid = ipcBeginProcess(sprintf(nil "perl %s" file)))
    (while newdata=(ipcReadProcess pid)
	   data=(strcat data newdata))
    (foreach line (parseString data "\n")
      when(pcreMatchp("MODES:" line)
        foreach(mode parseString(pcreReplace(pcreCompile(".*MODES: ") line "" 1) " ")
          modes = strcat(modes " " upperCase(mode) " ")
        )
      )
      when(pcreMatchp("BUTTONS:" line)
         buttons = (cdr (parseString line))
      )
    )
  (list modes buttons)
  );let
); procedure AppleRunPDVGetPDVModesFromPDVConfigNew2

procedure(AppleRunPDVGetPDVModesRVEFromPDVModesConfig2(mode_name waiver_opt rundir)
  let(( fid proj file pid rve_data (data "") (suffix "") newdata)
    proj=getShellEnvVar("PROJECT")

    fid = outfile(file = sprintf(nil "/tmp/%s_%s_RunPDVGetPdvModesRVE" getShellEnvVar("USER") proj)) ||
      error("Unable to create file: %L\n" file)

   rve_data = case(waiver_opt ("None" "rve_data") ("New" "gdswaiver_rve_data") ("Incremental" "incrwaiver_rve_data") ("None(cell-based)" "rve_data"))
    (if waiver_opt=="None(cell-based)"
      suffix=".orig")

    fprintf(fid "#!/bin/env perl\n
    use PAconfig;\n
    use perlSubs;\n
    \n
    if ($ARGV[0] eq 'all' || $ARGV[0] eq 'post') { \n
      ReadConfig(\"pdv\", \"optional\");\n
    } \n
    ReadConfig(\"pdv_modes.config\", \"optional\");\n
    if ($ARGV[0] eq 'all') { \n
      @modes = @{$PDV_CONFIG{PDVINFO_GLOBAL}{PDV_ALL_MODE}}; \n
    } elsif ($ARGV[0] eq 'post') { \n
      @modes = @{$PDV_CONFIG{PDVINFO_GLOBAL}{PDV_MACRO_MODE}{post}}; \n
    } else { \n
      @modes = @ARGV; \n
    } \n
    foreach my $mode (@modes) { \n
     if($Gtech{PDV}{MODES}{$mode}{%s}) { \n
        $output .= \"%s/$mode/$Gtech{PDV}{MODES}{$mode}{%s}%s \"; \n
    } else { $output .= \"%s/$mode/${mode}_all.rep%s \"; }\n } print \"$output\"; \n
	\n " rve_data rundir rve_data suffix rundir suffix)

    close(fid)
    info("Reading project pdv_modes config to figure out the RVE file name for a mode.\n")
    ipcWait(pid = ipcBeginProcess(sprintf(nil "perl %s %s" file buildString(mode_name))))
    (while newdata=(ipcReadProcess pid)
	   data=(strcat data newdata))
    data
  );let
); procedure AppleRunPDVGetPDVModesRVEFromPDVModesConfig2

procedure(AppleRunPDVRunChoicesCallback_42( theForm)
	let((using_lvs cellName project_home )
		using_lvs = "no"
		foreach(key theForm->AppleRunPDVModes2->_toggleItems
			when(rexMatchp("mode_LVS" symbolToString(key))
				if(theForm->AppleRunPDVModes2->mode_LVS->value == t then
					using_lvs = "yes"
					else
						using_lvs = "no"
					);if
				); when
			); foreach
		cellName = theForm->AppleRunPDVLayCellName2->value
		project_home = getShellEnvVar("PROJECT_HOME")
		if( project_home == nil then project_home = getShellEnvVar("PROJECT_DIR") )
		;;not used diskPath = getShellEnvVar("ECS_DISK_PATH")
		if(rexMatchp("yes" using_lvs) then
			theForm->AppleRunPDVSchPathOpt2->enabled = t
			if(theForm->AppleRunPDVSchPathOpt2->value == t then
				theForm->AppleRunPDVSchLibraryName2->enabled = nil
				theForm->AppleRunPDVSchCellName2->enabled = nil
				theForm->AppleRunPDVSchViewName2->enabled = nil
				theForm->AppleRunPDVSchLibraryName2->editable = nil
				theForm->AppleRunPDVSchCellName2->editable = nil
				theForm->AppleRunPDVSchViewName2->editable = nil
				theForm->AppleRunPDVSchPath2->editable = t 
				theForm->AppleRunPDVSchPath2->enabled = t 
				else
					theForm->AppleRunPDVSchLibraryName2->enabled = t
					theForm->AppleRunPDVSchCellName2->enabled = t
					theForm->AppleRunPDVSchViewName2->enabled = t
					theForm->AppleRunPDVSchLibraryName2->editable = t
					theForm->AppleRunPDVSchCellName2->editable = t
					theForm->AppleRunPDVSchViewName2->editable = t					
				);if
			AppleOptsForm->AppleRunPDVHcellFile2->editable = t
			AppleOptsForm->AppleRunPDVLVSExcludeCells2->editable = t
			AppleOptsForm->AppleRunPDVLVSPower2->editable = t
			AppleOptsForm->AppleRunPDVLVSGround2->editable = t
			AppleOptsForm->AppleRunPDVHcellFile2->enabled = t
			AppleOptsForm->AppleRunPDVHcellFileViewBtn2->enabled = t
			AppleOptsForm->AppleRunLVSFXOption2->enabled = t
			else 
				;;not doing lvs
				theForm->AppleRunPDVSchPathOpt2->enabled = nil 
				theForm->AppleRunPDVSchLibraryName2->editable = nil 
				theForm->AppleRunPDVSchPath2->editable = nil 
				theForm->AppleRunPDVSchPath2->enabled = nil 
				theForm->AppleRunPDVSchCellName2->editable = nil 
				theForm->AppleRunPDVSchViewName2->editable = nil
				AppleOptsForm->AppleRunPDVHcellFile2->editable = nil 
				AppleOptsForm->AppleRunPDVLVSExcludeCells2->editable = nil 
				AppleOptsForm->AppleRunPDVLVSPower2->editable = nil 
				AppleOptsForm->AppleRunPDVLVSGround2->editable = nil 
				AppleOptsForm->AppleRunPDVHcellFile2->enabled = nil
				AppleOptsForm->AppleRunPDVHcellFileViewBtn2->enabled = nil 
				AppleOptsForm->AppleRunLVSFXOption2->enabled = nil
			); if
		AppleUpdateCommandLine( theForm)
	);  let
); procedure AppleRunPDVRunChoicesCallback_42

procedure(AppleRunPDVOptionsCB2(optform)
	let(( )
		hiDisplayForm(optform)
		putprop(optform 'AppleRunPDVFormHelpCB2 'hiHelpAction)
        ); let
);AppleRunPDVOptionsCB2

;procedure(AppleRunOutputOptionsCB2(theForm)
;        let(( )
;             hiDisplayForm(outputForm)
;       ); let
;);AppleRunOutputOptionsCB2

;procedure(AppleRunDataOptionsCB2(theForm)
;        let(( )
;             hiDisplayForm(runDataForm)
;        ); let
;);AppleRunDataOptionsCB2

procedure(AppleOptsForm(parentForm)
        prog((optsForm optTopFrame )
			 ;AppleRunPDVChecker AppleRunPDVDfm_guideline AppleRunPDVMegaReleaseVersion
			;AppleRunLVSFXOption AppleAPSUBOtherOpt AppleRunPDVHcellFile AppleRunPDVHcellFileViewBtn
			;AppleRunPDVLVSExcludeCells AppleRunPDVLVSGround AppleRunPDVLVSPower AppleRunPDVMaxErrors
			;AppleRunPDVMegacell AppleRunPDVNoAudit AppleRunPDVNoAutoHcells AppleRunPDVNoWaivers AppleRunPDVNoWaiversGds
			;AppleRunPDVNumProc	AppleRunPDVOpdcap AppleRunPDVNo_ip_tighten AppleRunPDVQueue AppleRunPDVRelease_lay
			;AppleRunPDVReportFile AppleRunPDVReportFileViewExtBtn AppleRunPDVResultsFile AppleRunPDVRunDirectory
			;AppleRunPDVRunQueue AppleRunPDVRunFlat AppleRunPDVShort_equiv_nets AppleRunPDVVirtualConnColon
			;AppleRunPDVVirtualConnName AppleRunPDVWorkspace AppleRunPDVFormInitFile)  
		optTopFrame = hiCreateFormLayout('optMainLayout 
			?frame "main opt"
			?horiz_align 'left
			?items 
				list(
					hiCreateGridLayout('runOptions
						?frame "PDV run options"
						?items list(
							list(AppleRunPDVChecker 		'horiz_align 'left 'row 0 'col 0)
							list(AppleRunPDVShort_equiv_nets 'horiz_align 'left 'row 0 'col 1)
							list(AppleRunPDVNoAudit			'horiz_align 'left 'row 0 'col 2)
							list(AppleRunPDVNo_ip_tighten 	'horiz_align 'left 'row 1 'col 0)
							list(AppleRunPDVRelease_lay 	'horiz_align 'left 'row 1 'col 1)
							list(AppleRunPDVNoWaivers 		'horiz_align 'left 'row 1 'col 2)
							list(AppleRunPDVMegacell 		'horiz_align 'left 'row 2 'col 0)
							list(AppleRunPDVNoWaiversGds 	'horiz_align 'left 'row 2 'col 1)
							list(AppleRunPDVNoAutoHcells 	'horiz_align 'left 'row 2 'col 2)
							list(AppleRunPDVOpdcap 			'horiz_align 'left 'row 3 'col 0)
							)
						)
					hiCreateGridLayout('lvsOptions
						?frame "LVS options"
						?items list(
							list(AppleRunPDVVirtualConnColon 	'horiz_align 'left 'row 0 'col 0)
							list(AppleRunPDVRunFlat				'horiz_align 'left 'row 1 'col 0)
							list(AppleRunPDVVirtualConnName		'horiz_align 'left 'row 2 'col 0)	
	  						list(AppleRunPDVHcellFile			'horiz_align 'left 'row 3 'col 0)
	  						list(AppleRunPDVHcellFileViewBtn 	'horiz_align 'left 'row 4 'col 0)
							list(AppleRunPDVLVSExcludeCells		'horiz_align 'left 'row 5 'col 0)
							list(AppleRunPDVLVSPower			'horiz_align 'left 'row 6 'col 0)
	  						list(AppleRunPDVLVSGround			'horiz_align 'left 'row 7 'col 0)
							list(AppleRunLVSFXOption			'horiz_align 'left 'row 8 'col 0)
							)
						)
						;hiCreateGridLayout('Advanced_Node_Options
						;?frame "Advanced node options"
						;?items list(
						;	list(appDpColoredGdsOut				'row 2 'col 0)
	 					;	list(appleRunPDVMapAllColorsToLock	'row 3 'col 0)
						;	list(applRunPDVGenBAData			'row 4 'col 0)
						;	list(appleRunPDVBAGds				'row 5 'col 0)
						;	list(applRunPDVLockAllBAData		'row 6 'col 0)
						;	list(appDpColoredView				'row 7 'col 0)
						;	)
						;)
						hiCreateGridLayout('miscOptions
						?items list(
							list(AppleRunPDVRunQueue 			'row 0 'col 0)
							list(AppleAPSUBOtherOpt   			'row 0 'col 1 'col_span 15)
							;list(AppleRunPDVDfm_guideline		'row 1 'col 0)		
							list(AppleRunPDVMaxErrors			'row 3 'col 0)
							list(AppleRunPDVNumProc				'row 3 'col 5)
							list(AppleRunPDVQueue				'row 3 'col 6)	
							);list
						);hiCreateGridLayout
					list(editor_list)
					list(AppleRunPDVWorkspace)
					;list(AppleRunPDVOtherOpt)
					list(AppleRunPDVFormInitFile)
					;list(AppleRunPDVExtraCmdOpts)
	  				list(AppleRunPDVReportFile)
					list(AppleRunPDVRunDirectory) 
					list(AppleRunPDVResultsFile)
					list(AppleRunPDVReportFileViewExtBtn)
					list(AppleRunPDVMegaReleaseVersion)
					);list
				);
         optsForm = hiCreateLayoutForm(
           	'optForm
			"Advanced options"
			optTopFrame
			?sizePolicy 'expanding 
			?minSize list(700 400)
			;?buttonLayout 'Close
			?buttonLayout 'OKCancel
            ) ;hiCreateAppForm
	;hiInstantiateForm(optsForm)
	return(optsForm)
 );prog
);AppleOptsForm


procedure(AppleRunPDVEnableAll2(optform form)
;; Enable all buttons and fields. Normally this is run once the RunPDV has completed, or the stop button has been pressed.
	let(()
		AppleRunPDVShowMeCommand_wrap2( form nil)
	);let
);AppleRunPDVEnableAll2

procedure(AppleAPDVGUI2Help(@optional (form hiGetCurrentForm()))
	let( (toolTipPDV2 toolTipVal )
		toolTipPDV2 = list(nil
			'AppleRunPDVAll2 			"Turn on all available checks for this project"
			'GlobalPDVButtons			"Project-specific modes. Click help for more information"
			'AppleRunPDVNone2			"Turn off all available checks for this project"
			'AppleRunPDVPost2			"Turn on post-layout analysis checks "
			'AppleRunPDVAllMode2 		"Turn on '-mode all' option. Not the same as turning on all the check boxes above"
      		'AppleRunPDVLayLibraryName2	"Layout library name"
      		'AppleRunPDVLayCellName2	"Layout cell name"
      		'AppleRunPDVLayViewName2	"Layout view name"
      		'AppleRunPDVLayPathOpt2		"Use a GDS file instead of the Virtuoso view"
      		'AppleRunPDVLayPath2		"Path to GDS file "
     		'AppleRunPDVSchLibraryName2	"Schematic library name"
      		'AppleRunPDVSchCellName2	"Schematic cell name"
      		'AppleRunPDVSchViewName2	"Schematic view name"
      		'AppleRunPDVSchPathOpt2		"Use a CDL file instead of the Virtuoso view"
      		'AppleRunPDVSchPath2		"Path to CDL file"
			'AppleRunPDVUseOvdir2		"Use an ovdir"      
      		'AppleRunPDVOvdirPath2		"Path of ovdir to use"
      		'AppleRunPDVExtraCmdOpts2	"Information field: Extra command options found in the PDV config, from the Megacell Info Editor are displayed here"
			'AppleRunPDVLoadOptionsBtn2	"Load form settings from file"
			'AppleRunPDVSaveOptionsBtn2	"Save form settings to a file"
			'AppleRunPDVOptions2		"Opens  Advanced Options form"
			'AppleRunPDVStartBtn2		"Start the (RunPDV) job"
			'AppleRunPDVStopBtn2		"Stop the (RunPDV) job"
			'AppleGdsWaiver2			"RVE report file for waiver flow"
			'AppleRunPDVStartRVEBtn2	"Start RVE"
			'AppleGenPDVWaiverBtn2		"Export waivers"
			'AppleGenPDFBtn2			"Generate PDF"
			'AppleGenPDFWithSnapBtn2	"PDF"
			'AppleRunPDVRunPDVcmd2		"Display RunPDV command line as built by this form"
			'AppleRunPDVLef2			"Run PDV mode 'lef'"
			);list
      ;'AppleRunPDVModes			"Various Run PDV modes"
      ;'appDpColoredGdsOut		"Create decomposed GDS, -drc_auto_dpgds option"
      ;'appleRunPDVMapAllColorsToLock	"Adds command line argument to map all color data to 'locked'"
      ;'applRunPDVGenBAData		"Generate back annotation data, -genBAData option"
     ; 'appleRunPDVBAGds			"Back annotate GDS created from DP Merge utility. Runs 'colorAnnotate' in the background"
;      'applRunPDVLockAllBAData		"Lock all BA Data" ; invisible/unused
;      'appDpColoredView		"Create decomposed layout, -dp_colored_view option" ; invisible/unused
;      'AppleRunPDVDfm_guideline	"drc dfm guidleline" ; invisible/unused
;      'AppleRunPDVViewRunLog		"View Run Log" ; invisible/unused
    ;'AppleRunPDVReportFileViewBtn	"View report/summary file. Uses Report/Summary file/dir first and then Run Directory to look for files"
    ;  'AppleRunPDVReportFileViewLogBtn	"View log file. Uses Report/Summary file/dir first and then Run Directory to look for log files"
    ;  'AppleRunPDVScoreFileViewBtn	"View DFM Score file"
     ; 'AppleRunPDVFormInitFile		"Initialization file for RunPDV form"
    ;  'AppleRunPDVRefreshOptionsBtn	"Refresh the form, e.g. if current cellview has changed"
    ; Apply the tooltips to the form
    foreach(key toolTipPDV2->?
      when(member(key form->fieldList)
        toolTipVal=get(toolTipPDV2 key)
	cond(
	  (stringp(toolTipVal)
	    putprop(get(form key) AppleFoldStr(toolTipVal) 'hiToolTip)
	  )
	  (listp(toolTipVal)
	    putprop(get(form key) foreach(mapcar x toolTipVal AppleFoldStr(x)) 'hiToolTip)
	  )
	); cond
      ); when
    ); foreach
  ); let
); procedure AppleAPDVGUI2Help

procedure(AppleAPDVGUI2OptionsHelp(@optional (form hiGetCurrentForm()))
	let( (toolTipPDV2 toolTipVal )
		toolTipPDV2 = list(nil
			'AppleRunPDVChecker2				"Perform extra Apple-specific checks,like naming conventions etc."
			'AppleRunPDVShort_equiv_nets2		"Option -short_equivalent_nodes. Nodes that are electrically equivalent but not physically connected are considered shorted for LVS"
			'AppleRunPDVNoAudit2				"If off, do not run the audit - not for final runs, -noaudit option"
			'AppleRunPDVOpdcap2					"Create opportunistic decoupling capacitors where space permits"
			'AppleRunPDVNoWaivers2				"Ignore waiver text file if off, -no_waivers option"
			'AppleRunPDVNoWaiversGds2			"Turn on/off picking of waiver GDS, -no_waivergds option"
			'AppleRunPDVNoAutoHcells2			"If off, don't auto figure any hcells, only consider hcells supplied from the command line option, -no_auto_hcells option"
			'AppleRunPDVNo_ip_tighten2			"Check using tighter design rules for metal density checks (advanced nodes)"
			'AppleRunPDVRelease_lay2			"Create a release. Consider using the stand-alone utility instead"
			'AppleRunPDVMegacell2				"Option -megacell"
			'AppleRunPDVVirtualConnColon2		"Virtual connect colon, -vconn_colon option"
			'AppleRunPDVVirtualConnName2		"Connect by name, --connectByName option"
			'AppleRunPDVHcellFile2				"File containing Hcells, -hcells"
			'AppleRunPDVHcellFileViewBtn2		"View Hcell file"
			'AppleRunPDVLVSExcludeCells2		"LVS Exclude Cells, -exclude_cells passed to drcshort"
			'AppleRunPDVLVSPower2				"LVS Power. Additional power names (-additional_power option). Seperate multiple names with a space"
			'AppleRunPDVLVSGround2				"LVS Ground. Additional ground names (-additional_ground option). Seperate multiple names with a space"
			'AppleRunPDVMaxErrors2				"Maximum DRC errors to allow, -max_drc_errors option"
			'AppleRunPDVNumProc2				"Number of processors, -turbo option"
			'AppleRunPDVRunFlat2				"Run flat, no Hcells, not for general use, -flat option"
			'AppleRunPDVQueue2					"RunPDV Queue"
			'editor_list2						"Editor to use for PDV Report, DFM Score, View Log, Extraction Report, View Hcell ..."
			'AppleRunLVSFXOption2				"When running RVE, the Calibre LVSFX option is invoked to show hints for fixing LVS issues"
			'AppleRunPDVRunQueue2				"Submit job to named queue"
			'AppleAPSUBOtherOpt2				"Other queue otions for apsub"
			'AppleRunPDVWorkspace2				"Workspace directory"
			'AppleRunPDVFormInitFile2			"Options file"
			'AppleRunPDVReportFile2				"Report/Summary file or directory used as start of search. If blank the Run Directory is used as a base for the search."
			'AppleRunPDVOtherOpt2				"Additional command line options to supply to RunPDV. Use RunPDV -help from command line to check syntax"
			'AppleRunPDVRunDirectory2			"Directory where RunPDV will operate"
			'AppleRunPDVResultsFile2			"RVE results file"
			'AppleRunPDVReportFileViewExtBtn2	"View extraction report file. Uses Report/Summary file/dir first and then Run Directory to look for files"
			'AppleRunPDVMegaReleaseVersion2		"The release area where Verilog netlist resides for createLef pre-release validation, -check_release_lef option"
 		);list
   ; Apply the tooltips to the form
    foreach(key toolTipPDV2->?
      when(member(key form->fieldList)
        toolTipVal=get(toolTipPDV2 key)
	cond(
	  (stringp(toolTipVal)
	    putprop(get(form key) AppleFoldStr(toolTipVal) 'hiToolTip)
	  )
	  (listp(toolTipVal)
	    putprop(get(form key) foreach(mapcar x toolTipVal AppleFoldStr(x)) 'hiToolTip)
	  )
	); cond
      ); when
    ); foreach
  ); let
);AppleAPDVGUI2OptionsHelp

procedure(AppleRunPdvExampleThumbnailForm()
    let((lib cell view thumbnailIcon browse)
        lib=hiCreateStringField(
            ?name 'lib
            ?prompt "Library"
            ?callback "AppleRunPdvThumbnailSyncWithForm(hiGetCurrentForm() 'lib)"
        )
        cell=hiCreateStringField(
            ?name 'cell
            ?prompt "Cell"
            ?callback "AppleRunPdvThumbnailSyncWithForm(hiGetCurrentForm() 'cell)"
        )
        view=hiCreateStringField(
            ?name 'view
            ?prompt "View"
            ?callback "AppleRunPdvThumbnailSyncWithForm(hiGetCurrentForm() 'view)"
        )
        ;----------------------------------------------------------------
        ; Create a thumbnail with the labelText set to an (almost)
        ; empty string. It needs to have a space in it because either
        ; the labelText or labelIcon have to be specified.
        ;----------------------------------------------------------------
        thumbnailIcon=hiCreateLabel(
            ?name 'thumbnailIcon
            ?labelText " "
        )
        browse=hiCreateButton(
            ?buttonText "Browse"
            ?name 'browse
            ?callback "AppleRunPdvThumbnailSyncWithBrowser(hiGetCurrentForm())"
        )
        hiCreateAppForm(
            ?name 'AppleRunPdvThumbnailForm
            ?formTitle "Select a lib:cell:view"
            ?fields
                list(
                    list(lib 0:0 400:30 100)
                    list(cell 0:30 400:30 100)
                    list(view 0:60 400:30 100)
                    list(thumbnailIcon 420:5 64:64)
                    list(browse 100:90 100:30)
                )
            ?attachmentList
                list(
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicTopPositionSet
                )
            ?initialSize 500:120
        );hiCreateAppForm
        
    )
);AppleRunPdvThumbnailForm

/***************************************************************
*                                                              *
*               AppleRunPdvcreateExampleThumbnailForm()                *
*                                                              *
*                   Create the example form.                   *
*                                                              *
***************************************************************/
procedure(AppleRunPdvcreateExampleThumbnailForm()
    let((lib cell view thumbnailIcon browse)
        lib=hiCreateStringField(
            ?name 'lib
            ?prompt "Library"
            ?callback "AppleRunPdvThumbnailSyncWithForm(hiGetCurrentForm() 'lib)"
        )
        cell=hiCreateStringField(
            ?name 'cell
            ?prompt "Cell"
            ?callback "AppleRunPdvThumbnailSyncWithForm(hiGetCurrentForm() 'cell)"
        )
        view=hiCreateStringField(
            ?name 'view
            ?prompt "View"
            ?callback "AppleRunPdvThumbnailSyncWithForm(hiGetCurrentForm() 'view)"
        )
        ;----------------------------------------------------------------
        ; Create a thumbnail with the labelText set to an (almost)
        ; empty string. It needs to have a space in it because either
        ; the labelText or labelIcon have to be specified.
        ;----------------------------------------------------------------
        thumbnailIcon=hiCreateLabel(
            ?name 'thumbnailIcon
            ?labelText " "
        )
        browse=hiCreateButton(
            ?buttonText "Browse"
            ?name 'browse
            ?callback "AppleRunPdvThumbnailSyncWithBrowser(hiGetCurrentForm())"
        )
        hiCreateAppForm(
            ?name 'AppleRunPdvThumbnailForm
            ?formTitle "Select a view"
            ?fields
                list(
                    list(lib 0:0 400:30 100)
                    list(cell 0:30 400:30 100)
                    list(view 0:60 400:30 100)
                    list(thumbnailIcon 420:5 64:64)
                    list(browse 100:90 100:30)
                )
            ?attachmentList
                list(
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicRightPositionSet|hicTopPositionSet
                    hicRightPositionSet|hicTopPositionSet
                    hicLeftPositionSet|hicTopPositionSet
                )
            ?initialSize 500:120
        )
        ;AppleRunPdvThumbnailForm
    )
)
/***************************************************************
*                                                              *
*          AppleRunPdvThumbnailSyncWithBrowser(form)            *
*                                                              *
*                   Launch the file browser                    *
*                                                              *
***************************************************************/

procedure(AppleRunPdvThumbnailSyncWithBrowser(form)
    ddsSyncWithForm(form 'browse 'lib 'cell 'view)
);AppleRunPdvThumbnailSyncWithBrowser
    
/***************************************************************
*                                                              *
*        AppleRunPdvThumbnailSyncWithForm(form _field)          *
*                                                              *
* Synchronize changes in the typed-in fields with the browser. *
*                 Also updates the thumbnail.                  *
*                                                              *
***************************************************************/

procedure(AppleRunPdvThumbnailSyncWithForm(form _field)
    ddsUpdateSyncWithForm()
    AppleRunPdvThumbnailUpdateIcon(form)
);AppleRunPdvThumbnailSyncWithForm

/***************************************************************
*                                                              *
*             AppleRunPdvThumbnailUpdateIcon(form)              *
*                                                              *
* Update the icon on the form - either to the thumbnail image  *
* or to blank if the view doesn't have one or it is an invalid *
*                          view name                           *
*                                                              *
***************************************************************/

procedure(AppleRunPdvThumbnailUpdateIcon(form)
    let((lib cell view icon file)
        lib=form->lib->value
        cell=form->cell->value
        view=form->view->value
        unless(blankstrp(lib) || blankstrp(cell) || blankstrp(view)
            file=ddGetObj(lib cell view hiGetThumbnailFilename())->readPath
            when(file
                icon=hiLoadImageFile(file 64 64)
            )
        )
        unless(icon
            icon=" "
        )
        form->thumbnailIcon->value=icon
        if(file then
            ;------------------------------------------------------------
            ; Fancy tooltip using HTML
            ;------------------------------------------------------------
            form->thumbnailIcon->hiToolTip=sprintf(nil "<table><tr bgcolor='black'><td><center><img src='%s'></center></td></tr><tr><td>%s %s %s</tr></td></table>" file lib cell view)
        else
            form->thumbnailIcon->hiToolTip=""
        )
    )
);AppleRunPdvThumbnailUpdateIcon

procedure(AppleRunPdvThumbnailForm(type)
	prog(()
    unless(boundp('AppleRunPdvThumbnailForm)
        AppleRunPdvExampleThumbnailForm()
    )
	;; seed the l/c/v form
	if(type == "layout" then
		AppleRunPdvThumbnailForm->lib->value = AppleRunPDVForm2->AppleRunPDVLayLibraryName2->value
		AppleRunPdvThumbnailForm->cell->value = AppleRunPDVForm2->AppleRunPDVLayCellName2->value
		AppleRunPdvThumbnailForm->view->value = AppleRunPDVForm2->AppleRunPDVLayViewName2->value
		else
			if(type == "schematic" then
			AppleRunPdvThumbnailForm->lib->value = AppleRunPDVForm2->AppleRunPDVSchLibraryName2->value
			AppleRunPdvThumbnailForm->cell->value = AppleRunPDVForm2->AppleRunPDVSchCellName2->value
			AppleRunPdvThumbnailForm->view->value = AppleRunPDVForm2->AppleRunPDVSchViewName2->value			
		);if
	);if
    	AppleRunPdvThumbnailUpdateIcon(AppleRunPdvThumbnailForm)
    	hiDisplayForm(AppleRunPdvThumbnailForm)
	;; update the new fields in the main form
	if(type == "layout" then
		AppleRunPDVForm2->AppleRunPDVLayLibraryName2->value = AppleRunPdvThumbnailForm->lib->value
		AppleRunPDVForm2->AppleRunPDVLayCellName2->value = AppleRunPdvThumbnailForm->cell->value
		AppleRunPDVForm2->AppleRunPDVLayViewName2->value = AppleRunPdvThumbnailForm->view->value
		else
			if(type == "schematic" then
			AppleRunPDVForm2->AppleRunPDVSchLibraryName2->value = AppleRunPdvThumbnailForm->lib->value
			AppleRunPDVForm2->AppleRunPDVSchCellName2->value = AppleRunPdvThumbnailForm->cell->value
			AppleRunPDVForm2->AppleRunPDVSchViewName2->value	= AppleRunPdvThumbnailForm->view->value		
		);if
	);if
		return(t)
	);prog
);AppleRunPDVThumbnailForm

procedure(AppleRunPDVFT(theForm)
	prog((i project_name fid proj)
		proj = getShellEnvVar("PROJECT")
		project_name = getShellEnvVar("VOV_PROJECT_NAME")
		host_name = getShellEnvVar("VOV_HOST_NAME")
		ftfile = strcat("/tmp/" getLogin() "_PDV_FT_file.csh")
		if(isFile(ftfile) 	
			system(sprintf(nil "rm %s" ftfile)
			);if just in case an old file is lying around from a previous run
		);if		
		fPort = outfile(ftfile)
		fprintf(fPort "#! /bin/tcsh\n")
	    fprintf(fPort "module unload flowtracer\n")
	    fprintf(fPort "module load flowtracer/2016.03\n")
	    fprintf(fPort "setenv VOV_PROJECT_NAME %s\n" project_name )
	    fprintf(fPort "vovproject create %s\n" project_name)
	    fprintf(fPort "vovproject enable %s\n" project_name)
	    fprintf(fPort "vovconsole\n")
		close(fPort)
		system(sprintf(nil "chmod +x %s" ftfile))
		printf("\nStarting FlowTracer. Please wait... \n")
		cid = ipcBeginProcess(sprintf(nil "%s" ftfile) ""  nil nil "AppleRunPDVReset")
;		ipcWait(fid)
		return(nil)
	);prog
);AppleRunPDVFT

procedure(AppleRunPDVReset(cid exit)
	let(()
		AppleRunPDVForm2->AppleRunPDVStartBtn2->enabled=t
		AppleRunPDVForm2->AppleRunPDVStopBtn2->enabled=nil
	);let
);AppleRunPDVReset
