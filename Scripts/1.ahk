#Include %A_ScriptDir%\Include\Logger_Module.ahk
#Include %A_ScriptDir%\Include\Gdip_All.ahk
#Include %A_ScriptDir%\Include\Gdip_Imagesearch.ahk
#Include *i %A_ScriptDir%\Include\OCR.ahk
#Include %A_ScriptDir%\Include\Utils.ahk

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

global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, scriptName, GPTest, StatusText, defaultLanguage, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, deleteMethod, packs, FriendID, friendIDs, Instances, username, friendCode, stopToggle, friended, runMain, Mains, showStatus, injectMethod, packMethod, loadDir, loadedAccount, nukeAccount, CheckShiningPackOnly, TrainerCheck, FullArtCheck, RainbowCheck, ShinyCheck, dateChange, foundGP, friendsAdded, minStars, PseudoGodPack, Palkia, Dialga, Mew, Pikachu, Charizard, Mewtwo, packArray, CrownCheck, ImmersiveCheck, InvalidCheck, slowMotion, screenShot, accountFile, invalid, starCount, keepAccount, minStarsA1Charizard, minStarsA1Mewtwo, minStarsA1Pikachu, minStarsA1a, minStarsA2Dialga, minStarsA2Palkia, minStarsA2a, minStarsA2b
global DeadCheck, sendAccountXml, applyRoleFilters, MockGodPack, MockSinglePack, gpFoundTime
global statusLastMessage := {}
global statusLastUpdateTime := {}
global statusUpdateInterval := 2 ; Seconds between updates of the same message
global s4tEnabled, s4tSilent, s4t3Dmnd, s4t4Dmnd, s4t1Star, s4tGholdengo, s4tWP, s4tWPMinCards, s4tDiscordWebhookURL, s4tDiscordUserId, s4tSendAccountXml

scriptName := StrReplace(A_ScriptName, ".ahk")
winTitle := scriptName
foundGP := false
injectMethod := false
pauseToggle := false
showStatus := true
friended := false
dateChange := false
jsonFileName := A_ScriptDir . "\..\json\Packs.json"

; Trainer, Rainbow, Full Art, Shiny, Immersive, Crown, Double two star
; TODO: Be sure these are false before release!
MockGodPack := false ; DEBUG
MockSinglePack := false ; DEBUG - e.g., "Trainer"

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

IniRead, applyRoleFilters, %A_ScriptDir%\..\Settings.ini, UserSettings, applyRoleFilters, 0
IniRead, debugMode, %A_ScriptDir%\..\Settings.ini, UserSettings, debugMode, 0

InitLogger()

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

; connect adb
Sleep, % scriptName * 1000

if (InStr(defaultLanguage, "100")) {
    scaleParam := 287
} else {
    scaleParam := 277
}

; Attempt to connect to ADB
ConnectAdb(folderPath)

resetWindows()

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

; Define default swipe params.
adbSwipeX1 := Round(35 / 277 * 535)
adbSwipeX2 := Round(267 / 277 * 535)
adbSwipeY := Round((327 - 44) / 489 * 960)
global adbSwipeParams := adbSwipeX1 . " " . adbSwipeY . " " . adbSwipeX2 . " " . adbSwipeY . " " . swipeSpeed

