#Include %A_ScriptDir%\Include\Logging.ahk
#Include %A_ScriptDir%\Include\ADB.ahk
#Include %A_ScriptDir%\Include\Gdip_All.ahk
#Include %A_ScriptDir%\Include\Gdip_Imagesearch.ahk

#Include *i %A_ScriptDir%\Include\Gdip_Extra.ahk
#Include *i %A_ScriptDir%\Include\StringCompare.ahk
#Include *i %A_ScriptDir%\Include\OCR.ahk

#SingleInstance on
;SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
;SetWinDelay, -1
;SetControlDelay, -1
SetBatchLines, -1
SetTitleMatchMode, 3
CoordMode, Pixel, Screen

; Allocate and hide the console window to reduce flashing
DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, scriptName, GPTest, StatusText, defaultLanguage, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, skipInvalidGP, deleteXML, packs, FriendID, AddFriend, Instances, showStatus
global triggerTestNeeded, testStartTime, firstRun, minStars, minStarsA2b, vipIdsURL

deleteAccount := false
scriptName := StrReplace(A_ScriptName, ".ahk")
winTitle := scriptName
pauseToggle := false
showStatus := true
jsonFileName := A_ScriptDir . "\..\json\Packs.json"
IniRead, FriendID, %A_ScriptDir%\..\Settings.ini, UserSettings, FriendID
IniRead, Instances, %A_ScriptDir%\..\Settings.ini, UserSettings, Instances
IniRead, Delay, %A_ScriptDir%\..\Settings.ini, UserSettings, Delay, 250
IniRead, folderPath, %A_ScriptDir%\..\Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
IniRead, Variation, %A_ScriptDir%\..\Settings.ini, UserSettings, Variation, 20
IniRead, Columns, %A_ScriptDir%\..\Settings.ini, UserSettings, Columns, 5
IniRead, openPack, %A_ScriptDir%\..\Settings.ini, UserSettings, openPack, 1
IniRead, setSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, setSpeed, 2x
IniRead, defaultLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, defaultLanguage, Scale125
IniRead, SelectedMonitorIndex, %A_ScriptDir%\..\Settings.ini, UserSettings, SelectedMonitorIndex, 1:
IniRead, swipeSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, swipeSpeed, 350
IniRead, skipInvalidGP, %A_ScriptDir%\..\Settings.ini, UserSettings, skipInvalidGP, No
IniRead, godPack, %A_ScriptDir%\..\Settings.ini, UserSettings, godPack, Continue
IniRead, deleteMethod, %A_ScriptDir%\..\Settings.ini, UserSettings, deleteMethod, Hoard
IniRead, sendXML, %A_ScriptDir%\..\Settings.ini, UserSettings, sendXML, 0
IniRead, heartBeat, %A_ScriptDir%\..\Settings.ini, UserSettings, heartBeat, 1
if(heartBeat)
    IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
IniRead, vipIdsURL, %A_ScriptDir%\..\Settings.ini, UserSettings, vipIdsURL
IniRead, ocrLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, ocrLanguage, en
IniRead, clientLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, clientLanguage, en
IniRead, minStars, %A_ScriptDir%\..\Settings.ini, UserSettings, minStars, 0
IniRead, minStarsA2b, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2b, 0

; connect adb
instanceSleep := scriptName * 1000
Sleep, %instanceSleep%

; Attempt to connect to ADB
ConnectAdb(folderPath)

if (InStr(defaultLanguage, "100")) {
    scaleParam := 287
} else {
    scaleParam := 277
}

resetWindows()
MaxRetries := 10
RetryCount := 0
Loop {
    try {
        WinGetPos, x, y, Width, Height, %winTitle%
        sleep, 2000
        ;Winset, Alwaysontop, On, %winTitle%
        OwnerWND := WinExist(winTitle)
        x4 := x + 5
        y4 := y + 44
        buttonWidth := 35
        if (scaleParam = 287)
            buttonWidth := buttonWidth + 6

        Gui, Toolbar: New, +Owner%OwnerWND% -AlwaysOnTop +ToolWindow -Caption +LastFound
        Gui, Toolbar: Default
        Gui, Toolbar: Margin, 4, 4  ; Set margin for the GUI
        Gui, Toolbar: Font, s5 cGray Norm Bold, Segoe UI  ; Normal font for input labels
        Gui, Toolbar: Add, Button, % "x" . (buttonWidth * 0) . " y0 w" . buttonWidth . " h25 gReloadScript", Reload  (Shift+F5)
        Gui, Toolbar: Add, Button, % "x" . (buttonWidth * 1) . " y0 w" . buttonWidth . " h25 gPauseScript", Pause (Shift+F6)
        Gui, Toolbar: Add, Button, % "x" . (buttonWidth * 2) . " y0 w" . buttonWidth . " h25 gResumeScript", Resume (Shift+F6)
        Gui, Toolbar: Add, Button, % "x" . (buttonWidth * 3) . " y0 w" . buttonWidth . " h25 gStopScript", Stop (Shift+F7)
        Gui, Toolbar: Add, Button, % "x" . (buttonWidth * 4) . " y0 w" . buttonWidth . " h25 gShowStatusMessages", Status (Shift+F8)
        Gui, Toolbar: Add, Button, % "x" . (buttonWidth * 5) . " y0 w" . buttonWidth . " h25 gTestScript", GP Test (Shift+F9)
        DllCall("SetWindowPos", "Ptr", WinExist(), "Ptr", 1  ; HWND_BOTTOM
                , "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)  ; SWP_NOSIZE, SWP_NOMOVE, SWP_NOACTIVATE
        Gui, Toolbar: Show, NoActivate x%x4% y%y4% AutoSize
        break
    }
    catch {
        RetryCount++
        if (RetryCount >= MaxRetries) {
            CreateStatusMessage("Failed to create button GUI.",,,, false)
            break
        }
        Sleep, 1000
    }
    Sleep, %Delay%
    CreateStatusMessage("Creating button GUI...",,,, false)
}

rerollTime := A_TickCount

initializeAdbShell()
CreateStatusMessage("Initializing bot...",,,, false)
restartGameInstance("Initializing bot...", false)
pToken := Gdip_Startup()

if(heartBeat)
    IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 1000, 150)
