#Include %A_ScriptDir%\Include\Gdip_All.ahk
#Include %A_ScriptDir%\Include\Gdip_Imagesearch.ahk

; BallCity - 2025.20.25 - Add OCR library for Username if Inject is on
#Include *i %A_ScriptDir%\Include\OCR.ahk

#SingleInstance on
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetBatchLines, -1
SetTitleMatchMode, 3
CoordMode, Pixel, Screen
#NoEnv

; Allocate and hide the console window to reduce flashing
DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, adbPort, scriptName, adbShell, adbPath, GPTest, StatusText, defaultLanguage, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, discordUserId, discordWebhookURL, deleteMethod, packs, FriendID, friendIDs, Instances, username, friendCode, stopToggle, friended, runMain, Mains, showStatus, injectMethod, packMethod, loadDir, loadedAccount, nukeAccount, CheckShiningPackOnly, TrainerCheck, FullArtCheck, RainbowCheck, ShinyCheck, dateChange, foundGP, foundTS, friendsAdded, minStars, PseudoGodPack, Palkia, Dialga, Mew, Pikachu, Charizard, Mewtwo, packArray, CrownCheck, ImmersiveCheck, InvalidCheck, slowMotion, screenShot, accountFile, invalid, starCount, gpFound, foundTS, minStarsA1Charizard, minStarsA1Mewtwo, minStarsA1Pikachu, minStarsA1a, minStarsA2Dialga, minStarsA2Palkia, minStarsA2a, minStarsA2b
global DeadCheck, sendAccountXml

scriptName := StrReplace(A_ScriptName, ".ahk")
winTitle := scriptName
foundGP := false
injectMethod := false
pauseToggle := false
showStatus := true
friended := false
dateChange := false
jsonFileName := A_ScriptDir . "\..\json\Packs.json"
IniRead, FriendID, %A_ScriptDir%\..\Settings.ini, UserSettings, FriendID
IniRead, waitTime, %A_ScriptDir%\..\Settings.ini, UserSettings, waitTime, 5
IniRead, Delay, %A_ScriptDir%\..\Settings.ini, UserSettings, Delay, 250
IniRead, folderPath, %A_ScriptDir%\..\Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
IniRead, discordWebhookURL, %A_ScriptDir%\..\Settings.ini, UserSettings, discordWebhookURL, ""
IniRead, discordUserId, %A_ScriptDir%\..\Settings.ini, UserSettings, discordUserId, ""
IniRead, Columns, %A_ScriptDir%\..\Settings.ini, UserSettings, Columns, 5
IniRead, godPack, %A_ScriptDir%\..\Settings.ini, UserSettings, godPack, Continue
IniRead, Instances, %A_ScriptDir%\..\Settings.ini, UserSettings, Instances, 1
IniRead, defaultLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, defaultLanguage, Scale125
IniRead, SelectedMonitorIndex, %A_ScriptDir%\..\Settings.ini, UserSettings, SelectedMonitorIndex, 1
IniRead, swipeSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, swipeSpeed, 300
IniRead, deleteMethod, %A_ScriptDir%\..\Settings.ini, UserSettings, deleteMethod, 3 Pack
IniRead, runMain, %A_ScriptDir%\..\Settings.ini, UserSettings, runMain, 1
IniRead, Mains, %A_ScriptDir%\..\Settings.ini, UserSettings, Mains, 1
IniRead, heartBeat, %A_ScriptDir%\..\Settings.ini, UserSettings, heartBeat, 0
IniRead, heartBeatWebhookURL, %A_ScriptDir%\..\Settings.ini, UserSettings, heartBeatWebhookURL, ""
IniRead, heartBeatName, %A_ScriptDir%\..\Settings.ini, UserSettings, heartBeatName, ""
IniRead, nukeAccount, %A_ScriptDir%\..\Settings.ini, UserSettings, nukeAccount, 0
IniRead, packMethod, %A_ScriptDir%\..\Settings.ini, UserSettings, packMethod, 0
IniRead, CheckShiningPackOnly, %A_ScriptDir%\..\Settings.ini, UserSettings, CheckShiningPackOnly, 0
IniRead, TrainerCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, TrainerCheck, 0
IniRead, FullArtCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, FullArtCheck, 0
IniRead, RainbowCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, RainbowCheck, 0
IniRead, ShinyCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, ShinyCheck, 0
IniRead, CrownCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, CrownCheck, 0
IniRead, ImmersiveCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, ImmersiveCheck, 0
IniRead, InvalidCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, InvalidCheck, 0
IniRead, PseudoGodPack, %A_ScriptDir%\..\Settings.ini, UserSettings, PseudoGodPack, 0
IniRead, minStars, %A_ScriptDir%\..\Settings.ini, UserSettings, minStars, 0
IniRead, Palkia, %A_ScriptDir%\..\Settings.ini, UserSettings, Palkia, 0
IniRead, Dialga, %A_ScriptDir%\..\Settings.ini, UserSettings, Dialga, 0
IniRead, Arceus, %A_ScriptDir%\..\Settings.ini, UserSettings, Arceus, 0
IniRead, Shining, %A_ScriptDir%\..\Settings.ini, UserSettings, Shining, 1
IniRead, Mew, %A_ScriptDir%\..\Settings.ini, UserSettings, Mew, 0
IniRead, Pikachu, %A_ScriptDir%\..\Settings.ini, UserSettings, Pikachu, 0
IniRead, Charizard, %A_ScriptDir%\..\Settings.ini, UserSettings, Charizard, 0
IniRead, Mewtwo, %A_ScriptDir%\..\Settings.ini, UserSettings, Mewtwo, 0
IniRead, slowMotion, %A_ScriptDir%\..\Settings.ini, UserSettings, slowMotion, 0
IniRead, DeadCheck, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck, 0
IniRead, ocrLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, ocrLanguage, en
IniRead, sendAccountXml, %A_ScriptDir%\..\Settings.ini, UserSettings, sendAccountXml, 0

IniRead, minStarsA1Charizard, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1Charizard, 0
IniRead, minStarsA1Mewtwo, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1Mewtwo, 0
IniRead, minStarsA1Pikachu, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1Pikachu, 0
IniRead, minStarsA1a, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1a, 0
IniRead, minStarsA2Dialga, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2Dialga, 0
IniRead, minStarsA2Palkia, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2Palkia, 0
IniRead, minStarsA2a, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2a, 0
IniRead, minStarsA2b, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2b, 0

pokemonList := ["Palkia", "Dialga", "Mew", "Pikachu", "Charizard", "Mewtwo", "Arceus", "Shining"]

packArray := []  ; Initialize an empty array

Loop, % pokemonList.MaxIndex()  ; Loop through the array
{
    pokemon := pokemonList[A_Index]  ; Get the variable name as a string
    if (%pokemon%)  ; Dereference the variable using %pokemon%
        packArray.push(pokemon)  ; Add the name to packArray
}

changeDate := getChangeDateTime() ; get server reset time

if(heartBeat)
	IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Instance%scriptName%

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
Sleep, % scriptName * 1000
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
		buttonWidth := 40
		if (scaleParam = 287)
			buttonWidth := buttonWidth + 5

		Gui, New, +Owner%OwnerWND% -AlwaysOnTop +ToolWindow -Caption +LastFound
		Gui, Default
		Gui, Margin, 4, 4  ; Set margin for the GUI
		Gui, Font, s5 cGray Norm Bold, Segoe UI  ; Normal font for input labels
		Gui, Add, Button, % "x" . (buttonWidth * 0) . " y0 w" . buttonWidth . " h25 gReloadScript", Reload  (Shift+F5)
		Gui, Add, Button, % "x" . (buttonWidth * 1) . " y0 w" . buttonWidth . " h25 gPauseScript", Pause (Shift+F6)
		Gui, Add, Button, % "x" . (buttonWidth * 2) . " y0 w" . buttonWidth . " h25 gResumeScript", Resume (Shift+F6)
		Gui, Add, Button, % "x" . (buttonWidth * 3) . " y0 w" . buttonWidth . " h25 gStopScript", Stop (Shift+F7)
		Gui, Add, Button, % "x" . (buttonWidth * 4) . " y0 w" . buttonWidth . " h25 gShowStatusMessages", Status (Shift+F8)
		DllCall("SetWindowPos", "Ptr", WinExist(), "Ptr", 1  ; HWND_BOTTOM
				, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)  ; SWP_NOSIZE, SWP_NOMOVE, SWP_NOACTIVATE
		Gui, Show, NoActivate x%x4% y%y4% AutoSize
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
	Delay(1)
	CreateStatusMessage("Trying to create button gui...")
}

if (!godPack)
	godPack = 1
else if (godPack = "Close")
	godPack = 1
else if (godPack = "Pause")
	godPack = 2
if (godPack = "Continue")
	godPack = 3

if (!setSpeed)
	setSpeed = 1
if (setSpeed = "2x")
	setSpeed := 1
else if (setSpeed = "1x/2x")
	setSpeed := 2
else if (setSpeed = "1x/3x")
	setSpeed := 3

setSpeed := 3 ;always 1x/3x

if(InStr(deleteMethod, "Inject"))
	injectMethod := true

rerollTime := A_TickCount

initializeAdbShell()

createAccountList(scriptName)

if(injectMethod) {
	loadedAccount := loadAccount()
	nukeAccount := false
}

if(!injectMethod || !loadedAccount)
	restartGameInstance("Initializing bot...", false)

pToken := Gdip_Startup()
packs := 0