if(DeadCheck = 1){
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
			LogInfo("I need a break... Sleeping until " . changeDate + randomTime . " to avoid being kicked out from the date change")
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
        keepAccount := false

        ; BallCity 2025.02.21 - Keep track of additional metrics
        now := A_NowUTC
        IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastStartTimeUTC
        EnvSub, now, 1970, seconds
        IniWrite, %now%, %A_ScriptDir%\%scriptName%.ini, Metrics, LastStartEpoch

        if(!injectMethod || !loadedAccount)
            DoTutorial()

        ;    SquallTCGP 2025.03.12 -     Adding the delete method 5 Pack (Fast) to the wonder pick check.
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

            ; SquallTCGP 2025.03.12 - Added a check to not add friends if the delete method is 5 Pack (Fast). When using this method (5 Pack (Fast)),
            ;                         it goes to the social menu and clicks the home button to exit (instead of opening all packs directly)
            ;                         just to get around the checking for a level after opening a pack. This change is made based on the
            ;                         5p-no delete community mod created by DietPepperPhD in the discord server.

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

        if (nukeAccount && !keepAccount && !injectMethod) {
            CreateStatusMessage("Deleting account...")
            menuDelete()
        } else if (friended) {
            CreateStatusMessage("Unfriending...")
            RemoveFriends()
        }

        if (injectMethod)
            loadedAccount := loadAccount()

        if (!loadedAccount)
            if (deleteMethod = "5 Pack" || packMethod)
                packs := 5

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
        LogInfo("Packs: " . packs . " | Total time: " . mminutes . "m " . sseconds . "s | Avg: " . minutes . "m " . seconds . "s | Runs: " . rerolls)

        if ((!injectMethod || !loadedAccount) && (!nukeAccount || keepAccount)) {
            ; Doing the following because:
            ; - not using the inject method
            ; - or using the inject method but an hasn't been loaded
            ; - and...
            ; - not using menu delete account
            ; - or the current account opened a desirable pack and shouldn't be deleted
            saveAccount("All")
			ResetLogThrottling()
            if (stopToggle) {
                CreateStatusMessage("Stopping...")
                LogInfo("Stopping after completing run")
                ExitApp
            }

            restartGameInstance("New Run", false)
            LogInfo("Restarting game instance...")
            Sleep, 1000
        } else if (nukeAccount && !keepAccount && !injectMethod) {
            ; Doing the following because:
            ; - using the inject method
            ; - or the account was deleted because no desirable packs were found during the last run
            AppendToJsonFile(packs)
            
            ; Check stopToggle before continuing
            if (stopToggle) {
                CreateStatusMessage("Stopping...")
                LogInfo("Stopping after completing run")
                ExitApp
            }
        } else {
            ; Reached here because:
            ; - using the inject method
            ; - or the account was deleted because no desirable packs were found during the last run
            AppendToJsonFile(packs)
			ResetLogThrottling()

            if (stopToggle) {
                CreateStatusMessage("Stopping...")
                LogInfo("Stopping after completing run")
                ExitApp
            }

            CreateStatusMessage("New Run")
			LogInfo("New Run")
        }
    }
}
return

RemoveFriends(filterByPreference := false) {
	LogInfo("RemoveFriends called with filterByPreference: " . filterByPreference)
	global friendIDs, stopToggle, friended, foundLabel, openPack, rawFriendIDs
	; Early exit if no friends to process
	if (filterByPreference && !friendIDs) {
		CreateStatusMessage("No friends to filter - friendIDs is empty")
		LogDebug("No friends to filter - friendIDs is empty")
		friended := false
		return
	}
	
	; If this is a GodPack, don't remove anyone - everyone wants GodPacks
    if (foundLabel = "God Pack") {
        CreateStatusMessage("Found God Pack")
        LogGP("Found God Pack")
        friended := false
        return
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
		LogDebug("In failsafe for Social. ")
	}
	FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
	FindImageAndClick(205, 430, 255, 475, , "Search", 240, 120, 1500)
	FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
	
    ; Use the global rawFriendIDs variable instead of reading the file again
    filteredIDs := []
    
    if (filterByPreference && foundLabel) {
        ; Loop through each friend ID
        for index, id in friendIDs {
            shouldKeep := false
            
            ; Find this ID in the raw friends data
            for _, line in rawFriendIDs {
                if (InStr(line, id)) {
                    ; Check if this ID has no pipe character (no preferences)
                    if (!InStr(line, "|")) {
                        shouldKeep := true
                        LogDebug("Keeping friend " . id . " (no preferences specified)")
                        break
                    }
                    
                    ; Extract the preferences part
                    parts := StrSplit(line, "|", " ")
                    if (parts.MaxIndex() >= 2) {
                        preferences := Trim(parts[2])
                        
                        ; If preferences is "No preferences", always keep the friend
                        if (InStr(preferences, "No preferences")) {
                            shouldKeep := true
                            LogDebug("Keeping friend " . id . " (no preferences specified)")
                            break
                        }
                        
                        ; Look for the current openPack in the preferences
                        boosters := StrSplit(preferences, ";", " ")
                        for _, boosterData in boosters {
                            boosterInfo := StrSplit(boosterData, ":", " ")
                            boosterName := Trim(boosterInfo[1])
                            
                            ; If this is the current booster
                            if (boosterName = openPack) {
                                ; Check if the found card type is in the preferences
                                boosterPrefs := Trim(boosterInfo[2])
                                prefList := StrSplit(boosterPrefs, ",", " ")
                                
                                for _, pref in prefList {
                                    if (Trim(pref) = foundLabel) {
                                        shouldKeep := true
                                        LogDebug("Keeping friend " . id . " (wants " . foundLabel . " in " . openPack . ")")
                                        break
                                    }
                                }
                                
                                ; No need to check other boosters
                                break
                            }
                        }
                    }
                    
                    ; Found the line for this ID, no need to check other lines
                    break
                }
            }
            
            ; If we shouldn't keep this friend, add to filtered list for removal
            if (!shouldKeep) {
                filteredIDs.Push(id)
                LogDebug("Will remove friend " . id . " (doesn't want " . foundLabel . " in " . openPack . ")")
            }
        }
    } else {
        ; If not filtering by preference, remove all friends
        filteredIDs := friendIDs
    }

	 ; Process filtered IDs for removal
	for index, value in filteredIDs {
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
			LogDebug("In failsafe for RemoveFriends-1. ")
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
			LogDebug("In failsafe for RemoveFriends-2. ")
		}
		
		if(index != filteredIDs.maxIndex()) {
			FindImageAndClick(205, 430, 255, 475, , "Search2", 150, 50, 1500)
			FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
			EraseInput(index, filteredIDs.MaxIndex())
		}
	}
	
	if(stopToggle) {
		IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
		ExitApp
	}
	LogInfo("Removed " . filteredIDs.MaxIndex() . " friends")
	friended := false
}

