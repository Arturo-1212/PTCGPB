version = Arturos PTCGP Bot
#SingleInstance, force
CoordMode, Mouse, Screen
SetTitleMatchMode, 3

if not A_IsAdmin
{
    ; Relaunch script with admin rights
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

;KillADBProcesses()

global Instances, jsonFileName, PacksText, runMain

totalFile := A_ScriptDir . "\json\total.json"
backupFile := A_ScriptDir . "\json\total-backup.json"
if FileExist(totalFile) ; Check if the file exists
{
	FileCopy, %totalFile%, %backupFile%, 1 ; Copy source file to target
	if (ErrorLevel)
		MsgBox, Failed to create %backupFile%. Ensure permissions and paths are correct.
}
FileDelete, %totalFile%
packsFile := A_ScriptDir . "\json\Packs.json"
backupFile := A_ScriptDir . "\json\Packs-backup.json"
if FileExist(packsFile) ; Check if the file exists
{
	FileCopy, %packsFile%, %backupFile%, 1 ; Copy source file to target
	if (ErrorLevel)
		MsgBox, Failed to create %backupFile%. Ensure permissions and paths are correct.
}
InitializeJsonFile() ; Create or open the JSON file
global FriendID
; Create the main GUI for selecting number of instances
	IniRead, FriendID, settings2.ini, UserSettings, FriendID
	IniRead, waitTime, settings2.ini, UserSettings, waitTime, 5
	IniRead, Delay, settings2.ini, UserSettings, Delay, 250
	IniRead, folderPath, settings2.ini, UserSettings, folderPath, C:\Program Files\Netease
	IniRead, discordWebhookURL, settings2.ini, UserSettings, discordWebhookURL, ""
	IniRead, discordUserId, settings2.ini, UserSettings, discordUserId, ""
	IniRead, changeDate, settings2.ini, UserSettings, ChangeDate, 0100
	IniRead, Columns, settings2.ini, UserSettings, Columns, 5
	IniRead, openPack, settings2.ini, UserSettings, openPack, Palkia
	IniRead, godPack, settings2.ini, UserSettings, godPack, Continue
	IniRead, Instances, settings2.ini, UserSettings, Instances, 1
	;IniRead, setSpeed, settings2.ini, UserSettings, setSpeed, 1x/3x
	IniRead, defaultLanguage, settings2.ini, UserSettings, defaultLanguage, Scale125
	IniRead, SelectedMonitorIndex, settings2.ini, UserSettings, SelectedMonitorIndex, 1
	IniRead, swipeSpeed, settings2.ini, UserSettings, swipeSpeed, 600
	IniRead, skipInvalidGP, settings2.ini, UserSettings, skipInvalidGP, Yes
	IniRead, deleteMethod, settings2.ini, UserSettings, deleteMethod, 3 Pack
	IniRead, runMain, settings2.ini, UserSettings, runMain, 1
	IniRead, heartBeat, settings2.ini, UserSettings, heartBeat, 0
	IniRead, heartBeatWebhookURL, settings2.ini, UserSettings, heartBeatWebhookURL, ""
	IniRead, heartBeatName, settings2.ini, UserSettings, heartBeatName, ""
	IniRead, nukeAccount, settings2.ini, UserSettings, nukeAccount, 0
	IniRead, TrainerCheck, settings2.ini, UserSettings, TrainerCheck, No
	IniRead, FullArtCheck, settings2.ini, UserSettings, FullArtCheck, No
	IniRead, RainbowCheck, settings2.ini, UserSettings, RainbowCheck, No

; Main GUI setup
; Add the link text at the bottom of the GUI

Gui, Show, w500 h640, Arturo's PTCGPB Bot Setup ;' Ensure the GUI size is appropriate

Gui, Color, White  ; Set the background color to white
Gui, Font, s10 Bold , Segoe UI 
; Add the button image on top of the GUI
;Gui, Add, Picture, gStart x196 y196 w108 h108 vImageButton  +BackgroundTrans, %normalImage%
Gui, Add, Button, gArrangeWindows x215 y208 w70 h32, Arrange Windows
Gui, Add, Text, x227 y258 w46 h32 BackgroundGreen
Gui, Add, Button, gStart x227 y258 w46 h32 vArrangeWindows, Start

Gui, Add, Text, x0 y604 w640 h30 gOpenLink cBlue Center +BackgroundTrans
Gui, Add, Text, x265 y558 w167 h50 gOpenDiscord cBlue Center +BackgroundTrans
Gui, Font, s15 Bold , Segoe UI
; Add the background image to the GUI
Gui, Add, Picture, x0 y0 w500 h640, %A_ScriptDir%\Scripts\GUI\GUI.png

; Add input controls
if(FriendID = "ERROR")
	FriendID = 

if(FriendID = )
	Gui, Add, Edit, vFriendID x80 y95 w145 h30 Center
else
	Gui, Add, Edit, vFriendID x80 y95 w145 h30 Center, %FriendID%
	
if(runMain)
	Gui, Add, CheckBox, Checked vrunMain x2 y95 Center, Main2
else
	Gui, Add, CheckBox, vrunMain x2 y95 Center, Main2
	
Gui, Add, Edit, vInstances x275 y95 w72 Center, %Instances%
Gui, Add, Edit, vColumns x348 y95 w72 Center, %Columns%

; Pack selection logic
if (openPack = "Palkia") {
	defaultPack := 1
} else if (openPack = "Dialga") {
	defaultPack := 2
} else if (openPack = "Mew") {
	defaultPack := 3
} 

Gui, Add, DropDownList, x80 y166 w145 vopenPack choose%defaultPack% Center, Palkia|Dialga|Mew
global scaleParam

if (defaultLanguage = "Scale125") {
	defaultLang := 1
	scaleParam := 277
} else if (defaultLanguage = "Scale100") {
	defaultLang := 2
	scaleParam := 287
} 

Gui, Add, DropDownList, x80 y245 w145 vdefaultLanguage choose%defaultLang%, Scale125

; Initialize monitor dropdown options
SysGet, MonitorCount, MonitorCount
MonitorOptions := ""
Loop, %MonitorCount%
{
	SysGet, MonitorName, MonitorName, %A_Index%
	SysGet, Monitor, Monitor, %A_Index%
	MonitorOptions .= (A_Index > 1 ? "|" : "") "" A_Index ": (" MonitorRight - MonitorLeft "x" MonitorBottom - MonitorTop ")"
	
}
SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
Gui, Add, DropDownList, x275 y245 w145 vSelectedMonitorIndex Choose%SelectedMonitorIndex%, %MonitorOptions%

Gui, Add, Edit, vDelay x80 y332 w145 Center, %Delay%
Gui, Add, Edit, vChangeDate x275 y332 w145 Center, %ChangeDate%

; Speed selection logic
; if (setSpeed = "2x") {
	; defaultSpeed := 1
; } else if (setSpeed = "1x/2x") {
	; defaultSpeed := 2
; } else if (setSpeed = "1x/3x") {
	; defaultSpeed := 3
; }
; Gui, Add, DropDownList, x275 y404 w72 vsetSpeed choose%defaultSpeed% Center, 2x|1x/2x|1x/3x


Gui, Add, Edit, vswipeSpeed x348 y404 w72 Center, %swipeSpeed%


; Pack selection logic
; if (godPack = "Close") {
	; defaultgodPack := 1
; } else if (godPack = "Pause") {
	; defaultgodPack := 2
; } else if (godPack = "Continue") {
	; defaultgodPack := 3
; }

; Gui, Add, DropDownList, x275 y166 w145 vgodPack choose%defaultgodPack% Center, Close|Pause|Continue

if (!CardCheck)
    CardCheck = "Only God Packs" 
defaultCardCheck := 1 
if (TrainerCheck = "Yes" && FullArtCheck = "Yes" && RainbowCheck = "Yes")
    defaultCardCheck := 2      ; All
else if (TrainerCheck = "Yes" && FullArtCheck = "Yes")
    defaultCardCheck := 3      ; Trainer+Normal
else if (TrainerCheck = "Yes" && RainbowCheck = "Yes")
    defaultCardCheck := 4      ; Trainer+Rainbow
else if (FullArtCheck = "Yes" && RainbowCheck = "Yes")
    defaultCardCheck := 5      ; Normal+Rainbow
else if (TrainerCheck = "Yes")
    defaultCardCheck := 6      ; Trainer
else if (FullArtCheck = "Yes")
    defaultCardCheck := 7      ; Normal
else if (RainbowCheck = "Yes")
    defaultCardCheck := 8      ; Rainbow

Gui, Add, DropDownList, x275 y166 w145 vCardCheck choose%defaultCardCheck% Center, Only God Packs|All|Trainer+Full Art|Trainer+Rainbow|Full Art+Rainbow|Trainer|Full Arts|Rainbow

Gui, Add, Edit, x275 y404 w72 vwaitTime Center, %waitTime%

; Pack selection logic
if (skipInvalidGP = "No") {
	defaultskipGP := 1
} else if (skipInvalidGP = "Yes") {
	defaultskipGP := 2
}

Gui, Add, DropDownList, x80 y476 w145 vskipInvalidGP choose%defaultskipGP% Center, No|Yes

; Pack selection logic
if (deleteMethod = "3 Pack") {
	defaultDelete := 1
} else if (deleteMethod = "1 Pack") {
	defaultDelete := 2
} else if (deleteMethod = "Inject 1 Pack") {
	defaultDelete := 3
} else if (deleteMethod = "Inject 2 Pack") {
	defaultDelete := 4
}

Gui, Add, DropDownList, x80 y546 w145 vdeleteMethod choose%defaultDelete% Center gdeleteSettings, 3 Pack|1 Pack|Inject 1 Pack|Inject 2 Pack

Gui, Font, s10 Bold, Segoe UI 
if (InStr(deleteMethod, "Inject"))
	if(nukeAccount)
		Gui, Add, CheckBox, Checked vnukeAccount x2 y546 Center Hidden, Menu `nDelete
	else
		Gui, Add, CheckBox, vnukeAccount x2 y546 Center Hidden, Menu `nDelete
else
	if(nukeAccount)
		Gui, Add, CheckBox, Checked vnukeAccount x2 y546 Center, Menu `nDelete
	else
		Gui, Add, CheckBox, vnukeAccount x2 y546 Center, Menu `nDelete


Gui, Add, Edit, vfolderPath x80 y404 w145 h35 Center, %folderPath%

if(StrLen(discordUserID) > 2)
	Gui, Add, Edit, vdiscordUserId x273 y476 w72 h35 Center, %discordUserId%
else
	Gui, Add, Edit, vdiscordUserId x273 y476 w72 h35 Center
	
if(StrLen(discordWebhookURL) > 2)
	Gui, Add, Edit, vdiscordWebhookURL x348 y476 w72 h35 Center, %discordWebhookURL%
else
	Gui, Add, Edit, vdiscordWebhookURL x348 y476 w72 h35 Center
	
if(StrLen(heartBeatName) < 3)
	heartBeatName = 
	
if(StrLen(heartBeatWebhookURL) < 3)
	heartBeatWebhookURL = 

if(heartBeat) {
	Gui, Add, CheckBox, Checked vheartBeat x273 y512 Center gdiscordSettings, Discord Heartbeat
	Gui, Add, Edit, vheartBeatName x273 y532 w72 h20 Center, %heartBeatName%
	Gui, Add, Edit, vheartBeatWebhookURL x348 y532 w72 h20 Center, %heartBeatWebhookURL%
}
else {
	Gui, Add, CheckBox, vheartBeat x273 y512 Center gdiscordSettings, Discord Heart Beat
	Gui, Add, Edit, vheartBeatName x273 y532 w72 h20 Center Hidden, %heartBeatName%
	Gui, Add, Edit, vheartBeatWebhookURL x348 y532 w72 h20 Center Hidden, %heartBeatWebhookURL%
}



; Gui, Font, s10 cGray Norm Bold, Segoe UI  ; Normal font for input labels
; Gui Add, Button, x190 y72 w17 h19 gShowMsgName, ? ;Questionmark box for Name Field
; Gui Add, Button, x342 y77 w17 h19 gShowMsgInstances, ? ;Questionmark box for Instance Field
; Gui Add, Button, x415 y77 w17 h19 gShowMsgColumns, ? ;Questionmark box for Instance Per Row Field

; Gui Add, Button, x190 y145 w17 h19 gShowMsgPacks, ? ;Questionmark box for Pack to Open Field
; Gui Add, Button, x423 y145 w17 h19 gShowMsgGodPacks, ? ;Questionmark box for God Pack to Open Field

; Gui Add, Button, x78 y219 w17 h19 gShowMsgLanguage, ? ;Questionmark box for God Pack to Open Field
; Gui Add, Button, x400 y219 w17 h19 gShowMsgMonitor, ? ;Questionmark box for God Pack to Open Field

; Gui Add, Button, x192 y307 w17 h19 gShowMsgDelay, ? ;Questionmark box for Delay in ms Field
; Gui Add, Button, x411 y307 w17 h19 gShowMsgTimeZone, ? ;Questionmark box for Timezone Field

; Gui Add, Button, x193 y378 w17 h19 gShowMsgFolder, ? ;Questionmark box for SwipeSpeed Field
; Gui Add, Button, x343 y378 w17 h19 gShowMsgSpeed, ? ;Questionmark box for Speed Field
; Gui Add, Button, x408 y378 w17 h19 gShowMsgSwipeSpeed, ? ;Questionmark box for SwipeSpeed Field

; Gui Add, Button, x428 y448 w17 h19 gShowMsgdiscordwebHook, ? ;Questionmark box for discord id Field
; Gui Add, Button, x330 y448 w17 h19 gShowMsgdiscordID, ? ;Questionmark box for discord web hook Field

; Gui Add, Button, x230 y518 w17 h19 gShowMsgAccountDeletion, ? ;Questionmark box for Account Deletion to Open Field
; Gui Add, Button, x235 y448 w17 h19 gShowMsgSkipGP, ? ;Questionmark box for Account Deletion to Open Field

; Show the GUI
Gui, Show
return


discordSettings:
    Gui, Submit, NoHide

    if (heartBeat) {
		GuiControl, Show, heartBeatName
        GuiControl, Show, heartBeatWebhookURL
    }
    else {
        GuiControl, Hide, heartBeatName
        GuiControl, Hide, heartBeatWebhookURL
    }
return

deleteSettings:
    Gui, Submit, NoHide
	;GuiControlGet, deleteMethod,, deleteMethod
	
	if(InStr(deleteMethod, "Inject")) {
		GuiControl, Hide, nukeAccount
		nukeAccount = false
	}
	else
		GuiControl, Show, nukeAccount
return

ShowMsgName:
	MsgBox, Input the name you want the accounts to have. `nIf it's getting stuck inputting the name then make sure your dpi is set to 220.`nLeave blank for a random pokemon name ;'
return

ShowMsgInstances:
	MsgBox, Input how many instances you are running
return

ShowMsgColumns:
	MsgBox, Input the number of instances per row
return

ShowMsgPacks:
	MsgBox, Select the pack you want to open
return

ShowMsgGodPacks:
	MsgBox, Select the behavior you want when finding a god pack. `nClose will close the emulator and stop the script to save resources. `nPause will only pause the script on the opening screen. `nContinue will save the account data to a file and continue rolling with the instance. The xml account data can then be injected into an instance using the tools in the 'Accounts' folder to recover the god pack.
return

ShowMsgLanguage:
	MsgBox, Select your game's language. In order to change your language > change language settings in mumu > delete the game account data. ;'
return

ShowMsgMonitor:
	MsgBox, Select the monitor you want the instances to be on. `nBe sure to start them on that monitor to prevent issues. `nIf you're having issues make sure all monitors are set to 125`% scale or the scale you have chosen ;'
return

ShowMsgDelay:
	MsgBox, Input the delay in between clicks.
return

ShowMsgTimeZone:
	MsgBox, What time the date change is for you. `n1 AM EST is default you can look up what that is in your time zone.
return

ShowMsgFolder:
	MsgBox, Where the "MuMuPlayerGlobal-12.0" folder is located. `nTypically it's in the Netease folder: C:\Program Files\Netease ;'
return

ShowMsgSpeed:
	MsgBox, Select the speed configuration. `n2x flat speed. (usually better when maxing out your system) `n1x/2x to swipe at 1x speed then do the rest on 2x. This needs the new speed mod in the guide. (Good option if you are having issues swiping on flat 2x speed) `n1x/3x to swipe at 1x speed then do the reset on 3x. This needs the new speed mod in the guide. (usually better when running fewer instances)
return

ShowMsgSwipeSpeed:
	MsgBox, Input the swipe speed in milliseconds. `nAnything from 100 to 1000 can probably work. `nPlay around with the speed to get the best speed for your system. Lower number = faster speed. 
return

ShowMsgdiscordID:
	MsgBox, Input your discord ID for pings using webhook. Not your username, but your numerical discord ID.
return

ShowMsgdiscordwebHook:
	MsgBox, Input your server's webhook. It will be something like: https://discord.com/api/webhooks/124124151245/oihri1u24hifb12oiu43hy1 `nCreate a server in discord > for any channel > click the edit channel cog wheel > integrations > create a webhook > click on the webhook created > copy webhook url. Paste that here. ;'
return

ShowMsgAccountDeletion:
	MsgBox, Select the method to delete the account. `nFile method deletes the XML file and then closes/reopens the game. This should be more efficient. `nClicks method will simulate clicking and deleting the account through the Menu. Use this if for some reason your game takes a long time starting up.
return

ShowMsgSkipGP:
	MsgBox, Select whether or not to skip god packs. If you skip them you will still receive a discord ping and the account XML is also saved in the Accounts folder.
return

ArrangeWindows:
	GuiControlGet, runMain,, runMain
	GuiControlGet, Instances,, Instances
	GuiControlGet, Columns,, Columns
	GuiControlGet, SelectedMonitorIndex,, SelectedMonitorIndex
	Loop %Instances% {
		resetWindows(A_Index, SelectedMonitorIndex)
		sleep, 10
	}
return

; Handle the link click
OpenLink:
	Run, https://buymeacoffee.com/aarturoo
return

OpenDiscord:
	Run, https://discord.gg/C9Nyf7P4sT
return

Start:
Gui, Submit  ; Collect the input values from the first page
Instances := Instances  ; Directly reference the "Instances" variable

if (CardCheck = "Only God Packs") {
    TrainerCheck := "No"
    FullArtCheck := "No"
    RainbowCheck := "No"
} else if (CardCheck = "All") {
    TrainerCheck := "Yes"
    FullArtCheck := "Yes"
    RainbowCheck := "Yes"
} else if (CardCheck = "Trainer") {
    TrainerCheck := "Yes"
    FullArtCheck := "No"
    RainbowCheck := "No"
} else if (CardCheck = "Full Arts") {
    TrainerCheck := "No"
    FullArtCheck := "Yes"
    RainbowCheck := "No"
} else if (CardCheck = "Rainbow") {
    TrainerCheck := "No"
    FullArtCheck := "No"
    RainbowCheck := "Yes"
} else if (CardCheck = "Trainer+Full Art") {
    TrainerCheck := "Yes"
    FullArtCheck := "Yes"
    RainbowCheck := "No"
} else if (CardCheck = "Trainer+Rainbow") {
    TrainerCheck := "Yes"
    FullArtCheck := "No"
    RainbowCheck := "Yes"
} else if (CardCheck = "Full Art+Rainbow") {
    TrainerCheck := "No"
    FullArtCheck := "Yes"
    RainbowCheck := "Yes"
}

; Create the second page dynamically based on the number of instances
Gui, Destroy ; Close the first page

IniWrite, %FriendID%, settings2.ini, UserSettings, FriendID
IniWrite, %waitTime%, settings2.ini, UserSettings, waitTime
IniWrite, %Delay%, settings2.ini, UserSettings, Delay
IniWrite, %folderPath%, settings2.ini, UserSettings, folderPath
IniWrite, %discordWebhookURL%, settings2.ini, UserSettings, discordWebhookURL
IniWrite, %discordUserId%, settings2.ini, UserSettings, discordUserId
IniWrite, %ChangeDate%, settings2.ini, UserSettings, ChangeDate
IniWrite, %Columns%, settings2.ini, UserSettings, Columns
IniWrite, %openPack%, settings2.ini, UserSettings, openPack
IniWrite, %godPack%, settings2.ini, UserSettings, godPack
IniWrite, %Instances%, settings2.ini, UserSettings, Instances
;IniWrite, %setSpeed%, settings2.ini, UserSettings, setSpeed
IniWrite, %defaultLanguage%, settings2.ini, UserSettings, defaultLanguage
IniWrite, %SelectedMonitorIndex%, settings2.ini, UserSettings, SelectedMonitorIndex
IniWrite, %swipeSpeed%, settings2.ini, UserSettings, swipeSpeed
IniWrite, %skipInvalidGP%, settings2.ini, UserSettings, skipInvalidGP
IniWrite, %deleteMethod%, settings2.ini, UserSettings, deleteMethod
IniWrite, %runMain%, settings2.ini, UserSettings, runMain
IniWrite, %heartBeat%, settings2.ini, UserSettings, heartBeat
IniWrite, %heartBeatWebhookURL%, settings2.ini, UserSettings, heartBeatWebhookURL
IniWrite, %heartBeatName%, settings2.ini, UserSettings, heartBeatName
IniWrite, %nukeAccount%, settings2.ini, UserSettings, nukeAccount
IniWrite, %TrainerCheck%, settings2.ini, UserSettings, TrainerCheck
IniWrite, %FullArtCheck%, settings2.ini, UserSettings, FullArtCheck
IniWrite, %RainbowCheck%, settings2.ini, UserSettings, RainbowCheck

; Loop to process each instance
Loop, %Instances%
{
	if (A_Index != 1) {
		SourceFile := "Scripts\1.ahk" ; Path to the source .ahk file
		TargetFolder := "Scripts\" ; Path to the target folder
		TargetFile := TargetFolder . A_Index . ".ahk" ; Generate target file path
		FileCopy, %SourceFile%, %TargetFile%, 1 ; Copy source file to target
		if (ErrorLevel)
			MsgBox, Failed to create %TargetFile%. Ensure permissions and paths are correct.
	}
	
	FileName := "Scripts\" . A_Index . ".ahk"
	Command := FileName
	
	Run, %Command%
}
if(runMain) {
	FileName := "Scripts\Main2.ahk"
	Run, %FileName%
}
if(inStr(FriendID, "http"))
	DownloadFile(FriendID, "ids.txt")
SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
SysGet, Monitor, Monitor, %SelectedMonitorIndex%
rerollTime := A_TickCount
Loop {
	Sleep, 30000
	; Sum all variable values and write to total.json
	total := SumVariablesInJsonFile()
	totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
	mminutes := Floor(totalSeconds / 60)
	if(total = 0)
	total := "0                             "
	packStatus := "Time: " . mminutes . "m Packs: " . total
	CreateStatusMessage(packStatus, 287, 490)
	if(heartBeat)
		if((A_Index = 1 || (Mod(A_Index, 60) = 0))) {
			onlineAHK := "Online: "
			offlineAHK := "Offline: "
			Online := []
			if(runMain) {
				IniRead, value, HeartBeat.ini, HeartBeat, Main2
				if(value)
					onlineAHK := "Online: Main2, "
				else
					offlineAHK := "Offline: Main2, "
				IniWrite, 0, HeartBeat.ini, HeartBeat, Main2
			}
			Loop %Instances% {
				IniRead, value, HeartBeat.ini, HeartBeat, Instance%A_Index%
				if(value)
					Online.push(1)
				else
					Online.Push(0)
				IniWrite, 0, HeartBeat.ini, HeartBeat, Instance%A_Index%
			}
			for index, value in Online {
				if(index = Online.MaxIndex())
					commaSeparate := "."
				else
					commaSeparate := ", "
				if(value)
					onlineAHK .= A_Index . commaSeparate
				else
					offlineAHK .= A_Index . commaSeparate
			}
			if(offlineAHK = "Offline: ")
				offlineAHK := "Offline: none."
			if(onlineAHK = "Online: ")
				onlineAHK := "Online: none."
			
			discMessage := "\n" . onlineAHK . "\n" . offlineAHK . "\n" . packStatus
			if(heartBeatName)
				discordUserID := heartBeatName
			LogToDiscord(discMessage, , discordUserID)
		}
}
Return

GuiClose:
ExitApp

createAccountList(instance) {
	currentDate := A_Now  
	year := SubStr(currentDate, 1, 4)  
	month := SubStr(currentDate, 5, 2) 
	day := SubStr(currentDate, 7, 2)   


	daysSinceBase := (year - 1900) * 365 + Floor((year - 1900) / 4)
	daysSinceBase += MonthToDays(year, month)                       
	daysSinceBase += day                                            

	remainder := Mod(daysSinceBase, 3)
	
	saveDir := A_ScriptDir "\Accounts\Saved\" . remainder . "\" . instance
	outputTxt := saveDir . "\list.txt"
	
	if FileExist(outputTxt) {
		FileGetTime, fileTime, %outputTxt%, M  ; Get last modified time
		timeDiff := A_Now - fileTime  ; Calculate time difference

		if (timeDiff > 86400)  ; 24 hours in seconds (60 * 60 * 24)
			FileDelete, %outputTxt%
	}
	if (!FileExist(outputTxt))
		Loop, %saveDir%\*.xml {
			FileAppend, % A_LoopFileFullPath "`n", %outputTxt%  ; Append file path to output.txt
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

LogToDiscord(message, screenshotFile := "", ping := false, xmlFile := "") {
	global discordUserId, discordWebhookURL, friendCode, heartBeatWebhookURL
	discordPing := discordUserId
	if(heartBeatWebhookURL)
		discordWebhookURL := heartBeatWebhookURL
		
	if (discordWebhookURL != "") {
		MaxRetries := 10
		RetryCount := 0
		Loop {
			try {
				; If an image file is provided, send it
				if (screenshotFile != "") {
					; Check if the file exists
					if (FileExist(screenshotFile)) {
						; Send the image using curl
						curlCommand := "curl -k "
    . "-F ""payload_json={\""content\"":\""" . discordPing . message . "\""};type=application/json;charset=UTF-8"" " . discordWebhookURL
						RunWait, %curlCommand%,, Hide
					}
				}
				else {
					curlCommand := "curl -k "
    . "-F ""payload_json={\""content\"":\""" . discordPing . message . "\""};type=application/json;charset=UTF-8"" " . discordWebhookURL
						RunWait, %curlCommand%,, Hide
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

DownloadFile(url, filename) {
	url := url  ; Change to your hosted .txt URL "https://pastebin.com/raw/vYxsiqSs"
	localPath = %A_ScriptDir%\%filename% ; Change to the folder you want to save the file

	URLDownloadToFile, %url%, %localPath%

	; if ErrorLevel
		; MsgBox, Download failed!
	; else
		; MsgBox, File downloaded successfully!

}

resetWindows(Title, SelectedMonitorIndex){
	global Columns, runMain
	RetryCount := 0
	MaxRetries := 10
	if(runMain){
		if(Title = 1) {
			Loop
			{
				try {
					; Get monitor origin from index
					SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
					SysGet, Monitor, Monitor, %SelectedMonitorIndex%

					rowHeight := 533  ; Adjust the height of each row
					currentRow := Floor((Title - 1) / Columns)
					y := currentRow * rowHeight	
					x := Mod((Title - 1), Columns) * scaleParam
					Title := "Main2"
					WinMove, %Title%, , % (MonitorRight - scaleParam - x), % (MonitorTop + y), scaleParam, 537
					break
				}
				catch {
					if (RetryCount > MaxRetries)
						Pause
				}
				Sleep, 1000
			}
			Title := 1
		}
	}
	Loop
	{
		try {
			; Get monitor origin from index
			SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
			SysGet, Monitor, Monitor, %SelectedMonitorIndex%
			if(runMain)
				Title := Title + 1
			rowHeight := 533  ; Adjust the height of each row
			currentRow := Floor((Title - 1) / Columns)
			y := currentRow * rowHeight	
			x := Mod((Title - 1), Columns) * scaleParam
			if(runMain)
				Title := Title - 1
			WinMove, %Title%, , % (MonitorRight - scaleParam - x), % (MonitorTop + y), scaleParam, 537
			break
		}
		catch {
			if (RetryCount > MaxRetries)
				Pause
		}
		Sleep, 1000
	}
	return true
}

CreateStatusMessage(Message, X := 0, Y := 80) {
	global PacksText, SelectedMonitorIndex, createdGUI, Instances
	MaxRetries := 10
	RetryCount := 0
	try {
		GuiName := 22
		SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
		SysGet, Monitor, Monitor, %SelectedMonitorIndex%
		X := MonitorRight - scaleParam - X
		Y := MonitorTop + Y
		Gui %GuiName%:+LastFoundExist
		if WinExist() {
			GuiControl, , PacksText, %Message%
		} else {			OwnerWND := WinExist(1)
			if(!OwnerWND)
				Gui, %GuiName%:New, +ToolWindow -Caption
			else
				Gui, %GuiName%:New, +Owner%OwnerWND% +ToolWindow -Caption 
			Gui, %GuiName%:Margin, 2, 2  ; Set margin for the GUI
			Gui, %GuiName%:Font, s8  ; Set the font size to 8 (adjust as needed)
			Gui, %GuiName%:Add, Text, vPacksText, %Message%
			Gui, %GuiName%:Show, NoActivate x%X% y%Y%, NoActivate %GuiName%
		}
	}
}

; Global variable to track the current JSON file
global jsonFileName := ""

; Function to create or select the JSON file
InitializeJsonFile() {
	global jsonFileName
	fileName := A_ScriptDir . "\json\Packs.json"
	if FileExist(fileName)
		FileDelete, %fileName%
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
		MsgBox, JSON file not initialized. Call InitializeJsonFile() first.
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
		return
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
	
	if(sum > 0) {
		totalFile := A_ScriptDir . "\json\total.json"
		totalContent := "{""total_sum"": " sum "}"
		FileDelete, %totalFile%
		FileAppend, %totalContent%, %totalFile%
	}

	return sum
}

KillADBProcesses() {
    ; Use AHK's Process command to close adb.exe
    Process, Close, adb.exe
    ; Fallback to taskkill for robustness
    RunWait, %ComSpec% /c taskkill /IM adb.exe /F /T,, Hide
}

~F7::ExitApp
