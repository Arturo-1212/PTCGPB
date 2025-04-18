global adbPort, adbShell, adbPath, debugMode, discordWebhookURL, discordUserId, sendAccountXml

; ============================================================================
; Image Recognition Functions
; ============================================================================
GetNeedle(Path) {
    static NeedleBitmaps := Object()
    if (NeedleBitmaps.HasKey(Path)) {
        return NeedleBitmaps[Path]
    } else {
        pNeedle := Gdip_CreateBitmapFromFile(Path)
        NeedleBitmaps[Path] := pNeedle
        return pNeedle
    }
}
; ============================================================================
; Status Display Functions
; ============================================================================
; filepath: c:\Users\Gabriel\Documents\GitHub\PTCGPB\Scripts\Include\Utils.ahk
; Add this function to the Utils.ahk file

CreateStatusMessage(Message, GuiName := "StatusMessage", X := 0, Y := 80, enableThrottling := true, updateInterval := 0.5) {
    global scriptName, winTitle, StatusText, showStatus
    static statusLastMessage := {}, statusLastUpdateTime := {}, hwnds := {}
    static statusUpdateInterval := updateInterval
    
    if(!showStatus)
        return
    
    ; Handle the different types of GuiName (string or number)
    if GuiName is integer
        uniqueGuiName := GuiName . scriptName
    else
        uniqueGuiName := GuiName
    
    ; Create a unique key for this GuiName/position combination
    messageKey := uniqueGuiName . ":" . X . ":" . Y
    currentTime := A_TickCount / 1000
    
    ; If throttling is enabled and the same message was displayed recently in the same location
    if (enableThrottling && statusLastMessage.HasKey(messageKey) && statusLastMessage[messageKey] = Message) {
        ; Only update if enough time has passed since the last update
        if (currentTime - statusLastUpdateTime[messageKey] < statusUpdateInterval) {
            return
        }
    }
    
    ; Update our record of this message
    statusLastMessage[messageKey] := Message
    statusLastUpdateTime[messageKey] := currentTime
    
    try {
        ; Check if GUI with this name already exists
        if !hwnds.HasKey(uniqueGuiName) {
            WinGetPos, xpos, ypos, Width, Height, %winTitle%
            X := X + xpos + 5
            Y := Y + ypos
            if(!X)
                X := 0
            if(!Y)
                Y := 0

            ; Create a new GUI with the given name, position, and message
            Gui, %uniqueGuiName%:New, -AlwaysOnTop +ToolWindow -Caption
            Gui, %uniqueGuiName%:Margin, 2, 2  ; Set margin for the GUI
            Gui, %uniqueGuiName%:Font, s8  ; Set the font size to 8 (adjust as needed)
            Gui, %uniqueGuiName%:Add, Text, hwndhCtrl vStatusText,
            hwnds[uniqueGuiName] := hCtrl
            OwnerWND := WinExist(winTitle)
            Gui, %uniqueGuiName%:+Owner%OwnerWND% +LastFound
            DllCall("SetWindowPos", "Ptr", WinExist(), "Ptr", 1  ; HWND_BOTTOM
                , "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)  ; SWP_NOSIZE, SWP_NOMOVE, SWP_NOACTIVATE
            Gui, %uniqueGuiName%:Show, NoActivate x%X% y%Y% AutoSize
        }
        SetTextAndResize(hwnds[uniqueGuiName], Message)
        Gui, %uniqueGuiName%:Show, NoActivate AutoSize
    }
}
resetWindows(Title="", UseSelectedMonitor="", createToolbar=true) {
    global Columns, runMain, Mains, scaleParam, winTitle, SelectedMonitorIndex, scriptName
    
    LogDebug("resetWindows started. Title: [" . Title . "], Monitor: [" . UseSelectedMonitor . "]")
    
    ; Use parameters if provided, otherwise use global variables
    currentTitle := (Title != "") ? Title : winTitle
    currentMonitor := (UseSelectedMonitor != "") ? UseSelectedMonitor : SelectedMonitorIndex
    
    ; Strip .ahk from scriptName for comparison
    baseScriptName := RegExReplace(scriptName, "\.ahk$", "")
    
    LogDebug("Using title: [" . currentTitle . "], monitor: [" . currentMonitor . "]")
    
    ; Check if window exists before attempting to position it
    if (!WinExist(currentTitle)) {
        LogDebug("Window does not exist: " . currentTitle)
        return false
    }
    
    CreateStatusMessage("Arranging window positions and sizes")
    
    ; Get monitor origin from index
    currentMonitor := RegExReplace(currentMonitor, ":.*$")
    SysGet, Monitor, Monitor, %currentMonitor%
    
    ; Determine instance index based on title
    if (InStr(currentTitle, "Main") = 1) {
        ; Handle Main, Main2, Main3, etc.
        instanceIndex := StrReplace(currentTitle, "Main", "")
        instanceIndex := (instanceIndex = "") ? 1 : instanceIndex
        LogDebug("Main window detected. Instance index: " . instanceIndex)
    } else {
        ; Handle numeric titles (1, 2, 3, etc)
        instanceIndex := (runMain && Mains > 0) ? (Mains + currentTitle) : currentTitle
        LogDebug("Numeric window detected. Instance index: " . instanceIndex)
    }
    
    ; Calculate position
    rowHeight := 533
    currentRow := Floor((instanceIndex - 1) / Columns)
    y := currentRow * rowHeight
    x := Mod((instanceIndex - 1), Columns) * scaleParam
    
    ; Move the window
    WinMove, %currentTitle%, , % (MonitorLeft + x), % (MonitorTop + y), scaleParam, 537
    
    ; After moving the window, create the toolbar GUI only if requested
    if (createToolbar && currentTitle != "PTCGPB") {
        Sleep, 500  ; Small delay to ensure the window is stable
        LogDebug("Attempting to create toolbar for " . currentTitle . " (baseScriptName = " . baseScriptName . ")")
        CreateToolbarGUI(currentTitle, scaleParam)
    } else {
        LogDebug("Skipping toolbar creation for " . currentTitle)
    }
    
    return true
}
CreateToolbarGUI(targetWindow, scaleParam) {
    global Delay, scriptName
    
    ; Strip .ahk from scriptName for comparison
    baseScriptName := RegExReplace(scriptName, "\.ahk$", "")
    
    ; Skip for PTCGPB window or if the title contains "PTCGPB Bot Setup"
    if (targetWindow = "PTCGPB" || InStr(targetWindow, "PTCGPB Bot Setup")) {
        LogDebug("Skipping toolbar for PTCGPB window: " . targetWindow)
        return true
    }
    
    MaxRetries := 10
    RetryCount := 0
    
    CreateStatusMessage("Creating toolbar for " . targetWindow . "...")
    LogInfo("Creating toolbar for " . targetWindow . "...")
    
    ; Check if this is a Main window
    isMainWindow := InStr(targetWindow, "Main") = 1
    
    Loop {
        try {
            ; Ensure window exists and get position
            if (!WinExist(targetWindow)) {
                throw Exception("Window not found: " . targetWindow)
            }
            
            WinGetPos, x, y, Width, Height, %targetWindow%
            if (ErrorLevel) {
                throw Exception("Failed to get window position")
            }
            
            ; Calculate toolbar position
            x4 := x + 5
            y4 := y + 44
            buttonWidth := 38
            if (scaleParam = 287)
                buttonWidth := buttonWidth + 6
            
            ; Get window handle
            OwnerWND := WinExist(targetWindow)
            
            ; Create unique toolbar name
            toolbarName := targetWindow . "Toolbar"
            
            ; Destroy existing toolbar if any
            Gui, %toolbarName%: Destroy
            
            ; Create new toolbar GUI
            Gui, %toolbarName%: New, +Owner%OwnerWND% +ToolWindow -Caption +LastFound
            Gui, %toolbarName%: Default
            Gui, %toolbarName%: Margin, 4, 4
            Gui, %toolbarName%: Font, s6 cGray Norm Bold, Segoe UI
            
            ; Always add these buttons
            Gui, %toolbarName%: Add, Button, % "x" . (buttonWidth * 0) . " y0 w" . buttonWidth . " h25 gReloadScript", Reload (Shift+F5)
            Gui, %toolbarName%: Add, Button, % "x" . (buttonWidth * 1) . " y0 w" . buttonWidth . " h25 gPauseScript", Pause (Shift+F6)
            Gui, %toolbarName%: Add, Button, % "x" . (buttonWidth * 2) . " y0 w" . buttonWidth . " h25 gResumeScript", Resume (Shift+F6)
            Gui, %toolbarName%: Add, Button, % "x" . (buttonWidth * 3) . " y0 w" . buttonWidth . " h25 gStopScript", Stop (Shift+F7)
            Gui, %toolbarName%: Add, Button, % "x" . (buttonWidth * 4) . " y0 w" . buttonWidth . " h25 gShowStatusMessages", Status (Shift+F8)
            
            ; Only add GP Test button for Main windows
            if (isMainWindow) {
                Gui, %toolbarName%: Add, Button, % "x" . (buttonWidth * 5) . " y0 w" . buttonWidth . " h25 gTestScript", GP Test (Shift+F9)
            }
            
            ; Show the toolbar
            Gui, %toolbarName%: Show, NoActivate x%x4% y%y4% AutoSize
            
            ; Set window position (bottom layer)
            DllCall("SetWindowPos", "Ptr", WinExist(), "Ptr", 1
                    , "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)
            
            LogDebug("Toolbar successfully created for: " . targetWindow)
            return true
        }
        catch e {
            RetryCount++
            if (RetryCount >= MaxRetries) {
                CreateStatusMessage("Failed to create toolbar for " . targetWindow . ": " . e.Message)
                LogError("Failed to create toolbar: " . e.Message)
                break
            }
            Sleep, 1000
        }
    }
    return false
}
ToggleStatusMessages() {
    global showStatus
    
    if(showStatus) {
        CreateStatusMessage("")
        showStatus := False
    }
    else {
        showStatus := True
    }
}

SetTextAndResize(controlHwnd, newText) {
    dc := DllCall("GetDC", "Ptr", controlHwnd)

    ; 0x31 = WM_GETFONT
    SendMessage 0x31,,,, ahk_id %controlHwnd%
    hFont := ErrorLevel
    oldFont := 0
    if (hFont != "FAIL")
        oldFont := DllCall("SelectObject", "Ptr", dc, "Ptr", hFont)

    VarSetCapacity(rect, 16, 0)
    ; 0x440 = DT_CALCRECT | DT_EXPANDTABS
    h := DllCall("DrawText", "Ptr", dc, "Ptr", &newText, "Int", -1, "Ptr", &rect, "UInt", 0x440)
    ; width = rect.right - rect.left
    w := NumGet(rect, 8, "Int") - NumGet(rect, 0, "Int")

    if oldFont
        DllCall("SelectObject", "Ptr", dc, "Ptr", oldFont)
    DllCall("ReleaseDC", "Ptr", controlHwnd, "Ptr", dc)

    GuiControl,, %controlHwnd%, %newText%
    GuiControl MoveDraw, %controlHwnd%, % "h" h*96/A_ScreenDPI + 2 " w" w*96/A_ScreenDPI + 2
}

; ============================================================================
; ADB Interface Functions
; ============================================================================
KillADBProcesses() {
    ; Use AHK's Process command to close adb.exe
    Process, Close, adb.exe
    ; Fallback to taskkill for robustness
    RunWait, %ComSpec% /c taskkill /IM adb.exe /F /T,, Hide
}

ControlClick(X, Y) {
	global winTitle
	ControlClick, x%X% y%Y%, %winTitle%
}

; filepath: c:\Users\Gabriel\Documents\GitHub\PTCGPB\Scripts\Include\Utils.ahk

initializeAdbShell() {
    global adbShell, adbPath, adbPort, debugMode
    
    RetryCount := 0
    MaxRetries := 10
    BackoffTime := 1000  ; Initial backoff time in milliseconds
    MaxBackoff := 5000   ; Prevent excessive waiting

    Loop {
        try {
            if (!adbShell || adbShell.Status != 0) {
                adbShell := ""  ; Reset before reattempting

                ; Validate adbPath and adbPort
                if (!FileExist(adbPath)) {
                    throw Exception("ADB path is invalid: " . adbPath)
                }
                if (adbPort < 0 || adbPort > 65535) {
                    throw Exception("ADB port is invalid: " . adbPort)
                }

                ; Attempt to start adb shell
                adbShell := ComObjCreate("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPort . " shell")

                ; Ensure adbShell is running before sending 'su'
                Sleep, 500
                if (adbShell.Status != 0) {
                    throw Exception("Failed to start ADB shell.")
                }

                adbShell.StdIn.WriteLine("su")
            }

            ; If adbShell is running, break loop
            if (adbShell.Status = 0) {
                break
            }
        } catch e {
            errorMsg := IsObject(e) && e.HasKey("message") ? e.message : "Unknown error"
            RetryCount++
            LogError("ADB Shell Error: " . errorMsg)
            
            if (RetryCount >= MaxRetries) {
                if (debugMode) {
                    CreateStatusMessage("Failed to connect to shell after multiple attempts: " . errorMsg)
                    LogCritical("Failed to connect to shell after multiple attempts: " . errorMsg)
                } else {
                    CreateStatusMessage("Failed to connect to shell. Pausing.")
                    LogCritical("Failed to connect to shell. Pausing.")
                }
                Pause
            }
        }

        Sleep, BackoffTime
        BackoffTime := Min(BackoffTime + 1000, MaxBackoff)  ; Limit backoff time
    }
}

ConnectAdb(folderPath := "C:\Program Files\Netease") {
    adbPort := findAdbPorts(folderPath)

    adbPath := folderPath . "\MuMuPlayerGlobal-12.0\shell\adb.exe"

    if !FileExist(adbPath) ;if international mumu file path isn't found look for chinese domestic path
        adbPath := folderPath . "\MuMu Player 12\shell\adb.exe"

    if !FileExist(adbPath)
        MsgBox Double check your folder path! It should be the one that contains the MuMuPlayer 12 folder! `nDefault is just C:\Program Files\Netease

    if(!adbPort) {
        Msgbox, Invalid port... Check the common issues section in the readme/github guide.
        ExitApp
    }

    MaxRetries := 5
    RetryCount := 0
    connected := false
    ip := "127.0.0.1:" . adbPort ; Specify the connection IP:port

    CreateStatusMessage("Connecting to ADB...")
    LogDebug("Connecting to ADB...")

    Loop %MaxRetries% {
        ; Attempt to connect using CmdRet
        connectionResult := CmdRet(adbPath . " connect " . ip)

        ; Check for successful connection in the output
        if InStr(connectionResult, "connected to " . ip) {
            connected := true
            CreateStatusMessage("ADB connected successfully.")
            LogDebug("ADB connected successfully.")
            return true
        } else {
            RetryCount++
            CreateStatusMessage("ADB connection failed.`nRetrying (" . RetryCount . "/" . MaxRetries . ")...")
            LogDebug("ADB connection failed. Retrying (" . RetryCount . "/" . MaxRetries . ")...")
            Sleep, 2000
        }
    }

    if !connected {
        if (debugMode){
            CreateStatusMessage("Failed to connect to ADB after multiple retries. Please check your emulator and port settings.")
            LogCritical("Failed to connect to ADB after multiple retries. Please check your emulator and port settings.")
        }else{
            CreateStatusMessage("Failed to connect to ADB.")
            LogCritical("Failed to connect to ADB.")
        }Reload
    }
}

CmdRet(sCmd, callBackFuncObj := "", encoding := "")
{
    static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT
        , STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000

   (encoding = "" && encoding := "cp" . DllCall("GetOEMCP", "UInt"))
   DllCall("CreatePipe", "PtrP", hPipeRead, "PtrP", hPipeWrite, "Ptr", 0, "UInt", 0)
   DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)

   VarSetCapacity(STARTUPINFO , siSize :=    A_PtrSize*4 + 4*8 + A_PtrSize*5, 0)
   NumPut(siSize              , STARTUPINFO)
   NumPut(STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)

   VarSetCapacity(PROCESS_INFORMATION, A_PtrSize*2 + 4*2, 0)

   if !DllCall("CreateProcess", "Ptr", 0, "Str", sCmd, "Ptr", 0, "Ptr", 0, "UInt", true, "UInt", CREATE_NO_WINDOW
                              , "Ptr", 0, "Ptr", 0, "Ptr", &STARTUPINFO, "Ptr", &PROCESS_INFORMATION)
   {
      DllCall("CloseHandle", "Ptr", hPipeRead)
      DllCall("CloseHandle", "Ptr", hPipeWrite)
      throw "CreateProcess is failed"
   }
   DllCall("CloseHandle", "Ptr", hPipeWrite)
   VarSetCapacity(sTemp, 4096), nSize := 0
   while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", &sTemp, "UInt", 4096, "UIntP", nSize, "UInt", 0) {
      sOutput .= stdOut := StrGet(&sTemp, nSize, encoding)
      ( callBackFuncObj && callBackFuncObj.Call(stdOut) )
   }
   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION))
   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize))
   DllCall("CloseHandle", "Ptr", hPipeRead)
   Return sOutput
}