TradeTutorial() {
	if(FindOrLoseImage(100, 120, 175, 145, , "Trade", 0)) {
		LogDebug("Trade tutorial detected, handling...")
		FindImageAndClick(15, 455, 40, 475, , "Add2", 188, 449)
		Sleep, 1000
		FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
	}
	Delay(1)
}

AddFriends(renew := false, getFC := false) {
	global FriendID, friendIds, waitTime, friendCode, scriptName
	IniWrite, 1, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
	LogInfo("AddFriends called with renew: " . renew . ", getFC: " . getFC)
    ; Skip processing IDs if we're just getting the friend code
    if (!getFC) {
        ; Modify the reading of IDs to store in global variable
        rawFriendIDs := ReadFile("ids")
        friendIDs := [] ; Initialize an empty array to store friend IDs
        
        if (rawFriendIDs) {
            LogDebug("Found " . rawFriendIDs.MaxIndex() . " lines in ids.txt")
            CreateStatusMessage("Checking for IDs in ids.txt")
            LogDebug("Checking for IDs in ids.txt")

            for index, value in rawFriendIDs {
                ; Skip empty lines
                if (value = "") {
                    continue
                }
                
                LogDebug("Processing line: " . value)
                
                ; Extract the ID part (everything before | or the whole line if no |)
                if (InStr(value, "|")) {
                    parts := StrSplit(value, "|", " ")
                    id := Trim(parts[1])
                    
                    ; If the ID is not valid (not 16 digits), skip it
                    if (StrLen(id) != 16) {
                        LogWarning("ID " . id . " is invalid (wrong length)")
                        continue
                    }
                    
                    preferences := Trim(parts[2])
                    
                    ; Only filter by preferences if role filtering is enabled
                    if (applyRoleFilters) {
                        ; If preferences is "No preferences", always add the ID
                        if (InStr(preferences, "No preferences")) {
                            friendIDs.Push(id)
                            LogDebug("ADDING: " . id . " (no preferences specified)")
                            continue
                        }
                        
                        boosters := StrSplit(preferences, ";", " ")
                        
                        ; Check if the current openPack is in the boosters list
                        hasCurrentBooster := false
                        for _, boosterData in boosters {
                            if (InStr(boosterData, openPack . ":")) {
                                hasCurrentBooster := true
                                break
                            }
                        }
                        
                        if (hasCurrentBooster) {
                            friendIDs.Push(id)
                            LogDebug("ADDING: " . id . " wants the booster " . openPack)
                        } else {
                            LogDebug("SKIPPING: " . id . " doesn't want booster " . openPack)
                        }
                    } else {
                        ; If role filtering is disabled, add all IDs
                        friendIDs.Push(id)
                        LogDebug("ADDING: " . id . " (role filtering disabled)")
                    }
                } else {
                    id := RegExReplace(value, "[^a-zA-Z0-9]")
                    ; If there is no pipe character, check if it's a valid ID (length = 16)
                    if (StrLen(id) = 16) {
                        ; If no preferences are specified, add the ID (it accepts all boosters)
                        friendIDs.Push(id)
                        LogDebug("ADDING: " . id . " (no preferences specified)")
                    } else {
                        LogWarning("SKIPPING: " . id . " is invalid (wrong length)")
                    }
                }
            }
        }
        
        ; Handle single FriendID, rather than ids.txt file
        if (friendIDs.MaxIndex() = "" && FriendID != "") {
            friendIDs.Push(FriendID)
        }
        
        LogInfo("Final list contains " . friendIDs.MaxIndex() . " friends")
    }
	
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
				LogDebug("In failsafe for Social. ")
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
					LogDebug("In failsafe for AddFriends3. ")
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
					LogDebug("In failsafe for AddFriends4. ")
				}
				if(index != friendIDs.maxIndex()) {
					FindImageAndClick(205, 430, 255, 475, , "Search2", 150, 50, 1500)
					FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
					EraseInput(index, n)
				}
			}
			FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 500)
			FindImageAndClick(20, 500, 55, 530, , "Home", 40, 516, 500)
		}
		LogDebug("Waiting for friends to accept request. " . count . "/" . waitTime . " seconds.")
		sleep, 1000
		count++
	}
	LogInfo("Added " . n . " friends.")
	return n ;return added friends so we can dynamically update the .txt in the middle of a run without leaving friends at the end
}