firstRun := true

global 99Configs := {}
99Configs["en"] := {leftx: 123, rightx: 162}
99Configs["es"] := {leftx: 68, rightx: 107}
99Configs["fr"] := {leftx: 56, rightx: 95}
99Configs["de"] := {leftx: 72, rightx: 111}
99Configs["it"] := {leftx: 60, rightx: 99}
99Configs["pt"] := {leftx: 127, rightx: 166}
99Configs["jp"] := {leftx: 84, rightx: 127}
99Configs["ko"] := {leftx: 65, rightx: 100}
99Configs["cn"] := {leftx: 63, rightx: 102}
if (scaleParam = 287) {
    99Configs["en"] := {leftx: 123, rightx: 162}
    99Configs["es"] := {leftx: 73, rightx: 105}
    99Configs["fr"] := {leftx: 61, rightx: 93}
    99Configs["de"] := {leftx: 77, rightx: 108}
    99Configs["it"] := {leftx: 66, rightx: 97}
    99Configs["pt"] := {leftx: 133, rightx: 165}
    99Configs["jp"] := {leftx: 88, rightx: 122}
    99Configs["ko"] := {leftx: 69, rightx: 105}
    99Configs["cn"] := {leftx: 63, rightx: 102}
}

99Path := "99" . clientLanguage
99Leftx := 99Configs[clientLanguage].leftx
99Rightx := 99Configs[clientLanguage].rightx