if(DeadCheck==1) {
	;LogToDiscord("Sup dudes. Not sure what happened, but a script died and I'm doing a menu delete and starting over.")
	friended:= true
	menuDeleteStart()
	IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
	Reload
}else{
	Loop {
		Randmax := packArray.Length()
		Random, rand, 1, Randmax
		openPack := packArray[rand]
		friended := false
		IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Instance%scriptName%
		FormatTime, CurrentTime,, HHmm

		StartTime := changeDate - 45 ; 12:55 AM2355
		EndTime := changeDate + 5 ; 1:01 AM

		; Adjust for crossing midnight
		if (StartTime < 0)
			StartTime += 2400
		if (EndTime >= 2400)
			EndTime -= 2400

		Random, randomTime, 3, 7

		While(((CurrentTime - StartTime >= 0) && (CurrentTime - StartTime <= randomTime)) || ((EndTime - CurrentTime >= 0) && (EndTime - CurrentTime <= randomTime)))
		{
			CreateStatusMessage("I need a break... Sleeping until " . changeDate + randomTime . " `nto avoid being kicked out from the date change")
			FormatTime, CurrentTime,, HHmm ; Update the current time after sleep
			Sleep, 5000
			dateChange := true
		}
		if(dateChange)
			createAccountList(scriptName)
		FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
		if(setSpeed = 3)
			FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
		else
			FindImageAndClick(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		Delay(1)
		adbClick(41, 296)
		Delay(1)
		packs := 0

		; BallCity 2025.02.21 - Keep track of additional metrics
		now := A_NowUTC
		IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastStartTimeUTC
		EnvSub, now, 1970, seconds
		IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastStartEpoch

		if(!injectMethod || !loadedAccount)
			DoTutorial()

		;	SquallTCGP 2025.03.12 - 	Adding the delete method 5 Pack (Fast) to the wonder pick check.
		if(deleteMethod = "5 Pack" || deleteMethod = "5 Pack (Fast)" || packMethod)
			if(!loadedAccount)
				wonderPicked := DoWonderPick()

		friendsAdded := AddFriends()
		SelectPack("First")
		PackOpening()

		if(packMethod) {
			friendsAdded := AddFriends(true)
			SelectPack()
		}

		PackOpening()

		if(!injectMethod || !loadedAccount)
			HourglassOpening() ;deletemethod check in here at the start

		if(wonderPicked) {
			
			;	SquallTCGP 2025.03.12 - 	Added a check to not add friends if the delete method is 5 Pack (Fast). When using this method (5 Pack (Fast)), 
			;															it goes to the social menu and clicks the home button to exit (instead of opening all packs directly)
			; 														just to get around the checking for a level after opening a pack. This change is made based on the 
			;															5p-no delete community mod created by DietPepperPhD in the discord server.

			if(deleteMethod != "5 Pack (Fast)") {
				friendsAdded := AddFriends(true)
			} else {
				FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 500)
				FindImageAndClick(20, 500, 55, 530, , "Home", 40, 516, 500)
			}
			SelectPack("HGPack")
			PackOpening()
			if(packMethod) {
				friendsAdded := AddFriends(true)
				SelectPack("HGPack")
				PackOpening()
			}
			else {
				HourglassOpening(true)
			}
		}

		if(nukeAccount && !injectMethod) {
			menuDelete()
		}else{
			RemoveFriends()
		}
		IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

		; BallCity 2025.02.21 - Keep track of additional metrics
		now := A_NowUTC
		IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastEndTimeUTC
		EnvSub, now, 1970, seconds
		IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastEndEpoch

		if(injectMethod)
			loadedAccount := loadAccount()

		if(!injectMethod || !loadedAccount) {
			if(!nukeAccount) {
				saveAccount("All")
				restartGameInstance("New Run", false)
			}
		}

		CreateStatusMessage("New Run")
		rerolls++
		if(!loadedAccount)
			if(deleteMethod = "5 Pack" || packMethod)
				packs := 5
		AppendToJsonFile(packs)
		totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
		avgtotalSeconds := Round(totalSeconds / rerolls) ; Total time in seconds
		minutes := Floor(avgtotalSeconds / 60) ; Total minutes
		seconds := Mod(avgtotalSeconds, 60) ; Remaining seconds within the minute
		mminutes := Floor(totalSeconds / 60) ; Total minutes
		sseconds := Mod(totalSeconds, 60) ; Remaining seconds within the minute
		CreateStatusMessage("Avg: " . minutes . "m " . seconds . "s Runs: " . rerolls, 25, 0, 510)
		LogToFile("Packs: " . packs . " Total time: " . mminutes . "m " . sseconds . "s Avg: " . minutes . "m " . seconds . "s Runs: " . rerolls)
		if(stopToggle)
			ExitApp
	}
}
return

RemoveFriends() {
	global friendIDs, stopToggle, friended
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbClick(143, 518)
		if(FindOrLoseImage(120, 500, 155, 530, , "Social", 0, failSafeTime))
			break
		else if(FindOrLoseImage(175, 165, 255, 235, , "Hourglass3", 0)) {
			Delay(3)
			adbClick(146, 441) ; 146 440
			Delay(3)
			adbClick(146, 441)
			Delay(3)
			adbClick(146, 441)
			Delay(3)

			FindImageAndClick(98, 184, 151, 224, , "Hourglass1", 168, 438, 500, 5) ;stop at hourglasses tutorial 2
			Delay(1)

			adbClick(203, 436) ; 203 436
		}
		Sleep, 500
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Social. " . failSafeTime "/90 seconds")
	}
	FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
	FindImageAndClick(205, 430, 255, 475, , "Search", 240, 120, 1500)
	FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
	if(!friendIDs) {
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			adbInput(FriendID)
			Delay(1)
			if(FindOrLoseImage(205, 430, 255, 475, , "Search", 0, failSafeTime)) {
				FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
				EraseInput(1,1)
			} else if(FindOrLoseImage(205, 430, 255, 475, , "Search2", 0, failSafeTime)) {
				break
			}
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for AddFriends1. " . failSafeTime "/45 seconds")
		}
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			adbClick(232, 453)
			if(FindOrLoseImage(165, 250, 190, 275, , "Send", 0, failSafeTime)) {
				break
			} else if(FindOrLoseImage(165, 250, 190, 275, , "Accepted", 0, failSafeTime)) {
				FindImageAndClick(135, 355, 160, 385, , "Remove", 193, 258, 500)
				FindImageAndClick(165, 250, 190, 275, , "Send", 200, 372, 2000)
				break
			} else if(FindOrLoseImage(165, 240, 255, 270, , "Withdraw", 0, failSafeTime)) {
				FindImageAndClick(165, 250, 190, 275, , "Send", 243, 258, 2000)
				break
			}
			Sleep, 750
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for AddFriends2. " . failSafeTime "/45 seconds")
		}
		n := 1 ;how many friends added needed to return number for remove friends
	} else {
		;randomize friend id list to not back up mains if running in groups since they'll be sent in a random order.
		n := friendIDs.MaxIndex()
		Loop % n
		{
			i := n - A_Index + 1
			Random, j, 1, %i%
			; Force string assignment with quotes
			temp := friendIDs[i] . ""  ; Concatenation ensures string type
			friendIDs[i] := friendIDs[j] . ""
			friendIDs[j] := temp . ""
		}
		for index, value in friendIDs {
			if (StrLen(value) != 16) {
				; Wrong id value
				continue
			}
			failSafe := A_TickCount
			failSafeTime := 0
			Loop {
				adbInput(value)
				Delay(1)
				if(FindOrLoseImage(205, 430, 255, 475, , "Search", 0, failSafeTime)) {
					FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
					EraseInput()
				} else if(FindOrLoseImage(205, 430, 255, 475, , "Search2", 0, failSafeTime)) {
					break
				}
				failSafeTime := (A_TickCount - failSafe) // 1000
				CreateStatusMessage("In failsafe for AddFriends3. " . failSafeTime "/45 seconds")
			}
			failSafe := A_TickCount
			failSafeTime := 0
			Loop {
				adbClick(232, 453)
				if(FindOrLoseImage(165, 250, 190, 275, , "Send", 0, failSafeTime)) {
					break
				} else if(FindOrLoseImage(165, 250, 190, 275, , "Accepted", 0, failSafeTime)) {
					FindImageAndClick(135, 355, 160, 385, , "Remove", 193, 258, 500)
					FindImageAndClick(165, 250, 190, 275, , "Send", 200, 372, 500)
					break
				} else if(FindOrLoseImage(165, 240, 255, 270, , "Withdraw", 0, failSafeTime)) {
					FindImageAndClick(165, 250, 190, 275, , "Send", 243, 258, 2000)
					break
				}
				Sleep, 750
				failSafeTime := (A_TickCount - failSafe) // 1000
				CreateStatusMessage("In failsafe for AddFriends4. " . failSafeTime "/45 seconds")
			}
			if(index != friendIDs.maxIndex()) {
				FindImageAndClick(205, 430, 255, 475, , "Search2", 150, 50, 1500)
				FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
				EraseInput(index, n)
			}
		}
	}
	if(stopToggle)
	{
		IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
		ExitApp
	}
	friended := false
}

TradeTutorial() {
	if(FindOrLoseImage(100, 120, 175, 145, , "Trade", 0)) {
		FindImageAndClick(15, 455, 40, 475, , "Add2", 188, 449)
		Sleep, 1000
		FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
	}
	Delay(1)
}