ChooseTag() {
    FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 500)
    FindImageAndClick(20, 500, 55, 530, , "Home", 40, 516, 500)
    FindImageAndClick(209, 277, 225, 292, , "Profile", 143, 95, 500)
    FindImageAndClick(205, 310, 220, 319, , "ChosenTag", 143, 306, 1000)
    FindImageAndClick(209, 277, 225, 292, , "Profile", 143, 505, 1000)
    if (FindOrLoseImage(145, 140, 157, 155, , "Eevee", 1)) {
        FindImageAndClick(163, 200, 173, 207, , "ChooseEevee", 147, 207, 1000)
        FindImageAndClick(53, 218, 63, 228, , "Badge", 143, 466, 500)
    }
}

EraseInput(num := 0, total := 0) {
	if(num)
		LogDebug("Removing friend ID " . num . "/" . total)
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
	    adbClick(50, 500)
        Sleep, 5
	    adbClick(50, 500)
        Sleep, 5
            adbInputEvent("67")
		if(FindOrLoseImage(15, 500, 68, 520, , "Erase", 0, failSafeTime))
			break
	}
	failSafeTime := (A_TickCount - failSafe) // 1000
	LogDebug("In failsafe for Erase. ")
}

FindOrLoseImage(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", EL := 1, safeTime := 0) {
    global winTitle, failSafe, statusLastMessage, statusLastUpdateTime, statusUpdateInterval
	if(slowMotion) {
		if(imageName = "Platin" || imageName = "One" || imageName = "Two" || imageName = "Three")
			return true
	}
	if(searchVariation = "")
		searchVariation := 20
	imagePath := A_ScriptDir . "\" . defaultLanguage . "\"
	confirmed := false

	CreateStatusMessage(imageName)
	LogDebug("Looking for image: " . imageName)
	pBitmap := CachedWindowCapture()
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
		LogWarning("At home page during image search. Opening app...")
		restartGameInstance("At the home page during: " imageName)
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
			Sleep, 5000  ; Give more time for cache clearing to take effect
			CreateStatusMessage("Loaded deleted account. Deleting XML." )
			LogError("Loaded deleted account. Deleting XML.")
			if(loadedAccount) {
				FileDelete, %loadedAccount%
				IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
			}
			LogRestart("Restarted game, reason: No save data found")
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
		CreateStatusMessage("Instance has been stuck`n" . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		LogError("Instance has been stuck " . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		restartGameInstance("Instance has been stuck " . imageName)
		failSafe := A_TickCount
	}

	return confirmed
}

FindImageAndClick(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", clickx := 0, clicky := 0, sleepTime := "", skip := false, safeTime := 0) {
    global winTitle, failSafe, confirmed, slowMotion, statusLastMessage, statusLastUpdateTime, statusUpdateInterval

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
	CreateStatusMessage(imageName)
	LogDebug("Looking for image: " . imageName . " to click")

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

        ; Use cached window capture instead of creating new one each time
        pBitmap := CachedWindowCapture()
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
					LogDebug("Looking for " . imageName)
					messageTime := ElapsedTime
					firstTime := false
				}
			}
			if (ElapsedTime >= FSTime || safeTime >= FSTime) {
				CreateStatusMessage("Instance has been stuck for 90s. Killing it...")
				LogError("Instance has been stuck for 90s looking for " . imageName . ". Killing it...")
				restartGameInstance("Instance has been stuck at " . imageName) ; change to reset the instance and delete data then reload script
				StartSkipTime := A_TickCount
				failSafe := A_TickCount
			}
		}
		Path = %imagePath%Error1.png
		pNeedle := GetNeedle(Path)
		; ImageSearch within the region
		vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 155, 270, 420, searchVariation)
		if (vRet = 1) {
			CreateStatusMessage("Error message, Clicking retry..." )
			LogError("Error message, Clicking retry..." )
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
			LogWarning("At home page during image search. Opening app...")
			restartGameInstance("Found myself at the home page during: " imageName)
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
				Sleep, 5000  ; Give more time for cache clearing to take effect
				CreateStatusMessage("Loaded deleted account. Deleting XML." )
				LogError("Loaded deleted account. Deleting XML.")
				if(loadedAccount) {
					FileDelete, %loadedAccount%
					IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
				}
				LogRestart("Restarted game, reason: No save data found")
				Reload
			}
		}
        ; No need to dispose bitmap - it's now managed by the caching system
		if(imageName = "Points" || imageName = "Home") { ;look for level up ok "button"
			LevelUp()
		}
		if(imageName = "Social" || imageName = "Add") {
			TradeTutorial()
		}
		if(skip) {
			ElapsedTime := (A_TickCount - StartSkipTime) // 1000
			if(ElapsedTime - messageTime > 0.5 || firstTime) {
				LogDebug(imageName . " until skipping")
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
    ; Don't dispose the bitmap since it's managed by the caching system now
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

restartGameInstance(reason, RL := true){
    AppendToJsonFile(packs)

    if (debugMode)
        CreateStatusMessage("Restarting game reason:`n" . reason)
    else if (InStr(reason, "Stuck"))
        CreateStatusMessage("Stuck! Restarting game...")
    else
        CreateStatusMessage("Restarting game...")

    if (RL = "GodPack") {
        LogRestart("Restarted game for reason: " . reason)
        IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck

        Reload
    } else {
        adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
        waitadb()
        if (!RL && DeadCheck = 0) {
            adbShell.StdIn.WriteLine("rm /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml") ; delete account data
        }
        waitadb()
        adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
        waitadb()
        Sleep, 5000

        if (RL) {
            if (menuDeleteStart()) {
                IniWrite, 0, %A_ScriptDir%\%scriptName%.ini, UserSettings, DeadCheck
                logMessage := "\n" . username . "\n[" . (starCount ? starCount : "0") . "/5][" . (packs ? packs : 0) . "P][" . openPack . "] " . (invalid ? invalid . " God Pack" : "Some sort of pack") . " found, file name: " . accountFile . "\nGot stuck doing something"
                LogInfo(Trim(StrReplace(logMessage, "\n", " ")))
                ; Logging to Discord is temporarily disabled until all of the scenarios which could cause the script to end up here are fully understood.
                ;LogToDiscord(logMessage,, true)
            }
            LogRestart("Restarted game for reason: " . reason)

            Reload
        }
    }
}

menuDelete() {
	sleep, %Delay%
	failSafe := A_TickCount
	failSafeTime := 0
	
	; Flush any pending log messages before menu delete operations
	FlushLogMessages()
	
	LogInfo("Menu Delete...")
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
		LogDebug("In failsafe for Settings. ")
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
				LogDebug("In failsafe for clicking to delete. ")
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
		LogDebug("In failsafe for clicking to delete. ")
	}

    Sleep, 2500
}

menuDeleteStart() {
	LogInfo("Start...")
	global friended
	if(gpFound) {
		; Don't re-process God Pack information on restart
		if(A_TickCount - gpFoundTime < 120000) { ; Check if it's been less than 2 minutes
			return false ; Return false to prevent reprocessing
		}
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
					LogDebug("In failsafe for clicking to delete. ")
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
			LogDebug("In failsafe for clicking to delete. ")
		}
		CreateStatusMessage("Looking for Country/Menu")
		LogInfo("Looking for Country/Menu")
		Delay(3)
		failSafeTime := (A_TickCount - failSafe) // 1000
		LogDebug("In failsafe for Country/Menu. ")
	}
	if(loadedAccount) {
		FileDelete, %loadedAccount%
	}
}

