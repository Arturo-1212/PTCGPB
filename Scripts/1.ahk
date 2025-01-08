#Include %A_ScriptDir%\Include\Gdip_All.ahk
#Include %A_ScriptDir%\Include\Gdip_Imagesearch.ahk
#SingleInstance on
;SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
;SetWinDelay, -1
;SetControlDelay, -1
SetBatchLines, -1
SetTitleMatchMode, 3
CoordMode, Pixel, Screen

global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, adbPort, scriptName, adbShell, adbPath, GPTest, StatusText, defaultLanguage, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, discordUserId, discordWebhookURL, skipInvalidGP, telegramToken, telegramChatID, telegramTopicID

	
	adbPath := A_ScriptDir . "\adb\platform-tools\adb.exe"  ; Example path, adjust if necessary
	deleteAccount := false
	scriptName := StrReplace(A_ScriptName, ".ahk")
	winTitle := scriptName
	pauseToggle := false
	IniRead, adbPort, %A_ScriptDir%\..\Settings.ini, UserSettings, adbPort%scriptName%, 11111
    IniRead, Name, %A_ScriptDir%\..\Settings.ini, UserSettings, Name, player1
    IniRead, Delay, %A_ScriptDir%\..\Settings.ini, UserSettings, Delay, 250
    IniRead, Variation, %A_ScriptDir%\..\Settings.ini, UserSettings, Variation, 40
    IniRead, changeDate, %A_ScriptDir%\..\Settings.ini, UserSettings, ChangeDate, 0100
    IniRead, Columns, %A_ScriptDir%\..\Settings.ini, UserSettings, Columns, 5
    IniRead, openPack, %A_ScriptDir%\..\Settings.ini, UserSettings, openPack, 4
    IniRead, setSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, setSpeed, 2x
	IniRead, defaultLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, defaultLanguage, English
	jsonFileName := A_ScriptDir . "\..\json\Packs.json"
	IniRead, SelectedMonitorIndex, %A_ScriptDir%\..\Settings.ini, UserSettings, SelectedMonitorIndex, 1:
	IniRead, swipeSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, swipeSpeed, 600
	IniRead, falsePositive, %A_ScriptDir%\..\Settings.ini, UserSettings, falsePositive, No
	IniRead, skipInvalidGP, %A_ScriptDir%\..\Settings.ini, UserSettings, skipInvalidGP, No
	IniRead, godPack, %A_ScriptDir%\..\Settings.ini, UserSettings, godPack, 1
	IniRead, discordWebhookURL, Settings.ini, UserSettings, discordWebhookURL, ""
    IniRead, discordUserId, Settings.ini, UserSettings, discordUserId, ""
    IniRead, telegramToken, Settings.ini, UserSettings, telegramToken, ""
    IniRead, telegramChatID, Settings.ini, UserSettings, telegramChatID, ""
    IniRead, telegramTopicID, Settings.ini, UserSettings, telegramTopicID, ""
	
	
	if(!adbPort) {
		Msgbox, Invalid port... Check the common issues section in the readme/github guide.
		ExitApp
	}
	
	; connect adb
	instanceSleep := scriptName * 1000
	Sleep, %instanceSleep%
	RunWait, %adbPath% connect 127.0.0.1:%adbPort%,, Hide
	if (defaultLanguage = "English100")
		scaleParam := 287
	else
		scaleParam := 277
		
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
			
		
			Gui, New, +Owner%OwnerWND% -AlwaysOnTop +ToolWindow -Caption 
			Gui, Default
			Gui, Margin, 4, 4  ; Set margin for the GUI
			Gui, Font, s5 cGray Norm Bold, Segoe UI  ; Normal font for input labels
			Gui, Add, Button, x0 y0 w30 h25 gReloadScript, Reload  (F5)
			Gui, Add, Button, x30 y0 w30 h25 gPauseScript, Pause (F6)
			Gui, Add, Button, x60 y0 w40 h25 gResumeScript, Resume (F6)
			Gui, Add, Button, x100 y0 w30 h25 gStopScript, Stop (F7)
			Gui, Add, Button, x130 y0 w40 h25 gTestScript, GP Test  (F8)
			Gui, Show, NoActivate x%x4% y%y4% AutoSize
			break
		}
		catch {
			RetryCount++
			if (RetryCount >= MaxRetries) {
				CreateStatusMessage("Failed to create button gui.")
				; WinGetPos, x, y, Width, Height, %winTitle%
				; sleep, 2000
				; x4 := x + 5
				; y4 := y + 25
				
			
				; Gui, New, -AlwaysOnTop +ToolWindow -Caption 
				; Gui, Default
				; Gui, Margin, 4, 4  ; Set margin for the GUI
				; Gui, Font, s5 cGray Norm Bold, Segoe UI  ; Normal font for input labels
				; Gui, Add, Button, x0 y0 w30 h25 gReloadScript, Reload  (F5)
				; Gui, Add, Button, x30 y0 w30 h25 gPauseScript, Pause (F6)
				; Gui, Add, Button, x60 y0 w40 h25 gResumeScript, Resume (F6)
				; Gui, Add, Button, x100 y0 w30 h25 gStopScript, Stop (F7)
				; Gui, Add, Button, x130 y0 w40 h25 gTestScript, GP Test  (F8)
				; Gui, Show, NoActivate x%x4% y%y4% AutoSize
				break
			}
			Sleep, 1000
		}
		Sleep, %Delay%
		CreateStatusMessage("Trying to create button gui...")
	}
		
	if (!openPack)
		openPack = 1
	else if (openPack = "Mewtwo")
		openPack = 1
	else if (openPack = "Pikachu")
		openPack = 2
	else if (openPack = "Charizard")
		openPack = 3
	else if (openPack = "Mew")
		openPack = 4
	else if (openPack = "Random") {
		Random, rand, 1, 4
		openPack = %rand%
	}
	
	if (!godPack)
		godPack = 1
	else if (godPack = "Close")
		godPack = 1
	else if (godPack = "Pause")
		godPack = 2
	
	if (!falsePositive)
		godPack = 1
	else if (falsePositive = "No")
		falsePositive = 1
	else if (falsePositive = "Yes")
		falsePositive = 2
	
	if (!skipInvalidGP)
		skipInvalidGP = 1
	else if (skipInvalidGP = "No")
		skipInvalidGP = 1
	else if (skipInvalidGP = "Yes")
		skipInvalidGP = 2
		
	if (!setSpeed)
		setSpeed = 1
	if (setSpeed = "2x")
		setSpeed := 1
	else if (setSpeed = "1x/2x")
		setSpeed := 2
	else if (setSpeed = "1x/3x")
		setSpeed := 3

	rerollTime := A_TickCount	

	MaxRetries := 10
	RetryCount := 0
	Loop {
		try {
			if (!adbShell) {
	adbShell := ComObjCreate("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPort . " shell")
	; Extract the Process ID
	processID := adbShell.ProcessID

	; Wait for the console window to open using the process ID
	WinWait, ahk_pid %processID%

	; Minimize the window using the process ID
	WinMinimize, ahk_pid %processID%
			}
			else if (adbShell.Status != 0) {
				Sleep, 1000
			}
			else {
	break
}
		}
		catch {
			RetryCount++
			if(RetryCount > MaxRetries) {
				CreateStatusMessage("Failed to connect to shell")
				Pause
			}
		}
		Sleep, 1000
	}
	instanceSleep := scriptName * 1000
	pToken := Gdip_Startup()
Loop {
	FormatTime, CurrentTime,, HHmm

    StartTime := changeDate - 45 ; 12:55 AM2355
    EndTime := changeDate + 5 ; 1:01 AM

    ; Adjust for crossing midnight
    if (StartTime < 0)
        StartTime += 2400
    if (EndTime >= 2400)
        EndTime -= 2400
		
	While(((CurrentTime - StartTime >= 0) && (CurrentTime - StartTime <= 5)) || ((EndTime - CurrentTime >= 0) && (EndTime - CurrentTime <= 5)))
	{
		CreateStatusMessage("I need a break... Sleeping until " . changeDate + 5 . " `nto avoid being kicked out from the date change")
		FormatTime, CurrentTime,, HHmm ; Update the current time after sleep
		Sleep, 5000
	}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbClick(255, 83)
		if(CheckInstances(77, 144, 169, 175, , "Country", 0, failSafeTime)) { ;if at country continue
			break
		}
		else if(CheckInstances(116, 77, 167, 97, , "Menu", 0, failSafeTime)) { ; if the clicks in the top right open up the game settings menu then continue to delete account
			Sleep,%Delay%
			KeepSync(56, 312, 108, 334, , "Account2", 79, 267, 2000) ;wait for account menu
			Sleep,%Delay%
			KeepSync(74, 104, 133, 135, , "Delete", 145, 446, 2000) ;wait for delete save data confirmation
			Sleep,%Delay%
			KeepSync(73, 191, 133, 208, , "Delete2", 201, 447, %Delay%) ;wait for second delete save data confirmation
			Sleep,%Delay%
			KeepSync(30, 240, 121, 275, , "Delete3", 201, 369, 2000) ;wait for second 
			
			
			adbClick(143, 370)
			break
		}
		CreateStatusMessage("Looking for Country/Menu")
		Sleep, %Delay%
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Country/Menu. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Country/Menu. It's been: " . failSafeTime "s ")
	}
	if(setSpeed > 1 && !packs) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		if(setSpeed = 3)
			KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
		else
			KeepSync(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		Sleep, %Delay%
		adbClick(166, 296)
		Sleep, %Delay%
	}	
KeepSync(77, 144, 169, 175, , "Country", 143, 370) ;select month and year and click

adbClick(80, 400)
Sleep, %Delay%
adbClick(80, 375)
Sleep, %Delay%
failSafe := A_TickCount
failSafeTime := 0

Loop
{
	Sleep, %Delay%
	if(KeepSync(100, 386, 138, 416, , "Month", , , , 1, failSafeTime))
		break
	Sleep, %Delay%
adbClick(142, 159)
	Sleep, %Delay%
adbClick(80, 400)
	Sleep, %Delay%
adbClick(80, 375)
    Sleep, %Delay%
adbClick(82, 422)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Month. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Month. It's been: " . failSafeTime "s ")
} ;select month and year and click

adbClick(200, 400)
Sleep, %Delay%
adbClick(200, 375)
Sleep, %Delay%
failSafe := A_TickCount
failSafeTime := 0
Loop ;select month and year and click
{
	Sleep, %Delay%
	if(KeepSync(148, 384, 256, 419, , "Year", , , , 1, failSafeTime))
		break
	Sleep, %Delay%
	adbClick(142, 159)
	Sleep, %Delay%
	adbClick(142, 159)
	Sleep, %Delay%
	adbClick(200, 400)
	Sleep, %Delay%
	adbClick(200, 375)
	Sleep, %Delay%
	adbClick(142, 159)
	Sleep, %Delay%
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Year. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Year. It's been: " . failSafeTime "s ")
} ;select month and year and click

Sleep, %Delay%
if(CheckInstances(93, 471, 122, 485, , "CountrySelect", 0)) {
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		if(KeepSync(93, 471, 122, 485, , "CountrySelect", 140, 474, 1000, 1, failSafeTime)) {
			sleep, %Delay%
			sleep, %Delay%
			adbClick(124, 250)
			sleep, %Delay%
			sleep, %Delay%
			adbClick(124, 250)
			if(KeepSync(67, 286, 217, 319, , "Birth", 140, 474, 1000))
				break
		}
		sleep, 10
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for country select. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for country select. It's been: " . failSafeTime "s ")
	}
} else {
	KeepSync(67, 286, 217, 319, , "Birth", 140, 474, 1000)
}

 ;wait date confirmation screen while clicking ok

