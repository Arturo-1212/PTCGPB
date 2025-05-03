#Include %A_ScriptDir%\Include\Logging.ahk
#Include %A_ScriptDir%\Include\ADB.ahk
#Include %A_ScriptDir%\Include\Gdip_All.ahk
#Include %A_ScriptDir%\Include\Gdip_Imagesearch.ahk

; BallCity - 2025.20.25 - Add OCR library for Username if Inject is on
#Include *i %A_ScriptDir%\Include\OCR.ahk
#Include *i %A_ScriptDir%\Include\Gdip_Extra.ahk

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

global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, scriptName, GPTest, StatusText, defaultLanguage, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, deleteMethod, packs, FriendID, friendIDs, Instances, username, friendCode, stopToggle, friended, runMain, Mains, showStatus, injectMethod, packMethod, loadDir, loadedAccount, nukeAccount, CheckShinyPackOnly, TrainerCheck, FullArtCheck, RainbowCheck, ShinyCheck, dateChange, foundGP, friendsAdded, PseudoGodPack, packArray, CrownCheck, ImmersiveCheck, InvalidCheck, slowMotion, screenShot, accountFile, invalid, starCount, keepAccount
global Mewtwo, Charizard, Pikachu, Mew, Dialga, Palkia, Arceus, Shining, Solgaleo, Lunala
global shinyPacks, minStars, minStarsShiny, minStarsA1Mewtwo, minStarsA1Charizard, minStarsA1Pikachu, minStarsA1a, minStarsA2Dialga, minStarsA2Palkia, minStarsA2a, minStarsA2b, minStarsA3Solgaleo, minStarsA3Lunala
global DeadCheck
global s4tEnabled, s4tSilent, s4t3Dmnd, s4t4Dmnd, s4t1Star, s4tGholdengo, s4tWP, s4tWPMinCards, s4tDiscordWebhookURL, s4tDiscordUserId, s4tSendAccountXml
global avgtotalSeconds

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
IniRead, Columns, %A_ScriptDir%\..\Settings.ini, UserSettings, Columns, 5
IniRead, godPack, %A_ScriptDir%\..\Settings.ini, UserSettings, godPack, Continue
IniRead, Instances, %A_ScriptDir%\..\Settings.ini, UserSettings, Instances, 1
IniRead, defaultLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, defaultLanguage, Scale125
IniRead, SelectedMonitorIndex, %A_ScriptDir%\..\Settings.ini, UserSettings, SelectedMonitorIndex, 1
IniRead, swipeSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, swipeSpeed, 300
IniRead, deleteMethod, %A_ScriptDir%\..\Settings.ini, UserSettings, deleteMethod, 3 Pack
IniRead, runMain, %A_ScriptDir%\..\Settings.ini, UserSettings, runMain, 1
IniRead, Mains, %A_ScriptDir%\..\Settings.ini, UserSettings, Mains, 1
IniRead, AccountName, %A_ScriptDir%\..\Settings.ini, UserSettings, AccountName, ""
IniRead, nukeAccount, %A_ScriptDir%\..\Settings.ini, UserSettings, nukeAccount, 0
IniRead, packMethod, %A_ScriptDir%\..\Settings.ini, UserSettings, packMethod, 0
IniRead, CheckShinyPackOnly, %A_ScriptDir%\..\Settings.ini, UserSettings, CheckShinyPackOnly, 0
IniRead, TrainerCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, TrainerCheck, 0
IniRead, FullArtCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, FullArtCheck, 0
IniRead, RainbowCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, RainbowCheck, 0
IniRead, ShinyCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, ShinyCheck, 0
IniRead, CrownCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, CrownCheck, 0
IniRead, ImmersiveCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, ImmersiveCheck, 0
IniRead, InvalidCheck, %A_ScriptDir%\..\Settings.ini, UserSettings, InvalidCheck, 0
IniRead, PseudoGodPack, %A_ScriptDir%\..\Settings.ini, UserSettings, PseudoGodPack, 0
IniRead, minStars, %A_ScriptDir%\..\Settings.ini, UserSettings, minStars, 0
IniRead, minStarsShiny, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsShiny, 0
IniRead, Solgaleo, %A_ScriptDir%\..\Settings.ini, UserSettings, Solgaleo, 1
IniRead, Lunala, %A_ScriptDir%\..\Settings.ini, UserSettings, Lunala, 1
IniRead, Shining, %A_ScriptDir%\..\Settings.ini, UserSettings, Shining, 0
IniRead, Arceus, %A_ScriptDir%\..\Settings.ini, UserSettings, Arceus, 0
IniRead, Dialga, %A_ScriptDir%\..\Settings.ini, UserSettings, Dialga, 0
IniRead, Palkia, %A_ScriptDir%\..\Settings.ini, UserSettings, Palkia, 0
IniRead, Mewtwo, %A_ScriptDir%\..\Settings.ini, UserSettings, Mewtwo, 0
IniRead, Charizard, %A_ScriptDir%\..\Settings.ini, UserSettings, Charizard, 0
IniRead, Pikachu, %A_ScriptDir%\..\Settings.ini, UserSettings, Pikachu, 0
IniRead, Mew, %A_ScriptDir%\..\Settings.ini, UserSettings, Mew, 0
IniRead, slowMotion, %A_ScriptDir%\..\Settings.ini, UserSettings, slowMotion, 0
IniRead, DeadCheck, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck, 0
IniRead, ocrLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, ocrLanguage, en

IniRead, minStarsA1Mewtwo, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1Mewtwo, 0
IniRead, minStarsA1Charizard, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1Charizard, 0
IniRead, minStarsA1Pikachu, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1Pikachu, 0
IniRead, minStarsA1a, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA1a, 0
IniRead, minStarsA2Dialga, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2Dialga, 0
IniRead, minStarsA2Palkia, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2Palkia, 0
IniRead, minStarsA2a, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2a, 0
IniRead, minStarsA2b, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2b, 0
IniRead, minStarsA3Solgaleo, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA3Solgaleo, 0
IniRead, minStarsA3Lunala, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA3Lunala, 0

IniRead, s4tEnabled, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tEnabled, 0
IniRead, s4tSilent, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tSilent, 1
IniRead, s4t3Dmnd, %A_ScriptDir%\..\Settings.ini, UserSettings, s4t3Dmnd, 0
IniRead, s4t4Dmnd, %A_ScriptDir%\..\Settings.ini, UserSettings, s4t4Dmnd, 0
IniRead, s4t1Star, %A_ScriptDir%\..\Settings.ini, UserSettings, s4t1Star, 0
IniRead, s4tGholdengo, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tGholdengo, 0
IniRead, s4tWP, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tWP, 0
IniRead, s4tWPMinCards, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tWPMinCards, 1
IniRead, s4tDiscordWebhookURL, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tDiscordWebhookURL
IniRead, s4tDiscordUserId, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tDiscordUserId
IniRead, s4tSendAccountXml, %A_ScriptDir%\..\Settings.ini, UserSettings, s4tSendAccountXml, 1

pokemonList := ["Mewtwo", "Charizard", "Pikachu", "Mew", "Dialga", "Palkia", "Arceus", "Shining", "Solgaleo", "Lunala"]
shinyPacks := {"Shining": 1, "Solgaleo": 1, "Lunala": 1}

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

; connect adb
Sleep, % scriptName * 1000
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
            CreateStatusMessage("Failed to create button GUI.",,,, false)
            break
        }
        Sleep, 1000
    }
    Delay(1)
    CreateStatusMessage("Trying to create button GUI...")
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

clearMissionCache()

if(!injectMethod || !loadedAccount)
    restartGameInstance("Initializing bot...", false)

pToken := Gdip_Startup()
packs := 0

; Define default swipe params.
adbSwipeX1 := Round(35 / 277 * 535)
adbSwipeX2 := Round(267 / 277 * 535)
adbSwipeY := Round((327 - 44) / 489 * 960)
global adbSwipeParams := adbSwipeX1 . " " . adbSwipeY . " " . adbSwipeX2 . " " . adbSwipeY . " " . swipeSpeed