CheckPack() {
	LogDebug("Checking pack...")
    ; Wait for cards to render before checking.
    Loop {
        if (FindBorders("lag") = 0)
            break
        Delay(1)
    }

    ; Update pack count.

    ; SquallTCGP 2025.03.12 - Just checking the packs count and setting them to 0 if it's number of packs is 3.
    ;                         This applies to any Delete Method except 5 Pack (Fast). This change is made based
    ;                         on the 5p-no delete community mod created by DietPepperPhD in the discord server.
    if (deleteMethod != "5 Pack (Fast)") {
        if (packs = 3)
            packs := 0
    }

    packs += 1
    if (packMethod)
        packs := 1

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
				LogRestart("Restarted game, reason: " . foundLabel . " found")
			} else {
				; If no invalid cards were found, check if the pack is a god pack.
				foundInvalidGP := FindGodPack(true)
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
		LogRestart("Restarted game, reason: God Pack found")
        return
    }
    if (!CheckShiningPackOnly || openPack = "Shining") {
        ; Check for 2-star cards.
        foundTrainer := (MockSinglePack == "Trainer")
        foundRainbow := (MockSinglePack == "Rainbow")
        foundFullArt := (MockSinglePack == "Full Art")
        2starCount := (MockSinglePack == "Double two star") ? 2 : 0

        if (MockSinglePack)
            foundLabel := MockSinglePack

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
            LogRestart("Restarted game, reason: " . foundLabel . " found")
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
        CreateStatusMessage("Tradeable cards found! Continuing...")
		LogDebug("Tradeable cards found! Continuing...")

        logMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ") File name: " . accountFile . " Screenshot file: " . screenShotFileName . " Backing up to the Accounts\\Trades folder and continuing..."
        LogTrade( . packs . " packs, " . openPack . ") File name: " . accountFile . " Screenshot file: " . screenShotFileName . " Backing up to the Accounts\\Trades folder and continuing...")

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
        LogError("Failed to OCR the friend code: " . e.message)
    }

    statusMessage := "Tradeable cards found"
    if (username)
        statusMessage .= " by " . username
    if (friendCode)
        statusMessage .= " (" . friendCode . ")"

    logMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ")\nFile name: " . accountFile . "\nScreenshot file: " . screenShotFileName . "\nBacking up to the Accounts\\Trades folder and continuing..."
    LogTrade( . packs . " packs, " . openPack . ")\nFile name: " . accountFile . "\nScreenshot file: " . screenShotFileName . "\nBacking up to the Accounts\\Trades folder and continuing...")

    if (s4tDiscordWebhookURL) {
        discordMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ")\nFound: " . packDetailsMessage . "\nFile name: " . accountFile . "\nBacking up to the Accounts\\Trades folder and continuing..."
        LogToDiscord(discordMessage, screenShot, true, (s4tSendAccountXml ? accountFullPath : ""), fcScreenshot, s4tDiscordWebhookURL, s4tDiscordUserId)
    }

    restartGameInstance("Tradeable cards found. Continuing...", "GodPack")
	LogRestart("Restarted game, reason: Tradeable cards found")
	return
}