KeepSync(97, 285, 185, 315, , "TosScreen", 203, 371, 1000) ;wait to be at the tos screen while confirming birth

KeepSync(81, 68, 204, 94, , "Tos", 139, 299, 1000) ;wait for tos while clicking it

KeepSync(97, 285, 185, 315, , "TosScreen", 142, 486, 1000) ;wait to be at the tos screen and click x

KeepSync(82, 71, 146, 95, , "Privacy", 142, 339, 1000) ;wait to be at the tos screen

KeepSync(97, 285, 185, 315, , "TosScreen", 142, 486, 1000) ;wait to be at the tos screen, click X

Sleep, %Delay%
adbClick(261, 374)

Sleep, %Delay%
adbClick(261, 406)

Sleep, %Delay%
adbClick(145, 484)

failSafe := A_TickCount
failSafeTime := 0
Loop {
	if(KeepSync(78, 334, 216, 363, , "Save", 145, 484, , 2, failSafeTime)) ;wait to be at create save data screen while clicking
		break
	Sleep, %Delay%
adbClick(261, 406)
	if(KeepSync(78, 334, 216, 363, , "Save", 145, 484, , 2, failSafeTime)) ;wait to be at create save data screen while clicking
		break
	Sleep, %Delay%
adbClick(261, 374)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Save. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Save. It's been: " . failSafeTime "s ")
}