AddFriends(renew := false, getFC := false) {
	global FriendID, friendIds, waitTime, friendCode, scriptName
	IniWrite, 1, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
	friendIDs := ReadFile("ids")
	count := 0
	friended := true
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		if(count > waitTime) {
			break
		}
		if(count = 0) {
			failSafe := A_TickCount
			failSafeTime := 0
			Loop {
				adbClick(143, 518)
				Delay(1)
				if(FindOrLoseImage(120, 500, 155, 530, , "Social", 0, failSafeTime)) {
					break
				}
				else if(!renew && !getFC) {
					clickButton := FindOrLoseImage(75, 340, 195, 530, 80, "Button", 0)
					if(clickButton) {
						StringSplit, pos, clickButton, `,  ; Split at ", "
						if (scaleParam = 287) {
							pos2 += 5
						}
						adbClick(pos1, pos2)
					}
				}
				else if(FindOrLoseImage(175, 165, 255, 235, , "Hourglass3", 0)) {
					Delay(3)
					adbClick(146, 441) ; 146 440
					Delay(3)
					adbClick(146, 441)
					Delay(3)
					adbClick(146, 441)
					Delay(3)

					FindImageAndClick(98, 184, 151, 224, , "Hourglass1", 168, 438, 500, 5) ;stop at hourglasses tutorial 2
					Delay(1)

					adbClick(203, 436) ; 203 436
				}
				failSafeTime := (A_TickCount - failSafe) // 1000
				CreateStatusMessage("In failsafe for Social. " . failSafeTime "/90 seconds")
			}
			FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
			FindImageAndClick(205, 430, 255, 475, , "Search", 240, 120, 1500)
			if(getFC) {
				Delay(3)
				adbClick(210, 342)
				Delay(3)
				friendCode := Clipboard
				return friendCode
			}
			FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
			if(!friendIDs) {
				failSafe := A_TickCount
				failSafeTime := 0
				Loop {
					adbInput(FriendID)
					Delay(1)
					if(FindOrLoseImage(205, 430, 255, 475, , "Search", 0, failSafeTime)) {
						FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
						EraseInput(1,1)
					} else if(FindOrLoseImage(205, 430, 255, 475, , "Search2", 0, failSafeTime)) {
						break
					}
					failSafeTime := (A_TickCount - failSafe) // 1000
					CreateStatusMessage("In failsafe for AddFriends1. " . failSafeTime "/45 seconds")
				}
				failSafe := A_TickCount
				failSafeTime := 0
				Loop {
					adbClick(232, 453)
					if(FindOrLoseImage(165, 250, 190, 275, , "Send", 0, failSafeTime)) {
						adbClick(243, 258)
						Delay(2)
						break
					}
					else if(FindOrLoseImage(165, 240, 255, 270, , "Withdraw", 0, failSafeTime)) {
						break
					}
					else if(FindOrLoseImage(165, 250, 190, 275, , "Accepted", 0, failSafeTime)) {
						if(renew){
							FindImageAndClick(135, 355, 160, 385, , "Remove", 193, 258, 500)
							FindImageAndClick(165, 250, 190, 275, , "Send", 200, 372, 500)
							if(!friended)
								ExitApp
							Delay(2)
							adbClick(243, 258)
						}
						break
					}
					Sleep, 750
					failSafeTime := (A_TickCount - failSafe) // 1000
					CreateStatusMessage("In failsafe for AddFriends2. " . failSafeTime "/45 seconds")
				}
				n := 1 ;how many friends added needed to return number for remove friends
			}
			else {
				;randomize friend id list to not back up mains if running in groups since they'll be sent in a random order.
				n := friendIDs.MaxIndex()
				Loop % n
				{
					i := n - A_Index + 1
					Random, j, 1, %i%
					; Force string assignment with quotes
					temp := friendIDs[i] . ""  ; Concatenation ensures string type
					friendIDs[i] := friendIDs[j] . ""
					friendIDs[j] := temp . ""
				}
				for index, value in friendIDs {
					if (StrLen(value) != 16) {
						; Wrong id value
						continue
					}
					failSafe := A_TickCount
					failSafeTime := 0
					Loop {
						adbInput(value)
						Delay(1)
						if(FindOrLoseImage(205, 430, 255, 475, , "Search", 0, failSafeTime)) {
							FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
							EraseInput()
						} else if(FindOrLoseImage(205, 430, 255, 475, , "Search2", 0, failSafeTime)) {
							break
						}
						failSafeTime := (A_TickCount - failSafe) // 1000
						CreateStatusMessage("In failsafe for AddFriends3. " . failSafeTime "/45 seconds")
					}
					failSafe := A_TickCount
					failSafeTime := 0
					Loop {
						adbClick(232, 453)
						if(FindOrLoseImage(165, 250, 190, 275, , "Send", 0, failSafeTime)) {
							adbClick(243, 258)
							Delay(2)
							break
						}
						else if(FindOrLoseImage(165, 240, 255, 270, , "Withdraw", 0, failSafeTime)) {
							break
						}
						else if(FindOrLoseImage(165, 250, 190, 275, , "Accepted", 0, failSafeTime)) {
							if(renew){
								FindImageAndClick(135, 355, 160, 385, , "Remove", 193, 258, 500)
								FindImageAndClick(165, 250, 190, 275, , "Send", 200, 372, 500)
								Delay(2)
								adbClick(243, 258)
							}
							break
						}
						Sleep, 750
						failSafeTime := (A_TickCount - failSafe) // 1000
						CreateStatusMessage("In failsafe for AddFriends4. " . failSafeTime "/45 seconds")
					}
					if(index != friendIDs.maxIndex()) {
						FindImageAndClick(205, 430, 255, 475, , "Search2", 150, 50, 1500)
						FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
						EraseInput(index, n)
					}
				}
			}
			FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 500)
			FindImageAndClick(20, 500, 55, 530, , "Home", 40, 516, 500)
		}
		CreateStatusMessage("Waiting for friends to accept request. `n" . count . "/" . waitTime . " seconds.")
		sleep, 1000
		count++
	}
	return n ;return added friends so we can dynamically update the .txt in the middle of a run without leaving friends at the end
}

ChooseTag() {
	FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 500)
	FindImageAndClick(20, 500, 55, 530, , "Home", 40, 516, 500) 212 276 230 294
	FindImageAndClick(203, 272, 237, 300, , "Profile", 143, 95, 500)
	FindImageAndClick(205, 310, 220, 319, , "ChosenTag", 143, 306, 1000)
	FindImageAndClick(203, 272, 237, 300, , "Profile", 143, 505, 1000)
	if(FindOrLoseImage(145, 140, 157, 155, , "Eevee", 1)) {
		FindImageAndClick(163, 200, 173, 207, , "ChooseEevee", 147, 207, 1000)
		FindImageAndClick(53, 218, 63, 228, , "Badge", 143, 466, 500)
	}
}

EraseInput(num := 0, total := 0) {
	if(num)
		CreateStatusMessage("Removing friend ID " . num . "/" . total)
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
		Loop 20 {
			adbInputEvent("67")
			Sleep, 10
		}
		if(FindOrLoseImage(15, 500, 68, 520, , "Erase", 0, failSafeTime))
			break
	}
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for EraseInput. " . failSafeTime "/45 seconds")
	LogToFile("In failsafe for Erase. " . failSafeTime "/45 seconds")
}

FindOrLoseImage(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", EL := 1, safeTime := 0) {
	global winTitle, failSafe
	if(slowMotion) {
		if(imageName = "Platin" || imageName = "One" || imageName = "Two" || imageName = "Three")
			return true
	}
	if(searchVariation = "")
		searchVariation := 20
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
		} else if (imageName = "Erika") { ; 100% fix for Erika avatar
			X1 := 149
			Y1 := 153
			X2 := 159
			Y2 := 162
		} else if (imageName = "DeleteAll") { ; 100% for Deleteall offset
			X1 := 200
			Y1 := 340
			X2 := 265
			Y2 := 530
		}
	}
	;bboxAndPause(X1, Y1, X2, Y2)

	; ImageSearch within the region
	vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, X1, Y1, X2, Y2, searchVariation)
	if(EL = 0)
		GDEL := 1
	else
		GDEL := 0
	if (!confirmed && vRet = GDEL && GDEL = 1) {
		confirmed := vPosXY
	} else if(!confirmed && vRet = GDEL && GDEL = 0) {
		confirmed := true
	}
	Path = %imagePath%App.png
	pNeedle := GetNeedle(Path)
	; ImageSearch within the region
	vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 225, 300, 242, 314, searchVariation)
	if (vRet = 1) {
		CreateStatusMessage("At home page. Opening app..." )
		restartGameInstance("At the home page during: `n" imageName)
	}
	if(imageName = "Social" || imageName = "Add") {
		TradeTutorial()
	}
	if(imageName = "Social" || imageName = "Country" || imageName = "Account2" || imageName = "Account") { ;only look for deleted account on start up.
		Path = %imagePath%NoSave.png ; look for No Save Data error message > if loaded account > delete xml > reload
		pNeedle := GetNeedle(Path)
		; ImageSearch within the region
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 30, 331, 50, 449, searchVariation)
		if (scaleParam = 287) {
			vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 30, 325, 55, 445, searchVariation)
		}
		if (vRet = 1) {
			adbShell.StdIn.WriteLine("rm -rf /data/data/jp.pokemon.pokemontcgp/cache/*") ; clear cache
			waitadb()
			CreateStatusMessage("Loaded deleted account. Deleting XML." )
			if(loadedAccount) {
				FileDelete, %loadedAccount%
				IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
			}
			LogToFile("Restarted game for instance " scriptName " Reason: No save data found", "Restart.txt")
			Reload
		}
	}
	if(imageName = "Points" || imageName = "Home") { ;look for level up ok "button"
		LevelUp()
	}
	if(imageName = "Country" || imageName = "Social")
		FSTime := 90
	else
		FSTime := 45
	if (safeTime >= FSTime) {
		CreateStatusMessage("Instance " . scriptName . " has been `nstuck " . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		restartGameInstance("Instance " . scriptName . " has been stuck " . imageName)
		failSafe := A_TickCount
	}
	Gdip_DisposeImage(pBitmap)
	return confirmed
}

FindImageAndClick(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", clickx := 0, clicky := 0, sleepTime := "", skip := false, safeTime := 0) {
	global winTitle, failSafe, confirmed, slowMotion

	if(slowMotion) {
		if(imageName = "Platin" || imageName = "One" || imageName = "Two" || imageName = "Three")
			return true
	}
	if(searchVariation = "")
		searchVariation := 20
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

		clicky += 2 ; clicky offset
		if (imageName = "Platin") { ; can't do text so purple box
			X1 := 141
			Y1 := 189
			X2 := 208
			Y2 := 224
		} else if (imageName = "Opening") { ; Opening click (to skip cards) can't click on the immersive skip with 239, 497
			X1 := 10
			Y1 := 80
			X2 := 50
			Y2 := 115
			clickx := 250
			clicky := 505
		} else if (imageName = "SelectExpansion") { ; SelectExpansion
			X1 := 120
			Y1 := 135
			X2 := 161
			Y2 := 145
		} else if (imageName = "CountrySelect2") { ; SelectExpansion
			X1 := 120
			Y1 := 130
			X2 := 174
			Y2 := 155
		} else if (imageName = "ChosenTag") { ; ChangeTag GP found
			X1 := 218
			Y1 := 307
			X2 := 231
			Y2 := 312
		} else if (imageName = "Badge") { ; ChangeTag GP found
			X1 := 48
			Y1 := 204
			X2 := 72
			Y2 := 230
		} else if (imageName = "ChooseErika") { ; ChangeTag GP found
			X1 := 150
			Y1 := 286
			X2 := 155
			Y2 := 291
		} else if (imageName = "ChooseEevee") { ; Change Eevee Avatar
			X1 := 157
			Y1 := 195
			X2 := 162
			Y2 := 200
			clickx := 147
			clicky := 207
		}
	}

	if(click) {
		adbClick(clickx, clicky)
		clickTime := A_TickCount
	}
	CreateStatusMessage(imageName)

	messageTime := 0
	firstTime := true
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
		if (!confirmed && vRet = 1) {
			confirmed := vPosXY
		} else {
			ElapsedTime := (A_TickCount - StartSkipTime) // 1000
			if(imageName = "Country")
				FSTime := 90
			else if(imageName = "Proceed") ; Decrease time for Marowak
				FSTime := 8
			else
				FSTime := 45
			if(!skip) {
				if(ElapsedTime - messageTime > 0.5 || firstTime) {
					CreateStatusMessage("Looking for " . imageName . " for " . ElapsedTime . "/" . FSTime . " seconds")
					messageTime := ElapsedTime
					firstTime := false
				}
			}
			if (ElapsedTime >= FSTime || safeTime >= FSTime) {
				CreateStatusMessage("Instance " . scriptName . " has been stuck for 90s. Killing it...")
				restartGameInstance("Instance " . scriptName . " has been stuck at `n" . imageName) ; change to reset the instance and delete data then reload script
				StartSkipTime := A_TickCount
				failSafe := A_TickCount
			}
		}
		Path = %imagePath%Error1.png
		pNeedle := GetNeedle(Path)
		; ImageSearch within the region
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
		if (vRet = 1) {
			CreateStatusMessage("Error message in " . scriptName " Clicking retry..." )
			LogToFile("Error message in " scriptName " Clicking retry..." )
			adbClick(82, 389)
			Delay(1)
			adbClick(139, 386)
			Sleep, 1000
		}
		Path = %imagePath%App.png
		pNeedle := GetNeedle(Path)
		; ImageSearch within the region
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 225, 300, 242, 314, searchVariation)
		if (vRet = 1) {
			CreateStatusMessage("At home page. Opening app..." )
			restartGameInstance("Found myself at the home page during: `n" imageName)
		}
		if(imageName = "Social" || imageName = "Country" || imageName = "Account2" || imageName = "Account") { ;only look for deleted account on start up.
			Path = %imagePath%NoSave.png ; look for No Save Data error message > if loaded account > delete xml > reload
			pNeedle := GetNeedle(Path)
			; ImageSearch within the region
			vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 30, 331, 50, 449, searchVariation)
			if (scaleParam = 287) {
				vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 30, 325, 55, 445, searchVariation)
			}
			if (vRet = 1) {
				adbShell.StdIn.WriteLine("rm -rf /data/data/jp.pokemon.pokemontcgp/cache/*") ; clear cache
				waitadb()
				CreateStatusMessage("Loaded deleted account. Deleting XML." )
				if(loadedAccount) {
					FileDelete, %loadedAccount%
					IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
				}
				LogToFile("Restarted game for instance " scriptName " Reason: No save data found", "Restart.txt")
				Reload
			}
		}
		Gdip_DisposeImage(pBitmap)
		if(imageName = "Points" || imageName = "Home") { ;look for level up ok "button"
			LevelUp()
		}
		if(imageName = "Social" || imageName = "Add") {
			TradeTutorial()
		}
		if(skip) {
			ElapsedTime := (A_TickCount - StartSkipTime) // 1000
			if(ElapsedTime - messageTime > 0.5 || firstTime) {
				CreateStatusMessage(imageName . " " . ElapsedTime . "/" . skip . " seconds until skipping")
				messageTime := ElapsedTime
				firstTime := false
			}
			if (ElapsedTime >= skip) {
				confirmed := false
				ElapsedTime := ElapsedTime/2
				break
			}
		}
		if (confirmed) {
			break
		}
	}
	Gdip_DisposeImage(pBitmap)
	return confirmed
}