FoundStars(star) {
	LogInfo("Found " . star)
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
			LogError("Failed to OCR the friend code: " . e.message)
		}
	}

    CreateStatusMessage(star . " found!")
    LogInfo(star . " found!")

    statusMessage := star . " found"
    if (username)
        statusMessage .= " by " . username
    if (friendCode)
        statusMessage .= " (" . friendCode . ")"

    logMessage := statusMessage . " in instance: " . scriptName . " (" . packs . " packs, " . openPack . ")\nFile name: " . accountFile . "\nBacking up to the Accounts\\SpecificCards folder and continuing..."
    LogToDiscord(logMessage, screenShot, true, (sendAccountXml ? accountFullPath : ""), fcScreenshot)
    LogGP(star . " found :(" . packs . " packs, " . openPack . ") File name: " . accountFile)
	
	if(star != "Crown" && star != "Immersive" && star != "Shiny") {
		ChooseTag()
		; Use the filtered removal function
		if (applyRoleFilters)
			RemoveFriends(true)
	}
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
    ; Get a single window capture for all searches
    pBitmap := CachedWindowCapture()
    
    ; Prepare all needles at once to avoid repeated file checks
    needles := []
    for index, coords in borderCoords {
        Path := A_ScriptDir . "\" . defaultLanguage . "\" . prefix . index . ".png"
        if (FileExist(Path)) {
            needles[index] := GetNeedle(Path)
        }
    }
    
    ; Perform all searches on the same bitmap
    for index, coords in borderCoords {
        if (needles[index]) {
            vRet := Gdip_ImageSearch(pBitmap, needles[index], vPosXY, coords[1], coords[2], coords[3], coords[4], searchVariation)
            if (vRet = 1) {
                count += 1
            }
        }
    }
    
    ; Don't dispose the bitmap as it's now cached
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
    ; Get a single window capture for all searches
    pBitmap := CachedWindowCapture()
    
    ; Prepare all needles at once
    needles := []
    for index, coords in borderCoords {
        Path := A_ScriptDir . "\" . defaultLanguage . "\" . prefix . index . ".png"
        if (FileExist(Path)) {
            needles[index] := GetNeedle(Path)
        }
    }
    
    ; Perform all searches on the same bitmap
    for index, coords in borderCoords {
        if (needles[index]) {
            vRet := Gdip_ImageSearch(pBitmap, needles[index], vPosXY, coords[1], coords[2], coords[3], coords[4], searchVariation)
            if (vRet = 1) {
                count += 1
            }
        }
    }
    
    ; Don't dispose the bitmap as it's now cached
    return count
}