Sleep, %Delay%

adbClick(143, 348)

Sleep, %Delay%

KeepSync(51, 335, 107, 359, , "Link") ;wait for link account screen%
Sleep, %Delay%
KeepSync(19, 233, 105, 252, , "Confirm", 140, 460, 1000) ;wait for confirm download screen

KeepSync(69, 248, 207, 270, , "Complete", 203, 364, 1000) ;wait for complete download screen

Sleep, %Delay%

adbClick(143, 369)

Sleep, %Delay%
		
	if(setSpeed = 3) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		KeepSync(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
		Sleep, %Delay%
		adbClick(166, 296)
		Sleep, %Delay%
	} 
	
	KeepSync(60, 206, 226, 248, , "Welcome", 253, 506, 110) ;click through cutscene until welcome page
	
	if(setSpeed = 3) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
	
		KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
		Sleep, %Delay%
		adbClick(166, 296)
	}
KeepSync(190, 241, 225, 270, , "Name", 189, 438) ;wait for name input screen

KeepSync(230, 500, 270, 520, , "OK", 139, 257) ;wait for name input screen

failSafe := A_TickCount
failSafeTime := 0
Loop {
	adbName()
	Sleep, %Delay%
	if(KeepSync(121, 490, 161, 520, , "Return", 185, 372, , 5)) ;click through until return button on open pack
		break
		
	adbClick(90, 370)
	Sleep, %Delay%
	adbClick(139, 254) ; 139 254 194 372
	Sleep, %Delay%
	adbClick(139, 254)
	Sleep, %Delay%
	length := StrLen(Name) ; in case it lags and misses inputting name
	Loop %length% {
		adbShell.StdIn.WriteLine("input keyevent 67")	
		Sleep, 10
	}
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
	if(failSafeTime > 45)
		restartGameInstance("Stuck at name")
}

Sleep, %Delay%

adbClick(140, 424)