Loop {
    if (GPTest) {
        if (triggerTestNeeded)
            GPTestScript()
        Sleep, 1000
        if (heartBeat && (Mod(A_Index, 60) = 0))
            IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
        Continue
    }

    if(heartBeat)
        IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
    Sleep, %Delay%
    FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 1000, 30)
    FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
    FindImageAndClick(170, 450, 195, 480, , "Approve", 228, 464)
    if(firstRun) {
        Sleep, 1000
        adbClick(205, 510)
        Sleep, 1000
        adbClick(210, 372)
        firstRun := false
    }
    done := false
    Loop 3 {
        Sleep, %Delay%
        if(FindOrLoseImage(225, 195, 250, 215, , "Pending", 0)) {
            failSafe := A_TickCount
            failSafeTime := 0
            Loop {
                Sleep, %Delay%
                clickButton := FindOrLoseImage(75, 340, 195, 530, 80, "Button", 0, failSafeTime) ;looking for ok button in case an invite is withdrawn
                if(FindOrLoseImage(99Leftx, 110, 99Rightx, 127, , 99Path, 0, failSafeTime)) {
                    done := true
                    break
                } else if(FindOrLoseImage(80, 170, 120, 195, , "player", 0, failSafeTime)) {
                    if (GPTest)
                        break
                    Sleep, %Delay%
                    adbClick(210, 210)
                    Sleep, 1000
                } else if(FindOrLoseImage(225, 195, 250, 220, , "Pending", 0, failSafeTime)) {
                    if (GPTest)
                        break
                    adbClick(245, 210)
                } else if(FindOrLoseImage(186, 496, 206, 518, , "Accept", 0, failSafeTime)) {
                    done := true
                    break
                } else if(clickButton) {
                    StringSplit, pos, clickButton, `,  ; Split at ", "
                    if (scaleParam = 287) {
                        pos2 += 5
                    }
                    Sleep, 1000
                    if(FindImageAndClick(190, 195, 215, 220, , "DeleteFriend", pos1, pos2, 4000)) {
                        Sleep, %Delay%
                        adbClick(210, 210)
                    }
                }
                if (GPTest)
                    break
                failSafeTime := (A_TickCount - failSafe) // 1000
                CreateStatusMessage("Failsafe " . failSafeTime . "/180 seconds")
            }
        }
        if(done || fullList|| GPTest)
            break
    }
}
return

FindOrLoseImage(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", EL := 1, safeTime := 0) {
    global winTitle, Variation, failSafe
    if(searchVariation = "")
        searchVariation := Variation
    imagePath := A_ScriptDir . "\" . defaultLanguage . "\"
    confirmed := false

    CreateStatusMessage("Finding " . imageName . "...")
    pBitmap := from_window(WinExist(winTitle))
    Path = %imagePath%%imageName%.png
    pNeedle := GetNeedle(Path)

    ; 100% scale changes
    if (scaleParam = 287) {
        Y1 -= 8 ; offset, should be 44-36 i think?
        Y2 -= 8
        if (Y1 < 0) {
            Y1 := 0
        }
        if (imageName = "Bulba") { ; too much to the left? idk how that happens
            X1 := 200
            Y1 := 220
            X2 := 230
            Y2 := 260
        }else if (imageName = 99Path) { ; 100% full of friend list
            Y1 := 103
            Y2 := 118
        }
    }
    ;bboxAndPause(X1, Y1, X2, Y2)

    ; ImageSearch within the region
    vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, X1, Y1, X2, Y2, searchVariation)
    Gdip_DisposeImage(pBitmap)
    if(EL = 0)
        GDEL := 1
    else
        GDEL := 0
    if (!confirmed && vRet = GDEL && GDEL = 1) {
        confirmed := vPosXY
    } else if(!confirmed && vRet = GDEL && GDEL = 0) {
        confirmed := true
    }
    pBitmap := from_window(WinExist(winTitle))
    Path = %imagePath%App.png
    pNeedle := GetNeedle(Path)
    ; ImageSearch within the region
    vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
    Gdip_DisposeImage(pBitmap)
    if (vRet = 1) {
        LogToFile("Stuck at home while looking for " . imageName . "...")
        restartGameInstance("Stuck at " . imageName . "...")
    }
    if(imageName = "Country" || imageName = "Social")
        FSTime := 90
    else if(imageName = "Button")
        FSTime := 240
    else
        FSTime := 180
    if (safeTime >= FSTime) {
        LogToFile("Instance " . scriptName . " has been stuck at " . imageName . " for 90s. (EL: " . EL . ", sT: " . safeTime . ") Killing it...")
        restartGameInstance("Stuck at " . imageName . "...")
        failSafe := A_TickCount
    }
    return confirmed
}

FindImageAndClick(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", clickx := 0, clicky := 0, sleepTime := "", skip := false, safeTime := 0) {
    global winTitle, Variation, failSafe, confirmed
    if(searchVariation = "")
        searchVariation := Variation
    if (sleepTime = "") {
        global Delay
        sleepTime := Delay
    }
    imagePath := A_ScriptDir . "\" defaultLanguage "\"
    click := false
    if(clickx > 0 and clicky > 0)
        click := true
    x := 0
    y := 0
    StartSkipTime := A_TickCount

    confirmed := false

    ; 100% scale changes
    if (scaleParam = 287) {
        Y1 -= 8 ; offset, should be 44-36 i think?
        Y2 -= 8
        if (Y1 < 0) {
            Y1 := 0
        }

        if (imageName = "Platin") { ; can't do text so purple box
            X1 := 141
            Y1 := 189
            X2 := 208
            Y2 := 224
        } else if (imageName = "Opening") { ; Opening click (to skip cards) can't click on the immersive skip with 239, 497
            clickx := 250
            clicky := 505
        }
    }

    if(click) {
        adbClick(clickx, clicky)
        clickTime := A_TickCount
    }
    CreateStatusMessage("Finding and clicking " . imageName . "...")

    Loop { ; Main loop
        Sleep, 10
        if(click) {
            ElapsedClickTime := A_TickCount - clickTime
            if(ElapsedClickTime > sleepTime) {
                adbClick(clickx, clicky)
                clickTime := A_TickCount
            }
        }

        if (confirmed) {
            continue
        }

        pBitmap := from_window(WinExist(winTitle))
        Path = %imagePath%%imageName%.png
        pNeedle := GetNeedle(Path)
        ;bboxAndPause(X1, Y1, X2, Y2)
        ; ImageSearch within the region
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, X1, Y1, X2, Y2, searchVariation)
        Gdip_DisposeImage(pBitmap)
        if (!confirmed && vRet = 1) {
            confirmed := vPosXY
        } else {
            if(skip < 45) {
                ElapsedTime := (A_TickCount - StartSkipTime) // 1000
                FSTime := 45
                if (ElapsedTime >= FSTime || safeTime >= FSTime) {
                    LogToFile("Instance " . scriptName . " has been stuck at " . imageName . " for 90s. (EL: " . ElapsedTime . ", sT: " . safeTime . ") Killing it...")
                    restartGameInstance("Stuck at " . imageName . "...") ; change to reset the instance and delete data then reload script
                    StartSkipTime := A_TickCount
                    failSafe := A_TickCount
                }
            }
        }

        pBitmap := from_window(WinExist(winTitle))
        Path = %imagePath%Error1.png
        pNeedle := GetNeedle(Path)
        ; ImageSearch within the region
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
        Gdip_DisposeImage(pBitmap)
        if (vRet = 1) {
            CreateStatusMessage("Error message in " . scriptName . ". Clicking retry...")
            LogToFile("Error message in " . scriptName . ". Clicking retry...")
            adbClick(82, 389)
            Sleep, %Delay%
            adbClick(139, 386)
            Sleep, 1000
        }
        pBitmap := from_window(WinExist(winTitle))
        Path = %imagePath%App.png
        pNeedle := GetNeedle(Path)
        ; ImageSearch within the region
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
        Gdip_DisposeImage(pBitmap)
        if (vRet = 1) {
            LogToFile("At the home page while looking for " . imageName . "...")
            restartGameInstance("At the home page while looking for " . imageName . "...")
        }

        if(skip) {
            ElapsedTime := (A_TickCount - StartSkipTime) // 1000
            if (ElapsedTime >= skip) {
                return false
                ElapsedTime := ElapsedTime/2
                break
            }
        }
        if (confirmed) {
            break
        }

    }
    return confirmed
}

resetWindows(){
    global Columns, winTitle, SelectedMonitorIndex, scaleParam
    CreateStatusMessage("Arranging window positions and sizes")
    RetryCount := 0
    MaxRetries := 10
    Loop
    {
        try {
            ; Get monitor origin from index
            SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
            SysGet, Monitor, Monitor, %SelectedMonitorIndex%
            Title := winTitle

            instanceIndex := StrReplace(Title, "Main", "")
            if (instanceIndex = "")
                instanceIndex := 1

            rowHeight := 533  ; Adjust the height of each row
            currentRow := Floor((instanceIndex - 1) / Columns)
            y := currentRow * rowHeight
            x := Mod((instanceIndex - 1), Columns) * scaleParam
            WinMove, %Title%, , % (MonitorLeft + x), % (MonitorTop + y), scaleParam, 537
            break
        }
        catch {
            if (RetryCount > MaxRetries)
                CreateStatusMessage("Pausing. Can't find window " . winTitle . ".",,,, false)
            Pause
        }
        Sleep, 1000
    }
    return true
}

restartGameInstance(reason, RL := true){
    global Delay, scriptName, adbShell, adbPath, adbPort
    initializeAdbShell()

    if (Debug)
        CreateStatusMessage("Restarting game reason:`n" . reason)
    else
        CreateStatusMessage("Restarting game...",,,, false)

    adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
    ;adbShell.StdIn.WriteLine("rm -rf /data/data/jp.pokemon.pokemontcgp/cache/*") ; clear cache
    Sleep, 3000
    adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")

    Sleep, 3000
    if(RL) {
        LogToFile("Restarted game for instance " . scriptName . ". Reason: " reason, "Restart.txt")
        Reload
    }
}

ControlClick(X, Y) {
    global winTitle
    ControlClick, x%X% y%Y%, %winTitle%
}

RandomUsername() {
    FileRead, content, %A_ScriptDir%\..\usernames.txt

    values := StrSplit(content, "`r`n") ; Use `n if the file uses Unix line endings

    ; Get a random index from the array
    Random, randomIndex, 1, values.MaxIndex()

    ; Return the random value
    return values[randomIndex]
}

Screenshot(filename := "Valid") {
    global packs
    SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

    ; Define folder and file paths
    screenshotsDir := A_ScriptDir "\..\Screenshots"
    if !FileExist(screenshotsDir)
        FileCreateDir, %screenshotsDir%

    ; File path for saving the screenshot locally
    screenshotFile := screenshotsDir "\" . A_Now . "_" . winTitle . "_" . filename . "_" . packs . "_packs.png"

    pBitmap := from_window(WinExist(winTitle))
    Gdip_SaveBitmapToFile(pBitmap, screenshotFile)

    return screenshotFile
}

; Pause Script
PauseScript:
    CreateStatusMessage("Pausing...",,,, false)
    Pause, On
return

; Resume Script
ResumeScript:
    CreateStatusMessage("Resuming...",,,, false)
    Pause, Off
    StartSkipTime := A_TickCount ;reset stuck timers
    failSafe := A_TickCount
return

; Stop Script
StopScript:
    CreateStatusMessage("Stopping script...",,,, false)
ExitApp
return

ShowStatusMessages:
    ToggleStatusMessages()
return

ReloadScript:
    Reload
return

TestScript:
    ToggleTestScript()
return

ToggleTestScript() {
    global GPTest, triggerTestNeeded, testStartTime, firstRun
    if(!GPTest) {
        GPTest := true
        triggerTestNeeded := true
        testStartTime := A_TickCount
        CreateStatusMessage("In GP Test Mode",,,, false)
        StartSkipTime := A_TickCount ;reset stuck timers
        failSafe := A_TickCount
    }
    else {
        GPTest := false
        triggerTestNeeded := false
        totalTestTime := (A_TickCount - testStartTime) // 1000
        if (testStartTime != "" && (totalTestTime >= 180))
        {
            firstRun := True
            testStartTime := ""
        }
        CreateStatusMessage("Exiting GP Test Mode",,,, false)
    }
}

FriendAdded() {
    global AddFriend
    AddFriend++
}

; Function to create or select the JSON file
InitializeJsonFile() {
    global jsonFileName
    fileName := A_ScriptDir . "\..\json\Packs.json"
    if !FileExist(fileName) {
        ; Create a new file with an empty JSON array
        FileAppend, [], %fileName%  ; Write an empty JSON array
        jsonFileName := fileName
        return
    }
}

; Function to append a time and variable pair to the JSON file
AppendToJsonFile(variableValue) {
    global jsonFileName
    if (jsonFileName = "") {
        return
    }

    ; Read the current content of the JSON file
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "") {
        jsonContent := "[]"
    }

    ; Parse and modify the JSON content
    jsonContent := SubStr(jsonContent, 1, StrLen(jsonContent) - 1) ; Remove trailing bracket
    if (jsonContent != "[")
        jsonContent .= ","
    jsonContent .= "{""time"": """ A_Now """, ""variable"": " variableValue "}]"

    ; Write the updated JSON back to the file
    FileDelete, %jsonFileName%
    FileAppend, %jsonContent%, %jsonFileName%
}

; Function to sum all variable values in the JSON file
SumVariablesInJsonFile() {
    global jsonFileName
    if (jsonFileName = "") {
        return 0
    }

    ; Read the file content
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "") {
        return 0
    }

    ; Parse the JSON and calculate the sum
    sum := 0
    ; Clean and parse JSON content
    jsonContent := StrReplace(jsonContent, "[", "") ; Remove starting bracket
    jsonContent := StrReplace(jsonContent, "]", "") ; Remove ending bracket
    Loop, Parse, jsonContent, {, }
    {
        ; Match each variable value
        if (RegExMatch(A_LoopField, """variable"":\s*(-?\d+)", match)) {
            sum += match1
        }
    }

    ; Write the total sum to a file called "total.json"
    totalFile := A_ScriptDir . "\json\total.json"
    totalContent := "{""total_sum"": " sum "}"
    FileDelete, %totalFile%
    FileAppend, %totalContent%, %totalFile%

    return sum
}

from_window(ByRef image) {
    ; Thanks tic - https://www.autohotkey.com/boards/viewtopic.php?t=6517

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

~+F5::Reload
~+F6::Pause
~+F7::ExitApp
~+F8::ToggleStatusMessages()
~+F9::ToggleTestScript() ; hoytdj Add

ToggleStatusMessages() {
    showStatus := !showStatus
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

ReadFile(filename, numbers := false) {
    FileRead, content, %A_ScriptDir%\..\%filename%.txt

    if (!content)
        return false

    values := []
    for _, val in StrSplit(Trim(content), "`n") {
        cleanVal := RegExReplace(val, "[^a-zA-Z0-9]") ; Remove non-alphanumeric characters
        if (cleanVal != "")
            values.Push(cleanVal)
    }

    return values.MaxIndex() ? values : false
}

; ^e::
; msgbox ss
; pToken := Gdip_Startup()
; Screenshot()
; return

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ~~~ GP Test Mode Everying Below ~~~
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

GPTestScript() {
    global triggerTestNeeded
    triggerTestNeeded := false
    RemoveNonVipFriends()
}

; Automation script for removing Non-VIP firends.
RemoveNonVipFriends() {
    global GPTest, vipIdsURL, failSafe
    failSafe := A_TickCount
    failSafeTime := 0
    ; Get us to the Social screen. Won't be super resilient but should be more consistent for most cases.
    Loop {
        adbClick(143, 518)
        if(FindOrLoseImage(120, 500, 155, 530, , "Social", 0, failSafeTime))
            break
        Delay(5)
        failSafeTime := (A_TickCount - failSafe) // 1000
        CreateStatusMessage("In failsafe for Social. " . failSafeTime "/90 seconds")
    }
    FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
    Delay(3)

    CreateStatusMessage("Downloading vip_ids.txt.",,,, false)
    if (vipIdsURL != "" && !DownloadFile(vipIdsURL, "vip_ids.txt")) {
        CreateStatusMessage("Failed to download vip_ids.txt. Aborting test...",,,, false)
        return
    }

    includesIdsAndNames := false
    vipFriendsArray :=  GetFriendAccountsFromFile(A_ScriptDir . "\..\vip_ids.txt", includesIdsAndNames)
    if (!vipFriendsArray.MaxIndex()) {
        CreateStatusMessage("No accounts found in vip_ids.txt. Aborting test...",,,, false)
        return
    }

    friendIndex := 0
    repeatFriendAccounts := 0
    recentFriendAccounts := []
    Loop {
        friendClickY := 195 + (95 * friendIndex)
        if (FindImageAndClick(75, 400, 105, 420, , "Friend", 138, friendClickY, 500, 3)) {
            Delay(1)

            ; Get the friend account
            parseFriendResult := ParseFriendInfo(friendCode, friendName, parseFriendCodeResult, parseFriendNameResult, includesIdsAndNames)
            friendAccount := new FriendAccount(friendCode, friendName)

            ; Check if this is a repeat
            if (IsRecentlyCheckedAccount(friendAccount, recentFriendAccounts)) {
                repeatFriendAccounts++
            }
            else if (parseFriendResult) {
                repeatFriendAccounts := 0
            }
            if (repeatFriendAccounts > 2) {
                if (Debug)
                    CreateStatusMessage("End of list - parsed the same friend codes multiple times.`nReady to test.")
                else
                    CreateStatusMessage("Ready to test.",,,, false)
                adbClick(143, 507)
                return
            }
            matchedFriend := ""
            isVipResult := IsFriendAccountInList(friendAccount, vipFriendsArray, matchedFriend)
            if (isVipResult || !parseFriendResult) {
                ; If we couldn't parse the friend, skip removal
                if (!parseFriendResult) {
                    CreateStatusMessage("Couldn't parse friend. Skipping friend...`nParsed friend: " . friendAccount.ToString(),,,, false)
                    LogToFile("Friend skipped: " . friendAccount.ToString() . ". Couldn't parse identifiers.", "GPTestLog.txt")
                }
                ; If it's a VIP friend, skip removal
                if (isVipResult)
                    CreateStatusMessage("Parsed friend: " . friendAccount.ToString() . "`nMatched VIP: " . matchedFriend.ToString() . "`nSkipping VIP...",,,, false)
                Sleep, 1500 ; Time to read
                FindImageAndClick(226, 100, 270, 135, , "Add", 143, 507, 500)
                Delay(2)
                if (friendIndex < 2)
                    friendIndex++
                else {
                    ; Large vertical swipe up, to scroll through no more than 3 friends on the friend list.
                    ; The swipe is performed with a fixed X-coordinate, simulating a larger vertical swipe.
                    X := 138
                    Y1 := 380
                    Y2 := 200

                    Delay(10)
                    adbSwipe(X . " " . Y1 . " " . X . " " . Y2 . " " . 300)
                    Sleep, 1000

                    friendIndex := 0
                }
            }
            else {
                ; If NOT a VIP remove the friend
                CreateStatusMessage("Parsed friend: " . friendAccount.ToString() . "`nNo VIP match found.`nRemoving friend...",,,, false)
                LogToFile("Friend removed: " . friendAccount.ToString() . ". No VIP match found.", "GPTestLog.txt")
                Sleep, 1500 ; Time to read
                FindImageAndClick(135, 355, 160, 385, , "Remove", 145, 407, 500)
                FindImageAndClick(70, 395, 100, 420, , "Send2", 200, 372, 500)
                Delay(1)
                FindImageAndClick(226, 100, 270, 135, , "Add", 143, 507, 500)
                Delay(3)
            }
        }
        else {
            ; If on social screen, we're stuck between friends, micro scroll
            If (FindOrLoseImage(226, 100, 270, 135, , "Add", 0)) {
                CreateStatusMessage("Stuck between friends. Tiny scroll and continue.")

                ; Very small vertical swipe up, to correct miss-swipe on the friend list.
                ; The swipe is performed with a fixed X-coordinate, simulating a small vertical swipe.
                X := 138
                Y1 := 380
                Y2 := 355

                Delay(3)
                adbSwipe(X . " " . Y1 . " " . X . " " . Y2 . " " . 200)
                Sleep, 500
            }
            else { ; Handling for account not currently in use
                FindImageAndClick(226, 100, 270, 135, , "Add", 143, 508, 500)
                Delay(3)
            }
        }
        if (!GPTest) {
            Return
        }
    }
}

; Attempts to extract a friend accounts's code and name from the screen, by taking screenshot and running OCR on specific regions.
ParseFriendInfo(ByRef friendCode, ByRef friendName, ByRef parseFriendCodeResult, ByRef parseFriendNameResult, includesIdsAndNames := False) {
    ; ------------------------------------------------------------------------------
    ; The function has a fail-safe mechanism to stop after 5 seconds.
    ;
    ; Parameters:
    ;   friendCode (ByRef String)          - A reference to store the extracted friend code.
    ;   friendName (ByRef String)          - A reference to store the extracted friend name.
    ;   parseFriendCodeResult (ByRef Bool) - A reference to store the result of parsing the friend code.
    ;   parseFriendNameResult (ByRef Bool) - A reference to store the result of parsing the friend name.
    ;   includesIdsAndNames (Bool)         - A flag indicating whether to parse the friend name, in addition to the code (default: False).
    ;
    ; Returns:
    ;   (Boolean) - True if EITHER the friend code OR name were successfully parsed, false otherwise.
    ; ------------------------------------------------------------------------------
    ; Initialize variables
    failSafe := A_TickCount
    failSafeTime := 0
    friendCode := ""
    friendName := ""
    parseFriendCodeResult := False
    parseFriendNameResult := False

    Loop {
        ; Grab screenshot via Adb
        fullScreenshotFile := GetTempDirectory() . "\" .  winTitle . "_FriendProfile.png"
        adbTakeScreenshot(fullScreenshotFile)

        ; Parse friend identifiers
        if (!parseFriendCodeResult)
            parseFriendCodeResult := ParseFriendInfoLoop(fullScreenshotFile, 328, 57, 197, 28, "0123456789", "^\d{14,17}$", friendCode)
        if (includesIdsAndNames && !parseFriendNameResult)
            parseFriendNameResult := ParseFriendInfoLoop(fullScreenshotFile, 107, 427, 325, 46, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", "^[a-zA-Z0-9]{5,20}$", friendName)
        if (parseFriendCodeResult && (!includesIdsAndNames || parseFriendNameResult))
            break

        ; Break and fail if this take more than 5 seconds
        failSafeTime := (A_TickCount - failSafe) // 1000
        if (failSafeTime > 5)
            break
    }

    ; Return true if we were able to parse EITHER the code OR the name
    return parseFriendCodeResult || (includesIdsAndNames && parseFriendNameResult)
}

; Attempts to extract and validate text from a specified region of a screenshot using OCR.
ParseFriendInfoLoop(screenshotFile, x, y, w, h, allowedChars, validPattern, ByRef output) {
    ; ------------------------------------------------------------------------------
    ; The function crops, formats, and scales the screenshot, runs OCR,
    ; and checks if the result matches a valid pattern. It loops through multiple
    ; scaling factors to improve OCR accuracy.
    ;
    ; Parameters:
    ;   screenshotFile (String)   - The path to the screenshot file to process.
    ;   x (Integer)               - The X-coordinate of the crop region.
    ;   y (Integer)               - The Y-coordinate of the crop region.
    ;   w (Integer)               - The width of the crop region.
    ;   h (Integer)               - The height of the crop region.
    ;   allowedChars (String)     - A list of allowed characters for OCR filtering.
    ;   validPattern (String)     - A regular expression pattern to validate the OCR result.
    ;   output (ByRef)            - A reference variable to store the OCR output text.
    ;
    ; Returns:
    ;   (Boolean) - True if valid text was found and matched the pattern, false otherwise.
    ; ------------------------------------------------------------------------------
    blowUp := [200, 500, 1000, 2000, 100, 250, 300, 350, 400, 450, 550, 600, 700, 800, 900]
    Loop, % blowUp.Length() {
        ; Get the formatted pBitmap
        pBitmap := CropAndFormatForOcr(screenshotFile, x, y, w, h, blowUp[A_Index])
        ; Run OCR
        output := GetTextFromBitmap(pBitmap, allowedChars)
        ; Validate result
        if (RegExMatch(output, validPattern))
            return True
    }
    return False
}

; FriendAccount class that holds information about a friend account, including the account's code (ID) and name.
class FriendAccount {
    ; ------------------------------------------------------------------------------
    ; Properties:
    ;   Code (String)    - The unique identifier (ID) of the friend account.
    ;   Name (String)    - The name associated with the friend account.
    ;
    ; Methods:
    ;   __New(Code, Name) - Constructor method to initialize the friend account
    ;                       with a code and name.
    ;   ToString()        - Returns a string representation of the friend account.
    ;                       If both the code and name are provided, it returns
    ;                       "Name (Code)". If only one is available, it returns
    ;                       that value, and if both are missing, it returns "Null".
    ; ------------------------------------------------------------------------------
    __New(Code, Name) {
        this.Code := Code
        this.Name := Name
    }

    ToString() {
        if (this.Name != "" && this.Code != "")
            return this.Name . " (" . this.Code . ")"
        if (this.Name == "" && this.Code != "")
            return this.Code
        if (this.Name != "" && this.Code == "")
            return this.Name
        return "Null"
    }
}

; Reads a file containing friend account information, parses it, and returns a list of FriendAccount objects
GetFriendAccountsFromFile(filePath, ByRef includesIdsAndNames) {
    ; ------------------------------------------------------------------------------
    ; The function also determines if the file includes both IDs and names for each friend account.
    ; Friend accounts are only added to the output list if star and pack requirements are met.
    ;
    ; Parameters:
    ;   filePath (String)           - The path to the file to read.
    ;   includesIdsAndNames (ByRef) - A reference variable that will be set to true if the file includes both friend IDs and names.
    ;
    ; Returns:
    ;   (Array) - An array of FriendAccount objects, parsed from the file.
    ; ------------------------------------------------------------------------------
    global minStars, minStarsA2b
    friendList := []  ; Create an empty array
    includesIdsAndNames := false

    FileRead, fileContent, %filePath%
    if (ErrorLevel) {
        MsgBox, Failed to read file!
        return friendList  ; Return empty array if file can't be read
    }

    Loop, Parse, fileContent, `n, `r  ; Loop through lines in file
    {
        line := A_LoopField
        if (line = "" || line ~= "^\s*$")  ; Skip empty lines
            continue

        friendCode := ""
        friendName := ""
        twoStarCount := ""
        packName := ""

        if InStr(line, " | ") {
            parts := StrSplit(line, " | ") ; Split by " | "

            ; Check for ID and Name parts
            friendCode := Trim(parts[1])
            friendName := Trim(parts[2])
            if (friendCode != "" && friendName != "")
                includesIdsAndNames := true

            ; Extract the number before "/" in TwoStarCount
            twoStarCount := RegExReplace(parts[3], "\D.*", "")  ; Remove everything after the first non-digit

            packName := Trim(parts[4])
        } else {
            friendCode := Trim(line)
        }

        friendCode := RegExReplace(friendCode, "\D") ; Clean the string (just in case)
        if (!RegExMatch(friendCode, "^\d{14,17}$")) ; Only accept valid IDs
            friendCode := ""
        if (friendCode = "" && friendName = "")
            continue

        ; Trim spaces and create a FriendAccount object
        if (twoStarCount == ""
            || (packName != "Shining" && twoStarCount >= minStars)
            || (packName == "Shining" && twoStarCount >= minStarsA2b)
            || (packName == "" && (twoStarCount >= minStars || twoStarCount >= minStarsA2b)) ) {
            friend := new FriendAccount(friendCode, friendName)
            friendList.Push(friend)  ; Add to array
        }
    }
    return friendList
}

; Compares two friend accounts to check if they match based on their code and/or name.
MatchFriendAccounts(friend1, friend2, ByRef similarityScore := 1) {
    ; ------------------------------------------------------------------------------
    ; The similarity score between the two accounts is calculated and used to determine a match.
    ; If both the code and name match with a high enough similarity score, the function returns true.
    ;
    ; Parameters:
    ;   friend1 (Object)           - The first friend account to compare.
    ;   friend2 (Object)           - The second friend account to compare.
    ;   similarityScore (ByRef)    - A reference to store the calculated similarity score
    ;                                (defaults to 1).
    ;
    ; Returns:
    ;   (Bool) - True if the accounts match based on the similarity score, false otherwise.
    ; ------------------------------------------------------------------------------
    if (friend1.Code != "" && friend2.Code != "") {
        similarityScore := SimilarityScore(friend1.Code, friend2.Code)
        if (similarityScore > 0.6)
            return true
    }
    if (friend1.Name != "" && friend2.Name != "") {
        similarityScore := SimilarityScore(friend1.Name, friend2.Name)
        if (similarityScore > 0.8) {
            if (friend1.Code != "" && friend2.Code != "") {
                similarityScore := (SimilarityScore(friend1.Code, friend2.Code) + SimilarityScore(friend1.Name, friend2.Name)) / 2
                if (similarityScore > 0.7)
                    return true
            }
            else
                return true
        }
    }
    return false
}

; Checks if a given friend account exists in the friend list. If a match is found, the matching friend's information is returned via the matchedFriend parameter.
IsFriendAccountInList(inputFriend, friendList, ByRef matchedFriend) {
    ; ------------------------------------------------------------------------------
    ; Parameters:
    ;   inputFriend (String)  - The account to search for in the list.
    ;   friendList (Array)    - The list of friends to search through.
    ;   matchedFriend (ByRef) - The matching friend's account information, if found (passed by reference).
    ;
    ; Returns:
    ;   (Bool) - True if a matching friend account is found, false otherwise.
    ; ------------------------------------------------------------------------------
    matchedFriend := ""
    for index, friend in friendList {
        if (MatchFriendAccounts(inputFriend, friend)) {
            matchedFriend := friend
            return true
        }
    }
    return false
}

; Checks if an account has already been added to the friend list. If not, it adds the account to the list.
IsRecentlyCheckedAccount(inputFriend, ByRef friendList) {
    ; ------------------------------------------------------------------------------
    ; Parameters:
    ;   inputFriend (String) - The account to check against the list.
    ;   friendList (Array)   - The list of friends to check the account against.
    ;
    ; Returns:
    ;   (Bool) - True if the account is already in the list, false otherwise.
    ; ------------------------------------------------------------------------------
    if (inputFriend == "") {
        return false
    }

    ; Check if the account is already in the list
    if (IsFriendAccountInList(inputFriend, friendList, matchedFriend)) {
        return true
    }

    ; Add the account to the end of the list
    friendList.Push(inputFriend)

    return false  ; Account was not found and has been added
}

; Crops an image, scales it up, converts it to grayscale, and enhances contrast to improve OCR accuracy.
CropAndFormatForOcr(inputFile, x := 0, y := 0, width := 200, height := 200, scaleUpPercent := 200) {
    ; ------------------------------------------------------------------------------
    ; Parameters:
    ;   inputFile (String)    - Path to the input image file.
    ;   x (Int)               - X-coordinate of the crop region (default: 0).
    ;   y (Int)               - Y-coordinate of the crop region (default: 0).
    ;   width (Int)           - Width of the crop region (default: 200).
    ;   height (Int)          - Height of the crop region (default: 200).
    ;   scaleUpPercent (Int)  - Scaling percentage for resizing (default: 200%).
    ;
    ; Returns:
    ;   (Ptr) - Pointer to the processed GDI+ bitmap. Caller must dispose of it.
    ; ------------------------------------------------------------------------------
    ; Get bitmap from file
    pBitmapOrignal := Gdip_CreateBitmapFromFile(inputFile)
    ; Crop to region, Scale up the image, Convert to greyscale, Increase contrast
    pBitmapFormatted := Gdip_CropResizeGreyscaleContrast(pBitmapOrignal, x, y, width, height, scaleUpPercent, 25)
    ; Cleanup references
    Gdip_DisposeImage(pBitmapOrignal)
    return pBitmapFormatted
}

; Extracts text from a bitmap using OCR (Optical Character Recognition). Converts the bitmap to a format usable by Windows OCR, performs OCR, and optionally removes characters not in the allowed character list.
GetTextFromBitmap(pBitmap, charAllowList := "") {
    ; ------------------------------------------------------------------------------
    ; Parameters:
    ;   pBitmap (Ptr)         - Pointer to the source GDI+ bitmap.
    ;   charAllowList (String) - A list of allowed characters for OCR results (default: "").
    ;
    ; Returns:
    ;   (String) - The OCR-extracted text, with disallowed characters removed.
    ; -----------------------------------------------------------------------------
    global ocrLanguage
    ocrText := ""
    ; OCR the bitmap directly
    hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    ocrText := ocr(pIRandomAccessStream, ocrLanguage)
    ; Cleanup references
    ; ObjRelease(pIRandomAccessStream) ; TODO: do I need this?
    DeleteObject(hBitmapFriendCode)
    ; Remove disallowed characters
    if (charAllowList != "") {
        allowedPattern := "[^" RegExEscape(charAllowList) "]"
        ocrText := RegExReplace(ocrText, allowedPattern)
    }

    return Trim(ocrText, " `t`r`n")
}

; Escapes special characters in a string for use in a regular expression. It prepends a backslash to characters that have special meaning in regex.
RegExEscape(str) {
    ; ------------------------------------------------------------------------------
    ; Parameters:
    ;   str (String) - The input string to be escaped.
    ;
    ; Returns:
    ;   (String) - The escaped string, ready for use in a regular expression.
    ; ------------------------------------------------------------------------------
    return RegExReplace(str, "([-[\]{}()*+?.,\^$|#\s])", "\$1")
}

; Retrieves the path to the temporary directory for the script. If the directory does not exist, it is created.
GetTempDirectory() {
    ; ------------------------------------------------------------------------------
    ; Returns:
    ;   (String) - The full path to the temporary directory.
    ; ------------------------------------------------------------------------------
    tempDir := A_ScriptDir . "\temp"
    if !FileExist(tempDir)
        FileCreateDir, %tempDir%
    return tempDir
}

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ~~~ Copied from other Arturo scripts ~~~
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Delay(n) {
    global Delay
    msTime := Delay * n
    Sleep, msTime
}

DownloadFile(url, filename) {
    url := url  ; Change to your hosted .txt URL "https://pastebin.com/raw/vYxsiqSs"
    localPath = %A_ScriptDir%\..\%filename% ; Change to the folder you want to save the file
    errored := false
    try {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, true)
        whr.Send()
        whr.WaitForResponse()
        contents := whr.ResponseText
    } catch {
        errored := true
    }
    if(!errored) {
        FileDelete, %localPath%
        FileAppend, %contents%, %localPath%
    }
    return !errored
}