FindGodPack(invalidPack := false) {
	LogInfo("Finding God Pack")
    ; Check for normal borders.
    normalBorders := MockGodPack ? 0 : FindBorders("normal")
    if (normalBorders) {
        CreateStatusMessage("Not a God Pack...")
		LogInfo("Not a God Pack...")
        ; Clear bitmap cache after checks
        ClearBitmapCache()
        return false
    }

    ; A god pack (although possibly invalid) has been found.
    keepAccount := true

    ; Count stars if required.
    packMinStars := minStars
    if (openPack = "Shining") {
        packMinStars := minStarsA2b
    } else if (openPack = "Arceus") {
        packMinStars := minStarsA2a
    } else if (openPack = "Palkia") {
        packMinStars := minStarsA2Palkia
    } else if (openPack = "Dialga") {
        packMinStars := minStarsA2Dialga
    } else if (openPack = "Mew") {
        packMinStars := minStarsA1a
    } else if (openPack = "Pikachu") {
        packMinStars := minStarsA1Pikachu
    } else if (openPack = "Charizard") {
        packMinStars := minStarsA1Charizard
    } else if (openPack = "Mewtwo") {
        packMinStars := minStarsA1Mewtwo
    }

    if (!invalidPack && packMinStars > 0) {
        starCount := MockGodPack ? 5 : (5 - FindBorders("1star"))
        if (starCount < packMinStars) {
            CreateStatusMessage("Pack doesn't contain enough 2 stars...")
			LogInfo("Pack doesn't contain enough 2 stars...")
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
    ; Clear bitmap cache after processing
    ClearBitmapCache()
    return keepAccount
}

GodPackFound(validity) {
	; Flush any pending log messages before reporting a God Pack
	FlushLogMessages()
	LogInfo("God Pack found ")
	global scriptName, DeadCheck, ocrLanguage, injectMethod, openPack, gpFoundTime
	; Set the timestamp of when we found the God Pack
	gpFoundTime := A_TickCount

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
    accountFullPath := ""
    accountFile := saveAccount(validity, accountFullPath)
    friendCode := getFriendCode()

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
		LogError("Failed to OCR the friend code: " . e.message)
	}

	logMessage := Interjection . "\n" . username . " (" . friendCode . ")\n[" . starCount . "/5][" . packs . "P][" . openPack . " Booster] " . invalid . " God pack found in instance: " . scriptName . "\nFile name: " . accountFile . "\nBacking up to the Accounts\\GodPacks folder and continuing..."
	LogGP(username . "[" . starCount . "/5][" . packs . "P] " . invalid . " God pack found, File name: " . accountFile . "Backing up to the Accounts\\GodPacks folder and continuing...")
	;Run, http://google.com, , Hide ;Remove the ; at the start of the line and replace your url if you want to trigger a link when finding a god pack.

    ; Adjust the below to only send a 'ping' to Discord friends on Valid packs
    if (validity = "Valid") {
        LogToDiscord(logMessage, screenShot, true, (sendAccountXml ? accountFullPath : ""), fcScreenshot)
        LogDiscord("Sended a message to Discord")
        ChooseTag()
    } else if (!InvalidCheck) {
        LogToDiscord(logMessage, screenShot, true, (sendAccountXml ? accountFullPath : ""), fcScreenshot)
        LogDiscord("Sended a message to Discord")
    }
}

loadAccount() {
	global adbShell, adbPath, adbPort, loadDir
	CreateStatusMessage("Loading account...")
	LogInfo("Loading account...")
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
				LogInfo("Making sure XML is > 24 hours old: " . cycle . " attempts.")	
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

saveAccount(file := "Valid", ByRef filePath := "", packDetails := "") {
	LogInfo("Saving account...")
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
		CreateStatusMessage("Attempting to save account XML. " . count . "/10")
		LogDebug("Attempting to save account XML. " . count . "/10")	

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
            CreateStatusMessage("Account not saved. Pausing...")
			LogWarning("Account not saved. Pausing...")
            LogToDiscord("Attempted to save account in " . scriptName . " but was unsuccessful. Pausing. You will need to manually extract.", Screenshot(), true)
            LogDiscord("Attempted to save account but was unsuccessful. Pausing. You will need to manually extract.")
            Pause, On
        }
        count++
    }

    return xmlFile
}