LevelUp() {
	Leveled := FindOrLoseImage(100, 86, 167, 116, , "LevelUp", 0)
	if(Leveled) {
		clickButton := FindOrLoseImage(75, 340, 195, 530, 80, "Button", 0, failSafeTime)
		StringSplit, pos, clickButton, `,  ; Split at ", "
		if (scaleParam = 287) {
			pos2 += 5
		}
		adbClick(pos1, pos2)
	}
	Delay(1)
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

			if (runMain) {
				instanceIndex := (Mains - 1) + Title + 1
			} else {
				instanceIndex := Title
			}

			rowHeight := 533  ; Adjust the height of each row
			currentRow := Floor((instanceIndex - 1) / Columns)
			y := currentRow * rowHeight
			x := Mod((instanceIndex - 1), Columns) * scaleParam
			WinMove, %Title%, , % (MonitorLeft + x), % (MonitorTop + y), scaleParam, 537
			break
		}
		catch {
			if (RetryCount > MaxRetries) {
				CreateStatusMessage("Pausing. Can't find window " . winTitle)
				Pause
			}
			RetryCount++
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
		Pause, On
	} else if(godPack = 1) {
		CreateStatusMessage("Closing script. Found GP.")
		LogToFile("Closing God Pack instance.")
		WinClose, %winTitle%
		ExitApp
	}
}

waitadb() {
	adbShell.StdIn.WriteLine("echo done")
	while !adbShell.StdOut.AtEndOfStream
	{
		line := adbShell.StdOut.ReadLine()
		if (line = "done")
			break
		Sleep, 50
	}
}

restartGameInstance(reason, RL := true){
	global Delay, scriptName, adbShell, adbPath, adbPort, friended, loadedAccount, DeadCheck, openPack
	;initializeAdbShell()
	CreateStatusMessage("Restarting game reason: `n" reason)

	if(!RL || RL != "GodPack") {
		adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
		waitadb()
		if(!RL && DeadCheck==0)
			adbShell.StdIn.WriteLine("rm /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml") ; delete account data
		waitadb()
		adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
		waitadb()
	}
	Sleep, 4500

	if(RL = "GodPack") {
		LogToFile("Restarted game for instance " scriptName " Reason: " reason, "Restart.txt")
		IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

		Reload
	} else if(RL) {
		if(menuDeleteStart()) {
			IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
			logMessage := "\n" . username . "\n[" . starCount . "/5][" . packs . "P][" . openPack . " Booster] " . invalid . " God pack found in instance: " . scriptName . "\nFile name: " . accountFile . "\nGot stuck getting friend code."
			LogToFile(logMessage, "GPlog.txt")
			LogToDiscord(logMessage, screenShot, discordUserId, accountFullPath, fcScreenshot)
		}
		LogToFile("Restarted game for instance " scriptName " Reason: " reason, "Restart.txt")

		Reload
	}
}

menuDelete() {
	sleep, %Delay%
	failSafe := A_TickCount
	failSafeTime := 0
	Loop
	{
		sleep, %Delay%
		sleep, %Delay%
		adbClick(245, 518)
		if(FindImageAndClick(90, 260, 126, 290, , "Settings", , , , 1, failSafeTime)) ;wait for settings menu
			break
		sleep, %Delay%
		sleep, %Delay%
		adbClick(50, 100)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Settings. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Settings. It's been: " . failSafeTime "s ")
	}
	Sleep,%Delay%
	FindImageAndClick(24, 158, 57, 189, , "Account", 140, 440, 2000) ;wait for other menu
	Sleep,%Delay%
	FindImageAndClick(56, 435, 108, 460, , "Account2", 79, 256, 1000) ;wait for account menu
	Sleep,%Delay%

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			clickButton := FindOrLoseImage(75, 340, 195, 530, 40, "Button2", 0, failSafeTime)
			if(!clickButton) {
				clickImage := FindOrLoseImage(200, 340, 250, 530, 60, "DeleteAll", 0, failSafeTime) ; fix https://discord.com/channels/1330305075393986703/1354775917288882267/1355090394307887135
				if(clickImage) {
					StringSplit, pos, clickImage, `,  ; Split at ", "
					if (scaleParam = 287) {
						pos2 += 5
					}
					adbClick(pos1, pos2)
				}
				else {
					adbClick(230, 506)
				}
				Delay(1)
				failSafeTime := (A_TickCount - failSafe) // 1000
				CreateStatusMessage("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
				LogToFile("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
			}
			else {
				break
			}
			Sleep,%Delay%
		}
		StringSplit, pos, clickButton, `,  ; Split at ", "
		if (scaleParam = 287) {
			pos2 += 5
		}
		adbClick(pos1, pos2)
		break
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
	}

	Sleep, 2500
}

menuDeleteStart() {
	global friended
	if(gpFound) {
		return gpFound
	}
	if(friended) {
		FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
		if(setSpeed = 3)
			FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
		else
			FindImageAndClick(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		Delay(1)
		adbClick(41, 296)
		Delay(1)
	}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		if(!friended)
			break
		adbClick(255, 83)
		if(FindOrLoseImage(105, 396, 121, 406, , "Country", 0, failSafeTime)) { ;if at country continue
			break
		}
		else if(FindOrLoseImage(20, 120, 50, 150, , "Menu", 0, failSafeTime)) { ; if the clicks in the top right open up the game settings menu then continue to delete account
			Sleep,%Delay%
			FindImageAndClick(56, 435, 108, 460, , "Account2", 79, 256, 1000) ;wait for account menu
			Sleep,%Delay%
			failSafe := A_TickCount
			failSafeTime := 0
			Loop {
				clickButton := FindOrLoseImage(75, 340, 195, 530, 80, "Button", 0, failSafeTime)
				if(!clickButton) {
					clickImage := FindOrLoseImage(200, 340, 250, 530, 60, "DeleteAll", 0, failSafeTime)
					if(clickImage) {
						StringSplit, pos, clickImage, `,  ; Split at ", "
						if (scaleParam = 287) {
							pos2 += 5
						}
						adbClick(pos1, pos2)
					}
					else {
						adbClick(230, 506)
					}
					Delay(1)
					failSafeTime := (A_TickCount - failSafe) // 1000
					CreateStatusMessage("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
					LogToFile("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
				}
				else {
					break
				}
				Sleep,%Delay%
			}
			StringSplit, pos, clickButton, `,  ; Split at ", "
			if (scaleParam = 287) {
				pos2 += 5
			}
			adbClick(pos1, pos2)
			break
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
			LogToFile("In failsafe for clicking to delete. " . failSafeTime "/45 seconds")
		}
		CreateStatusMessage("Looking for Country/Menu")
		Delay(1)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Country/Menu. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Country/Menu. " . failSafeTime "/45 seconds")
	}
	if(loadedAccount) {
		FileDelete, %loadedAccount%
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

CreateStatusMessage(Message, GuiName := 50, X := 0, Y := 80) {
	global scriptName, winTitle, StatusText, showStatus
	static hwnds = {}
	if(!showStatus) {
		return
	}
	try {
		; Check if GUI with this name already exists
		GuiName := GuiName+scriptName
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

CheckPack() {
	global scriptName, DeadCheck, CheckShiningPackOnly, InvalidCheck
	foundGP := false ;check card border to find godpacks
	foundTrainer := false
	foundRainbow := false
	foundFullArt := false
	foundShiny := false
	foundCrown := false
	foundImmersive := false
	foundTS := false
	foundGP := FindGodPack()
	;msgbox 1 foundGP:%foundGP%, TC:%TrainerCheck%, RC:%RainbowCheck%, FAC:%FullArtCheck%, FTS:%foundTS%
	if(!CheckShiningPackOnly || openPack = "Shining") {
		if(TrainerCheck && !foundTS) {
			foundTrainer := FindBorders("trainer")
			if(foundTrainer)
				foundTS := "Trainer"
		}
		if(RainbowCheck && !foundTS) {
			foundRainbow := FindBorders("rainbow")
			if(foundRainbow)
				foundTS := "Rainbow"
		}
		if(FullArtCheck && !foundTS) {
			foundFullArt := FindBorders("fullart")
			if(foundFullArt)
				foundTS := "Full Art"
		}
		if((ShinyCheck && !foundTS) || InvalidCheck) {
			foundShiny := FindBorders("shiny2star") + FindBorders("shiny1star")
			if(foundShiny)
				foundTS := "Shiny"
		}
		if((ImmersiveCheck && !foundTS) || InvalidCheck) {
			foundImmersive := FindBorders("immersive")
			if(foundImmersive)
				foundTS := "Immersive"
		}
		If((CrownCheck && !foundTS) || InvalidCheck) {
			foundCrown := FindBorders("crown")
			if(foundCrown)
				foundTS := "Crown"
		}
		If(PseudoGodPack && !foundTS) {
			2starCount := FindBorders("trainer") + FindBorders("rainbow") + FindBorders("fullart")
			if(2starCount > 1)
				foundTS := "Double two star"
		}
	}
	if(foundGP || foundTrainer || foundRainbow || foundFullArt || foundShiny || foundImmersive || foundCrown || 2starCount > 1) {
		if(!(InvalidCheck && (foundShiny || foundImmersive || foundCrown)) || foundGP) {
			if(loadedAccount) {
				FileDelete, %loadedAccount% ;delete xml file from folder if using inject method
				IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
			}
			if(foundGP)
				restartGameInstance("God Pack found. Continuing...", "GodPack") ; restarts to backup and delete xml file with account info.
			else {
				FoundStars(foundTS)
				restartGameInstance(foundTS . " found. Continuing...", "GodPack") ; restarts to backup and delete xml file with account info.
			}
		}
	}
}

FoundStars(star) {
	global scriptName, DeadCheck, ocrLanguage, injectMethod, openPack
	screenShot := Screenshot(star)
	accountFile := saveAccount(star, accountFullPath)
	friendCode := getFriendCode()
	IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

	; Pull back screenshot of the friend code/name (good for inject method)
	Sleep, 8000
	fcScreenshot := Screenshot("FRIENDCODE")

	if(star = "Crown" || star = "Immersive" || star = "Shiny")
		RemoveFriends()
	else {
		; If we're doing the inject method, try to OCR our Username
		try {
			if(injectMethod && IsFunc("ocr"))
			{
					ocrText := Func("ocr").Call(fcScreenshot, ocrLanguage)
					ocrLines := StrSplit(ocrText, "`n")
					len := ocrLines.MaxIndex()
					if(len > 1) {
						playerName := ocrLines[1]
						playerID := RegExReplace(ocrLines[2], "[^0-9]", "")
						; playerID := SubStr(ocrLines[2], 1, 19)
						username := playerName
					}
			}
		} catch e {
			LogToFile("Failed to OCR the friend code: " . e.message, "BC.txt")
		}
	}

	logMessage := star . " found by " . username . " (" . friendCode . ") in instance: " . scriptName . " (" . packs . " packs, " . openPack . " booster)\nFile name: " . accountFile . "\nBacking up to the Accounts\\SpecificCards folder and continuing..."
	CreateStatusMessage(logMessage)
	LogToFile(logMessage, "GPlog.txt")
	LogToDiscord(logMessage, screenShot, discordUserId, accountFullPath, fcScreenshot)
	if(star != "Crown" && star != "Immersive" && star != "Shiny")
		ChooseTag()
}

FindBorders(prefix) {
	count := 0
	searchVariation := 40
	borderCoords := [[30, 284, 83, 286]
		,[113, 284, 166, 286]
		,[196, 284, 249, 286]
		,[70, 399, 123, 401]
		,[155, 399, 208, 401]]
	if (prefix = "shiny1star" || prefix = "shiny2star") {
		; TODO: Need references images for these coordinates (right side, bottom corner)
		borderCoords := [[90, 261, 93, 283]
		,[173, 261, 176, 283]
		,[255, 261, 258, 283]
		,[130, 376, 133, 398]
		,[215, 376, 218, 398]]
	}
	; 100% scale changes
	if (scaleParam = 287) {
		if (prefix = "shiny1star" || prefix = "shiny2star") {
			borderCoords := [[91, 253, 95, 278]
			,[175, 253, 179, 278]  
			,[259, 253, 263, 278]
			,[132, 370, 136, 395]
			,[218, 371, 222, 394]]
		} else {
			borderCoords := [[30, 277, 85, 281]
			,[112, 277, 167, 281]
			,[195, 277, 250, 281]
			,[70, 394, 125, 398]
			,[156, 394, 211, 398]]
		}
	}
	pBitmap := from_window(WinExist(winTitle))
	; imagePath := "C:\Users\Arturo\Desktop\PTCGP\GPs\" . Clipboard . ".png"
	; pBitmap := Gdip_CreateBitmapFromFile(imagePath)
	for index, value in borderCoords {
		coords := borderCoords[A_Index]
		Path = %A_ScriptDir%\%defaultLanguage%\%prefix%%A_Index%.png
		pNeedle := GetNeedle(Path)
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, coords[1], coords[2], coords[3], coords[4], searchVariation)
		if (vRet = 1) {
			count += 1
		}
	}
	Gdip_DisposeImage(pBitmap)
	return count
}

FindGodPack() {
	global winTitle, discordUserId, Delay, username, packs, minStars, minStarsA1Charizard, minStarsA1Mewtwo, minStarsA1Pikachu, minStarsA1a, minStarsA2Dialga, minStarsA2Palkia, minStarsA2a, minStarsA2b, openPack, scriptName, DeadCheck, deleteMethod
	packMinStars := minStars
	if(openPack = "Shining") { 
		packMinStars := minStarsA2b 
	}
	if (openPack = "Arceus") { 
		packMinStars := minStarsA2a 
	}
	if (openPack = "Palkia") { 
		packMinStars := minStarsA2Palkia 
	}
	if (openPack = "Dialga") { 
		packMinStars := minStarsA2Dialga 
	}
	if (openPack = "Mew") { 
		packMinStars := minStarsA1a 
	}
	if (openPack = "Pikachu") { 
		packMinStars := minStarsA1Pikachu 
	}
	if (openPack = "Charizard") { 
		packMinStars := minStarsA1Charizard 
	}
	if (openPack = "Mewtwo") { 
		packMinStars := minStarsA1Mewtwo 
	}
	
	gpFound := false
	invalidGP := false
	searchVariation := 5
	confirm := false
	Loop {
		if(FindBorders("lag") = 0)
			break
		Delay(1)
	}
	borderCoords := [[20, 284, 90, 286]
		,[103, 284, 173, 286]]
		
	; Change borderCoords if scaleParam is 287 for 100%
	if (scaleParam = 287) {
		borderCoords := [[21, 278, 91, 280]
			,[105, 278, 175, 280]]
	}

	;	SquallTCGP 2025.03.12 - 	Just checking the packs count and setting them to 0 if it's number of packs is 3. 
	;															This applies to any Delete Method except 5 Pack (Fast). This change is made based 
	;															on the 5p-no delete community mod created by DietPepperPhD in the discord server.
	if(deleteMethod != "5 Pack (Fast)") {
		if(packs = 3)
			packs := 0
	}

	Loop {
		normalBorders := false
		pBitmap := from_window(WinExist(winTitle))
		Path = %A_ScriptDir%\%defaultLanguage%\Border.png
		pNeedle := GetNeedle(Path)
		for index, value in borderCoords {
			coords := borderCoords[A_Index]
			vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, coords[1], coords[2], coords[3], coords[4], searchVariation)
			if (vRet = 1) {
				normalBorders := true
				break
			}
		}
		Gdip_DisposeImage(pBitmap)
		if(normalBorders) {
			CreateStatusMessage("Not a God Pack ")
			packs += 1
			break
		} else {
			packs += 1
			if(packMethod)
				packs := 1
			foundShiny := FindBorders("shiny2star") + FindBorders("shiny1star")
			foundImmersive := FindBorders("immersive")
			foundCrown := FindBorders("crown")
			if(foundImmersive || foundCrown || foundShiny) {
				invalidGP := true
			}
			if(!invalidGP && packMinStars > 0) {
				starCount := 5 - FindBorders("1star")
				if(starCount < packMinStars) {
					CreateStatusMessage("Does not meet minimum 2 star threshold.")
					invalidGP := true
				}
			}
			if(invalidGP) {
				gpFound := true
				GodPackFound("Invalid")
				RemoveFriends()
				IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
				break
			}
			else {
				gpFound := true
				GodPackFound("Valid")
				break
			}
		}
	}
	return gpFound
}

GodPackFound(validity) {
	global scriptName, DeadCheck, ocrLanguage, injectMethod, openPack

	if(validity = "Valid") {
		IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
		Praise := ["Congrats!", "Congratulations!", "GG!", "Whoa!", "Praise Helix! ༼ つ ◕_◕ ༽つ", "Way to go!", "You did it!", "Awesome!", "Nice!", "Cool!", "You deserve it!", "Keep going!", "This one has to be live!", "No duds, no duds, no duds!", "Fantastic!", "Bravo!", "Excellent work!", "Impressive!", "You're amazing!", "Well done!", "You're crushing it!", "Keep up the great work!", "You're unstoppable!", "Exceptional!", "You nailed it!", "Hats off to you!", "Sweet!", "Kudos!", "Phenomenal!", "Boom! Nailed it!", "Marvelous!", "Outstanding!", "Legendary!", "Youre a rock star!", "Unbelievable!", "Keep shining!", "Way to crush it!", "You're on fire!", "Killing it!", "Top-notch!", "Superb!", "Epic!", "Cheers to you!", "Thats the spirit!", "Magnificent!", "Youre a natural!", "Gold star for you!", "You crushed it!", "Incredible!", "Shazam!", "You're a genius!", "Top-tier effort!", "This is your moment!", "Powerful stuff!", "Wicked awesome!", "Props to you!", "Big win!", "Yesss!", "Champion vibes!", "Spectacular!"]
		invalid := ""
	} else {
		Praise := ["Uh-oh!", "Oops!", "Not quite!", "Better luck next time!", "Yikes!", "That didn’t go as planned.", "Try again!", "Almost had it!", "Not your best effort.", "Keep practicing!", "Oh no!", "Close, but no cigar.", "You missed it!", "Needs work!", "Back to the drawing board!", "Whoops!", "That’s rough!", "Don’t give up!", "Ouch!", "Swing and a miss!", "Room for improvement!", "Could be better.", "Not this time.", "Try harder!", "Missed the mark.", "Keep at it!", "Bummer!", "That’s unfortunate.", "So close!", "Gotta do better!"]
		invalid := validity
	}
	Randmax := Praise.Length()
	Random, rand, 1, Randmax
	Interjection := Praise[rand]
	starCount := 5 - FindBorders("1star") - FindBorders("shiny1star")
	screenShot := Screenshot(validity)
	accountFile := saveAccount(validity, accountFullPath)
	logMessage := "\n" . username . "\n[" . starCount . "/5][" . packs . "P] " . invalid . " God pack found in instance: " . scriptName . "\nFile name: " . accountFile . "\nGetting friend code then sendind discord message."
	godPackLog = GPlog.txt
	LogToFile(logMessage, godPackLog)
	CreateStatusMessage(logMessage)
	friendCode := getFriendCode()
	IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

	; Pull screenshot of the Friend code page; wait so we don't get the clipboard pop up; good for the inject method
	Sleep, 8000
	fcScreenshot := Screenshot("FRIENDCODE")

	; If we're doing the inject method, try to OCR our Username
	try {
		if(injectMethod && IsFunc("ocr"))
		{
				ocrText := Func("ocr").Call(fcScreenshot, ocrLanguage)
				ocrLines := StrSplit(ocrText, "`n")
				len := ocrLines.MaxIndex()
				if(len > 1) {
					playerName := ocrLines[1]
					playerID := RegExReplace(ocrLines[2], "[^0-9]", "")
					; playerID := SubStr(ocrLines[2], 1, 19)
					username := playerName
				}
		}
	} catch e {
		LogToFile("Failed to OCR the friend code: " . e.message, "BC.txt")
	}

	logMessage := Interjection . "\n" . username . " (" . friendCode . ")\n[" . starCount . "/5][" . packs . "P][" . openPack . " Booster] " . invalid . " God pack found in instance: " . scriptName . "\nFile name: " . accountFile . "\nBacking up to the Accounts\\GodPacks folder and continuing..."
	LogToFile(logMessage, godPackLog)
	;Run, http://google.com, , Hide ;Remove the ; at the start of the line and replace your url if you want to trigger a link when finding a god pack.

	; Adjust the below to only send a 'ping' to Discord friends on Valid packs
	if(validity = "Valid") {
		LogToDiscord(logMessage, screenShot, discordUserId, accountFullPath, fcScreenshot)
		ChooseTag()
	} else {
		LogToDiscord(logMessage, screenShot, false, accountFullPath, fcScreenshot)
	}
}

loadAccount() {
	global adbShell, adbPath, adbPort, loadDir
	CreateStatusMessage("Loading account...")
	currentDate := A_Now
	year := SubStr(currentDate, 1, 4)
	month := SubStr(currentDate, 5, 2)
	day := SubStr(currentDate, 7, 2)

	daysSinceBase := (year - 1900) * 365 + Floor((year - 1900) / 4)
	daysSinceBase += MonthToDays(year, month)
	daysSinceBase += day

	remainder := Mod(daysSinceBase, 3)

	saveDir := A_ScriptDir "\..\Accounts\Saved\" . remainder . "\" . winTitle

	outputTxt := saveDir . "\list.txt"

	if FileExist(outputTxt) {
		FileRead, fileContent, %outputTxt%  ; Read entire file
		fileLines := StrSplit(fileContent, "`n", "`r")  ; Split into lines

		if (fileLines.MaxIndex() >= 1) {
			cycle := 0
			Loop {
				CreateStatusMessage("Making sure XML is > 24 hours old: " . cycle . " attempts.")
				loadDir := saveDir . "\" . fileLines[1]  ; Store the first line
				test := fileExist(loadDir)

				if(!InStr(loadDir, "xml"))
					return false
				newContent := ""
				Loop, % fileLines.MaxIndex() - 1  ; Start from the second line
					newContent .= fileLines[A_Index + 1] "`r`n"

				FileDelete, %outputTxt%  ; Delete old file
				FileAppend, %newContent%, %outputTxt%  ; Write back without the first line

				FileGetTime, fileTime, %loadDir%, M  ; Get last modified time
				timeDiff := A_Now - fileTime

				if (timeDiff > 86400)
					break
				cycle++
				Delay(1)
			}
		} else return false
	} else return false

		;initializeAdbShell()

	adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")

	RunWait, % adbPath . " -s 127.0.0.1:" . adbPort . " push " . loadDir . " /sdcard/deviceAccount.xml",, Hide

	Sleep, 500

	adbShell.StdIn.WriteLine("cp /sdcard/deviceAccount.xml /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml")
	waitadb()
	adbShell.StdIn.WriteLine("rm /sdcard/deviceAccount.xml")
	waitadb()
	adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
	waitadb()
	Sleep, 1000

	FileSetTime,, %loadDir%

	return loadDir
}

saveAccount(file := "Valid", ByRef filePath := "") {
	global adbShell, adbPath, adbPort
	;initializeAdbShell()
	currentDate := A_Now
	year := SubStr(currentDate, 1, 4)
	month := SubStr(currentDate, 5, 2)
	day := SubStr(currentDate, 7, 2)

	daysSinceBase := (year - 1900) * 365 + Floor((year - 1900) / 4)
	daysSinceBase += MonthToDays(year, month)
	daysSinceBase += day

	remainder := Mod(daysSinceBase, 3)

	filePath := ""

	if (file = "All") {
		saveDir := A_ScriptDir "\..\Accounts\Saved\" . remainder . "\" . winTitle
		filePath := saveDir . "\" . A_Now . "_" . winTitle . ".xml"
	} else if(file = "Valid" || file = "Invalid") {
		saveDir := A_ScriptDir "\..\Accounts\GodPacks\"
		xmlFile := A_Now . "_" . winTitle . "_" . file . "_" . packs . "_packs.xml"
		filePath := saveDir . xmlFile
	} else {
		saveDir := A_ScriptDir "\..\Accounts\SpecificCards\"
		xmlFile := A_Now . "_" . winTitle . "_" . file . "_" . packs . "_packs.xml"
		filePath := saveDir . xmlFile
	}

	if !FileExist(saveDir) ; Check if the directory exists
		FileCreateDir, %saveDir% ; Create the directory if it doesn't exist

	count := 0
	Loop {
		CreateStatusMessage("Attempting to save account XML. " . count . "/10")

		adbShell.StdIn.WriteLine("cp -f /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml /sdcard/deviceAccount.xml")
		waitadb()
		Sleep, 500

		RunWait, % adbPath . " -s 127.0.0.1:" . adbPort . " pull /sdcard/deviceAccount.xml """ . filePath,, Hide

		Sleep, 500

		adbShell.StdIn.WriteLine("rm /sdcard/deviceAccount.xml")

		Sleep, 500

		FileGetSize, OutputVar, %filePath%

		if(OutputVar > 0)
			break

		if(count > 10 && file != "All") {
			CreateStatusMessage("Attempted to save the account XML`n10 times, but was unsuccesful.`nPausing...")
			LogToDiscord("Attempted to save account in " . scriptName . " but was unsuccessful. Pausing. You will need to manually extract.", Screenshot(), discordUserId)
			Pause, On
		} else if(count > 10) {
			LogToDiscord("Couldnt save this regular account skipping it.")
			break
		}
		count++
	}

	return xmlFile
}

; adbClick(X, Y) {
	; global adbShell, setSpeed, adbPath, adbPort
	; initializeAdbShell()
	; X := Round(X / 277 * 540)
	; Y := Round((Y - 44) / 489 * 960)
	; adbShell.StdIn.WriteLine("input tap " X " " Y)
; }

adbClick(X, Y) {
    global adbShell
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

ControlClick(X, Y) {
	global winTitle
	ControlClick, x%X% y%Y%, %winTitle%
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
		ids := whr.ResponseText
	} catch {
		errored := true
	}
	if(!errored) {
		FileDelete, %localPath%
		FileAppend, %ids%, %localPath%
	}
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

adbInput(input) {
	global adbShell, adbPath, adbPort
	;initializeAdbShell()
	Delay(3)
	adbShell.StdIn.WriteLine("input text " . input )
	Delay(3)
}

adbInputEvent(event) {
	global adbShell, adbPath, adbPort
	;initializeAdbShell()
	adbShell.StdIn.WriteLine("input keyevent " . event)
}

adbSwipeUp(speed) {
	global adbShell, adbPath, adbPort
	;initializeAdbShell()
	adbShell.StdIn.WriteLine("input swipe 266 770 266 355 " . speed)
	waitadb()
}

adbSwipe() {
	global adbShell, setSpeed, swipeSpeed, adbPath, adbPort
	;initializeAdbShell()
	X1 := 35
	Y1 := 327
	X2 := 267
	Y2 := 327
	X1 := Round(X1 / 277 * 535)
	Y1 := Round((Y1 - 44) / 489 * 960)
	X2 := Round(X2 / 277 * 535)
	Y2 := Round((Y2 - 44) / 489 * 960)

	adbShell.StdIn.WriteLine("input swipe " . X1 . " " . Y1 . " " . X2 . " " . Y2 . " " . swipeSpeed)
	waitadb()
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
	pBitmapW := from_window(WinExist(winTitle))
	pBitmap := Gdip_CloneBitmapArea(pBitmapW, 18, 175, 240, 227)
	;scale 100%
	if (scaleParam = 287) {
	pBitmap := Gdip_CloneBitmapArea(pBitmapW, 17, 168, 245, 230)
	}
	Gdip_DisposeImage(pBitmapW)

	Gdip_SaveBitmapToFile(pBitmap, screenshotFile)

	Gdip_DisposeImage(pBitmap)
	return screenshotFile
}

LogToDiscord(message, screenshotFile := "", ping := false, xmlFile := "", screenshotFile2 := "") {
	global discordUserId, discordWebhookURL, friendCode, sendAccountXml
	discordPing := "<@" . discordUserId . "> "
	discordFriends := ReadFile("discord")

	if(ping != false && discordFriends) {
		for index, value in discordFriends {
			if(value = discordUserId)
				continue
			discordPing .= "<@" . value . "> "
		}
	}

	if (discordWebhookURL != "") {
		if (!sendAccountXml)
			xmlFile := ""
		MaxRetries := 10
		RetryCount := 0
		Loop {
			try {
				; Base command
				curlCommand := "curl -k "
					. "-F ""payload_json={\""content\"":\""" . discordPing . message . "\""};type=application/json;charset=UTF-8"" "
				
				; If an screenshot or xml file is provided, send it
				sendScreenshot1 := screenshotFile != "" && FileExist(screenshotFile)
				sendScreenshot2 := screenshotFile2 != "" && FileExist(screenshotFile2)
				sendAccountXml := xmlFile != "" && FileExist(xmlFile)
				if (sendScreenshot1 + sendScreenshot2 + sendAccountXml > 1) {
					fileIndex := 0
					if (sendScreenshot1) {
						fileIndex++
						curlCommand := curlCommand . "-F ""file" . fileIndex . "=@" . screenshotFile . """ "
					}
					if (sendScreenshot2) {
						fileIndex++
						curlCommand := curlCommand . "-F ""file" . fileIndex . "=@" . screenshotFile2 . """ "
					}
					if (sendAccountXml) {
						fileIndex++
						curlCommand := curlCommand . "-F ""file" . fileIndex . "=@" . xmlFile . """ "
					}
				}
				else if (sendScreenshot1 + sendScreenshot2 + sendAccountXml == 1) {
					if (sendScreenshot1)
						curlCommand := curlCommand . "-F ""file=@" . screenshotFile . """ "
					if (sendScreenshot2)
						curlCommand := curlCommand . "-F ""file=@" . screenshotFile2 . """ "
					if (sendAccountXml)
						curlCommand := curlCommand . "-F ""file=@" . xmlFile . """ "
				}
				; Add the webhook
				curlCommand := curlCommand . discordWebhookURL
				; Send the message using curl
				RunWait, %curlCommand%,, Hide
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
	StartSkipTime := A_TickCount ;reset stuck timers
	failSafe := A_TickCount
	Pause, Off
return

; Stop Script
StopScript:
	ToggleStop()
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

ToggleStop()
{
	global stopToggle, friended
	CreateStatusMessage("Stopping script at the end of the run...")
	stopToggle := true
	if(!friended)
		ExitApp
}

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
~+F7::ToggleStop()
~+F8::ToggleStatusMessages()
;~F9::restartGameInstance("F9")

ToggleStatusMessages() {
	if(showStatus) {
		showStatus := False
	}
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


initializeAdbShell() {
	global adbShell, adbPath, adbPort
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
					throw "ADB path is invalid: " . adbPath
				}
				if (adbPort < 0 || adbPort > 65535) {
					throw "ADB port is invalid: " . adbPort
				}

				; Attempt to start adb shell
				adbShell := ComObjCreate("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPort . " shell")

				; Ensure adbShell is running before sending 'su'
				Sleep, 500
				if (adbShell.Status != 0) {
					throw "Failed to start ADB shell."
				}

				adbShell.StdIn.WriteLine("su")
			}

			; If adbShell is running, break loop
			if (adbShell.Status = 0) {
				break
			}
		} catch e {
			RetryCount++
			LogToFile("ADB Shell Error: " . e.message)

			if (RetryCount >= MaxRetries) {
				CreateStatusMessage("Failed to connect to shell after multiple attempts: " . e.message)
				Pause
			}
		}

		Sleep, BackoffTime
		BackoffTime := Min(BackoffTime + 1000, MaxBackoff)  ; Limit backoff time
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

Delay(n) {
	global Delay
	msTime := Delay * n
	Sleep, msTime
}

DoTutorial() {
	FindImageAndClick(105, 396, 121, 406, , "Country", 143, 370) ;select month and year and click

	Delay(1)
	adbClick(80, 400)
	Delay(1)
	adbClick(80, 375)
	Delay(1)
	failSafe := A_TickCount
	failSafeTime := 0

	Loop
	{
		Delay(1)
		if(FindImageAndClick(100, 386, 138, 416, , "Month", , , , 1, failSafeTime))
			break
		Delay(1)
		adbClick(142, 159)
		Delay(1)
		adbClick(80, 400)
		Delay(1)
		adbClick(80, 375)
		Delay(1)
		adbClick(82, 422)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Month. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Month. " . failSafeTime "/45 seconds")
	} ;select month and year and click

	adbClick(200, 400)
	Delay(1)
	adbClick(200, 375)
	Delay(1)
	failSafe := A_TickCount
	failSafeTime := 0
	Loop ;select month and year and click
	{
		Delay(1)
		if(FindImageAndClick(148, 384, 256, 419, , "Year", , , , 1, failSafeTime))
			break
		Delay(1)
		adbClick(142, 159)
		Delay(1)
		adbClick(142, 159)
		Delay(1)
		adbClick(200, 400)
		Delay(1)
		adbClick(200, 375)
		Delay(1)
		adbClick(142, 159)
		Delay(1)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Year. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Year. " . failSafeTime "/45 seconds")
	} ;select month and year and click

	Delay(1)
	if(FindOrLoseImage(93, 471, 122, 485, , "CountrySelect", 0)) {
		FindImageAndClick(110, 134, 164, 160, , "CountrySelect2", 141, 237, 500)
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			countryOK := FindOrLoseImage(93, 450, 122, 470, , "CountrySelect", 0, failSafeTime)
			birthFound := FindOrLoseImage(116, 352, 138, 389, , "Birth", 0, failSafeTime)
			if(countryOK)
				adbClick(124, 250)
			else if(!birthFound)
					adbClick(140, 474)
			else if(birthFound)
				break
			Delay(2)
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for country select. " . failSafeTime "/45 seconds")
			LogToFile("In failsafe for country select. " . failSafeTime "/45 seconds")
		}
	} else {
		FindImageAndClick(116, 352, 138, 389, , "Birth", 140, 474, 1000)
	}

	;wait date confirmation screen while clicking ok

	FindImageAndClick(210, 285, 250, 315, , "TosScreen", 203, 371, 1000) ;wait to be at the tos screen while confirming birth

	FindImageAndClick(129, 477, 156, 494, , "Tos", 139, 299, 1000) ;wait for tos while clicking it

	FindImageAndClick(210, 285, 250, 315, , "TosScreen", 142, 486, 1000) ;wait to be at the tos screen and click x

	FindImageAndClick(129, 477, 156, 494, , "Privacy", 142, 339, 1000) ;wait to be at the tos screen

	FindImageAndClick(210, 285, 250, 315, , "TosScreen", 142, 486, 1000) ;wait to be at the tos screen, click X

	Delay(1)
	adbClick(261, 374)

	Delay(1)
	adbClick(261, 406)

	Delay(1)
	adbClick(145, 484)

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		if(FindImageAndClick(30, 336, 53, 370, , "Save", 145, 484, , 2, failSafeTime)) ;wait to be at create save data screen while clicking
			break
		Delay(1)
		adbClick(261, 406)
		if(FindImageAndClick(30, 336, 53, 370, , "Save", 145, 484, , 2, failSafeTime)) ;wait to be at create save data screen while clicking
			break
		Delay(1)
		adbClick(261, 374)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Save. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Save. " . failSafeTime "/45 seconds")
	}

	Delay(1)

	adbClick(143, 348)

	Delay(1)

	FindImageAndClick(51, 335, 107, 359, , "Link") ;wait for link account screen%
	Delay(1)
	failSafe := A_TickCount
	failSafeTime := 0
		Loop {
			if(FindOrLoseImage(51, 335, 107, 359, , "Link", 0, failSafeTime)) {
				adbClick(140, 460)
				Loop {
					Delay(1)
					if(FindOrLoseImage(51, 335, 107, 359, , "Link", 1, failSafeTime)) {
						adbClick(140, 380) ; click ok on the interrupted while opening pack prompt
						break
					}
					failSafeTime := (A_TickCount - failSafe) // 1000
				}
			} else if(FindOrLoseImage(110, 350, 150, 404, , "Confirm", 0, failSafeTime)) {
				adbClick(203, 364)
			} else if(FindOrLoseImage(215, 371, 264, 418, , "Complete", 0, failSafeTime)) {
				adbClick(140, 370)
			} else if(FindOrLoseImage(0, 46, 20, 70, , "Cinematic", 0, failSafeTime)) {
				break
			}
			;CreateStatusMessage("Looking for Link/Welcome")
			Delay(1)
			failSafeTime := (A_TickCount - failSafe) // 1000
			;CreateStatusMessage("In failsafe for Link/Welcome. " . failSafeTime "/45 seconds")
		}

		if(setSpeed = 3) {
			FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
			FindImageAndClick(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
			Delay(1)
			adbClick(41, 296)
			Delay(1)
		}

		FindImageAndClick(110, 230, 182, 257, , "Welcome", 253, 506, 110) ;click through cutscene until welcome page

		if(setSpeed = 3) {
			FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings

			FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
			Delay(1)
			adbClick(41, 296)
		}
	FindImageAndClick(190, 241, 225, 270, , "Name", 189, 438) ;wait for name input screen
	;choose any
	Delay(1)
	if(FindOrLoseImage(147, 160, 157, 169, , "Erika", 1)) {
		AdbClick(143, 207)
		Delay(1)
		AdbClick(143, 207)
		FindImageAndClick(165, 294, 173, 301, , "ChooseErika", 143, 306)
		FindImageAndClick(190, 241, 225, 270, , "Name", 143, 462) ;wait for name input screen
	}
	FindImageAndClick(0, 476, 40, 502, , "OK", 139, 257) ;wait for name input screen

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		fileName := A_ScriptDir . "\..\usernames.txt"
		if(FileExist(fileName))
			name := ReadFile("usernames")
		else
			name := ReadFile("usernames_default")

		Random, randomIndex, 1, name.MaxIndex()
		username := name[randomIndex]
		username := SubStr(username, 1, 14)  ;max character limit
		adbInput(username)
		if(FindImageAndClick(121, 490, 161, 520, , "Return", 185, 372, , 10)) ;click through until return button on open pack
			break
		adbClick(90, 370)
		Delay(1)
		adbClick(139, 254) ; 139 254 194 372
		Delay(1)
		adbClick(139, 254)
		Delay(1)
		EraseInput() ; incase the random pokemon is not accepted
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. " . failSafeTime "/45 seconds")
		CreateStatusMessage("In failsafe for Trace. " . failSafeTime "/45 seconds")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at name")
	}

	Delay(1)

	adbClick(140, 424)

	FindImageAndClick(225, 273, 235, 290, , "Pack", 140, 424) ;wait for pack to be ready  to trace
		if(setSpeed > 1) {
			FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
			FindImageAndClick(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
			Delay(1)
		}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()
		Sleep, 10
		if (FindOrLoseImage(225, 273, 235, 290, , "Pack", 1, failSafeTime)){
			if(setSpeed > 1) {
				if(setSpeed = 3)
						FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click 3x
				else
						FindImageAndClick(100, 170, 113, 190, , "Two", 107, 180) ; click 2x
			}
			adbClick(41, 296)
				break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Pack. " . failSafeTime "/45 seconds")
	}

	FindImageAndClick(34, 99, 74, 131, , "Swipe", 140, 375) ;click through cards until needing to swipe up
		if(setSpeed > 1) {
			FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
			FindImageAndClick(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
			Delay(1)
		}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipeUp(60)
		Sleep, 10
		if (FindOrLoseImage(120, 70, 150, 95, , "SwipeUp", 0, failSafeTime)){
			if(setSpeed > 1) {
				if(setSpeed = 3)
						FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
				else
						FindImageAndClick(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
			}
			adbClick(41, 296)
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for swipe up. " . failSafeTime "/45 seconds")
		Delay(1)
	}

	Delay(1)
	if(setSpeed > 2) {
		FindImageAndClick(136, 420, 151, 436, , "Move", 134, 375, 500) ; click through until move
		FindImageAndClick(50, 394, 86, 412, , "Proceed", 141, 483, 750) ;wait for menu to proceed then click ok. increased delay in between clicks to fix freezing on 3x speed
	}
	else {
		FindImageAndClick(136, 420, 151, 436, , "Move", 134, 375) ; click through until move
		FindImageAndClick(50, 394, 86, 412, , "Proceed", 141, 483) ;wait for menu to proceed then click ok
	}

	Delay(1)
	adbClick(204, 371)

	FindImageAndClick(46, 368, 103, 411, , "Gray") ;wait for for missions to be clickable

	Delay(1)
	adbClick(247, 472)

	FindImageAndClick(115, 97, 174, 150, , "Pokeball", 247, 472, 5000) ; click through missions until missions is open

	Delay(1)
	adbClick(141, 294)
	Delay(1)
	adbClick(141, 294)
	Delay(1)
	FindImageAndClick(124, 168, 162, 207, , "Register", 141, 294, 1000) ; wait for register screen
	Delay(6)
	adbClick(140, 500)

	FindImageAndClick(115, 255, 176, 308, , "Mission") ; wait for mission complete screen

	FindImageAndClick(46, 368, 103, 411, , "Gray", 143, 360) ;wait for for missions to be clickable

	FindImageAndClick(170, 160, 220, 200, , "Notifications", 145, 194) ;click on packs. stop at booster pack tutorial

	Delay(3)
	adbClick(142, 436)
	Delay(3)
	adbClick(142, 436)
	Delay(3)
	adbClick(142, 436)
	Delay(3)
	adbClick(142, 436)

	FindImageAndClick(225, 273, 235, 290, , "Pack", 239, 497) ;wait for pack to be ready  to Trace
		if(setSpeed > 1) {
			FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
			FindImageAndClick(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
			Delay(1)
		}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()
		Sleep, 10
		if (FindOrLoseImage(225, 273, 235, 290, , "Pack", 1, failSafeTime)){
		if(setSpeed > 1) {
			if(setSpeed = 3)
						FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
			else
						FindImageAndClick(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		}
				adbClick(41, 296)
				break
			}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Pack. " . failSafeTime "/45 seconds")
		Delay(1)
	}

	FindImageAndClick(0, 98, 116, 125, 5, "Opening", 239, 497) ;skip through cards until results opening screen

	FindImageAndClick(233, 486, 272, 519, , "Skip", 146, 496) ;click on next until skip button appears

	FindImageAndClick(120, 70, 150, 100, , "Next", 239, 497, , 2)

	FindImageAndClick(53, 281, 86, 310, , "Wonder", 146, 494) ;click on next until skip button appearsstop at hourglasses tutorial

	Delay(3)

	adbClick(140, 358)

	FindImageAndClick(191, 393, 211, 411, , "Shop", 146, 444) ;click until at main menu

	FindImageAndClick(87, 232, 131, 266, , "Wonder2", 79, 411) ; click until wonder pick tutorial screen

	FindImageAndClick(114, 430, 155, 441, , "Wonder3", 190, 437) ; click through tutorial

	Delay(2)

	FindImageAndClick(155, 281, 192, 315, , "Wonder4", 202, 347, 500) ; confirm wonder pick selection

	Delay(2)

	adbClick(208, 461)

	if(setSpeed = 3) ;time the animation
		Sleep, 1500
	else
		Sleep, 2500

	FindImageAndClick(60, 130, 202, 142, 10, "Pick", 208, 461, 350) ;stop at pick a card

	Delay(1)

	adbClick(187, 345)

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		if(setSpeed = 3)
			continueTime := 1
		else
			continueTime := 3

		if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime)) {
			adbClick(239, 497)
		} else if(FindOrLoseImage(110, 230, 182, 257, , "Welcome", 0, failSafeTime)) { ;click through to end of tut screen
			break
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next2", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		}
		else {
			adbClick(187, 345)
			Delay(1)
			adbClick(143, 492)
			Delay(1)
			adbClick(143, 492)
			Delay(1)
		}
		Delay(1)

		; adbClick(66, 446)
		; Delay(1)
		; adbClick(66, 446)
		; Delay(1)
		; adbClick(66, 446)
		; Delay(1)
		; adbClick(187, 345)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for End. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for End. " . failSafeTime "/45 seconds")
	}

	FindImageAndClick(120, 316, 143, 335, , "Main", 192, 449) ;click until at main menu

	return true
}

SelectPack(HG := false) {
	global openPack, packArray
	packy := 196
	if(openPack = "Shining") {
		packx := 145 
	} else if(openPack = "Arceus") {
		packx := 200
	} else {
		packx := 80
	}
	FindImageAndClick(233, 400, 264, 428, , "Points", packx, packy)
	if(openPack = "Pikachu" || openPack = "Mewtwo" || openPack = "Charizard" || openPack = "Mew") {
		FindImageAndClick(115, 140, 160, 155, , "SelectExpansion", 245, 475)
		packy := 442
		if(openPack = "Pikachu" || openPack = "Mewtwo" || openPack = "Charizard"){
			Sleep, 500 
			adbSwipeUp(160)
			Sleep, 500
		}
		if(openPack = "Pikachu"){
            packx := 125
        } else if(openPack = "Mewtwo"){
            packx := 85
        } else if(openPack = "Charizard"){
            packx := 45 
        } else if(openPack = "Mew"){
            packx := 205
        }
		FindImageAndClick(233, 400, 264, 428, , "Points", packx, packy)
	} else if(openPack = "Palkia") {
		Sleep, 500 
		adbClick(245, 245) ;temp
		Sleep, 500 
	}
	if(HG = "Tutorial") {
		FindImageAndClick(236, 198, 266, 226, , "Hourglass2", 180, 436, 500) ;stop at hourglasses tutorial 2 180 to 203?
	}
	else if(HG = "HGPack") {
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			if(FindOrLoseImage(60, 440, 90, 480, , "HourglassPack", 0, failSafeTime)) {
				break
			}
			adbClick(146, 439)
			Delay(1)
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for HourglassPack3. " . failSafeTime "/45 seconds")
		}
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			if(FindOrLoseImage(60, 440, 90, 480, , "HourglassPack", 1, failSafeTime)) {
				break
			}
			adbClick(205, 458)
			Delay(1)
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for HourglassPack4. " . failSafeTime "/45 seconds")
		}
	}
	;if(HG != "Tutorial")
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			if(FindImageAndClick(233, 486, 272, 519, , "Skip2", 130, 430, , 2)) ;click on next until skip button appears
				break
			Delay(1)
			adbClick(200, 451)
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for Skip2. " . failSafeTime "/45 seconds")
		}
}

PackOpening() {
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbClick(146, 439)
		Delay(1)
		if(FindOrLoseImage(225, 273, 235, 290, , "Pack", 0, failSafeTime))
			break ;wait for pack to be ready to Trace and click skip
		else
			adbClick(239, 497)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Pack. " . failSafeTime "/45 seconds")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at Pack")
	}

	if(setSpeed > 1) {
	FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
	FindImageAndClick(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
		Delay(1)
	}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()
		Sleep, 10
		if (FindOrLoseImage(225, 273, 235, 290, , "Pack", 1, failSafeTime)){
		if(setSpeed > 1) {
			if(setSpeed = 3)
					FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
			else
					FindImageAndClick(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		}
			adbClick(41, 296)
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. " . failSafeTime "/45 seconds")
		Delay(1)
	}

	FindImageAndClick(0, 98, 116, 125, 5, "Opening", 239, 497) ;skip through cards until results opening screen

	CheckPack()

	FindImageAndClick(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		Delay(1)
		if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime)) {
			adbClick(239, 497)
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next2", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		} else if(FindOrLoseImage(121, 465, 140, 485, , "ConfirmPack", 0, failSafeTime)) {
			break
		} else if(FindOrLoseImage(178, 193, 251, 282, , "Hourglass", 0, failSafeTime)) {
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Home. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Home. " . failSafeTime "/45 seconds")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at Home")
	}
}

HourglassOpening(HG := false) {
	if(!HG) {
		Delay(3)
		adbClick(146, 441) ; 146 440
		Delay(3)
		adbClick(146, 441)
		Delay(3)
		adbClick(146, 441)
		Delay(3)

		FindImageAndClick(98, 184, 151, 224, , "Hourglass1", 168, 438, 500, 5) ;stop at hourglasses tutorial 2
		Delay(1)

		adbClick(203, 436) ; 203 436

		if(packMethod) {
			AddFriends(true)
			SelectPack("Tutorial")
		}
		else {
			FindImageAndClick(236, 198, 266, 226, , "Hourglass2", 180, 436, 500) ;stop at hourglasses tutorial 2 180 to 203?
		}
	}
	if(!packMethod) {
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			if(FindOrLoseImage(60, 440, 90, 480, , "HourglassPack", 0, failSafeTime)) {
				break
			}
			adbClick(146, 439)
			Delay(1)
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for HourglassPack. " . failSafeTime "/45 seconds")
		}
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			if(FindOrLoseImage(60, 440, 90, 480, , "HourglassPack", 1, failSafeTime)) {
				break
			}
			adbClick(205, 458)
			Delay(1)
			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("In failsafe for HourglassPack2. " . failSafeTime "/45 seconds")
		}
	}
	Loop {
		adbClick(146, 439)
		Delay(1)
		if(FindOrLoseImage(225, 273, 235, 290, , "Pack", 0, failSafeTime))
			break ;wait for pack to be ready to Trace and click skip
		else
			adbClick(239, 497)
		clickButton := FindOrLoseImage(145, 440, 258, 480, 80, "Button", 0, failSafeTime)
		if(clickButton) {
			StringSplit, pos, clickButton, `,  ; Split at ", "
			if (scaleParam = 287) {
				pos2 += 5
			}
			adbClick(pos1, pos2)
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Pack. " . failSafeTime "/45 seconds")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at Pack")
	}

	if(setSpeed > 1) {
	FindImageAndClick(65, 195, 100, 215, , "Platin", 18, 109, 2000) ; click mod settings
	FindImageAndClick(9, 170, 25, 190, , "One", 26, 180) ; click mod settings
		Delay(1)
	}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()
		Sleep, 10
		if (FindOrLoseImage(225, 273, 235, 290, , "Pack", 1, failSafeTime)){
		if(setSpeed > 1) {
			if(setSpeed = 3)
					FindImageAndClick(182, 170, 194, 190, , "Three", 187, 180) ; click mod settings
			else
					FindImageAndClick(100, 170, 113, 190, , "Two", 107, 180) ; click mod settings
		}
			adbClick(41, 296)
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. " . failSafeTime "/45 seconds")
		Delay(1)
	}

	FindImageAndClick(0, 98, 116, 125, 5, "Opening", 239, 497) ;skip through cards until results opening screen

	CheckPack()

	FindImageAndClick(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		Delay(1)
		if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime)) {
			adbClick(239, 497)
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next2", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		} else if(FindOrLoseImage(121, 465, 140, 485, , "ConfirmPack", 0, failSafeTime)) {
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for ConfirmPack. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for ConfirmPack. " . failSafeTime "/45 seconds")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at ConfirmPack")
	}
}

getFriendCode() {
	global friendCode
	CreateStatusMessage("Getting friend code")
	Sleep, 2000
	FindImageAndClick(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		Delay(1)
		if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime)) {
			adbClick(239, 497)
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		} else if(FindOrLoseImage(120, 70, 150, 100, , "Next2", 0, failSafeTime)) {
			adbClick(146, 494) ;146, 494
		} else if(FindOrLoseImage(121, 465, 140, 485, , "ConfirmPack", 0, failSafeTime)) {
			break
		}
		else if(FindOrLoseImage(20, 500, 55, 530, , "Home", 0, failSafeTime)) {
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Home. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Home. " . failSafeTime "/45 seconds")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at Home")
	}
	friendCode := AddFriends(false, true)

	return friendCode
}

createAccountList(instance) {
	currentDate := A_Now
	year := SubStr(currentDate, 1, 4)
	month := SubStr(currentDate, 5, 2)
	day := SubStr(currentDate, 7, 2)

	daysSinceBase := (year - 1900) * 365 + Floor((year - 1900) / 4)
	daysSinceBase += MonthToDays(year, month)
	daysSinceBase += day

	remainder := Mod(daysSinceBase, 3)

	saveDir := A_ScriptDir "\..\Accounts\Saved\" . remainder . "\" . instance
	outputTxt := saveDir . "\list.txt"

	if FileExist(outputTxt) {
		FileGetTime, fileTime, %outputTxt%, M  ; Get last modified time
		timeDiff := A_Now - fileTime  ; Calculate time difference
		if (timeDiff > 86400)  ; 24 hours in seconds (60 * 60 * 24)
			FileDelete, %outputTxt%
	}
	if (!FileExist(outputTxt)) {
		Loop, %saveDir%\*.xml {
			xml := saveDir . "\" . A_LoopFileName
			FileGetTime, fileTime, %xml%, M
			timeDiff := A_Now - fileTime  ; Calculate time difference
			if (timeDiff > 86400) {  ; 24 hours in seconds (60 * 60 * 24)
				FileAppend, % A_LoopFileName "`n", %outputTxt%  ; Append file path to output.txt\
			}
		}
	}
}

DoWonderPick() {
	FindImageAndClick(191, 393, 211, 411, , "Shop", 40, 515) ;click until at main menu
	FindImageAndClick(240, 80, 265, 100, , "WonderPick", 59, 429) ;click until in wonderpick Screen
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbClick(80, 460)
		if(FindOrLoseImage(240, 80, 265, 100, , "WonderPick", 1, failSafeTime)) {
			clickButton := FindOrLoseImage(100, 367, 190, 480, 100, "Button", 0, failSafeTime)
			if(clickButton) {
				StringSplit, pos, clickButton, `,  ; Split at ", "
					; Adjust pos2 if scaleParam is 287 for 100%
					if (scaleParam = 287) {
						pos2 += 5
					}
					adbClick(pos1, pos2)
				Delay(3)
			}
			if(FindOrLoseImage(160, 330, 200, 370, , "Card", 0, failSafeTime))
				break
		}
		Delay(1)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for WonderPick. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for WonderPick. " . failSafeTime "/45 seconds")
	}
	Sleep, 300
	if(slowMotion)
		Sleep, 3000
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbClick(183, 350) ; click card
		if(FindOrLoseImage(160, 330, 200, 370, , "Card", 1, failSafeTime)) {
			break
		}
		Delay(1)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Card. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Card. " . failSafeTime "/45 seconds")
	}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbClick(146, 494)
		if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime) || FindOrLoseImage(240, 80, 265, 100, , "WonderPick", 0, failSafeTime))
			break
		delay(1)
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Shop. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Shop. " . failSafeTime "/45 seconds")
	}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		Delay(2)
		if(FindOrLoseImage(191, 393, 211, 411, , "Shop", 0, failSafeTime))
			break
		else if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime))
			adbClick(239, 497)
		else
			adbInputEvent("111") ;send ESC
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Shop. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Shop. " . failSafeTime "/45 seconds")
	}
	FindImageAndClick(2, 85, 34, 120, , "Missions", 261, 478, 500)
	;FindImageAndClick(130, 170, 170, 205, , "WPMission", 150, 286, 1000)
	FindImageAndClick(120, 185, 150, 215, , "FirstMission", 150, 286, 1000)
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		Delay(1)
		adbClick(139, 424)
		Delay(1)
		clickButton := FindOrLoseImage(145, 447, 258, 480, 80, "Button", 0, failSafeTime)
		if(clickButton) {
			adbClick(110, 369)
		}
		else if(FindOrLoseImage(191, 393, 211, 411, , "Shop", 1, failSafeTime))
			adbInputEvent("111") ;send ESC
		else
			break
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for WonderPick. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for WonderPick. " . failSafeTime "/45 seconds")
	}
	return true
}

getChangeDateTime() {
	; Get system timezone bias and determine local time for 1 AM EST

	; Retrieve timezone information from Windows registry
	RegRead, TimeBias, HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation, Bias
	RegRead, DltBias, HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation, ActiveTimeBias

	; Convert registry values to integers
	Bias := TimeBias + 0
	DltBias := DltBias + 0

	; Determine if Daylight Saving Time (DST) is active
	IsDST := (Bias != DltBias) ? 1 : 0

	; EST is UTC-5 (300 minutes offset)
	EST_Offset := 300

	; Use the correct local offset (DST or Standard)
	Local_Offset := (IsDST) ? DltBias : Bias

	; Convert 1 AM EST to UTC (UTC = EST + 5 hours)
	UTC_Time := 1 + EST_Offset / 60  ; 06:00 UTC

	; Convert UTC to local time
	Local_Time := UTC_Time - (Local_Offset / 60)

	; Round to ensure we get whole numbers
	Local_Time := Floor(Local_Time)

	; Handle 24-hour wrap-around
	If (Local_Time < 0)
		Local_Time += 24
	Else If (Local_Time >= 24)
		Local_Time -= 24

	; Format output as HHMM
	FormattedTime := (Local_Time < 10 ? "0" : "") . Local_Time . "00"

	Return FormattedTime
}


/*
^e::
	msgbox ss
	pToken := Gdip_Startup()
	Screenshot()
return
*/