findAdbPorts(baseFolder := "C:\Program Files\Netease") {
    global scriptName
    ; Initialize variables
    adbPorts := 0  ; Create an empty associative array for adbPorts
    mumuFolder = %baseFolder%\MuMuPlayerGlobal-12.0\vms\*
    if !FileExist(mumuFolder)
        mumuFolder = %baseFolder%\MuMu Player 12\vms\*

    if !FileExist(mumuFolder){
        MsgBox, 16, , Double check your folder path! It should be the one that contains the MuMuPlayer 12 folder! `nDefault is just C:\Program Files\Netease
        ExitApp
    }
    ; Loop through all directories in the base folder
    Loop, Files, %mumuFolder%, D  ; D flag to include directories only
    {
        folder := A_LoopFileFullPath
        configFolder := folder "\configs"  ; The config folder inside each directory

        ; Check if config folder exists
        IfExist, %configFolder%
        {
            ; Define paths to vm_config.json and extra_config.json
            vmConfigFile := configFolder "\vm_config.json"
            extraConfigFile := configFolder "\extra_config.json"

            ; Check if vm_config.json exists and read adb host port
            IfExist, %vmConfigFile%
            {
                FileRead, vmConfigContent, %vmConfigFile%
                ; Parse the JSON for adb host port
                RegExMatch(vmConfigContent, """host_port"":\s*""(\d+)""", adbHostPort)
                adbPort := adbHostPort1  ; Capture the adb host port value
            }

            ; Check if extra_config.json exists and read playerName
            IfExist, %extraConfigFile%
            {
                FileRead, extraConfigContent, %extraConfigFile%
                ; Parse the JSON for playerName
                RegExMatch(extraConfigContent, """playerName"":\s*""(.*?)""", playerName)
                if(playerName1 = scriptName) {
                    return adbPort
                }
            }
        }
    }
}
waitadb() {
    adbShell.StdIn.WriteLine("echo done")
    while !adbShell.StdOut.AtEndOfStream {
        line := adbShell.StdOut.ReadLine()
        if (line = "done")
            break
        Sleep, 50
    }
}

adbClick(X, Y) {
    static clickCommands := Object()
    static convX := 540/277, convY := 960/489, offset := -44

    key := X << 16 | Y

    if (!clickCommands.HasKey(key)) {
        clickCommands[key] := Format("input tap {} {}"
            , Round(X * convX)
            , Round((Y + offset) * convY))
    }
    adbShell.StdIn.WriteLine(clickCommands[key])
}

adbInput(name) {
    adbShell.StdIn.WriteLine("input text " . name)
    waitadb()
}

adbInputEvent(event) {
    adbShell.StdIn.WriteLine("input keyevent " . event)
    waitadb()
}

adbSwipe(params) {
    adbShell.StdIn.WriteLine("input swipe " . params)
    waitadb()
}

; Simulates a touch gesture on an Android device to scroll in a controlled way.
; Not currently supported.
adbGesture(params) {
    ; Example params (a 2-second hold-drag from a lower to an upper Y-coordinate): 0 2000 138 380 138 90 138 90
    adbShell.StdIn.WriteLine("input touchscreen gesture " . params)
    waitadb()
}

; Takes a screenshot of an Android device using ADB and saves it to a file.
adbTakeScreenshot(outputFile) {
    ; ------------------------------------------------------------------------------
    ; Parameters:
    ;   outputFile (String) - The path and filename where the screenshot will be saved.
    ; ------------------------------------------------------------------------------
    deviceAddress := "127.0.0.1:" . adbPort
    command := """" . adbPath . """ -s " . deviceAddress . " exec-out screencap -p > """ .  outputFile . """"
    RunWait, %ComSpec% /c "%command%", , Hide
}

; ============================================================================
; Window and UI Handling Functions
; ============================================================================

from_window(ByRef image) {
    ; Get the handle to the window.
    image := (hwnd := WinExist(image)) ? hwnd : image

    ; Restore the window if minimized! Must be visible for capture.
    if DllCall("IsIconic", "ptr", image)
        DllCall("ShowWindow", "ptr", image, "int", 4)

    ; Get the width and height of the client window.
    VarSetCapacity(Rect, 16) ; sizeof(RECT) = 16
    DllCall("GetClientRect", "ptr", image, "ptr", &Rect)
        , width  := NumGet(Rect, 8, "int")
        , height := NumGet(Rect, 12, "int")

    ; struct BITMAPINFOHEADER - https://docs.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-bitmapinfoheader
    hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
    VarSetCapacity(bi, 40, 0)                ; sizeof(bi) = 40
        , NumPut(       40, bi,  0,   "uint") ; Size
        , NumPut(    width, bi,  4,   "uint") ; Width
        , NumPut(  -height, bi,  8,    "int") ; Height - Negative so (0, 0) is top-left.
        , NumPut(        1, bi, 12, "ushort") ; Planes
        , NumPut(       32, bi, 14, "ushort") ; BitCount / BitsPerPixel
        , NumPut(        0, bi, 16,   "uint") ; Compression = BI_RGB
        , NumPut(        3, bi, 20,   "uint") ; Quality setting (3 = low quality, no anti-aliasing)
    hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", &bi, "uint", 0, "ptr*", pBits:=0, "ptr", 0, "uint", 0, "ptr")
    obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")

    ; Print the window onto the hBitmap using an undocumented flag. https://stackoverflow.com/a/40042587
    DllCall("PrintWindow", "ptr", image, "ptr", hdc, "uint", 0x3) ; PW_CLIENTONLY | PW_RENDERFULLCONTENT
    ; Additional info on how this is implemented: https://www.reddit.com/r/windows/comments/8ffr56/altprintscreen/

    ; Convert the hBitmap to a Bitmap using a built in function as there is no transparency.
    DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", pBitmap:=0)

    ; Cleanup the hBitmap and device contexts.
    DllCall("SelectObject", "ptr", hdc, "ptr", obm)
    DllCall("DeleteObject", "ptr", hbm)
    DllCall("DeleteDC",     "ptr", hdc)

    return pBitmap
}

bboxAndPause(X1, Y1, X2, Y2, doPause := False) {
    BoxWidth := X2-X1
    BoxHeight := Y2-Y1
    ; Create a GUI
    Gui, BoundingBox:+AlwaysOnTop +ToolWindow -Caption +E0x20
    Gui, BoundingBox:Color, 123456
    Gui, BoundingBox:+LastFound  ; Make the GUI window the last found window for use by the line below. (straght from documentation)
    WinSet, TransColor, 123456 ; Makes that specific color transparent in the gui

    ; Create the borders and show
    Gui, BoundingBox:Add, Progress, x0 y0 w%BoxWidth% h2 BackgroundRed
    Gui, BoundingBox:Add, Progress, x0 y0 w2 h%BoxHeight% BackgroundRed
    Gui, BoundingBox:Add, Progress, x%BoxWidth% y0 w2 h%BoxHeight% BackgroundRed
    Gui, BoundingBox:Add, Progress, x0 y%BoxHeight% w%BoxWidth% h2 BackgroundRed
    Gui, BoundingBox:Show, x%X1% y%Y1% NoActivate
    Sleep, 100

    if (doPause) {
        Pause
    }

    if GetKeyState("F4", "P") {
        Pause
    }

    Gui, BoundingBox:Destroy
}

; ============================================================================
; File and Data Handling Functions
; ============================================================================

EscapeForJson(text) {
    ; First escape backslashes (must come first)
    text := StrReplace(text, "\", "\\")
    ; Then escape quotes
    text := StrReplace(text, """", "\""")
    ; Finally replace newlines
    text := StrReplace(text, "`n", "\n")
    return text
}

LogToDiscord(message, screenshotFile := "", ping := false, xmlFile := "", screenshotFile2 := "", altWebhookURL := "", altUserId := "") {
    LogDiscord("Starting Discord message preparation")
    discordPing := ""

    if (ping) {
        userId := (altUserId ? altUserId : discordUserId)
        LogDebug("Creating ping for user ID: " . userId)

        discordPing := "<@" . userId . "> "
        discordFriends := ReadFile("discord")
        if (discordFriends) {
            LogDebug("Found " . discordFriends.MaxIndex() . " additional users to ping")
            for index, value in discordFriends {
                if (value = userId)
                    continue
                discordPing .= "<@" . value . "> "
            }
        } else {
            LogDebug("No additional users found in discord.txt")
        }
    } else {
        LogDebug("Ping disabled for this message")
    }

    webhookURL := (altWebhookURL ? altWebhookURL : discordWebhookURL)
    
    if (webhookURL != "") {
        LogDebug("Using webhook URL: " . SubStr(webhookURL, 1, 30) . "...")
        
        MaxRetries := 10
        RetryCount := 0
        Loop {
            try {
                LogDebug("Building curl command (attempt " . (RetryCount + 1) . "/" . MaxRetries . ")")
                
                ; Base command
                curlCommand := "curl -k "
                    . "-F ""payload_json={\""content\"":\""" . discordPing . message . "\""};type=application/json;charset=UTF-8"" "

                ; If an screenshot or xml file is provided, send it
                sendScreenshot1 := screenshotFile != "" && FileExist(screenshotFile)
                sendScreenshot2 := screenshotFile2 != "" && FileExist(screenshotFile2)
                sendAccountXml := xmlFile != "" && FileExist(xmlFile)
                
                ; Build log message string without using line continuation
                attachmentMsg := "Attachments - Screenshot1: " . (sendScreenshot1 ? "YES (" . screenshotFile . ")" : "NO")
                attachmentMsg .= ", Screenshot2: " . (sendScreenshot2 ? "YES (" . screenshotFile2 . ")" : "NO")
                attachmentMsg .= ", XML: " . (sendAccountXml ? "YES (" . xmlFile . ")" : "NO")
                LogDiscord(attachmentMsg)
                
                if (sendScreenshot1 + sendScreenshot2 + sendAccountXml > 1) {
                    LogDebug("Using multi-file attachment format")
                    fileIndex := 0
                    if (sendScreenshot1) {
                        fileIndex++
                        curlCommand := curlCommand . "-F ""file" . fileIndex . "=@" . screenshotFile . """ "
                        LogDebug("Added screenshot1 as file" . fileIndex)
                    }
                    if (sendScreenshot2) {
                        fileIndex++
                        curlCommand := curlCommand . "-F ""file" . fileIndex . "=@" . screenshotFile2 . """ "
                        LogDebug("Added screenshot2 as file" . fileIndex)
                    }
                    if (sendAccountXml) {
                        fileIndex++
                        curlCommand := curlCommand . "-F ""file" . fileIndex . "=@" . xmlFile . """ "
                        LogDebug("Added XML as file" . fileIndex)
                    }
                }
                else if (sendScreenshot1 + sendScreenshot2 + sendAccountXml == 1) {
                    LogDebug("Using single-file attachment format")
                    if (sendScreenshot1) {
                        curlCommand := curlCommand . "-F ""file=@" . screenshotFile . """ "
                        LogDebug("Added screenshot1 as file")
                    }
                    if (sendScreenshot2) {
                        curlCommand := curlCommand . "-F ""file=@" . screenshotFile2 . """ "
                        LogDebug("Added screenshot2 as file")
                    }
                    if (sendAccountXml) {
                        curlCommand := curlCommand . "-F ""file=@" . xmlFile . """ "
                        LogDebug("Added XML as file")
                    }
                } else {
                    LogDebug("No files to attach")
                }
                
                ; Add the webhook
                curlCommand := curlCommand . webhookURL
                
                ; Log abbreviated command to avoid exposing full webhook URL
                LogDebug("Executing Discord webhook request...")
                
                ; Send the message using curl
                RunWait, %curlCommand%,, Hide
                
                LogDiscord("Discord message sent successfully!")
                break
            }
            catch e {
                errorMessage := IsObject(e) && e.HasKey("message") ? e.message : "Unknown error"
                LogDebug("Error sending Discord message: " . errorMessage, 30)
                
                RetryCount++
                if (RetryCount >= MaxRetries) {
                    LogError("Failed to send Discord message after " . MaxRetries . " attempts", 40)
                    CreateStatusMessage("Failed to send discord message.")
                    break
                }
                
                LogDebug("Retrying in 250ms... (attempt " . RetryCount . "/" . MaxRetries . ")")
                Sleep, 250
            }
            Sleep, 250
        }
    } else {
        LogError("No webhook URL configured, skipping Discord notification")
    }
}

ReadFile(filename, numbers := false) {
    FileRead, content, %A_ScriptDir%\..\%filename%.txt

    if (!content)
        return false

    values := []
    for _, val in StrSplit(Trim(content), "`n") {
        ; Don't strip non-alphanumeric characters - we need to keep the | and ,
		trimmedVal := Trim(val, " `t`n`r")
        if (trimmedVal != "")
            values.Push(trimmedVal)
    }

    return values.MaxIndex() ? values : false
}

DownloadFile(url, filename, useParentDir := false) {
    global debugMode
    
    ; Determine the path based on user preference
    if (useParentDir)
        localPath := A_ScriptDir . "\..\" . filename
    else
        localPath := A_ScriptDir . "\" . filename
    
    ; Try the download using the most reliable method first
    try {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, true)
        whr.Send()
        whr.WaitForResponse()
        
        if (whr.Status != 200) {
            if (debugMode)
                MsgBox, % "Download failed! Status: " . whr.Status
            return false
        }
        
        contents := whr.ResponseText
        
        ; Try to delete the existing file and write the new content
        FileDelete, %localPath%
        FileAppend, %contents%, %localPath%
        
        if (debugMode)
            MsgBox, File downloaded successfully!
        
        return true
    }
    catch e {
        ; If the main method fails, try the alternative method
        try {
            URLDownloadToFile, %url%, %localPath%
            
            if ErrorLevel {
                if (debugMode)
                    MsgBox, % "Download failed! Error: " . e.Message
                return false
            }
            else {
                if (debugMode)
                    MsgBox, File downloaded successfully!
                return true
            }
        }
        catch e2 {
            if (debugMode)
                MsgBox, % "All download methods failed! Error: " . e2.Message
            return false
        }
    }
}

; ============================================================================
; Date and Time Functions
; ============================================================================

MonthToDays(year, month) {
    static DaysInMonths := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    days := 0
    Loop, % month - 1 {
        days += DaysInMonths[A_Index]
    }
    if (month > 2 && IsLeapYear(year))
        days += 1
    return days
}
IsLeapYear(year) {
    return (Mod(year, 4) = 0 && Mod(year, 100) != 0) || Mod(year, 400) = 0
}
Delay(n) {
    global Delay
    msTime := Delay * n
    Sleep, msTime
}