KeepSync(104, 269, 177, 296, , "Trace", 140, 424) ;wait for pack to be ready  to trace
	if(setSpeed > 1) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		KeepSync(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
		Sleep, %Delay%
	}
failSafe := A_TickCount
failSafeTime := 0
Loop {
	adbSwipe()
	Sleep, 10
	if (CheckInstances(195, 220, 230, 270, , "Bulba", 0, failSafeTime)){
	if(setSpeed > 1) {
		if(setSpeed = 3)
				KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click 3x
		else
				KeepSync(100, 170, 113, 190, , "Two", 107, 180) ; click 2x
	}
		adbClick(166, 296)
			break
		}
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
}

KeepSync(34, 99, 74, 131, , "Swipe", 140, 375) ;click through cards until needing to swipe up
	if(setSpeed > 1) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		KeepSync(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
		Sleep, %Delay%
	}
failSafe := A_TickCount
failSafeTime := 0
Loop {
	adbSwipeUp()
	Sleep, 10
	if (CheckInstances(120, 70, 150, 95, , "SwipeUp", 0, failSafeTime)){
	if(setSpeed > 1) {
		if(setSpeed = 3)
				KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
		else
				KeepSync(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
	}
		adbClick(166, 296)
			break
		}
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for swipe up. It's been: " . failSafeTime "s ")
	Sleep, %Delay%
}

KeepSync(70, 80, 133, 109, , "Move", 134, 375) ; click through until move
Sleep, %Delay%
if(setSpeed > 2)
	KeepSync(105, 242, 173, 277, , "Proceed", 141, 483, 800) ;wait for menu to proceed then click ok. increased delay in between clicks to fix freezing on 3x speed
else
KeepSync(105, 242, 173, 277, , "Proceed", 141, 483) ;wait for menu to proceed then click ok
Sleep, %Delay%
adbClick(204, 371)

KeepSync(46, 368, 103, 411, , "Gray") ;wait for for missions to be clickable

Sleep, %Delay%
adbClick(247, 472)

KeepSync(115, 97, 174, 150, , "Pokeball", 247, 472, 5000) ; click through missions until missions is open

Sleep, %Delay%
adbClick(141, 294)
Sleep, %Delay%
adbClick(141, 294)
Sleep, %Delay%
KeepSync(124, 168, 162, 207, , "Register", 141, 294, 1000) ; wait for register screen
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(140, 500)

KeepSync(115, 255, 176, 308, , "Mission") ; wait for mission complete screen

KeepSync(46, 368, 103, 411, , "Gray", 143, 360) ;wait for for missions to be clickable

KeepSync(120, 176, 162, 210, , "Booster", 145, 194) ;click on packs. stop at booster pack tutorial

Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)

KeepSync(104, 269, 177, 296, , "Trace", 239, 497) ;wait for pack to be ready  to Trace
	if(setSpeed > 1) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		KeepSync(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
		Sleep, %Delay%
	}
failSafe := A_TickCount
failSafeTime := 0
Loop {
	adbSwipe()
	Sleep, 10
	if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime)){	
	if(setSpeed > 1) {
		if(setSpeed = 3)
					KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
		else
					KeepSync(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
	}
			adbClick(166, 296)
			break
		}
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for skip. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
		Sleep, %Delay%
}