if(DeadCheck = 1){
    IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
}
if(DeadCheck = 1 && !injectMethod){
    friended:= true
	menuDeleteStart()
	Reload
} else {
	;in injection mode, we don't need to reload
    Loop {
		clearMissionCache()
        Randmax := packArray.Length()
        Random, rand, 1, Randmax
        openPack := packArray[rand]
        friended := false
        IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Instance%scriptName%

		changeDate := getChangeDateTime() ; get server reset time

		if (avgtotalSeconds > 0 ) {
			StartTime := changeDate
			StartTime += -(1.5*avgtotalSeconds), Seconds
			EndTime := changeDate
			EndTime += (1.5*avgtotalSeconds), Seconds
		} else {
			StartTime := changeDate
			StartTime += -10, minutes
			EndTime := changeDate
			EndTime += 5, minutes
		}

		StartCurrentTimeDiff := A_Now
		EnvSub, StartCurrentTimeDiff, %StartTime%, Seconds
		EndCurrentTimeDiff := A_Now
		EnvSub, EndCurrentTimeDiff, %EndTime%, Seconds

		dateChange := false

		while (StartCurrentTimeDiff > 0 && EndCurrentTimeDiff < 0) {
            CreateStatusMessage("I need a break... Sleeping until " . EndTime ,,,, false)
            dateChange := true
            Sleep, 5000

			StartCurrentTimeDiff := A_Now
			EnvSub, StartCurrentTimeDiff, %StartTime%, Seconds
			EndCurrentTimeDiff := A_Now
			EnvSub, EndCurrentTimeDiff, %EndTime%, Seconds
		}


        if(dateChange)
	   ; This resets the counter for liking showcase to 5
	     IniWrite, 5, %A_ScriptDir%\..\Settings.ini, UserSettings, showcaseLikes ;###✔️✔️

	    ;always call it. it will updates the list every 1h
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
        keepAccount := false

        ; BallCity 2025.02.21 - Keep track of additional metrics
        now := A_NowUTC
        IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastStartTimeUTC
        EnvSub, now, 1970, seconds
        IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastStartEpoch

        if(!injectMethod || !loadedAccount)
            DoTutorial()

        ;    SquallTCGP 2025.03.12 -     Adding the delete method 5 Pack (Fast) to the wonder pick check.
        if(deleteMethod = "5 Pack" || deleteMethod = "5 Pack (Fast)" || deleteMethod = "13 Pack" || (injectMethod && !loadedAccount))
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

        if(wonderPicked && !loadedAccount) {
            ; SquallTCGP 2025.03.12 - Added a check to not add friends if the delete method is 5 Pack (Fast). When using this method (5 Pack (Fast)),
            ;                         it goes to the social menu and clicks the home button to exit (instead of opening all packs directly)
            ;                         just to get around the checking for a level after opening a pack. This change is made based on the
            ;                         5p-no delete community mod created by DietPepperPhD in the discord server.

            if(deleteMethod = "5 Pack" || packMethod) {
                friendsAdded := AddFriends(true)
				SelectPack("HGPack")
				PackOpening()
            } else {
				HourglassOpening(true)
            }

            if(packMethod) {
                friendsAdded := AddFriends(true)
                SelectPack("HGPack")
                PackOpening()
            }
            else {
                HourglassOpening(true)
            }
		}

		if(deleteMethod = "13 Pack" || (injectMethod && !loadedAccount) || (deleteMethod = "Inject 10P" && loadedAccount)) {
			;-----------------------------
			;if error during mission collection, try commenting the first line and uncommenting the second
			HomeAndMission()
			;HomeAndMission(0,true)
			;-----------------------------

			SelectPack("HGPack")
			PackOpening() ;6
			HourglassOpening(true) ;7

			HomeAndMission()
			SelectPack("HGPack")
			PackOpening() ;8
			HourglassOpening(true) ;9

			HomeAndMission()
			SelectPack("HGPack")
			PackOpening() ;10
			HourglassOpening(true) ;11

			HomeAndMission(1)
			SelectPack("HGPack")
			PackOpening() ;12
			HomeAndMission(1)
			SelectPack("HGPack")
			PackOpening() ;13
		}

        if (nukeAccount && !keepAccount && !injectMethod) {
            CreateStatusMessage("Deleting account...",,,, false)
            menuDelete()
        } else if (friended) {
            CreateStatusMessage("Unfriending...",,,, false)
            RemoveFriends()
        }

        if (loadedAccount){
			if(deleteMethod = "Inject 10P")
				packs := 10
			else
				packs := 2
		} else {
            if (deleteMethod = "3 Pack")
                packs := 3
            else if (deleteMethod = "5 Pack" || deleteMethod = "5 Pack (fast)")
                packs := 5
			else
				packs := 13
		}
		AppendToJsonFile(packs)
        IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

        ; BallCity 2025.02.21 - Keep track of additional metrics
        now := A_NowUTC
        IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastEndTimeUTC
        EnvSub, now, 1970, seconds
        IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastEndEpoch

        rerolls++

        totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
        avgtotalSeconds := Round(totalSeconds / rerolls) ; Total time in seconds
        minutes := Floor(avgtotalSeconds / 60) ; Total minutes
        seconds := Mod(avgtotalSeconds, 60) ; Remaining seconds within the minute
        mminutes := Floor(totalSeconds / 60) ; Total minutes
        sseconds := Mod(totalSeconds, 60) ; Remaining seconds within the minute
        CreateStatusMessage("Avg: " . minutes . "m " . seconds . "s | Runs: " . rerolls, "AvgRuns", 0, 510, false, true)
        LogToFile("Packs: " . packs . " | Total time: " . mminutes . "m " . sseconds . "s | Avg: " . minutes . "m " . seconds . "s | Runs: " . rerolls)

        if ((!injectMethod || !loadedAccount) && (!nukeAccount || keepAccount)) {
            ; Doing the following because:
            ; - not using the inject method
            ; - or using the inject method but an hasn't been loaded
            ; - and...
            ; - not using menu delete account
            ; - or the current account opened a desirable pack and shouldn't be deleted
            saveAccount("All")

            restartGameInstance("New Run", false)
        } else {
            ; Reached here because:
            ; - using the inject method
            ; - or the account was deleted because no desirable packs were found during the last run

            if (stopToggle) {
                CreateStatusMessage("Stopping...",,,, false)
				;TODO force stop, remove account
                ExitApp
            }

            CreateStatusMessage("New Run",,,, false)
        }

        if (injectMethod)
            loadedAccount := loadAccount()
		if (injectMethod && !loadedAccount)	;restartGameInstance if injection and no account loaded, switch to 13p
			restartGameInstance("Finished injecting", false)
    }
}
return



HomeAndMission(homeonly := 0, completeSecondMisson=false) {
	Sleep, 250
	failSafe := A_TickCount
	failSafeTime := 0
	Leveled := 0
	Loop {
		if(!Leveled)
			Leveled := LevelUp()
		else
			LevelUp()
		FindImageAndClick(191, 393, 211, 411, , "Shop", 146, 470, 500, 1)
		if(FindImageAndClick(120, 188, 140, 208, , "Album", 79, 86 , 500, 1)){
			FindImageAndClick(191, 393, 211, 411, , "Shop", 142, 488, 500)
			break
		}
		failSafeTime := (A_TickCount - failSafe) // 1000
	}
	if(!homeonly){
	FindImageAndClick(191, 393, 211, 411, , "Shop", 142, 488, 500)
	FindImageAndClick(180, 498, 190, 508, , "Mission_dino1", 261, 478, 1000)
	if (completeSecondMisson){
		FindImageAndClick(136, 158, 156, 190, , "Mission_dino2", 150, 390, 1000)
		}
	else {
		FindImageAndClick(136, 158, 156, 190, , "Mission_dino2", 150, 286, 1000)
		}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		Delay(1)
		adbClick(139, 424) ;clicks complete mission
		Delay(1)
		clickButton := FindOrLoseImage(145, 447, 258, 480, 80, "Button", 0, failSafeTime)
		if(clickButton) {
			adbClick(110, 369)
		}
		else if(FindOrLoseImage(191, 393, 211, 411, , "Shop", 1, failSafeTime)) {
			adbInputEvent("111") ;send ESC
			sleep, 1500
		}
		else
			break
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for WonderPick. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for WonderPick. " . failSafeTime "/45 seconds")
	}
	}
	return Leveled
}

clearMissionCache() {
    adbShell.StdIn.WriteLine("rm /data/data/jp.pokemon.pokemontcgp/files/UserPreferences/v1/MissionUserPrefs")
    waitadb()
	;TODO delete all user preferences?
}


RemoveFriends() {
    global friendIDs, friended

	if(!friendIDs && friendID = "") {
		friended := false
		return false
	}

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
        CreateStatusMessage("Waiting for Social`n(" . failSafeTime . "/90 seconds)")
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
            CreateStatusMessage("Waiting for AddFriends1`n(" . failSafeTime . "/45 seconds)")
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
            CreateStatusMessage("Waiting for AddFriends2`n(" . failSafeTime . "/45 seconds)")
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
                CreateStatusMessage("Waiting for AddFriends3`n(" . failSafeTime . "/45 seconds)")
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
                CreateStatusMessage("Waiting for AddFriends4`n(" . failSafeTime . "/45 seconds)")
            }
            if(index != friendIDs.maxIndex()) {
                FindImageAndClick(205, 430, 255, 475, , "Search2", 150, 50, 1500)
                FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
                EraseInput(index, n)
            }
        }
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

	if(!getFC && !friendIDs && friendID = "")
		return false

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
                CreateStatusMessage("Waiting for Social`n(" . failSafeTime . "/90 seconds)")
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
                    CreateStatusMessage("Waiting for AddFriends1`n(" . failSafeTime . "/45 seconds)")
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
                    CreateStatusMessage("Waiting for AddFriends2`n(" . failSafeTime . "/45 seconds)")
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
                        CreateStatusMessage("Waiting for AddFriends3`n(" . failSafeTime . "/45 seconds)")
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
                        CreateStatusMessage("Waiting for AddFriends4`n(" . failSafeTime . "/45 seconds)")
                    }
                    if(index != friendIDs.maxIndex()) {
                        FindImageAndClick(205, 430, 255, 475, , "Search2", 150, 50, 1500)
                        FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
                        EraseInput(index, n)
                    }
                }
            }
            FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 500)
