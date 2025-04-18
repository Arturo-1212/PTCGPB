#Include %A_ScriptDir%\Include\Logger_Module.ahk
#Include %A_ScriptDir%\Include\Gdip_All.ahk
#Include %A_ScriptDir%\Include\Gdip_Imagesearch.ahk
#Include %A_ScriptDir%\Include\Utils.ahk
#Include *i %A_ScriptDir%\Include\Gdip_Extra.ahk
#Include *i %A_ScriptDir%\Include\StringCompare.ahk
#Include *i %A_ScriptDir%\Include\OCR.ahk

#SingleInstance on
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetBatchLines, -1
SetTitleMatchMode, 3
CoordMode, Pixel, Screen

; Allocate and hide the console window to reduce flashing
DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, scriptName, GPTest, StatusText, defaultLanguage, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, skipInvalidGP, deleteXML, packs, FriendID, AddFriend, Instances, showStatus
global triggerTestNeeded, testStartTime, firstRun, minStars, minStarsA2b, vipIdsURL, tesseractPath
global statusLastMessage := {}
global statusLastUpdateTime := {}
global statusUpdateInterval := 2 ; Seconds between updates of the same message

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
IniRead, discordWebhookURL, %A_ScriptDir%\..\Settings.ini, UserSettings, discordWebhookURL, ""
IniRead, discordUserId, %A_ScriptDir%\..\Settings.ini, UserSettings, discordUserId, ""
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
IniRead, tesseractPath, %A_ScriptDir%\..\Settings.ini, UserSettings, tesseractPath, C:\Program Files\Tesseract-OCR\tesseract.exe
IniRead, debugMode, %A_ScriptDir%\..\Settings.ini, UserSettings, debugMode, 0

InitLogger()


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

rerollTime := A_TickCount

initializeAdbShell()
CreateStatusMessage("Initializing bot...")
restartGameInstance("Initializing bot...", false)
pToken := Gdip_Startup()

if(heartBeat)
    IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
FindImageAndClick(120, 500, 155, 530, , "Social", 143, 518, 1000, 150)
LogInfo("Waiting for the game to load...")
if (!debugMode)
	firstRun := True

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
			IniWrite, 0, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
		Continue
	}
	LogInfo("Adding Friends...")
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
				LogDebug("Failsafe " . failSafeTime "/180 seconds")
			}
		}
		if(done || fullList|| GPTest)
			break
	}
}
return

