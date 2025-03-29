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

global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, adbPort, scriptName, adbShell, adbPath, GPTest, StatusText, defaultLanguage, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, discordUserId, discordWebhookURL, skipInvalidGP, deleteXML, packs, FriendID, AddFriend, Instances, showStatus
global triggerTestNeeded, testStartTime, firstRun, minStars

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
IniRead, discordWebhookURL, %A_ScriptDir%\..\Settings.ini, UserSettings, discordWebhookURL, ""
IniRead, discordUserId, %A_ScriptDir%\..\Settings.ini, UserSettings, discordUserId, ""
IniRead, deleteMethod, %A_ScriptDir%\..\Settings.ini, UserSettings, deleteMethod, Hoard
IniRead, sendXML, %A_ScriptDir%\..\Settings.ini, UserSettings, sendXML, 0
IniRead, heartBeat, %A_ScriptDir%\..\Settings.ini, UserSettings, heartBeat, 1
if(heartBeat)
	IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
IniRead, vipIdsURL, %A_ScriptDir%\..\Settings.ini, UserSettings, vipIdsURL
IniRead, ocrLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, ocrLanguage, en
IniRead, clientLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, clientLanguage, en
IniRead, minStars, %A_ScriptDir%\..\Settings.ini, UserSettings, minStars, 0

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

; connect adb
instanceSleep := scriptName * 1000
Sleep, %instanceSleep%

; Attempt to connect to ADB
ConnectAdb()

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
			CreateStatusMessage("Failed to create button gui.")
			break
		}
		Sleep, 1000
	}
	Sleep, %Delay%
	CreateStatusMessage("Trying to create button gui...")
}

rerollTime := A_TickCount

initializeAdbShell()
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
	; hoytdj Add + 6
	if (GPTest) {
		if (triggerTestNeeded)
			HoytdjTestScript()
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
				CreateStatusMessage("Failsafe " . failSafeTime "/180 seconds")
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

	CreateStatusMessage(imageName)
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
		CreateStatusMessage("At home page. Opening app..." )
		restartGameInstance("At the home page during: `n" imageName)
	}
	if(imageName = "Country" || imageName = "Social")
		FSTime := 90
	else if(imageName = "Button")
		FSTime := 240
	else
		FSTime := 180
	if (safeTime >= FSTime) {
		CreateStatusMessage("Instance " . scriptName . " has been `nstuck " . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		restartGameInstance("Instance " . scriptName . " has been stuck " . imageName)
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
	CreateStatusMessage(imageName)

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
					CreateStatusMessage("Instance " . scriptName . " has been stuck for 90s. Killing it...")
					restartGameInstance("Instance " . scriptName . " has been stuck at " . imageName) ; change to reset the instance and delete data then reload script
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
			CreateStatusMessage("Error message in " scriptName " Clicking retry..." )
			LogToFile("Error message in " scriptName " Clicking retry..." )
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
			CreateStatusMessage("At home page. Opening app..." )
			restartGameInstance("Found myself at the home page during: `n" imageName)
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
				CreateStatusMessage("Pausing. Can't find window " . winTitle)
			Pause
		}
		Sleep, 1000
	}
	return true
}

restartGameInstance(reason, RL := true){
	global Delay, scriptName, adbShell, adbPath, adbPort
	initializeAdbShell()
	; hoytdj DEBUG
	CreateStatusMessage("Restarting game reason: " reason)

	adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
	;adbShell.StdIn.WriteLine("rm -rf /data/data/jp.pokemon.pokemontcgp/cache/*") ; clear cache
	Sleep, 3000
	adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")

	Sleep, 3000
	if(RL) {
		LogToFile("Restarted game for instance " scriptName " Reason: " reason, "Restart.txt")
		LogToDiscord("Restarted game for instance " scriptName " Reason: " reason, , discordUserId)
		Reload
	}
}