IniRead, showcaseNumber, %A_ScriptDir%\..\Settings.ini, UserSettings, showcaseLikes, 1
			if ( showcaseNumber > 0)
			{
				showcaseNumber -= 1
				IniWrite, %showcaseNumber%, %A_ScriptDir%\..\Settings.ini, UserSettings, showcaseLikes
				Delay(5)
				; Liking friend showcase script
				; clicking showcase button
				adbClick(80, 400)
				Delay(10)
				;MsgBox, showcaseNumber is > 0
				Loop, Read, %A_ScriptDir%\..\showcase_ids.txt
				{
					showcaseID := Trim(A_LoopReadLine)
					; clicking friend id search
					adbClick(220, 467)
					Delay(3)
					; clicking search bar
					adbClick(152, 272)
					Delay(3)
					;pasting id
					adbInput(showcaseID)
					Delay(1)
					;MsgBox, % showcaseID
					;pressing ok
					adbClick(212, 384)
					Delay(3)
					;pressing like on showcase
					adbClick(133, 192)
					Delay(3)
					;going back to community showcases
					adbClick(133, 492)
					Delay(3)
				}
			}
                    FindImageAndClick(20, 500, 55, 530, , "Home", 40, 516, 500)
        }
        CreateStatusMessage("Waiting for friends to accept request`n(" . count . "/" . waitTime . " seconds)")
        sleep, 1000
        count++
    }
    return n ;return added friends so we can dynamically update the .txt in the middle of a run without leaving friends at the end
}

ChooseTag() {
	FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 500)
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		FindImageAndClick(20, 500, 55, 530, , "Home", 40, 516, 500, 2)
		LevelUp()
		if(FindImageAndClick(203, 272, 237, 300, , "Profile", 143, 95, 500, 2, failSafeTime))
			break
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Profile. " . failSafeTime "/45 seconds")
		LogToFile("In failsafe for Profile. " . failSafeTime "/45 seconds")
	}
	FindImageAndClick(205, 310, 220, 319, , "ChosenTag", 143, 306, 1000)
	FindImageAndClick(53, 218, 63, 228, , "Badge", 143, 466, 500)
	FindImageAndClick(203, 272, 237, 300, , "Profile", 61, 112, 500)
	if(FindOrLoseImage(145, 140, 157, 155, , "Eevee", 1)) {
		FindImageAndClick(163, 200, 173, 207, , "ChooseEevee", 147, 207, 1000)
		FindImageAndClick(53, 218, 63, 228, , "Badge", 143, 466, 500)
	}
}

EraseInput(num := 0, total := 0) {
    if(num)
        CreateStatusMessage("Removing friend ID " . num . "/" . total,,,, false)
    failSafe := A_TickCount
    failSafeTime := 0
    Loop {
        FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
	    adbClick(50, 500)
		Sleep,10
	    adbClick(50, 500)
		Sleep,10
            adbInputEvent("67")
        if(FindOrLoseImage(15, 500, 68, 520, , "Erase", 0, failSafeTime))
            break
    }

    failSafeTime := (A_TickCount - failSafe) // 1000
    CreateStatusMessage("Waiting for EraseInput`n(" . failSafeTime . "/45 seconds)")
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
        restartGameInstance("Stuck at " . imageName . "...")
    }
    if(imageName = "Social" || imageName = "Add") {
        TradeTutorial()
    }
    if(imageName = "Social" || imageName = "Country" || imageName = "Account2" || imageName = "Account" || imageName = "Points") { ;only look for deleted account on start up.
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
            CreateStatusMessage("Loaded deleted account. Deleting XML...",,,, false)
            if(loadedAccount) {
                FileDelete, %loadedAccount%
                IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
            }
            LogToFile("Restarted game for instance " . scriptName . ". Reason: No save data found", "Restart.txt")
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
        restartGameInstance("Stuck at " . imageName . "...")
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
        } else if (imageName = "Profile") { ; ChangeTag GP found
            X1 := 213
            Y1 := 273
            X2 := 226
            Y2 := 286
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
    CreateStatusMessage("Finding and clicking " . imageName . "...")

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
                restartGameInstance("Stuck at " . imageName . "...") ; change to reset the instance and delete data then reload script
                StartSkipTime := A_TickCount
                failSafe := A_TickCount
            }
        }
        Path = %imagePath%Error.png
        pNeedle := GetNeedle(Path)
        ; ImageSearch within the region
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 120, 187, 155, 210, searchVariation)
        if (vRet = 1) {
            CreateStatusMessage("Error message in " . scriptName . ". Clicking retry...",,,, false)
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
            restartGameInstance("Stuck at " . imageName . "...")
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
                CreateStatusMessage("Loaded deleted account. Deleting XML...",,,, false)
                if(loadedAccount) {
                    FileDelete, %loadedAccount%
                    IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
                }
                LogToFile("Restarted game for instance " . scriptName . ". Reason: No save data found", "Restart.txt")
                Reload
            }
        }

        if(imageName = "Missions") { ; may input extra ESC and stuck at exit game
            Path = %imagePath%Delete2.png
            pNeedle := GetNeedle(Path)
            ; ImageSearch within the region
            vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 118, 353, 135, 390, searchVariation)
            if (vRet = 1) {
                adbClick(74, 353)
                Delay(1)
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
                CreateStatusMessage("Looking for " . imageName . "`nSkipping in " . (skip - ElapsedTime) . " seconds...")
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

resetWindows() {
    global Columns, winTitle, SelectedMonitorIndex, scaleParam
    CreateStatusMessage("Arranging window positions and sizes",,,, false)
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
                CreateStatusMessage("Pausing. Can't find window " . winTitle . ".",,,, false)
                Pause
            }
            RetryCount++
        }
        Sleep, 1000
    }
    return true
}

restartGameInstance(reason, RL := true){
	;initialize and new run (only not inject or not loaded), RL = false
	;delete device account only when new run, only not inject or not loaded, and no deadcheck
	;godpack, RL = godPack
	;stuckat RL = true

    if (Debug)
        CreateStatusMessage("Restarting game reason:`n" . reason)
    else if (InStr(reason, "Stuck"))
        CreateStatusMessage("Stuck! Restarting game...",,,, false)
    else
        CreateStatusMessage("Restarting game...",,,, false)

    if (RL = "GodPack") {
        LogToFile("Restarted game for instance " . scriptName . ". Reason: " reason, "Restart.txt")
        IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

		if (stopToggle) {
			CreateStatusMessage("Stopping...",,,, false)
			;TODO force stop, remove account
			ExitApp
		}

        Reload
    } else {
        adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
        waitadb()
		clearMissionCache()
        if (!RL && DeadCheck = 0) {
            adbShell.StdIn.WriteLine("rm /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml") ; delete account data
			;TODO improve friend list cluter with deadcheck/stuck at, for injection. need to check also loadAccount at the beggining
        }
        waitadb()
        adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
        waitadb()
        Sleep, 5000

        if (RL) {
			;if(!injectMethod || !loadedAccount) {
			if(!injectMethod) {
				if (menuDeleteStart()) {
					IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
					logMessage := "\n" . username . "\n[" . (starCount ? starCount : "0") . "/5][" . (packs ? packs : 0) . "P][" . openPack . "] " . (invalid ? invalid . " God Pack" : "Some sort of pack") . " found in instance: " . scriptName . "\nFile name: " . accountFile . "\nGot stuck doing something. Check Log_" . scriptName . ".txt."
					LogToFile(Trim(StrReplace(logMessage, "\n", " ")))
					; Logging to Discord is temporarily disabled until all of the scenarios which could cause the script to end up here are fully understood.
					;LogToDiscord(logMessage,, true)
				}
			}
            LogToFile("Restarted game for instance " . scriptName . ". Reason: " reason, "Restart.txt")

            if (stopToggle) {
                CreateStatusMessage("Stopping...",,,, false)
				;TODO force stop, remove account
                ExitApp
            }
            Reload
        }

		if (stopToggle) {
			CreateStatusMessage("Stopping...",,,, false)
			;TODO force stop, remove account
			ExitApp
		}
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
        CreateStatusMessage("Waiting for Settings`n(" . failSafeTime . " seconds)")
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
                ; fix https://discord.com/channels/1330305075393986703/1354775917288882267/1355090394307887135
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
                CreateStatusMessage("Waiting to click delete`n(" . failSafeTime . "/45 seconds)")
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
        CreateStatusMessage("Waiting to click delete`n(" . failSafeTime . "/45 seconds)")
    }

    Sleep, 2500
}

menuDeleteStart() {
    global friended
    if(keepAccount) {
        return keepAccount
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
                    CreateStatusMessage("Waiting to click delete`n(" . failSafeTime . "/45 seconds)")
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
            CreateStatusMessage("Waiting to click delete`n(" . failSafeTime . "/45 seconds)")
        }
        CreateStatusMessage("Looking for Country/Menu")
        Delay(1)
        failSafeTime := (A_TickCount - failSafe) // 1000
        CreateStatusMessage("Waiting for Country/Menu`n(" . failSafeTime . "/45 seconds)")
    }
    if(loadedAccount) {
        FileDelete, %loadedAccount%
    }
}