FindOrLoseImage(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", EL := 1, safeTime := 0) {
	global winTitle, Variation, failSafe, statusLastMessage, statusLastUpdateTime, statusUpdateInterval
	if(searchVariation = "")
		searchVariation := Variation
	imagePath := A_ScriptDir . "\" . defaultLanguage . "\"
	confirmed := false

	CreateStatusMessage(imageName)
	LogDebug("Looking for image: " . imageName)
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
		LogWarning("At home page during image search. Opening app...")
		restartGameInstance("At the home page during: " imageName)
	}
	if(imageName = "Country" || imageName = "Social")
		FSTime := 90
	else if(imageName = "Button")
		FSTime := 240
	else
		FSTime := 180
	if (safeTime >= FSTime) {
		CreateStatusMessage("Instance has been stuck `n" . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		LogError("Instance has been stuck " . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		restartGameInstance("Instance has been stuck " . imageName)
		failSafe := A_TickCount
	}
	return confirmed
}

FindImageAndClick(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", clickx := 0, clicky := 0, sleepTime := "", skip := false, safeTime := 0) {
	global winTitle, Variation, failSafe, confirmed, statusLastMessage, statusLastUpdateTime, statusUpdateInterval
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
					CreateStatusMessage("Instance has been stuck for 90s. Killing it...")
					LogError("Instance has been stuck for 90s looking for " . imageName . ". Killing it...")
					restartGameInstance("Instance has been stuck at " . imageName) ; change to reset the instance and delete data then reload script
					StartSkipTime := A_TickCount
					failSafe := A_TickCount
				}
			} else {
				ElapsedTime := (A_TickCount - StartSkipTime) // 1000
				if(ElapsedTime - messageTime > 0.5 || firstTime) {
					LogDebug("Looking for " . imageName . " for " . ElapsedTime . "/" . FSTime . " seconds")
					messageTime := ElapsedTime
					firstTime := false
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
			CreateStatusMessage("Error message, Clicking retry..." )
			LogError("Error message, Clicking retry..." )
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
			LogWarning("At home page during image search. Opening app...")
			restartGameInstance("Found myself at the home page during: " imageName)
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

restartGameInstance(reason, RL := true) {
    global debugMode, Delay, scriptName, adbShell, adbPath, adbPort

	if (debugMode)
		return

	initializeAdbShell()
	CreateStatusMessage("Restarting game reason: `n" reason)
	LogRestart("Restarting game reason: " . reason)

    adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
    ;adbShell.StdIn.WriteLine("rm -rf /data/data/jp.pokemon.pokemontcgp/cache/*") ; clear cache
    Sleep, 3000
    adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")

	Sleep, 3000
	if(RL) {
		LogRestart("Restarted game, reason: " . reason)
		LogToDiscord("Main restarted, reason: " . reason, , true)
		Reload
	}
}


RandomUsername() {
    FileRead, content, %A_ScriptDir%\..\usernames.txt

    values := StrSplit(content, "`r`n") ; Use `n if the file uses Unix line endings

    ; Get a random index from the array
    Random, randomIndex, 1, values.MaxIndex()

    ; Return the random value
    return values[randomIndex]
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
	Pause, Off
	StartSkipTime := A_TickCount ;reset stuck timers
	failSafe := A_TickCount
return

; Stop Script
StopScript:
	CreateStatusMessage("Stopping script...")
	LogInfo("Stopping script...")
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
    global GPTest, triggerTestNeeded, testStartTime, firstRun, heartBeat
    if(!GPTest) {
        GPTest := true
        triggerTestNeeded := true
        testStartTime := A_TickCount
        
        ; Only update HeartBeat.ini if heartBeat is enabled
        if (heartBeat) {
            IniWrite, 0, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
            IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, TestMode, Main
            LogInfo("Setting HeartBeat status to offline and enabling TestMode notification")
        }
        
        CreateStatusMessage("In GP Test Mode")
        LogInfo("In GP Test Mode")
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
        
        ; Only update HeartBeat.ini if heartBeat is enabled
        if (heartBeat) {
            IniWrite, 1, %A_ScriptDir%\..\HeartBeat.ini, HeartBeat, Main
            IniWrite, 2, %A_ScriptDir%\..\HeartBeat.ini, TestMode, Main
            LogInfo("Setting HeartBeat status to online and enabling TestMode exit notification")
        }
        
        CreateStatusMessage("Exiting GP Test Mode")
        LogInfo("Exiting GP Test Mode")
    }
}

FriendAdded() {
    global AddFriend
    AddFriend++
}

~+F5::Reload
~+F6::Pause
~+F7::ExitApp
~+F8::ToggleStatusMessages()
~+F9::ToggleTestScript() ; hoytdj Add

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
	LogInfo("Starting GP Test Script")
	RemoveNonVipFriends()
}

; Automation script for removing Non-VIP firends.
RemoveNonVipFriends() {
	global GPTest, vipIdsURL, failSafe
	failSafe := A_TickCount
	failSafeTime := 0
	LogInfo("RemoveNonVipFriends called")
	
	; Get us to the Social screen. Won't be super resilient but should be more consistent for most cases.
	Loop {
		adbClick(143, 518)
		if(FindOrLoseImage(120, 500, 155, 530, , "Social", 0, failSafeTime))
			break
		Delay(5)
		failSafeTime := (A_TickCount - failSafe) // 1000
		LogDebug("In failsafe for Social. " . failSafeTime "/90 seconds")
	}
	FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
	Delay(3)

	CreateStatusMessage("Downloading vip_ids.txt.")
	LogInfo("Downloading vip_ids.txt.")
	if (vipIdsURL != "" && !DownloadFile(vipIdsURL, "vip_ids.txt", true)) {
		CreateStatusMessage("Failed to download vip_ids.txt. Aborting test...")
		LogError("Failed to download vip_ids.txt.")
		return
	}

	includesIdsAndNames := false
	vipFriendsArray :=  GetFriendAccountsFromFile(A_ScriptDir . "\..\vip_ids.txt", includesIdsAndNames)
	if (!vipFriendsArray.MaxIndex()) {
		CreateStatusMessage("No accounts found in vip_ids.txt. Aborting test...")
		LogError("No accounts found in vip_ids.txt.")
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
                CreateStatusMessage("End of list - parsed the same friend codes multiple times.")
				LogInfo("End of list - parsed the same friend codes multiple times.")
                Delay(5)
                CreateStatusMessage("Ready to test.")
				LogToDiscord("GP test ended, ready to test.", ,true)
				adbClick(143, 507)
				Delay(30)
				CreateStatusMessage("")
                return 
            }
            
            matchedFriend := ""
            isVipResult := IsFriendAccountInList(friendAccount, vipFriendsArray, matchedFriend)
            if (isVipResult || !parseFriendResult) {
                ; If we couldn't parse the friend, skip removal
                if (!parseFriendResult) {
                    CreateStatusMessage("Couldn't parse friend. Skipping friend...`nParsed friend: " . friendAccount.ToString())
                    LogInfo("Friend skipped: " . friendAccount.ToString() . ". Couldn't parse identifiers.")
                }
                ; If it's a VIP friend, skip removal
                if (isVipResult)
                    CreateStatusMessage("Parsed friend: " . friendAccount.ToString() . "`nMatched VIP: " . matchedFriend.ToString() . "`nSkipping VIP...")
					LogInfo("Friend skipped: " . friendAccount.ToString() . ". Matched VIP: " . matchedFriend.ToString() . ".")
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
                CreateStatusMessage("Parsed friend: " . friendAccount.ToString() . "`nNo VIP match found.`nRemoving friend...")
                LogInfo("Friend removed: " . friendAccount.ToString() . ". No VIP match found.")
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
				LogInfo("Stuck between friends. Tiny scroll and continue.")
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
	global ocrLanguage, winTitle, tesseractPath
	ocrText := ""

	if FileExist(tesseractPath) {
		; ~~~~~~~~~~~~~~~~~~~~~~~~~
		; ~~~ Use Tesseract OCR ~~~
		; ~~~~~~~~~~~~~~~~~~~~~~~~~
		; Save to file
		filepath := GetTempDirectory() . "\" . winTitle . "_" . filename . ".png"
		saveResult := Gdip_SaveBitmapToFile(pBitmap, filepath, 100)
		if (saveResult != 0) {
			CreateStatusMessage("Failed to save " . filepath . " screenshot.`nError code: " . saveResult)
			return False
		}
		; OCR the file directly
		command := """" . tesseractPath . """ """ . filepath . """ -"
		if (charAllowList != "") {
			command := command . " -c tessedit_char_whitelist=" . charAllowList
		}
		command := command . " --oem 3 --psm 7"
		ocrText := CmdRet(command)
	}
	else {
		; ~~~~~~~~~~~~~~~~~~~~~~~
		; ~~~ Use Windows OCR ~~~
		; ~~~~~~~~~~~~~~~~~~~~~~~
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