LogToFile(message, logFile := "") {
	global scriptName
	if(logFile = "") {
		return ;step logs no longer needed and i'm too lazy to go through the script and remove them atm...
		logFile := A_ScriptDir . "\..\Logs\Logs" . scriptName . ".txt"
	}
	else
		logFile := A_ScriptDir . "\..\Logs\" . logFile
	FormatTime, readableTime, %A_Now%, MMMM dd, yyyy HH:mm:ss
	FileAppend, % "[" readableTime "] " message "`n", %logFile%
}

CreateStatusMessage(Message, GuiName := "StatusMessage", X := 0, Y := 80) {
	global scriptName, winTitle, StatusText
	static hwnds := {}
	if(!showStatus)
		return
	try {
		; Check if GUI with this name already exists
		if !hwnds.HasKey(GuiName) {
			WinGetPos, xpos, ypos, Width, Height, %winTitle%
			X := X + xpos + 5
			Y := Y + ypos
			if(!X)
				X := 0
			if(!Y)
				Y := 0

			; Create a new GUI with the given name, position, and message
			Gui, %GuiName%:New, -AlwaysOnTop +ToolWindow -Caption
			Gui, %GuiName%:Margin, 2, 2  ; Set margin for the GUI
			Gui, %GuiName%:Font, s8  ; Set the font size to 8 (adjust as needed)
			Gui, %GuiName%:Add, Text, hwndhCtrl vStatusText,
			hwnds[GuiName] := hCtrl
			OwnerWND := WinExist(winTitle)
			Gui, %GuiName%:+Owner%OwnerWND% +LastFound
			DllCall("SetWindowPos", "Ptr", WinExist(), "Ptr", 1  ; HWND_BOTTOM
				, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)  ; SWP_NOSIZE, SWP_NOMOVE, SWP_NOACTIVATE
			Gui, %GuiName%:Show, NoActivate x%X% y%Y% AutoSize
		}
		SetTextAndResize(hwnds[GuiName], Message)
		Gui, %GuiName%:Show, NoActivate AutoSize
	}
}

;Modified from https://stackoverflow.com/a/49354127
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