CheckPack() {
    ; Update pack count.

    ; SquallTCGP 2025.03.12 - Just checking the packs count and setting them to 0 if it's number of packs is 3.
    ;                         This applies to any Delete Method except 5 Pack (Fast). This change is made based
    ;                         on the 5p-no delete community mod created by DietPepperPhD in the discord server.
    if (deleteMethod = "5 Pack") {
        if (packs = 3)
            packs := 0
    }

    packs += 1
    if (packMethod)
        packs := 1

	if(!friendIDs && friend = "" && !s4tEnabled)
		return false

    ; Wait for cards to render before checking.
    Loop {
        if (FindBorders("lag") = 0)
            break
        Delay(1)
    }

    ; Define a variable to contain whatever is found based on settings.
    foundLabel := false

    ; Before doing anything else, check if the current pack is valid.
    foundShiny := FindBorders("shiny2star") + FindBorders("shiny1star")
    foundCrown := FindBorders("crown")
    foundImmersive := FindBorders("immersive")
    foundInvalid := foundShiny + foundCrown + foundImmersive

    if (foundInvalid) {
        ; Pack is invalid...
        if (!InvalidCheck) {
            ; Check if the current pack could have been a god pack.
            foundInvalidGP := FindGodPack(true)
        } else {
            ; If required, check what cards the current pack contains which make it invalid.
            if (ShinyCheck && foundShiny && !foundLabel)
                foundLabel := "Shiny"
            if (ImmersiveCheck && foundImmersive && !foundLabel)
                foundLabel := "Immersive"
            if (CrownCheck && foundCrown && !foundLabel)
                foundLabel := "Crown"

            ; Report invalid cards found.
            if (foundLabel) {
                FoundStars(foundLabel)
                restartGameInstance(foundLabel . " found. Continuing...", "GodPack")
            }
        }

        IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

        return
    }

    ; Check for god pack.
    foundGP := FindGodPack()

    if (foundGP) {
        if (loadedAccount) {
            FileDelete, %loadedAccount%
            IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
        }

        restartGameInstance("God Pack found. Continuing...", "GodPack")
        return
    }

    ; Check for 2-star cards.
    if (!CheckShinyPackOnly || shinyPacks.HasKey(openPack)) {
        foundTrainer := false
        foundRainbow := false
        foundFullArt := false
        2starCount := false

        if (TrainerCheck && !foundLabel) {
            foundTrainer := FindBorders("trainer")
            if (foundTrainer)
                foundLabel := "Trainer"
        }
        if (RainbowCheck && !foundLabel) {
            foundRainbow := FindBorders("rainbow")
            if (foundRainbow)
                foundLabel := "Rainbow"
        }
        if (FullArtCheck && !foundLabel) {
            foundFullArt := FindBorders("fullart")
            if (foundFullArt)
                foundLabel := "Full Art"
        }
        if (PseudoGodPack && !foundLabel) {
            2starCount := FindBorders("trainer") + FindBorders("rainbow") + FindBorders("fullart")
            if (2starCount > 1)
                foundLabel := "Double two star"
        }

        if (foundLabel) {
            if (loadedAccount) {
                FileDelete, %loadedAccount% ;delete xml file from folder if using inject method
                IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
            }

            FoundStars(foundLabel)
            restartGameInstance(foundLabel . " found. Continuing...", "GodPack")
        }
    }

    ; Check for tradeable cards.
    if (s4tEnabled) {
        found3Dmnd := 0
        found4Dmnd := 0
        found1Star := 0
        foundGimmighoul := 0

        if (s4t3Dmnd) {
            found3Dmnd += FindBorders("3diamond")
        }
        if (s4t1Star) {
            found1Star += FindBorders("1star")
        }

        if (s4t4Dmnd) {
            ; Detecting a 4-diamond EX card isn't possible using a needle.
            ; Start with 5 and substract other card types as efficiently as possible.
            found4Dmnd := 5 - FindBorders("normal")

            if (found4Dmnd > 0) {
                if (s4t3Dmnd)
                    found4Dmnd -= found3Dmnd
                else
                    found4Dmnd -= FindBorders("3diamond")
            }
            if (found4Dmnd > 0) {
                if (s4t1Star)
                    found4Dmnd -= found1Star
                else
                    found4Dmnd -= FindBorders("1star")
            }

            if (found4Dmnd > 0 && PseudoGodPack) {
                found4Dmnd -= 2starCount
            } else {
                if (found4Dmnd > 0) {
                    if (TrainerCheck)
                        found4Dmnd -= foundTrainer
                    else
                        found4Dmnd -= FindBorders("trainer")
                }
                if (found4Dmnd > 0) {
                    if (RainbowCheck)
                        found4Dmnd -= foundRainbow
                    else
                        found4Dmnd -= FindBorders("rainbow")
                }
                if (found4Dmnd > 0) {
                    if (FullArtCheck)
                        found4Dmnd -= foundFullArt
                    else
                        found4Dmnd -= FindBorders("fullart")
                }
            }
        }

        if (s4tGholdengo && openPack = "Shining") {
            foundGimmighoul += FindCard("gimmighoul")
        }

        foundTradeable := found3Dmnd + found4Dmnd + found1Star + foundGimmighoul

        if (foundTradeable > 0)
            FoundTradeable(found3Dmnd, found4Dmnd, found1Star, foundGimmighoul)
    }
}