Screenshot(fileType := "Valid", subDir := "", ByRef fileName := "") {
    global packs
    SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

    ; Define folder and file paths
    fileDir := A_ScriptDir "\..\Screenshots"
    if (subDir) {
        fileDir .= "\" . subDir
    }
    if !FileExist(fileDir)
        FileCreateDir, fileDir

    ; File path for saving the screenshot locally
    fileName := A_Now . "_" . winTitle . "_" . fileType . "_" . packs . "_packs.png"
    filePath := fileDir "\" . fileName

    pBitmapW := from_window(WinExist(winTitle))
    pBitmap := Gdip_CloneBitmapArea(pBitmapW, 18, 175, 240, 227)
    ;scale 100%
    if (scaleParam = 287) {
    pBitmap := Gdip_CloneBitmapArea(pBitmapW, 17, 168, 245, 230)
    }
    Gdip_DisposeImage(pBitmapW)
    Gdip_SaveBitmapToFile(pBitmap, filePath)
    Gdip_DisposeImage(pBitmap)

    return filePath
}

; Pause Script
PauseScript:
	CreateStatusMessage("Pausing...")
	LogInfo("Pausing...")
	Pause, On
return

; Resume Script
ResumeScript:
	CreateStatusMessage("Resuming...")
	LogInfo("Resuming...")
	StartSkipTime := A_TickCount ;reset stuck timers
	failSafe := A_TickCount
	Pause, Off
return

; Stop Script
StopScript:
    ToggleStop()
    CreateStatusMessage("Stopping script...")
    LogInfo("Stopping script...")
return

ShowStatusMessages:
    ToggleStatusMessages()
return

ReloadScript:
    Reload
return

ToggleStop() {
    global stopToggle, friended
    stopToggle := true
    if (!friended)
        ExitApp
    else {
        CreateStatusMessage("Stopping script at the end of the run...")
        LogInfo("Stopping script at the end of the run...")
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
~+F5::Reload
~+F6::Pause
~+F7::ToggleStop()
~+F8::ToggleStatusMessages()
;~F9::restartGameInstance("F9")

DoTutorial() {
	LogInfo("Starting tutorial...")
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
		LogDebug("In failsafe for Month. ")
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
		LogDebug("In failsafe for Year. ")
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
			LogDebug("In failsafe for country select. ")
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
		LogDebug("In failsafe for Save. ")
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
			LogDebug("Looking for Link/Welcome")
			Delay(1)
			failSafeTime := (A_TickCount - failSafe) // 1000
			LogDebug("In failsafe for Link/Welcome. ")
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
		LogDebug("In failsafe for Trace. ")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at name")
			LogRestart("Stuck at name")
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
        LogDebug("In failsafe for Trace. ")
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
		LogDebug("In failsafe for Swipe up. ")	
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
        LogDebug("In failsafe for Pack. ")
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
		LogDebug("In failsafe for End. ")
	}

    FindImageAndClick(120, 316, 143, 335, , "Main", 192, 449) ;click until at main menu

	return true
	LogInfo("Tutorial completed.")
}

SelectPack(HG := false) {
    global openPack, packArray
	LogInfo("Opening pack...")
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
            adbSwipe("266 770 266 355 160")
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
			LogDebug("In failsafe for HourglassPack3. ")
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
			LogDebug("In failsafe for HourglassPack4. ")
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
			LogDebug("In failsafe for Skip2. ")
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
		LogDebug("In failsafe for Pack. ")
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
		LogDebug("In failsafe for Trace. ")
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
		LogDebug("In failsafe for Home. ")
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
			LogDebug("In failsafe for HourglassPack. ")
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
			LogDebug("In failsafe for HourglassPack2. ")
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
		LogDebug("In failsafe for Pack. ")
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
		LogDebug("In failsafe for Trace. ")
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
		LogDebug("In failsafe for ConfirmPack. ")
		if(failSafeTime > 45)
			restartGameInstance("Stuck at ConfirmPack")
	}
}

getFriendCode() {
	global friendCode
	CreateStatusMessage("Getting friend code")
	LogInfo("Getting friend code")
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
		LogDebug("In failsafe for Home. ")
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
	LogInfo("WonderPick")
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
		LogDebug("In failsafe for WonderPick. ")
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
		LogDebug("In failsafe for Card. ")
	}
	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbClick(146, 494)
		if(FindOrLoseImage(233, 486, 272, 519, , "Skip", 0, failSafeTime) || FindOrLoseImage(240, 80, 265, 100, , "WonderPick", 0, failSafeTime))
			break
		if(FindOrLoseImage(160, 330, 200, 370, , "Card", 0, failSafeTime)) {
			adbClick(183, 350) ; click card
		}
		delay(1)
		failSafeTime := (A_TickCount - failSafe) // 1000
		LogDebug("In failsafe for Shop. ")
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
		LogDebug("In failsafe for Shop. ")
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
        LogDebug("In failsafe for WonderPick. ")
	}
	return true
	LogInfo("WonderPick completed.")
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