adbClick(X, Y) {
	global adbShell, setSpeed, adbPath, adbPort
	initializeAdbShell()
	X := Round(X / 277 * 540)
	Y := Round((Y - 44) / 489 * 960)
	adbShell.StdIn.WriteLine("input tap " X " " Y)
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

adbInput(name) {
	global adbShell, adbPath, adbPort
	initializeAdbShell()
	adbShell.StdIn.WriteLine("input text " . name )
}

adbSwipeUp() {
	global adbShell, adbPath, adbPort
	initializeAdbShell()
	adbShell.StdIn.WriteLine("input swipe 309 816 309 355 60")
	;adbShell.StdIn.WriteLine("input swipe 309 816 309 555 30")
	Sleep, 150
}

adbSwipe() {
	global adbShell, setSpeed, swipeSpeed, adbPath, adbPort
	initializeAdbShell()
	X1 := 35
	Y1 := 327
	X2 := 267
	Y2 := 327
	X1 := Round(X1 / 277 * 535)
	Y1 := Round((Y1 - 44) / 489 * 960)
	X2 := Round(X2 / 44 * 535)
	Y2 := Round((Y2 - 44) / 489 * 960)
	if(setSpeed = 1) {
		adbShell.StdIn.WriteLine("input swipe " . X1 . " " . Y1 . " " . X2 . " " . Y2 . " " . swipeSpeed)
		sleepDuration := swipeSpeed * 1.2
		Sleep, %sleepDuration%
	}
	else if(setSpeed = 2) {
		adbShell.StdIn.WriteLine("input swipe " . X1 . " " . Y1 . " " . X2 . " " . Y2 . " " . swipeSpeed)
		sleepDuration := swipeSpeed * 1.2
		Sleep, %sleepDuration%
	}
	else {
		adbShell.StdIn.WriteLine("input swipe " . X1 . " " . Y1 . " " . X2 . " " . Y2 . " " . swipeSpeed)
		sleepDuration := swipeSpeed * 1.2
		Sleep, %sleepDuration%
	}
}

Screenshot(filename := "Valid") {
	global adbShell, adbPath, packs
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

LogToDiscord(message, screenshotFile := "", ping := false, xmlFile := "") {
	global discordUserId, discordWebhookURL, sendXML
	if (discordWebhookURL != "") {
		MaxRetries := 10
		RetryCount := 0
		Loop {
			try {
				; Prepare the message data
				if (ping && discordUserId != "") {
					data := "{""content"": ""<@" discordUserId "> " message """}"
				} else {
					data := "{""content"": """ message """}"
				}

				; Create the HTTP request object
				whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
				whr.Open("POST", discordWebhookURL, false)
				whr.SetRequestHeader("Content-Type", "application/json")
				whr.Send(data)

				; If an image file is provided, send it
				if (screenshotFile != "") {
					; Check if the file exists
					if (FileExist(screenshotFile)) {
						; Send the image using curl
						RunWait, curl -k -F "file=@%screenshotFile%" %discordWebhookURL%,, Hide
					}
				}
				if (xmlFile != "" && sendXML > 0) {
					; Check if the file exists
					if (FileExist(xmlFile)) {
						; Send the image using curl
						RunWait, curl -k -F "file=@%xmlFile%" %discordWebhookURL%,, Hide
					}
				}
				break
			}
			catch {
				RetryCount++
				if (RetryCount >= MaxRetries) {
					CreateStatusMessage("Failed to send discord message.")
					break
				}
				Sleep, 250
			}
			sleep, 250
		}
	}
}
; Pause Script
PauseScript:
	CreateStatusMessage("Pausing...")
	Pause, On
return

; Resume Script
ResumeScript:
	CreateStatusMessage("Resuming...")
	Pause, Off
	StartSkipTime := A_TickCount ;reset stuck timers
	failSafe := A_TickCount
return

; Stop Script
StopScript:
	CreateStatusMessage("Stopping script...")
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

ToggleTestScript()
{
	global GPTest, triggerTestNeeded, testStartTime, firstRun
	if(!GPTest) {
		GPTest := true
		triggerTestNeeded := true
		testStartTime := A_TickCount
		CreateStatusMessage("In GP Test Mode")
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
		CreateStatusMessage("Exiting GP Test Mode")
	}
}

FriendAdded()
{
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
	DllCall("DeleteDC",	 "ptr", hdc)

	return pBitmap
}

~+F5::Reload
~+F6::Pause
~+F7::ExitApp
~+F8::ToggleStatusMessages()
~+F9::ToggleTestScript() ; hoytdj Add

ToggleStatusMessages() {
	if(showStatus)
		showStatus := False
	else
		showStatus := True
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

; Function to initialize ADB Shell
initializeAdbShell() {
	global adbShell, adbPath, adbPort
	RetryCount := 0
	MaxRetries := 10
	BackoffTime := 1000  ; Initial backoff time in milliseconds

	Loop {
		try {
			if (!adbShell) {
				; Validate adbPath and adbPort
				if (!FileExist(adbPath)) {
					throw "ADB path is invalid."
				}
				if (adbPort < 0 || adbPort > 65535)
					throw "ADB port is invalid."

				adbShell := ComObjCreate("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPort . " shell")

				adbShell.StdIn.WriteLine("su")
			} else if (adbShell.Status != 0) {
				Sleep, BackoffTime
				BackoffTime += 1000 ; Increase the backoff time
			} else {
				break
			}
		} catch e {
			RetryCount++
			if (RetryCount > MaxRetries) {
				CreateStatusMessage("Failed to connect to shell: " . e.message)
				LogToFile("Failed to connect to shell: " . e.message)
				Pause
			}
		}
		Sleep, BackoffTime
	}
}
ConnectAdb() {
	global adbPath, adbPort, StatusText
	MaxRetries := 5
	RetryCount := 0
	connected := false
	ip := "127.0.0.1:" . adbPort ; Specify the connection IP:port

	CreateStatusMessage("Connecting to ADB...")

	Loop %MaxRetries% {
		; Attempt to connect using CmdRet
		connectionResult := CmdRet(adbPath . " connect " . ip)

		; Check for successful connection in the output
		if InStr(connectionResult, "connected to " . ip) {
			connected := true
			CreateStatusMessage("ADB connected successfully.")
			return true
		} else {
			RetryCount++
			CreateStatusMessage("ADB connection failed. Retrying (" . RetryCount . "/" . MaxRetries . ").")
			Sleep, 2000
		}
	}

	if !connected {
		CreateStatusMessage("Failed to connect to ADB after multiple retries. Please check your emulator and port settings.")
		Reload
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

findAdbPorts(baseFolder := "C:\Program Files\Netease") {
	global adbPorts, winTitle, scriptName
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

; ^e::
; msgbox ss
; pToken := Gdip_Startup()
; Screenshot()
; return

; friendCount := cropAndOcr("Main", 234, 172, 90, 40, True, True, 200)
; friendCode := cropAndOcr("Main", 336, 106, 188, 20, True, True, blowUp)
cropAndOcr(winTitle := "Main", x := 0, y := 0, width := 200, height := 200, moveWindow := True, revertWindow := True, blowupPercent := 200)
{
	global ocrLanguage 
	
    if(moveWindow) {
		WinGetPos, srcX, srcY, srcW, srcH, %winTitle%
        WinMove, %winTitle%, , srcX, srcY, 550, 1015
        Delay(1)
    }
    hwnd := WinExist(winTitle)
    pBitmap := from_window(hwnd) ; Gdip_BitmapFromScreen( "hwnd: " . hwnd)
    ;;;;Gdip_SaveBitmapToFile(pBitmap, "src.jpg")

    pBitmap2 := Gdip_CropImage(pBitmap, x, y, width, height)
    pBitmap3 := Gdip_ResizeBitmap(pBitmap2, blowupPercent, true)
    hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap3)
    ;;hBitmap2 := ToGrayscale(hBitmap)

    ;;;; ret := SavePicture(hBitmap, "biggrey1.png")
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    text := ocr(pIRandomAccessStream, ocrLanguage)
    ;;;; MsgBox %text%

    DeleteObject(hBitmap)
    ;;DeleteObject(hBitmap2)
    Gdip_DisposeImage(pBitmap)
    Gdip_DisposeImage(pBitmap2)
    Gdip_DisposeImage(pBitmap3)

    if(revertWindow && moveWindow) {
        WinMove, %winTitle%, , srcX, srcY, srcW, srcH
        Delay(1)
    }

    return text
}

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ~~~ hoytdj Everying Below ~~~
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; TODO: Better isolate name spaces

HoytdjTestScript() {
	global triggerTestNeeded
	triggerTestNeeded := false
	RemoveNonVipFriends()
}

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

	CreateStatusMessage("Downloading vip_ids.txt.")
	if (vipIdsURL != "" && !DownloadFile(vipIdsURL, "vip_ids.txt")) {
		CreateStatusMessage("Failed to download vip_ids.txt. Aborting test...")
		return
	}

	includesIdsAndNames := false
	vipFriendsArray :=  ParseFriendAccounts(A_ScriptDir . "\..\vip_ids.txt", includesIdsAndNames)
	if (!vipFriendsArray.MaxIndex()) {
		CreateStatusMessage("No accounts found in vip_ids.txt. Aborting test...")
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
			friendCode := ""
			friendName := ""
			parseFriendCodeResult := ParseFriendCode(friendCode)
			if (includesIdsAndNames)
				parseFriendNameResult := ParseFriendName(friendName)
			parseFriendResult := parseFriendCodeResult || (includesIdsAndNames && parseFriendNameResult)
			friendAccount := new FriendAccount(friendCode, friendName)

			; Check if this is a repeat
			if (IsRecentlyCheckedAccount(friendAccount, recentFriendAccounts)) {
				repeatFriendAccounts++
			}
			else if (parseFriendResult) {
				repeatFriendAccounts := 0
			}
			if (repeatFriendAccounts > 2) {
				CreateStatusMessage("End of list - parsed the same friend codes multiple times.`nReady to test.")
				adbClick(143, 507)
				return
			}
			matchedFriend := ""
			isVipResult := IsFriendAccountInList(friendAccount, vipFriendsArray, matchedFriend)
			if (isVipResult || !parseFriendResult) {
				; If we couldn't parse the friend, skip removal
				if (!parseFriendResult) {
					CreateStatusMessage("Couldn't parse friend. Skipping friend...`nParsed friend: " . friendAccount.ToString())
					LogToFile("Friend skipped: " . friendAccount.ToString() . ". Couldn't parse identifiers.", "GPTestLog.txt")
				}
				; If it's a VIP friend, skip removal
				if (isVipResult)
					CreateStatusMessage("Parsed friend: " . friendAccount.ToString() . "`nMatched VIP: " . matchedFriend.ToString() . "`nSkipping VIP...")
				Sleep, 1500 ; Time to read
				FindImageAndClick(226, 100, 270, 135, , "Add", 143, 507, 500)
				Delay(2)
				if (friendIndex < 2)
					friendIndex++
				else {
					adbSwipeFriend()
					;adbGestureFriend()
					friendIndex := 0
				}
			}
			else {
				; If NOT a VIP remove the friend
				CreateStatusMessage("Parsed friend: " . friendAccount.ToString() . "`nNo VIP match found.`nRemoving friend...")
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
				adbSwipeFriendMicro()
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



GetFriendCode(blowupPercent := 200) {
	global winTitle
	ocrText := cropAndOcr(winTitle, 336, 106, 188, 20, True, True, blowupPercent)
	friendCode := RegExReplace(Trim(ocrText, " `t`r`n"), "\D")
	return friendCode
}

GetFriendName(blowupPercent := 200) {
	global winTitle
	ocrText := cropAndOcr(winTitle, 122, 483, 300, 33, True, True, blowupPercent)
	friendName := Trim(ocrText, " `t`r`n")
	return friendName
}

/*
GetFriendCode() {
	global winTitle, scaleParam
	WinGetPos, x, y, w, h, %winTitle%
	if (scaleParam = 287) {
		x := x + 170
		y := y + 63
		w := 103
		h := 20
	}
	else {
		x := x + 169
		y := y + 72
		w := 100
		h := 20
	}
	; Parse friendCode status from screen
	; Expected output something like "1234-5678-1234-5678"
	if (ScreenshotRegion(x, y, w, h, capturedScreenshot, "friendCode")) {
		ocrText := GetTextFromImage(capturedScreenshot)
		friendCode := RegExReplace(Trim(ocrText, " `t`r`n"), "\D")
		;MsgBox % "OCR Text:`n" . ocrText . "`nClean Text:`n" . friendCode
		return friendCode
	}
	return ""
}

GetFriendName() {
	global winTitle, scaleParam
	WinGetPos, x, y, w, h, %winTitle%
	if (scaleParam = 287) {
		x := x + 52
		y := y + 255
		w := 174
		h := 28
	}
	else {
		x := x + 51
		y := y + 262
		w := 174
		h := 28
	}

	if (ScreenshotRegion(x, y, w, h, capturedScreenshot, "friendName")) {
		ocrText := GetTextFromImage(capturedScreenshot)
		friendName := Trim(ocrText, " `t`r`n")
		;MsgBox % "OCR Text:`n" . ocrText . "`nClean Text:`n" . friendName
		return friendName
	}
	return ""
}
*/


ParseFriendCode(ByRef friendCode) {
	failSafe := A_TickCount
	failSafeTime := 0
	parseFriendCodeResult := False
	blowUp := [200, 500, 1000, 2000, 100, 250, 300, 350, 400, 450, 550, 600, 700, 800, 900]
	Loop {
		friendCode := GetFriendCode(blowUp[A_Index])
		if (RegExMatch(friendCode, "^\d{14,17}$")) {
			parseFriendCodeResult := True
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		if (failSafeTime > 4) {
			parseFriendCodeResult := False
			break
		}
	}
	return parseFriendCodeResult
}

ParseFriendName(ByRef friendName) {
	failSafe := A_TickCount
	failSafeTime := 0
	parseFriendNameResult := False
	blowUp := [200, 500, 1000, 2000, 100, 250, 300, 350, 400, 450, 550, 600, 700, 800, 900]
	Loop {
		friendName := GetFriendName(blowUp[A_Index])
		if (RegExMatch(friendName, "^[a-zA-Z0-9]{5,20}$")) {
			parseFriendNameResult := True
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		if (failSafeTime > 4) {
			parseFriendNameResult := False
			break
		}
	}
	return parseFriendNameResult
}

class FriendAccount {
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

ParseFriendAccounts(filePath, ByRef includesIdsAndNames) {
	global minStars
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

		if InStr(line, " | ") {
			parts := StrSplit(line, " | ") ; Split by " | "

			; Check for ID and Name parts
			friendCode := Trim(parts[1])
			friendName := Trim(parts[2])
			if (friendCode != "" && friendName != "")
				includesIdsAndNames := true

			; Extract the number before "/" in TwoStarCount
			twoStarCount := RegExReplace(parts[3], "\D.*", "")  ; Remove everything after the first non-digit
		} else {
			friendCode := Trim(line)
		}

		; Trim spaces and create a FriendAccount object
		if (twoStarCount == "" || twoStarCount >= minStars) {
			friend := new FriendAccount(friendCode, friendName)
			friendList.Push(friend)  ; Add to array
		}
	}
	return friendList
}

MatchFriendAccounts(friend1, friend2) {
	if (friend1.Code != "" && friend2.Code != "" && SimilarityScore(friend1.Code, friend2.Code) > 0.6)
	{
		return true
	}
	if (friend1.Name != "" && friend2.Name != "" && SimilarityScore(friend1.Name, friend2.Name) > 0.8)
	{
		return true
	}
	return false
}

IsFriendAccountInList(inputFriend, friendList, ByRef matchedFriend) {
	matchedFriend := ""
	for index, friend in friendList {
		if (MatchFriendAccounts(inputFriend, friend))
		{
			matchedFriend := friend
			return true
		}
	}
	return false
}

IsRecentlyCheckedAccount(inputFriend, ByRef friendList) {
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

adbSwipeFriend() {
	global adbShell
	initializeAdbShell()
	X := 138
	Y1 := 380
	Y2 := 200

	Delay(10)
	adbShell.StdIn.WriteLine("input swipe " . X . " " . Y1 . " " . X . " " . Y2 . " " . 300)
	Sleep, 1000
 }

 adbSwipeFriendMicro() {
	global adbShell
	initializeAdbShell()
	X := 138
	Y1 := 380
	Y2 := 355

	Delay(3)
	adbShell.StdIn.WriteLine("input swipe " . X . " " . Y1 . " " . X . " " . Y2 . " " . 200)
	Sleep, 500
 }

adbGestureFriend() {
	; The idea is to drag up and hold, in order to scroll in a controlled way
	; Unfortunately, touchscreen gesture doesn't seem to be supported
	global adbShell
	initializeAdbShell()
	X := 138
	Y1 := 380
	Y2 := 90
	duration := 2000

	adbShell.StdIn.WriteLine("input touchscreen gesture 0 " . duration . " " . X . " " . Y1 . " " . X . " " . Y2 . " " . X . " " . Y2)
	Delay(1)
}

; Copied from other Arturo scripts
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


; DEBUG
; F1::
; 	MouseGetPos, mouseX, mouseY  ; Retrieves the mouse cursor's X and Y positions
; 	CreateStatusMessage("Mouse coordinates - X: " . mouseX . " Y: " . mouseY )
; return