FoundTradeable(found3Dmnd := 0, found4Dmnd := 0, found1Star := 0, foundGimmighoul := 0) {
    ; Not dead.
    IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

    ; Keep account.
    keepAccount := true

    foundTradeable := found3Dmnd + found4Dmnd + found1Star + foundGimmighoul

    packDetailsFile := ""
    packDetailsMessage := ""

    if (found3Dmnd > 0) {
        packDetailsFile .= "3DmndX" . found3Dmnd . "_"
        packDetailsMessage .= "Three Diamond (x" . found3Dmnd . "), "
    }
    if (found4Dmnd > 0) {
        packDetailsFile .= "4DmndX" . found4Dmnd . "_"
        packDetailsMessage .= "Four Diamond EX (x" . found4Dmnd . "), "
    }
    if (found1Star > 0) {
        packDetailsFile .= "1StarX" . found1Star . "_"
        packDetailsMessage .= "One Star (x" . found1Star . "), "
    }
    if (foundGimmighoul > 0) {
        packDetailsFile .= "GimmighoulX" . foundGimmighoul . "_"
        packDetailsMessage .= "Gimmighoul (x" . foundGimmighoul . "), "
    }

    packDetailsFile := RTrim(packDetailsFile, "_")
    packDetailsMessage := RTrim(packDetailsMessage, ", ")

    accountFullPath := ""
    accountFile := saveAccount("Tradeable", accountFullPath, packDetailsFile)
    screenShot := Screenshot("Tradeable", "Trades", screenShotFileName)

    statusMessage := "Tradeable cards found"
    if (username)
        statusMessage .= " by " . username

    if (!s4tWP || (s4tWP && foundTradeable < s4tWPMinCards)) {
        CreateStatusMessage("Tradeable cards found! Continuing...",,,, false)

        logMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ") File name: " . accountFile . " Screenshot file: " . screenShotFileName . " Backing up to the Accounts\\Trades folder and continuing..."
        LogToFile(logMessage, "S4T.txt")

        if (!s4tSilent && s4tDiscordWebhookURL) {
            discordMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ")\nFound: " . packDetailsMessage . "\nFile name: " . accountFile . "\nBacking up to the Accounts\\Trades folder and continuing..."
            LogToDiscord(discordMessage, screenShot, true, (s4tSendAccountXml ? accountFullPath : ""),, s4tDiscordWebhookURL, s4tDiscordUserId)
        }

        return
    }

    friendCode := getFriendCode()

    Sleep, 8000
    fcScreenshot := Screenshot("FRIENDCODE", "Trades")

    ; If we're doing the inject method, try to OCR our Username
    try {
        if (injectMethod && IsFunc("ocr")) {
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
        LogToFile("Failed to OCR the friend code: " . e.message, "OCR.txt")
    }

    statusMessage := "Tradeable cards found"
    if (username)
        statusMessage .= " by " . username
    if (friendCode)
        statusMessage .= " (" . friendCode . ")"

    logMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ")\nFile name: " . accountFile . "\nScreenshot file: " . screenShotFileName . "\nBacking up to the Accounts\\Trades folder and continuing..."
    LogToFile(StrReplace(logMessage, "\n", " "), "S4T.txt")

    if (s4tDiscordWebhookURL) {
        discordMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ")\nFound: " . packDetailsMessage . "\nFile name: " . accountFile . "\nBacking up to the Accounts\\Trades folder and continuing..."
        LogToDiscord(discordMessage, screenShot, true, (s4tSendAccountXml ? accountFullPath : ""), fcScreenshot, s4tDiscordWebhookURL, s4tDiscordUserId)
    }

    restartGameInstance("Tradeable cards found. Continuing...", "GodPack")
}

FoundStars(star) {
    global scriptName, DeadCheck, ocrLanguage, injectMethod, openPack

    ; Not dead.
    IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

    ; Keep account.
    keepAccount := true

    screenShot := Screenshot(star)
    accountFullPath := ""
    accountFile := saveAccount(star, accountFullPath)
    friendCode := getFriendCode()

    ; Pull back screenshot of the friend code/name (good for inject method)
    Sleep, 8000
    fcScreenshot := Screenshot("FRIENDCODE")

    if(star = "Crown" || star = "Immersive" || star = "Shiny")
        RemoveFriends()
    else {
        ; If we're doing the inject method, try to OCR our Username
        try {
            if (injectMethod && IsFunc("ocr")) {
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
            LogToFile("Failed to OCR the friend code: " . e.message, "OCR.txt")
        }
    }

    CreateStatusMessage(star . " found!",,,, false)

    statusMessage := star . " found"
    if (username)
        statusMessage .= " by " . username
    if (friendCode)
        statusMessage .= " (" . friendCode . ")"

    logMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ")\nFile name: " . accountFile . "\nBacking up to the Accounts\\SpecificCards folder and continuing..."
    LogToDiscord(logMessage, screenShot, true, (sendAccountXml ? accountFullPath : ""), fcScreenshot)
    LogToFile(StrReplace(logMessage, "\n", " "), "GPlog.txt")
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
            borderCoords := [[26, 278, 84, 280]
            ,[110, 278, 168, 280]
            ,[194, 278, 252, 280]
            ,[67, 395, 125, 397]
            ,[153, 395, 211, 397]]
        }
    }
    pBitmap := from_window(WinExist(winTitle))
    ; imagePath := "C:\Users\Arturo\Desktop\PTCGP\GPs\" . Clipboard . ".png"
    ; pBitmap := Gdip_CreateBitmapFromFile(imagePath)
    for index, value in borderCoords {
        coords := borderCoords[A_Index]
        Path = %A_ScriptDir%\%defaultLanguage%\%prefix%%A_Index%.png
        if (FileExist(Path)) {
            pNeedle := GetNeedle(Path)
            vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, coords[1], coords[2], coords[3], coords[4], searchVariation)
            if (vRet = 1) {
                count += 1
            }
        }
    }
    Gdip_DisposeImage(pBitmap)
    return count
}

FindCard(prefix) {
    count := 0
    searchVariation := 40
    borderCoords := [[23, 191, 76, 193]
        ,[106, 191, 159, 193]
        ,[189, 191, 242, 193]
        ,[63, 306, 116, 308]
        ,[146, 306, 199, 308]]
    ; 100% scale changes
    if (scaleParam = 287) {
        borderCoords := [[23, 184, 81, 186]
            ,[107, 184, 165, 186]
            ,[191, 184, 249, 186]
            ,[64, 301, 122, 303]
            ,[148, 301, 206, 303]]
    }
    pBitmap := from_window(WinExist(winTitle))
    for index, value in borderCoords {
        coords := borderCoords[A_Index]
        Path = %A_ScriptDir%\%defaultLanguage%\%prefix%%A_Index%.png
        if (FileExist(Path)) {
            pNeedle := GetNeedle(Path)
            vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, coords[1], coords[2], coords[3], coords[4], searchVariation)
            if (vRet = 1) {
                count += 1
            }
        }
    }
    Gdip_DisposeImage(pBitmap)
    return count
}

FindGodPack(invalidPack := false) {
    ; Check for normal borders.
    normalBorders := FindBorders("normal")
    if (normalBorders) {
        CreateStatusMessage("Not a God Pack...",,,, false)
        return false
    }

    ; A god pack (although possibly invalid) has been found.
    keepAccount := true

    ; Count stars if required.
    packMinStars := minStars
    if (openPack = "Solgaleo") {
        packMinStars := minStarsA3Solgaleo
    } else if (openPack = "Lunala") {
        packMinStars := minStarsA3Lunala
    } else if (openPack = "Shining") {
        packMinStars := minStarsA2b
    } else if (openPack = "Arceus") {
        packMinStars := minStarsA2a
    } else if (openPack = "Dialga") {
        packMinStars := minStarsA2Dialga
    } else if (openPack = "Palkia") {
        packMinStars := minStarsA2Palkia
    } else if (openPack = "Mewtwo") {
        packMinStars := minStarsA1Mewtwo
    } else if (openPack = "Charizard") {
        packMinStars := minStarsA1Charizard
    } else if (openPack = "Pikachu") {
        packMinStars := minStarsA1Pikachu
    } else if (openPack = "Mew") {
        packMinStars := minStarsA1a
    }

    if (!invalidPack && packMinStars > 0) {
        starCount := 5 - FindBorders("1star")
        if (starCount < packMinStars) {
            CreateStatusMessage("Pack doesn't contain enough 2 stars...",,,, false)
            invalidPack := true
        }
    }

    if (invalidPack) {
        GodPackFound("Invalid")

        RemoveFriends()
        IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
    } else {
        GodPackFound("Valid")
    }

    return keepAccount
}