KeepSync(69, 66, 116, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

checkBorder() ;check card border to find godpacks	

KeepSync(233, 486, 272, 519, , "Skip", 146, 496) ;click on next until skip button appears

Loop {
		if(KeepSync(53, 281, 86, 310, , "Wonder", 239, 497, , 1)) ;click on next until skip button appearsstop at hourglasses tutorial
			break
		adbClick(146, 494) ;146 494
		Sleep, %Delay%
	}

Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%

adbClick(140, 358)

KeepSync(194, 421, 220, 433, , "Shop", 146, 444) ;click until at main menu

KeepSync(87, 232, 131, 266, , "Wonder2", 79, 411) ; click until wonder pick tutorial screen

KeepSync(116, 412, 167, 433, , "Wonder3", 190, 437) ; click through tutorial

Sleep, %Delay%
Sleep, %Delay%

KeepSync(155, 281, 192, 315, , "Wonder4", 202, 347, 500) ; confirm wonder pick selection 

KeepSync(103, 101, 177, 121, , "Pick", 208, 461, 350) ;stop at pick a card

sleep, %Delay%
adbClick(187, 345)
; Loop {
; if(KeepSync(39, 102, 68, 130, , "Swipe2", 239, 497, , 7)) ;click through cards until needing to swipe up
	; break
; }
failSafe := A_TickCount
failSafeTime := 0
Loop {
	if(setSpeed = 3)
		continueTime := 1
	else
		continueTime := 6
	if(KeepSync(60, 210, 224, 246, , "End", 239, 497, , continueTime, failSafeTime)) ;click through to end of tut screen
		break
	sleep, %Delay%
adbClick(143, 492)
	sleep, %Delay%
adbClick(143, 492)
	sleep, %Delay%
adbClick(66, 446)
	sleep, %Delay%
adbClick(66, 446)
	sleep, %Delay%
adbClick(66, 446)
	sleep, %Delay%
adbClick(187, 345)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for End. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for End. It's been: " . failSafeTime "s ")
}


KeepSync(125, 330, 162, 348, , "Main", 192, 449) ;click until at main menu
Loop {
	if(!GPTest) {
		break
	}
	if(!deleteAccount) {
		adbClick(143, 518)
		Sleep, %Delay%
		Sleep, %Delay%
		adbClick(143, 518)
		Sleep, %Delay%
		Sleep, %Delay%
		adbClick(143, 518)
		Sleep, %Delay%
		Sleep, %Delay%
		adbClick(143, 518)
		Sleep, %Delay%
		Sleep, %Delay%
		adbClick(143, 518)
		Sleep, %Delay%
		Sleep, %Delay%
		adbClick(143, 518)
		Sleep, %Delay%
		Sleep, %Delay%
		adbClick(143, 518)
		Sleep, %Delay%
		Sleep, %Delay%
	}
	deleteAccount := true
	CreateStatusMessage("GP Test mode. Press button again to delete.")
	sleep, 1000
}

if(deleteAccount = false) {	
	if(openPack = 4) { ; MEW
		KeepSync(233, 400, 264, 428, , "Points", 80, 196) ;Mew	
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
	else if(openPack = 1) { ;MEWTWO
		KeepSync(233, 400, 264, 428, , "Points", 200, 196) ;Genetic apex
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
	else if(openPack = 2) { ;pikachu
		KeepSync(233, 400, 264, 428, , "Points", 200, 196) ;Genetic apex
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 400, 264, 428, , "Points") ;Genetic apex
	adbClick(222, 268)
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
	else if(openPack = 3) { ;charizard
		
		KeepSync(233, 400, 264, 428, , "Points", 200, 196) ;Genetic apex
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 400, 264, 428, , "Points") ;Genetic apex
	adbClick(56, 268)
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
		
	Loop {
		if(KeepSync(104, 269, 174, 294, , "Trace", 239, 497, , 2))
			break ;wait for pack to be ready to Trace and click skip
		sleep, %Delay%
	adbClick(146, 439)
	}

		if(setSpeed > 1) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		KeepSync(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
			Sleep, %Delay%
		}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()	
		Sleep, 10
		if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime)){
		if(setSpeed > 1) {
			if(setSpeed = 3)
					KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
			else
					KeepSync(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		}
			adbClick(166, 296)
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
		Sleep, %Delay%
	}

		
	KeepSync(69, 66, 116, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

	checkBorder() ;check card border to find godpacks	

	KeepSync(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears

	Loop {
		if(KeepSync(20, 500, 55, 530, , "Home", 244, 496, , 1)) ;click on next until skip button appearsstop at hourglasses tutorial
			break
		adbClick(146, 494) ;146 494
		Sleep, %Delay%
	}

	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(142, 429)

	Loop {
		if(KeepSync(104, 269, 174, 294, , "Trace", 239, 497, , 2))
			break ;wait for pack to be ready to Trace and click skip
		sleep, %Delay%
	adbClick(142, 429)
	}
	
		if(setSpeed > 1) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		KeepSync(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
			Sleep, %Delay%
		}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()
		Sleep, 10
		if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime)){
		if(setSpeed > 1) {
			if(setSpeed = 3)
					KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
			else
					KeepSync(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		}
			adbClick(166, 296)
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
		Sleep, %Delay%
	}
	KeepSync(69, 66, 116, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

	checkBorder() ;check card border to find godpacks	
			
	KeepSync(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears


	Loop {
		if(KeepSync(178, 193, 251, 282, , "Hourglass", 239, 497, , 1)) ;click on next until skip button appearsstop at hourglasses tutorial
			break
		adbClick(146, 494) ;146 494
		Sleep, %Delay%
	}
	/*
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(146, 441) ; 146 440
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(146, 441)
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(146, 441)
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	*/
	KeepSync(98, 184, 151, 224, , "Hourglass1", 168, 438, 500, 5) ;stop at hourglasses tutorial 2
	Sleep, %Delay%

	adbClick(203, 436) ; 203 436

	KeepSync(184, 222, 248, 246, , "Hourglass2", 180, 436, 500) ;stop at hourglasses tutorial 2 180 to 203?

	Sleep, %Delay%
	adbClick(210, 464) ; 210 464
	Sleep, %Delay%
	adbClick(210, 464) ; 210 464

	Loop {

		if(KeepSync(104, 269, 174, 294, , "Trace", 239, 497, , 2)) ;wait for pack to be ready to Trace and click skip
			break 
		Sleep, %Delay%
		adbClick(210, 464) ; 210 464
	}
	failSafe := A_TickCount
	failSafeTime := 0
		if(setSpeed > 1) {
		KeepSync(73, 204, 137, 219, , "Platin", 18, 109, 2000) ; click mod settings
		KeepSync(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
			Sleep, %Delay%
		}
	Loop {
		adbSwipe()
		Sleep, 10
		if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime)) {
		if(setSpeed > 1) {
			if(setSpeed = 3)
					KeepSync(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
			else
					KeepSync(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		}
			adbClick(166, 296)
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
		Sleep, %Delay%
	}

	
	KeepSync(69, 66, 116, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

	checkBorder() ;check card border to find godpacks	

	KeepSync(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears
	sleep, %Delay%
	
	Loop {
		if(KeepSync(20, 500, 55, 530, , "Home", 244, 496, , 1)) ;click on next until skip button appearsstop at hourglasses tutorial
			break
		adbClick(146, 494) ;146 494
		Sleep, %Delay%
	}
	
}

sleep, %Delay%
failSafe := A_TickCount
failSafeTime := 0
Loop
{
	sleep, %Delay%
	sleep, %Delay%
	adbClick(245, 518)
	if(KeepSync(90, 260, 126, 290, , "Settings", , , , 3, failSafeTime)) ;wait for settings menu
		break
	sleep, %Delay%
	sleep, %Delay%
	adbClick(50, 100)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Settings. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Settings. It's been: " . failSafeTime "s ")
}
Sleep,%Delay%
KeepSync(24, 158, 57, 189, , "Account", 140, 440, 2000) ;wait for other menu
Sleep,%Delay%
KeepSync(56, 312, 108, 334, , "Account2", 79, 256, 1000) ;wait for account menu
Sleep,%Delay%
KeepSync(74, 104, 133, 135, , "Delete", 145, 446, 2000) ;wait for delete save data confirmation
Sleep,%Delay%
KeepSync(73, 191, 133, 208, , "Delete2", 201, 447, %Delay%) ;wait for second delete save data 
Sleep,%Delay%
KeepSync(30, 240, 121, 275, , "Delete3", 201, 369, 2000) ;wait for second 
Sleep,%Delay%
adbClick(143, 370)

Sleep, 2500

if(deleteAccount := true) {
	CreateStatusMessage("Exiting GP Test Mode")
	deleteAccount := false
}
	
rerolls++
AppendToJsonFile(4)
packs += 4
totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
avgtotalSeconds := Round(totalSeconds / rerolls) ; Total time in seconds
minutes := Floor(avgtotalSeconds / 60) ; Total minutes
seconds := Mod(avgtotalSeconds, 60) ; Remaining seconds within the minute
mminutes := Floor(totalSeconds / 60) ; Total minutes
sseconds := Mod(totalSeconds, 60) ; Remaining seconds within the minute
CreateStatusMessage("Avg: " . minutes . "m " . seconds . "s Runs: " . rerolls, 25, 0, 510)
LogToFile("Packs: " . packs . " Total time: " . mminutes . "m " . sseconds . "s Avg: " . minutes . "m " . seconds . "s Runs: " . rerolls)

}
return

CheckInstances(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", EL := 1, safeTime := 0) {
	global winTitle, Variation, failSafe
	if(searchVariation = "")
		searchVariation := Variation
	imagePath := A_ScriptDir . "\" . defaultLanguage . "\"
	confirmed := false
	
	CreateStatusMessage(imageName)
	pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
	Path = %imagePath%%imageName%.png
	pNeedle := Gdip_CreateBitmapFromFile(Path)

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
		}
	}
	;bboxAndPause(X1, Y1, X2, Y2)

	; ImageSearch within the region
	vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, X1, Y1, X2, Y2, searchVariation)
	Gdip_DisposeImage(pNeedle)
	Gdip_DisposeImage(pBitmap)
	if(EL = 0)
		GDEL := 1
	else
		GDEL := 0
	if (!confirmed && vRet = GDEL) {
		confirmed := true
	}
	pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
	Path = %imagePath%App.png
	pNeedle := Gdip_CreateBitmapFromFile(Path)
	; ImageSearch within the region
	vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
	Gdip_DisposeImage(pNeedle)
	Gdip_DisposeImage(pBitmap)
	if (vRet = 1) {
		CreateStatusMessage("At home page. Opening app..." )
		restartGameInstance("At the home page during: `n" imageName)
	}
	
	if (safeTime >= 45) {
		CreateStatusMessage("Instance " . scriptName . " has been stuck " . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		restartGameInstance("Instance " . scriptName . " has been stuck " . imageName)
		safeTime := safeTime/2
		failSafe := A_TickCount
	}
	return (confirmed)
}

KeepSync(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", clickx := 0, clicky := 0, sleepTime := "", skip := false, safeTime := 0) {
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
		} else if (imageName = "End") { ; instead of 0, 0
			X1 := 70
			Y1 := 212
		}

		if (clickx = 239 and clicky = 497  and imageName != "Wonder") { ; blanket fix for opening wonder trace hourglass end (though mostly opening for immersives)
			clickx := 255
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
		
		if (confirmed = true) {
			continue
		}

		pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
		Path = %imagePath%%imageName%.png
		pNeedle := Gdip_CreateBitmapFromFile(Path)
		;bboxAndPause(X1, Y1, X2, Y2)
		; ImageSearch within the region
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, X1, Y1, X2, Y2, searchVariation)
		Gdip_DisposeImage(pNeedle)
		Gdip_DisposeImage(pBitmap)
		if (!confirmed && vRet = 1) {
			confirmed := true
		} else {
			if(imageName = "Skip3") {
				Sleep, 1000
			adbClick(259, 79)
			}
			ElapsedTime := (A_TickCount - StartSkipTime) // 1000
			if (ElapsedTime >= 45 || safeTime >= 45) {
				CreateStatusMessage("Instance " . scriptName . " has been stuck for 90s. Killing it...")
				restartGameInstance("Instance " . scriptName . " has been stuck at " . imageName) ; change to reset the instance and delete data then reload script
				StartSkipTime := A_TickCount
				failSafe := A_TickCount
			}
		}

		pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
		Path = %imagePath%Error1.png
		pNeedle := Gdip_CreateBitmapFromFile(Path)
		; ImageSearch within the region
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
		Gdip_DisposeImage(pNeedle)
		Gdip_DisposeImage(pBitmap)
		if (vRet = 1) {
			CreateStatusMessage("Error message in " scriptName " Clicking retry..." )
			LogToFile("Error message in " scriptName " Clicking retry..." )
			adbClick(82, 389)
			Sleep, %Delay%
			adbClick(139, 386)
			Sleep, 1000
		}
		pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
		Path = %imagePath%App.png
		pNeedle := Gdip_CreateBitmapFromFile(Path)
		; ImageSearch within the region
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
		Gdip_DisposeImage(pNeedle)
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
		if (confirmed = true) {
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
			rowHeight := 533  ; Adjust the height of each row
			currentRow := Floor((winTitle - 1) / Columns)
			y := currentRow * rowHeight	
			x := Mod((winTitle - 1), Columns) * scaleParam
	
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

killGodPackInstance(){
	global winTitle, godPack
	if(godPack = 2) {
	CreateStatusMessage("Pausing script. Found GP.")
	LogToFile("Paused God Pack instance.")
		; Loop {
			; Sleep, 60000
			; adbShell.StdIn.WriteLine("input text GP" )
		; }
	Pause, On 
	}
	else {
		CreateStatusMessage("Closing script. Found GP.")
		LogToFile("Closing God Pack instance.")
		WinClose, %winTitle% ;in case you resume and miss that you got a god pack.
		ExitApp
	}
}

restartGameInstance(reason){
	global Delay, scriptName
	CreateStatusMessage("Restarting game. " reason)
	LogToFile("Restarted game for instance " scriptName " Reason: " reason, "Restart.txt")
	adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
	sleep, 1000
	adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
	sleep, 1000
	Reload
}

LogToFile(message, logFile := "") {
	global scriptName
	if(logFile = "")
		logFile := A_ScriptDir . "\..\Logs\Logs" . scriptName . ".txt"
	else
		logFile := A_ScriptDir . "\..\Logs\" . logFile
	FormatTime, readableTime, %A_Now%, MMMM dd, yyyy HH:mm:ss
    FileAppend, % "[" readableTime "] " message "`n", %logFile%
}

CreateStatusMessage(Message, GuiName := 50, X := 0, Y := 80) {
	global scriptName, winTitle, statusText, SelectedMonitorIndex
	MaxRetries := 10
	RetryCount := 0
	try {
		GuiName := GuiName+scriptName
		statusText := GuiName+scriptName
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
		Gui, %GuiName%:Add, Text, vStatusText, %Message%
		Gui,%GuiName%:Show,NoActivate x%X% y%Y% AutoSize, NoActivate %GuiName%
	}
}

checkBorder() {
	global winTitle, falsePositive, discordUserId, skipInvalidGP
	invalidGP := false
	if(falsePositive = 1) {
	Sleep, 250
		searchVariation := 10
	}
	else {
		Sleep, 1000
		searchVariation := 25
	}
	pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
	Path = %A_ScriptDir%\%defaultLanguage%\Border.png
	pNeedle := Gdip_CreateBitmapFromFile(Path)
	; ImageSearch within the region
	if (scaleParam = 277) {
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 20, 284, 90, 286, searchVariation)
	} else {
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 20, 284-6, 90, 286-6, searchVariation)
		;bboxAndPause(20, 284-6, 90, 286-6)
	}
	Gdip_DisposeImage(pNeedle)
	Gdip_DisposeImage(pBitmap)
	if (vRet = 1) {
		CreateStatusMessage("Not a God Pack ")
	}
	else {
		;pause (should pause if first card is not 1 or 2 diamonds)
		pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
		Path = %A_ScriptDir%\%defaultLanguage%\Border.png
		pNeedle := Gdip_CreateBitmapFromFile(Path)
		; ImageSearch within the region
		if (scaleParam = 277) {
			vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 103, 284, 173, 286, searchVariation)
		} else {
			vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 103, 284-6, 173, 286-6, searchVariation)
			;bboxAndPause(103, 284-6, 173, 286-6)
		}
		Gdip_DisposeImage(pNeedle)
		Gdip_DisposeImage(pBitmap)
		if (vRet = 1) {
			CreateStatusMessage("Not a God Pack ")
			LogToFile("Second card checked. Not a God Pack ")
		}
		else {
			if(skipInvalidGP = 2) {
				Loop 8 {
					pBitmap := from_window(WinExist(winTitle)) ; Pick your own window title
					if (scaleParam = 277) { ; 125% scale
						Path = %A_ScriptDir%\Skip\%A_Index%.png
						pNeedle := Gdip_CreateBitmapFromFile(Path)
						vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 5, 165, 265, 405, 40)
					} else {
						Path = %A_ScriptDir%\Skip\100\%A_Index%.png
						pNeedle := Gdip_CreateBitmapFromFile(Path)
						vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 5, 165-6, 265, 405-6, 40)
						;bboxAndPause(5, 165-6, 265, 405-6, True)
					}
					Gdip_DisposeImage(pNeedle)
					Gdip_DisposeImage(pBitmap)
					if (vRet = 1) {
						invalidGP := true
					}
				}
			}
			if(invalidGP) {
				logMessage := "Skipping invalid god pack in instance: " . scriptName
				CreateStatusMessage(logMessage)
				godPackLog = GPlog.txt
				LogToFile(logMessage, godPackLog)
				LogToDiscord(logMessage, Screenshot(), discordUserId)
				LogToTelegram(logMessage, Screenshot())
				;killGodPackInstance()
			}
			else {
				logMessage := "Congrats! God pack found in instance: " . scriptName
				CreateStatusMessage(logMessage)
				godPackLog = GPlog.txt
				LogToFile(logMessage, godPackLog)
				LogToDiscord(logMessage, Screenshot(), discordUserId)
				LogToTelegram(logMessage, Screenshot())
				killGodPackInstance()
			}
		}
	}
}

adbClick(X, Y) {
	global adbShell, setSpeed
	X := Round(X / 277 * 540)
    Y := Round((Y - 44) / 489 * 960) 
	adbShell.StdIn.WriteLine("input tap " X " " Y)
}

ControlClick(X, Y) {
	global winTitle
	ControlClick, x%X% y%Y%, %winTitle%
}

adbName() {
	global Name, adbShell
	adbShell.StdIn.WriteLine("input text " Name )
}

adbSwipeUp() {
	global adbShell
	adbShell.StdIn.WriteLine("input swipe 309 816 309 355 60") 
	;adbShell.StdIn.WriteLine("input swipe 309 816 309 555 30")	
	Sleep, 150
}

adbSwipe() {
	global adbShell, setSpeed, swipeSpeed
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

Screenshot() {
	global adbShell, adbPath
	SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

	; Define folder and file paths
	screenshotsDir := A_ScriptDir "\..\Screenshots"
	if !FileExist(screenshotsDir)
		FileCreateDir, %screenshotsDir%
		
	; File path for saving the screenshot locally
	screenshotFile := screenshotsDir "\" winTitle "_" A_Now ".png"

	pBitmap := from_window(WinExist(winTitle))
	Gdip_SaveBitmapToFile(pBitmap, screenshotFile) 
	
	return screenshotFile
}

LogToDiscord(message, screenshotFile := "", ping := false) {
    global discordUserId, discordWebhookURL
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
						RunWait, curl -F "file=@%screenshotFile%" %discordWebhookURL%,, Hide
					}
				}
				break
			}
			catch {
				RetryCount++
				if (RetryCount >= MaxRetries) {
					CreateStatusMessage("Failed to send discord message.")
				}
				Sleep, 250
				break
			}
			sleep, 250
		}
    }
}