GodPackFound(validity) {
    global scriptName, DeadCheck, ocrLanguage, injectMethod, openPack

    IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

    if(validity = "Valid") {
        Praise := ["Congrats!", "Congratulations!", "GG!", "Whoa!", "Praise Helix! ༼ つ ◕_◕ ༽つ", "Way to go!", "You did it!", "Awesome!", "Nice!", "Cool!", "You deserve it!", "Keep going!", "This one has to be live!", "No duds, no duds, no duds!", "Fantastic!", "Bravo!", "Excellent work!", "Impressive!", "You're amazing!", "Well done!", "You're crushing it!", "Keep up the great work!", "You're unstoppable!", "Exceptional!", "You nailed it!", "Hats off to you!", "Sweet!", "Kudos!", "Phenomenal!", "Boom! Nailed it!", "Marvelous!", "Outstanding!", "Legendary!", "Youre a rock star!", "Unbelievable!", "Keep shining!", "Way to crush it!", "You're on fire!", "Killing it!", "Top-notch!", "Superb!", "Epic!", "Cheers to you!", "Thats the spirit!", "Magnificent!", "Youre a natural!", "Gold star for you!", "You crushed it!", "Incredible!", "Shazam!", "You're a genius!", "Top-tier effort!", "This is your moment!", "Powerful stuff!", "Wicked awesome!", "Props to you!", "Big win!", "Yesss!", "Champion vibes!", "Spectacular!"]
        invalid := ""
    } else {
        Praise := ["Uh-oh!", "Oops!", "Not quite!", "Better luck next time!", "Yikes!", "That didn't go as planned.", "Try again!", "Almost had it!", "Not your best effort.", "Keep practicing!", "Oh no!", "Close, but no cigar.", "You missed it!", "Needs work!", "Back to the drawing board!", "Whoops!", "That's rough!", "Don't give up!", "Ouch!", "Swing and a miss!", "Room for improvement!", "Could be better.", "Not this time.", "Try harder!", "Missed the mark.", "Keep at it!", "Bummer!", "That's unfortunate.", "So close!", "Gotta do better!"]
        invalid := validity
    }
    Randmax := Praise.Length()
    Random, rand, 1, Randmax
    Interjection := Praise[rand]
    starCount := 5 - FindBorders("1star") - FindBorders("shiny1star")
    screenShot := Screenshot(validity)
    accountFullPath := ""
    accountFile := saveAccount(validity, accountFullPath)
    friendCode := getFriendCode()

    ; Pull screenshot of the Friend code page; wait so we don't get the clipboard pop up; good for the inject method
    Sleep, 8000
    fcScreenshot := Screenshot("FRIENDCODE")

    ; If we're doing the inject method, try to OCR our Username
    try {
        if (injectMethod && IsFunc("ocr")) {
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
        LogToFile("Failed to OCR the friend code: " . e.message, "OCR.txt")
    }

    CreateStatusMessage(Interjection . (invalid ? " " . invalid : "") . " God Pack found!",,,, false)
    logMessage := Interjection . "\n" . username . " (" . friendCode . ")\n[" . starCount . "/5][" . packs . "P][" . openPack . "] " . invalid . " God Pack found in instance: " . scriptName . "\nFile name: " . accountFile . "\nBacking up to the Accounts\\GodPacks folder and continuing..."
    LogToFile(StrReplace(logMessage, "\n", " "), "GPlog.txt")

    ; Adjust the below to only send a 'ping' to Discord friends on Valid packs
    if (validity = "Valid") {
        LogToDiscord(logMessage, screenShot, true, (sendAccountXml ? accountFullPath : ""), fcScreenshot)
        ChooseTag()
    } else if (!InvalidCheck) {
        LogToDiscord(logMessage, screenShot, true, (sendAccountXml ? accountFullPath : ""), fcScreenshot)
    }
}

loadAccount() {

	if (stopToggle) {
		CreateStatusMessage("Stopping...",,,, false)
		;TODO force stop, remove account
		ExitApp
	}

    CreateStatusMessage("Loading account...",,,, false)

    saveDir := A_ScriptDir "\..\Accounts\Saved\" . winTitle

    outputTxt := saveDir . "\list_current.txt"

    if FileExist(outputTxt) {
        FileRead, fileContent, %outputTxt%  ; Read entire file
        fileLines := StrSplit(fileContent, "`n", "`r")  ; Split into lines

        if (fileLines.MaxIndex() >= 1) {
            cycle := 0
            Loop {
                CreateStatusMessage("Making sure XML is > 24 hours old: " . cycle . " attempts")
                loadFile := saveDir . "\" . fileLines[1]  ; Store the first line
                test := fileExist(loadFile)

                if(!InStr(loadFile, "xml"))
                    return false
                newListContent := ""
                Loop, % fileLines.MaxIndex() - 1  ; remove first line TODO improve
                    newListContent .= fileLines[A_Index + 1] "`r`n"

                FileDelete, %outputTxt%  ; Delete old file TODO improve
                FileAppend, %newListContent%, %outputTxt%  ; Write back without the first line

                FileGetTime, accountFileTime, %loadFile%, M  ; Get last modified time of account file
                accountModifiedTimeDiff := A_Now
				EnvSub, accountModifiedTimeDiff, %accountFileTime%, Hours
				if (accountModifiedTimeDiff >= 24)
                    break
                cycle++
                Delay(1)
            }
        } else return false
    } else return false

    adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")

    RunWait, % adbPath . " -s 127.0.0.1:" . adbPort . " push " . loadFile . " /sdcard/deviceAccount.xml",, Hide

    Sleep, 500

    adbShell.StdIn.WriteLine("cp /sdcard/deviceAccount.xml /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml")
    waitadb()
    adbShell.StdIn.WriteLine("rm /sdcard/deviceAccount.xml")
    waitadb()
    adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
    waitadb()
    Sleep, 1000

    FileSetTime,, %loadFile%

    return loadFile
}

saveAccount(file := "Valid", ByRef filePath := "", packDetails := "") {

    filePath := ""

    if (file = "All") {
        saveDir := A_ScriptDir "\..\Accounts\Saved\" . winTitle
        filePath := saveDir . "\" . A_Now . "_" . winTitle . ".xml"
    } else if (file = "Valid" || file = "Invalid") {
        saveDir := A_ScriptDir "\..\Accounts\GodPacks\"
        xmlFile := A_Now . "_" . winTitle . "_" . file . "_" . packs . "_packs.xml"
        filePath := saveDir . xmlFile
    } else if (file = "Tradeable") {
        saveDir := A_ScriptDir "\..\Accounts\Trades\"
        xmlFile := A_Now . "_" . winTitle . "_" . file . (packDetails ? "_" . packDetails : "") . "_" . packs . "_packs.xml"
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
        if (Debug)
            CreateStatusMessage("Attempting to save account - " . count . "/10")
        else
            CreateStatusMessage("Saving account...",,,, false)

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
            CreateStatusMessage("Account not saved. Pausing...",,,, false)
            LogToDiscord("Attempted to save account in " . scriptName . " but was unsuccessful. Pausing. You will need to manually extract.", Screenshot(), true)
            Pause, On
        }
        count++
    }

    return xmlFile
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

Screenshot(fileType := "Valid", subDir := "", ByRef fileName := "") {
    global adbShell, adbPath, packs
    SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

    ; For PACKSTATS, use temp directory instead of Screenshots folder
    if (filename = "PACKSTATS") {
        ; Create temp directory if it doesn't exist
        tempDir := A_ScriptDir . "\temp"
        if !FileExist(tempDir)
            FileCreateDir, %tempDir%
        ; Use temp file path
        screenshotFile := tempDir . "\packstats_temp.png"
    } else {
        ; Normal screenshots go to Screenshots folder as before
        screenshotsDir := A_ScriptDir "\..\Screenshots"
        if !FileExist(screenshotsDir)
            FileCreateDir, %screenshotsDir%
        screenshotFile := screenshotsDir "\" . A_Now . "_" . winTitle . "_" . filename . "_" . packs . "_packs.png"
    }

    pBitmapW := from_window(WinExist(winTitle))
    pBitmap := Gdip_CloneBitmapArea(pBitmapW, 18, 175, 240, 227)
    ;scale 100%
    if (scaleParam = 287) {
        pBitmap := Gdip_CloneBitmapArea(pBitmapW, 17, 168, 245, 230)
    }
    Gdip_DisposeImage(pBitmapW)

    Gdip_SaveBitmapToFile(pBitmap, screenshotFile)

    ; Don't dispose pBitmap if it's a PACKSTATS screenshot
    if (filename != "PACKSTATS") {
        Gdip_DisposeImage(pBitmap)
        return screenshotFile
    }
    
    ; For PACKSTATS, return both values and delete temp file after OCR is done
    return {filepath: screenshotFile, bitmap: pBitmap, deleteAfterUse: true}
}


; Pause Script
PauseScript:
    CreateStatusMessage("Pausing...",,,, false)
    Pause, On
return

; Resume Script
ResumeScript:
    CreateStatusMessage("Resuming...",,,, false)
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

ToggleStop() {
    global stopToggle, friended
    stopToggle := true
    if (!friended)
        ExitApp
    else
        CreateStatusMessage("Stopping script at the end of the run...",,,, false)
}

ToggleTestScript() {
    global GPTest
    if(!GPTest) {
        CreateStatusMessage("In GP Test Mode",,,, false)
        GPTest := true
    }
    else {
        CreateStatusMessage("Exiting GP Test Mode",,,, false)
        ;Winset, Alwaysontop, On, %winTitle%
        GPTest := false
    }
}

; Function to append a time and variable pair to the JSON file
AppendToJsonFile(variableValue) {
    global jsonFileName
    if (!jsonFileName || !variableValue) {
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
        CreateStatusMessage("Waiting for Month`n(" . failSafeTime . "/45 seconds)")
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
        CreateStatusMessage("Waiting for Year`n(" . failSafeTime . "/45 seconds)")
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
            CreateStatusMessage("Waiting for country select for " . failSafeTime . "/45 seconds")
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
        CreateStatusMessage("Waiting for Save`n(" . failSafeTime . "/45 seconds)")
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
            Delay(1)
            failSafeTime := (A_TickCount - failSafe) // 1000
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
    ; Check for AccountName in Settings.ini
    IniRead, accountNameValue, %A_ScriptDir%\..\Settings.ini, UserSettings, AccountName, ERROR

    ; Use AccountName if it exists and isn't empty
    if (accountNameValue != "ERROR" && accountNameValue != "") {
        Random, randomNum, 1, 500 ; Generate random number from 1 to 500
        username := accountNameValue . "-" . randomNum
        username := SubStr(username, 1, 14)  ; max character limit
        LogToFile("Using AccountName: " . username)
    } else {
        fileName := A_ScriptDir . "\..\usernames.txt"
        if(FileExist(fileName))
            name := ReadFile("usernames")
        else
            name := ReadFile("usernames_default")

        Random, randomIndex, 1, name.MaxIndex()
        username := name[randomIndex]
        username := SubStr(username, 1, 14)  ; max character limit
        LogToFile("Using random username: " . username)
    }

    adbInput(username)
    Delay(1)
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
        adbSwipe(adbSwipeParams)
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
        CreateStatusMessage("Waiting for Pack`n(" . failSafeTime . "/45 seconds)")
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
        adbSwipe("266 770 266 355 60")
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
        CreateStatusMessage("Waiting for swipe up for " . failSafeTime . "/45 seconds")
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
        adbSwipe(adbSwipeParams)
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
        CreateStatusMessage("Waiting for Pack`n(" . failSafeTime . "/45 seconds)")
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
        CreateStatusMessage("Waiting for End`n(" . failSafeTime . "/45 seconds)")
    }

    FindImageAndClick(120, 316, 143, 335, , "Main", 192, 449) ;click until at main menu

    return true
}

SelectPack(HG := false) {
    global openPack, packArray
    packy := 225
    if (openPack = "Solgaleo") {
        packx := 140
    } else if (openPack = "Lunala") {
        packx := 215
    } else {
        packx := 60
    }

	if(HG = "First"){
		failSafe := A_TickCount
		failSafeTime := 0
		Loop {
			adbClick(packx, packy)
			Delay(1)
			if(FindOrLoseImage(233, 400, 264, 428, , "Points", 0, failSafeTime)) {
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
				;TODO hourglass tutorial still broken after injection
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
				FindImageAndClick(236, 198, 266, 226, , "Hourglass2", 180, 436, 500) ;stop at hourglasses tutorial 2 180 to 203?
			}

			failSafeTime := (A_TickCount - failSafe) // 1000
			CreateStatusMessage("Waiting for Points`n(" . failSafeTime . "/90 seconds)")
		}
	} else {
		FindImageAndClick(233, 400, 264, 428, , "Points", packx, packy)
	}

    if (openPack = "Mewtwo" || openPack = "Charizard" || openPack = "Pikachu" || openPack = "Mew" || openPack = "Dialga" || openPack = "Palkia" || openPack = "Arceus") {
        FindImageAndClick(115, 140, 160, 155, , "SelectExpansion", 245, 475)

        if (openPack = "Mewtwo" || openPack = "Charizard" || openPack = "Pikachu" || openPack = "Mew") {
            ; Swipe down
            adbSwipe("266 770 266 355 160")
            Sleep, 500

            packy := 470
            if (openPack = "Charizard") {
                packx := 160
            } else if (openPack = "Mewtwo") {
                packx := 200
            } else if (openPack = "Pikachu") {
                packx := 243
            } else if (openPack = "Mew") {
                packx := 73
            }
        } else {
            packy := 410
            if (openPack = "Arceus") {
                packx := 73
            } else if (openPack = "Dialga") {
                packx := 183
            } else if (openPack = "Palkia") {
                packx := 222
            }
        }

        FindImageAndClick(233, 400, 264, 428, , "Points", packx, packy)
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
            CreateStatusMessage("Waiting for HourglassPack3`n(" . failSafeTime . "/45 seconds)")
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
            CreateStatusMessage("Waiting for HourglassPack4`n(" . failSafeTime . "/45 seconds)")
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
            CreateStatusMessage("Waiting for Skip2`n(" . failSafeTime . "/45 seconds)")
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
        CreateStatusMessage("Waiting for Pack`n(" . failSafeTime . "/45 seconds)")
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
        adbSwipe(adbSwipeParams)
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
        CreateStatusMessage("Waiting for Trace`n(" . failSafeTime . "/45 seconds)")
        Delay(1)
    }

    FindImageAndClick(0, 98, 116, 125, 5, "Opening", 239, 497) ;skip through cards until results opening screen

    CheckPack()

    ;FindImageAndClick(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears

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
		} else {
			adbClick(146, 494) ;146, 494
		}
        failSafeTime := (A_TickCount - failSafe) // 1000
        CreateStatusMessage("Waiting for Home`n(" . failSafeTime . "/45 seconds)")
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
            CreateStatusMessage("Waiting for HourglassPack`n(" . failSafeTime . "/45 seconds)")
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
            CreateStatusMessage("Waiting for HourglassPack2`n(" . failSafeTime . "/45 seconds)")
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
        CreateStatusMessage("Waiting for Pack`n(" . failSafeTime . "/45 seconds)")
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
        adbSwipe(adbSwipeParams)
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
        CreateStatusMessage("Waiting for Trace`n(" . failSafeTime . "/45 seconds)")
        Delay(1)
    }

    FindImageAndClick(0, 98, 116, 125, 5, "Opening", 239, 497) ;skip through cards until results opening screen

    CheckPack()

    ;FindImageAndClick(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears

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
        } else {
			adbClick(146, 494) ;146, 494
		}
        failSafeTime := (A_TickCount - failSafe) // 1000
        CreateStatusMessage("Waiting for ConfirmPack`n(" . failSafeTime . "/45 seconds)")
        if(failSafeTime > 45)
            restartGameInstance("Stuck at ConfirmPack")
    }
}

getFriendCode() {
    global friendCode
    CreateStatusMessage("Getting friend code...",,,, false)
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
        CreateStatusMessage("Waiting for Home`n(" . failSafeTime . "/45 seconds)")
        if(failSafeTime > 45)
            restartGameInstance("Stuck at Home")
    }
    friendCode := AddFriends(false, true)

    return friendCode
}

createAccountList(instance) {


	saveDir := A_ScriptDir "\..\Accounts\Saved\" . instance
    outputTxt := saveDir . "\list.txt"
    outputTxt_current := saveDir . "\list_current.txt"

    if FileExist(outputTxt) {
		fileModifiedTimeDiff := A_Now
        FileGetTime, fileModifiedTime, %outputTxt%, M  ; Get last modified time
		EnvSub, fileModifiedTimeDiff, %fileModifiedTime%, Hours
        if (fileModifiedTimeDiff >= 1) {
			; file modified 1 hours ago or more
            FileDelete, %outputTxt%
            FileDelete, %outputTxt_current%
		}
    }
    if (!FileExist(outputTxt)) {
		if(FileExist(outputTxt_current))
            FileDelete, %outputTxt_current%

        Loop, %saveDir%\*.xml {
            xml := saveDir . "\" . A_LoopFileName
			fileModifiedTimeDiff := A_Now
            FileGetTime, fileModifiedTime, %xml%, M
			EnvSub, fileModifiedTimeDiff, %fileModifiedTime%, Hours
            if (fileModifiedTimeDiff >= 24) {  ; 24 hours
                FileAppend, % A_LoopFileName "`n", %outputTxt%  ; Append file path to list.txt\
                FileAppend, % A_LoopFileName "`n", %outputTxt_current%  ; Append file path to list_current.txt\
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
        CreateStatusMessage("Waiting for WonderPick`n(" . failSafeTime . "/45 seconds)")
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
        CreateStatusMessage("Waiting for Card`n(" . failSafeTime . "/45 seconds)")
    }
    failSafe := A_TickCount
    failSafeTime := 0
	;TODO thanks and wonder pick 5 times for missions
    Loop {
        adbClick(146, 494)
        if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime) || FindOrLoseImage(240, 80, 265, 100, , "WonderPick", 0, failSafeTime))
            break
        if(FindOrLoseImage(160, 330, 200, 370, , "Card", 0, failSafeTime)) {
            adbClick(183, 350) ; click card
        }
        delay(1)
        failSafeTime := (A_TickCount - failSafe) // 1000
        CreateStatusMessage("Waiting for Shop`n(" . failSafeTime . "/45 seconds)")
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
        CreateStatusMessage("Waiting for Shop`n(" . failSafeTime . "/45 seconds)")
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
            ;adbInputEvent("111") ;send ESC
			adbClick(139, 492)
        else
            break
        failSafeTime := (A_TickCount - failSafe) // 1000
        CreateStatusMessage("Waiting for WonderPick`n(" . failSafeTime . "/45 seconds)")
    }
    return true
}