LogToTelegram(message, screenshotFile := "") {
	global telegramToken, telegramChatID, telegramTopicID
	if (telegramToken != "" && telegramChatID != "") {
		; Prepare the message data
		url := "https://api.telegram.org/bot" . telegramToken
		params := "?chat_id=" . telegramChatID . "&message_thread_id=" . telegramTopicID . "&text=" . message . scriptName
		

		; Create the HTTP request object
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", url . "/sendMessage" . params, false)
		whr.Send()

		; If an image file is provided, send it
		if (screenshotFile != "") {
			; Check if the file exists
			if (FileExist(screenshotFile)) {
				; Send the image using curl
				image_url := url . "/sendPhoto"
				curlCommand := "curl -F ""photo=@" . screenshotFile . """ -F ""chat_id=" . telegramChatID . """ -F ""message_thread_id=" . telegramTopicID . """ " . image_url
				RunWait, %curlCommand%,, Hide
            }
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
	
	ReloadScript:
		Reload
	return
	
	TestScript:
	ToggleTestScript()
	return

ToggleTestScript()
{
	global GPTest
	if(!GPTest) {
		CreateStatusMessage("In GP Test Mode")
		GPTest := true
	}
	else {
		CreateStatusMessage("Exiting GP Test Mode")
		;Winset, Alwaysontop, On, %winTitle%
		GPTest := false
	}
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

; ^e::
	; WinGetPos, xpos, ypos, Width, Height, 1
	; Msgbox %xpos% %ypos%
	; checkBorder()
; return
~F5::Reload
~F6::Pause
~F7::ExitApp
~F8::ToggleTestScript()
;~F9::restartGameInstance("F9")

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