FindPackStats() {
    global adbShell, scriptName, ocrLanguage, loadDir

	; Click for hamburger menu
    Loop {
        adbClick(240, 499)
        if(FindOrLoseImage(230, 120, 260, 150, , "UserProfile", 0)) {
            break
        }
        
		; Check for dialogue boxes
        clickButton := FindOrLoseImage(75, 340, 195, 530, 80, "Button", 0)
        if(clickButton) {
            StringSplit, pos, clickButton, `,
            if (scaleParam = 287) {
                pos2 += 5
            }
            adbClick(pos1, pos2)
        }
        
        LevelUp()
        Delay(1)
    }

	; Open up profile/stats page
    Loop {
        adbClick(210, 140)
        if(FindOrLoseImage(203, 272, 237, 300, , "Profile", 0)) {
            break
        }
        Delay(1)
    }

    ; Swipe up 3 times
    Loop, 3 {
        adbSwipe("266 770 266 355 300")
        Delay(1)
    }

	;OCR Card Count, Try 3 Times
  	Sleep, 1000
    fcScreenshot := Screenshot("PACKSTATS")
    
    debugInfo := ""
    packValue := 0
    maxRetries := 3
    currentTry := 1
    
    while (currentTry <= maxRetries) {
        try {
            if(IsFunc("ocr")) {
                ocrText := Func("ocr").Call(fcScreenshot, ocrLanguage)
                
                ; Look for numbers
                foundNumbers := []
                pos := 1
                while pos := RegExMatch(ocrText, "O)(\d+)", match, pos) {
                    foundNumbers.Push(match.1)
                    pos += match.len
                }
                
                ; If we found any numbers, calculate pack count
                if (foundNumbers.Length() > 0) {
                    ; Get the largest number found
                    maxNumber := 0
                    for i, num in foundNumbers {
                        if (num > maxNumber)
                            maxNumber := num
                    }
                    
                    ; Calculate pack count by dividing by 5 and rounding down
                    packValue := Floor(maxNumber / 5)
                    break ; Exit retry loop if we found a number
                }
            } else {
                break
            }
        } catch e {
            LogToFile("Failed OCR attempt " . currentTry . ": " . e.message, "BC.txt")
        }
        
        currentTry++
        if (currentTry <= maxRetries)
            Sleep, 1000 ; Wait a second before retrying
    }

    ; Update XML filename if we have a valid loadDir and either got a pack value or OCR failed/Overwrite old pack counts
	if (loadDir && FileExist(loadDir) && packValue) {
		; Get the base path and current filename
		SplitPath, loadDir, currentFileName, fileDir
		
		; Extract the timestamp part (assuming format: YYYYMMDDHHMMSS_instance)
		timestamp := RegExMatch(currentFileName, "^(\d+)_", timestampMatch) ? timestampMatch1 : ""
		instance := RegExMatch(currentFileName, "_(\d+)", instanceMatch) ? instanceMatch1 : ""
		
		if (timestamp && instance) {
			; Create new filename with pack count
			newFileName := timestamp . "_" . instance . "_" . packValue . "P.xml"
			newFilePath := fileDir . "\" . newFileName
			
			; Rename the file
			FileMove, %loadDir%, %newFilePath%
			
			; Update loadDir to point to new file location
			loadDir := newFilePath
		}
	}

    return packValue
}

getChangeDateTime() {
	offset := A_Now
	currenttimeutc := A_NowUTC
	EnvSub, offset, %currenttimeutc%, Hours   ;offset from local timezone to UTC

    resetTime := SubStr(A_Now, 1, 8) "060000" ;today at 6am [utc] zero seconds is the reset time at UTC
	resetTime += offset, Hours                ;reset time in local timezone

	;find the closest reset time
	currentTime := A_Now
	timeToReset := resetTime
	EnvSub, timeToReset, %currentTime%, Hours
	if(timeToReset > 12) {
		resetTime += -1, Days
	} else if (timeToReset < -12) {
		resetTime += 1, Days
	}

    return resetTime
}


/*
^e::
    msgbox ss
    pToken := Gdip_Startup()
    Screenshot()
return
*/

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Find Card Count and Relevant Functions
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


FindPackStats() {
    global adbShell, scriptName, ocrLanguage, loadDir

    ; Click for hamburger menu and wait for profile
    Loop {
        adbClick(240, 499)
        if(FindOrLoseImage(230, 120, 260, 150, , "UserProfile", 0)) {
            break
        } else {
            clickButton := FindOrLoseImage(75, 340, 195, 530, 80, "Button", 0)
            if(clickButton) {
                StringSplit, pos, clickButton, `,  ; Split at ", "
                if (scaleParam = 287) {
                    pos2 += 5
                }
                adbClick(pos1, pos2)
			}
		}
        Delay(1)
    }

    ; Open profile/stats page and wait
    Loop {
        adbClick(210, 140)
        if(FindOrLoseImage(203, 272, 237, 300, , "Profile", 0)) {
            break
        }
        Delay(1)
    }

    ; Swipe up 3 times to get to pack count
    Loop, 3 {
           adbSwipe("266 770 266 355 300")
        Delay(1)
    }

    ; Take screenshot and prepare for OCR
    Sleep, 1000
    fcScreenshot := Screenshot("PACKSTATS")
    
    debugInfo := ""
    packValue := 0
    maxRetries := 3
    currentTry := 1
    
    while (currentTry <= maxRetries) {
        try {
            if(IsFunc("ocr")) {
                ; Try different scale factors for better OCR accuracy
                scaleFactors := [200, 300, 400, 500]
                
                for index, scaleFactor in scaleFactors {
                    ; Use the entire screenshot for OCR
                    pBitmap := CropAndFormatForOcr(fcScreenshot.filepath, 0, 0, 277, 537, scaleFactor)
                    
                    ; Extract text using OCR with allowed characters
                    ocrText := GetTextFromBitmap(pBitmap, "0123456789")
                    
                    ; Clean up bitmap
                    Gdip_DisposeImage(pBitmap)
                    
                    ; Look for numbers that are likely to be card counts (greater than 15)
                    foundNumbers := []
                    pos := 1
                    while pos := RegExMatch(ocrText, "O)(\d{2,3})", match, pos) {
                        number := match.1
                        if (number >= 15)  ; Only consider numbers that could be realistic card counts
                            foundNumbers.Push(number)
                        pos += match.len
                    }

                    ; Find valid numbers
                    if (foundNumbers.Length() > 0) {
                        ; Get the largest number found
                        maxNumber := 0
                        for i, num in foundNumbers {
                            if (num > maxNumber)
                                maxNumber := num
                        }

                        ; Calculate pack count
                        packValue := Floor(maxNumber / 5)
                        if (packValue > 100) {
                            ; If pack count is too high, get a new screenshot and retry
                            if (fcScreenshot.deleteAfterUse && FileExist(fcScreenshot.filepath))
                                FileDelete, % fcScreenshot.filepath
                            Sleep, 1000  ; Wait a bit before new screenshot
                            fcScreenshot := Screenshot("PACKSTATS")
                            break  ; Break inner loop to try new screenshot with all scale factors
                        }
                        if (packValue > 0)  ; If we got a valid value under 100, break out
                            break 2
                    }
                }
            } else {
                break
            }
        } catch e {
            LogToFile("Failed OCR attempt " . currentTry . ": " . e.message, "BC.txt")
        }
        
        currentTry++
        if (currentTry <= maxRetries)
            Sleep, 1000
    }

    ; Update XML filename if needed
    if (loadDir && FileExist(loadDir) && packValue && packValue <= 100) {
        SplitPath, loadDir, currentFileName, fileDir
        
        ; Extract timestamp and instance
        timestamp := RegExMatch(currentFileName, "^(\d+)_", timestampMatch) ? timestampMatch1 : ""
        instance := RegExMatch(currentFileName, "_(\d+)", instanceMatch) ? instanceMatch1 : ""
        
        if (timestamp && instance) {
            ; Create new filename with pack count
            newFileName := timestamp . "_" . instance . "_" . packValue . "P.xml"
            newFilePath := fileDir . "\" . newFileName
            
            ; Rename the file
            FileMove, %loadDir%, %newFilePath%
            loadDir := newFilePath
        }
    }

	if (fcScreenshot.deleteAfterUse && FileExist(fcScreenshot.filepath))
		FileDelete, % fcScreenshot.filepath

    if(stopToggle) {
        ExitApp
    }
    return packValue
}

; Attempts to extract and validate text from a specified region of a screenshot using OCR.
ParseFriendInfoLoop(screenshotFile, x, y, w, h, allowedChars, validPattern, ByRef output) {
    success := False
    blowUp := [200, 500, 1000, 2000, 100, 250, 300, 350, 400, 450, 550, 600, 700, 800, 900]
    Loop, % blowUp.Length() {
        ; Get the formatted pBitmap
        pBitmap := CropAndFormatForOcr(screenshotFile, x, y, w, h, blowUp[A_Index])
        ; Run OCR
        output := GetTextFromBitmap(pBitmap, allowedChars)
        ; Validate result
        if (RegExMatch(output, validPattern)) {
            success := True
            break
        }
    }
    return success
}

; Crops an image, scales it up, converts it to grayscale, and enhances contrast to improve OCR accuracy.
CropAndFormatForOcr(inputFile, x := 0, y := 0, width := 200, height := 200, scaleUpPercent := 200) {
    ; Get bitmap from file
    pBitmapOrignal := Gdip_CreateBitmapFromFile(inputFile)
    ; Crop to region, Scale up the image, Convert to greyscale, Increase contrast
    pBitmapFormatted := Gdip_CropResizeGreyscaleContrast(pBitmapOrignal, x, y, width, height, scaleUpPercent, 25)
    ; Cleanup references
    Gdip_DisposeImage(pBitmapOrignal)
    return pBitmapFormatted
}

; Extracts text from a bitmap using OCR. Converts the bitmap to a format usable by Windows OCR, performs OCR, and optionally removes characters not in the allowed character list.
GetTextFromBitmap(pBitmap, charAllowList := "") {
    global ocrLanguage
    ocrText := ""
    ; OCR the bitmap directly
    hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
    pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap)
    ocrText := ocr(pIRandomAccessStream, ocrLanguage)
    ; Cleanup references
    DeleteObject(hBitmapFriendCode)
    ; Remove disallowed characters
    if (charAllowList != "") {
        allowedPattern := "[^" RegExEscape(charAllowList) "]"
        ocrText := RegExReplace(ocrText, allowedPattern)
    }

    return Trim(ocrText, " `t`r`n")
}

; Escapes special characters in a string for use in a regular expression. 
RegExEscape(str) {
    return RegExReplace(str, "([-[\]{}()*+?.,\^$|#\s])", "\$1")
}

; Retrieves the path to the temporary directory for the script. Creates it if it doesn't exist.
GetTempDirectory() {
    tempDir := A_ScriptDir . "\temp"
    if !FileExist(tempDir)
        FileCreateDir, %tempDir%
    return tempDir
}

