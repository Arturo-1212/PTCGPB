version = Arturos PTCGP Bot
#SingleInstance, force
CoordMode, Mouse, Screen
SetTitleMatchMode, 3

githubUser := "Arturo-1212"
repoName := "PTCGPB"
localVersion := "v6.3.21"
scriptFolder := A_ScriptDir
zipPath := A_Temp . "\update.zip"
extractPath := A_Temp . "\update"

if not A_IsAdmin
{
	; Relaunch script with admin rights
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}

MsgBox, 64, The project is now licensed under CC BY-NC 4.0, The original intention of this project was not for it to be used for paid services even those disguised as 'donations.' I hope people respect my wishes and those of the community. `nThe project is now licensed under CC BY-NC 4.0, which allows you to use, modify, and share the software only for non-commercial purposes. Commercial use, including using the software to provide paid services or selling it (even if donations are involved), is not allowed under this license. The new license applies to this and all future releases.

CheckForUpdate()

KillADBProcesses()

global Instances, instanceStartDelay, jsonFileName, PacksText, runMain, Mains, scaleParam

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
IniRead, FriendID, Settings.ini, UserSettings, FriendID
IniRead, waitTime, Settings.ini, UserSettings, waitTime, 5
IniRead, Delay, Settings.ini, UserSettings, Delay, 250
IniRead, folderPath, Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
IniRead, discordWebhookURL, Settings.ini, UserSettings, discordWebhookURL, ""
IniRead, discordUserId, Settings.ini, UserSettings, discordUserId, ""
IniRead, Columns, Settings.ini, UserSettings, Columns, 5
IniRead, godPack, Settings.ini, UserSettings, godPack, Continue
IniRead, Instances, Settings.ini, UserSettings, Instances, 1
IniRead, instanceStartDelay, Settings.ini, UserSettings, instanceStartDelay, 0
IniRead, defaultLanguage, Settings.ini, UserSettings, defaultLanguage, Scale125
IniRead, SelectedMonitorIndex, Settings.ini, UserSettings, SelectedMonitorIndex, 1
IniRead, swipeSpeed, Settings.ini, UserSettings, swipeSpeed, 300
IniRead, deleteMethod, Settings.ini, UserSettings, deleteMethod, 3 Pack
IniRead, runMain, Settings.ini, UserSettings, runMain, 1
IniRead, Mains, Settings.ini, UserSettings, Mains, 1
IniRead, heartBeat, Settings.ini, UserSettings, heartBeat, 0
IniRead, heartBeatWebhookURL, Settings.ini, UserSettings, heartBeatWebhookURL, ""
IniRead, heartBeatName, Settings.ini, UserSettings, heartBeatName, ""
IniRead, nukeAccount, Settings.ini, UserSettings, nukeAccount, 0
IniRead, packMethod, Settings.ini, UserSettings, packMethod, 0
IniRead, TrainerCheck, Settings.ini, UserSettings, TrainerCheck, 0
IniRead, FullArtCheck, Settings.ini, UserSettings, FullArtCheck, 0
IniRead, RainbowCheck, Settings.ini, UserSettings, RainbowCheck, 0
IniRead, CrownCheck, Settings.ini, UserSettings, CrownCheck, 0
IniRead, ImmersiveCheck, Settings.ini, UserSettings, ImmersiveCheck, 0
IniRead, PseudoGodPack, Settings.ini, UserSettings, PseudoGodPack, 0
IniRead, minStars, Settings.ini, UserSettings, minStars, 0
IniRead, Palkia, Settings.ini, UserSettings, Palkia, 0
IniRead, Dialga, Settings.ini, UserSettings, Dialga, 0
IniRead, Arceus, Settings.ini, UserSettings, Arceus, 1
IniRead, Mew, Settings.ini, UserSettings, Mew, 0
IniRead, Pikachu, Settings.ini, UserSettings, Pikachu, 0
IniRead, Charizard, Settings.ini, UserSettings, Charizard, 0
IniRead, Mewtwo, Settings.ini, UserSettings, Mewtwo, 0
IniRead, slowMotion, Settings.ini, UserSettings, slowMotion, 0
IniRead, ocrLanguage, Settings.ini, UserSettings, ocrLanguage, en
IniRead, clientLanguage, Settings.ini, UserSettings, clientLanguage, en
IniRead, autoLaunchMonitor, Settings.ini, UserSettings, autoLaunchMonitor, 1
IniRead, mainIdsURL, Settings.ini, UserSettings, mainIdsURL, ""
IniRead, vipIdsURL, Settings.ini, UserSettings, vipIdsURL, ""
IniRead, instanceLaunchDelay, Settings.ini, UserSettings, instanceLaunchDelay, 5

; Create a stylish GUI with custom colors and modern look
Gui, Color, 1E1E1E, 333333 ; Dark theme background
Gui, Font, s10 cWhite, Segoe UI ; Modern font



; ========== Column 1 ==========
; ==============================

; ========== Friend ID Section ==========
Gui, Add, GroupBox, x5 y0 w240 h40 cWhite, Friend ID
if(FriendID = "ERROR" || FriendID = "")
    Gui, Add, Edit, vFriendID w180 x35 y15 h20 -E0x200 Background2A2A2A cWhite
else
    Gui, Add, Edit, vFriendID w180 x35 y15 h20 -E0x200 Background2A2A2A cWhite, %FriendID%

; ========== Instance Settings Section ==========
Gui, Add, GroupBox, x5 y40 w240 h125 cWhite, Instance Settings
Gui, Add, Text, x20 y65 cWhite, Instances:
Gui, Add, Edit, vInstances w50 x105 y63 h20 -E0x200 Background2A2A2A cWhite Center, %Instances%
Gui, Add, Text, x20 y90 cWhite, Start Delay:
Gui, Add, Edit, vinstanceStartDelay w50 x105 y88 h20 -E0x200 Background2A2A2A cWhite Center, %instanceStartDelay%
Gui, Add, Text, x20 y115 cWhite, Columns:
Gui, Add, Edit, vColumns w50 x105 y113 h20 -E0x200 Background2A2A2A cWhite Center, %Columns%
Gui, Add, Checkbox, % (runMain ? "Checked" : "") " vrunMain gmainSettings x35 y140 cWhite", Run Main(s)
Gui, Add, Edit, % "vMains w50 x135 y138 h20 -E0x200 Background2A2A2A cWhite Center" . (runMain ? "" : " Hidden"), %Mains%

; ========== Time Settings Section ==========
Gui, Add, GroupBox, x5 y165 w240 h110 c9370DB, Time Settings ; Purple
Gui, Add, Text, x20 y190 c9370DB, Delay:
Gui, Add, Edit, vDelay w70 x105 y188 h20 -E0x200 Background2A2A2A cWhite Center, %Delay%
Gui, Add, Text, x20 y215 c9370DB, Wait Time:
Gui, Add, Edit, vwaitTime w70 x105 y213 h20 -E0x200 Background2A2A2A cWhite Center, %waitTime%
Gui, Add, Text, x20 y240 c9370DB, Swipe Speed:
Gui, Add, Edit, vswipeSpeed w70 x105 y238 h20 -E0x200 Background2A2A2A cWhite Center, %swipeSpeed%

; ========== System Settings Section ==========
Gui, Add, GroupBox, x5 y275 w240 h220 c4169E1, System Settings ; Royal Blue
Gui, Add, Text, x20 y295 c4169E1, Monitor:
SysGet, MonitorCount, MonitorCount
MonitorOptions := ""
Loop, %MonitorCount% {
    SysGet, MonitorName, MonitorName, %A_Index%
    SysGet, Monitor, Monitor, %A_Index%
    MonitorOptions .= (A_Index > 1 ? "|" : "") "" A_Index ": (" MonitorRight - MonitorLeft "x" MonitorBottom - MonitorTop ")"
}
SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
Gui, Add, DropDownList, x20 y315 w130 vSelectedMonitorIndex Choose%SelectedMonitorIndex% Background2A2A2A cWhite, %MonitorOptions%
Gui, Add, Text, x160 y295 c4169E1, Scale:
if (defaultLanguage = "Scale125") {
    defaultLang := 1
    scaleParam := 277
} else if (defaultLanguage = "Scale100") {
    defaultLang := 2  
    scaleParam := 287
}
Gui, Add, DropDownList, x160 y315 w75 vdefaultLanguage choose%defaultLang% Background2A2A2A cWhite, Scale125|Scale100
Gui, Add, Text, x20 y345 c4169E1, Folder Path:
Gui, Add, Edit, vfolderPath w200 x20 y365 h20 -E0x200 Background2A2A2A cWhite, %folderPath%

;if(slowMotion)
	;Gui, Add, Checkbox, Checked vslowMotion x270 y375, Base Game Compatibility
;else
	;Gui, Add, Checkbox, vslowMotion x270 y375, Base Game Compatibility

Gui, Add, Text, x20 y395 c4169E1, OCR:

; ========== Language Pack list ==========
ocrLanguageList := "en|zh|es|de|fr|ja|ru|pt|ko|it|tr|pl|nl|sv|ar|uk|id|vi|th|he|cs|no|da|fi|hu|el|zh-TW"

if (ocrLanguage != "")
{
	index := 0
    Loop, Parse, ocrLanguageList, |
    {
        index++
        if (A_LoopField = ocrLanguage)
        {
            defaultOcrLang := index
            break
        }
    }
}

Gui, Add, DropDownList, vocrLanguage choose%defaultOcrLang% x55 y390 w50 Background2A2A2A cWhite, %ocrLanguageList%

Gui, Add, Text, x120 y395 c4169E1, Client:

; ========== Client Language Pack list ==========
clientLanguageList := "en|es|fr|de|it|pt|jp|ko|cn"

if (clientLanguage != "")
{
	index := 0
    Loop, Parse, clientLanguageList, |
    {
        index++
        if (A_LoopField = clientLanguage)
        {
            defaultClientLang := index
            break
        }
    }
}

Gui, Add, DropDownList, vclientLanguage choose%defaultClientLang% x165 y390 w50 Background2A2A2A cWhite, %clientLanguageList%

Gui, Add, Text, x20 y425 c4169E1, Launch All Mumu Delay:
Gui, Add, Edit, vinstanceLaunchDelay w50 x175 y425 h20 -E0x200 Background2A2A2A cWhite Center, %instanceLaunchDelay%
Gui, Add, Checkbox, % (autoLaunchMonitor ? "Checked" : "") " vautoLaunchMonitor x35 y455 cWhite", Auto Launch Monitor



; ========== Column 2 ==========
; ==============================

; ========== God Pack Settings Section ==========
Gui, Add, GroupBox, x255 y0 w240 h120 c39FF14, God Pack Settings ; Neon green
Gui, Add, Text, x270 y25 c39FF14, Min. 2 Stars:
Gui, Add, Edit, vminStars w50 x350 y23 h20 -E0x200 Background2A2A2A cWhite Center, %minStars%
Gui, Add, Text, x270 y53 c39FF14, Method:
if (deleteMethod = "5 Pack")
    defaultDelete := 1
else if (deleteMethod = "3 Pack")
    defaultDelete := 2
else if (deleteMethod = "Inject")
    defaultDelete := 3
else if (deleteMethod = "5 Pack (Fast)")
    defaultDelete := 4
;	SquallTCGP 2025.03.12 - 	Adding the delete method 5 Pack (Fast) to the delete method dropdown list.
Gui, Add, DropDownList, vdeleteMethod gdeleteSettings choose%defaultDelete% x325 y48 w100 Background2A2A2A cWhite, 5 Pack|3 Pack|Inject|5 Pack (Fast)
Gui, Add, Checkbox, % (packMethod ? "Checked" : "") " vpackMethod x280 y75 c39FF14", 1 Pack Method
Gui, Add, Checkbox, % (nukeAccount ? "Checked" : "") " vnukeAccount x280 y95 c39FF14", Menu Delete Account

; ========== Pack Selection Section ==========
Gui, Add, GroupBox, x255 y120 w240 h110 cFFD700, Pack Selection ; Gold
Gui, Add, Checkbox, % (Arceus ? "Checked" : "") " vArceus x280 y145 cFFD700", Arceus
Gui, Add, Checkbox, % (Palkia ? "Checked" : "") " vPalkia x280 y165 cFFD700", Palkia
Gui, Add, Checkbox, % (Dialga ? "Checked" : "") " vDialga x280 y185 cFFD700", Dialga
Gui, Add, Checkbox, % (Pikachu ? "Checked" : "") " vPikachu x365 y145 cFFD700", Pikachu
Gui, Add, Checkbox, % (Charizard ? "Checked" : "") " vCharizard x365 y165 cFFD700", Charizard
Gui, Add, Checkbox, % (Mewtwo ? "Checked" : "") " vMewtwo x365 y185 cFFD700", Mewtwo
Gui, Add, Checkbox, % (Mew ? "Checked" : "") " vMew x365 y205 cFFD700", Mew

; ========== Card Detection Section ==========
Gui, Add, GroupBox, x255 y230 w240 h155 cFF4500, Card Detection ; Orange Red
Gui, Add, Checkbox, % (FullArtCheck ? "Checked" : "") " vFullArtCheck x280 y255 cFF4500", Single Full Art
Gui, Add, Checkbox, % (TrainerCheck ? "Checked" : "") " vTrainerCheck x280 y275 cFF4500", Single Trainer
Gui, Add, Checkbox, % (RainbowCheck ? "Checked" : "") " vRainbowCheck x280 y295 cFF4500", Single Rainbow
Gui, Add, Checkbox, % (PseudoGodPack ? "Checked" : "") " vPseudoGodPack x280 y315 cFF4500", Double 2 Star
Gui, Add, Checkbox, % (CrownCheck ? "Checked" : "") " vCrownCheck x280 y335 cFF4500", Save Crowns
Gui, Add, Checkbox, % (ImmersiveCheck ? "Checked" : "") " vImmersiveCheck x280 y355 cFF4500", Save Immersives



; ========== Column 3 ==========
; ==============================

; ========== Discord Settings Section ==========
Gui, Add, GroupBox, x505 y0 w240 h120 cFF69B4, Discord Settings ; Hot pink
if(StrLen(discordUserID) < 3)
    discordUserID =
if(StrLen(discordWebhookURL) < 3)
    discordWebhookURL =
Gui, Add, Text, x520 y20 cFF69B4, Discord ID:
Gui, Add, Edit, vdiscordUserId w210 x520 y40 h20 -E0x200 Background2A2A2A cWhite, %discordUserId%
Gui, Add, Text, x520 y70 cFF69B4, Webhook URL:
Gui, Add, Edit, vdiscordWebhookURL w210 x520 y90 h20 -E0x200 Background2A2A2A cWhite, %discordWebhookURL%

; ========== Heartbeat Settings Section ==========
Gui, Add, GroupBox, x505 y120 w240 h155 c00FFFF, Heartbeat Settings ; Cyan
Gui, Add, Checkbox, % (heartBeat ? "Checked" : "") " vheartBeat x520 y145 gdiscordSettings c00FFFF", Discord Heartbeat

if(StrLen(heartBeatName) < 3)
    heartBeatName =
if(StrLen(heartBeatWebhookURL) < 3)
    heartBeatWebhookURL =

if (heartBeat) {
    Gui, Add, Text, vhbName x520 y170 c00FFFF, Name:
    Gui, Add, Edit, vheartBeatName w210 x520 y195 h20 -E0x200 Background2A2A2A cWhite, %heartBeatName%
    Gui, Add, Text, vhbURL x520 y220 c00FFFF, Webhook URL:
    Gui, Add, Edit, vheartBeatWebhookURL w210 x520 y245 h20 -E0x200 Background2A2A2A cWhite, %heartBeatWebhookURL%
} else {
    Gui, Add, Text, vhbName x520 y170 Hidden c00FFFF, Name:
    Gui, Add, Edit, vheartBeatName w210 x520 y195 h20 Hidden -E0x200 Background2A2A2A cWhite, %heartBeatName%
    Gui, Add, Text, vhbURL x520 y220 Hidden c00FFFF, Webhook URL:
    Gui, Add, Edit, vheartBeatWebhookURL w210 x520 y245 h20 Hidden -E0x200 Background2A2A2A cWhite, %heartBeatWebhookURL%
}

; ========== Action Buttons ==========
Gui, Add, Button, gOpenLink x505 y350 w76 h35, Buy Me a Coffee
Gui, Add, Button, gCheckForUpdates x588 y350 w77 h35, Check Updates
Gui, Add, Button, gOpenDiscord x670 y350 w75 h35, Join Discord
Gui, Add, Button, gStart x505 y280 w240 h30, START BOT
Gui, Add, Button, gArrangeWindows x630 y315 w115 h30, Arrange Windows
Gui, Add, Button, gLaunchAllMumu x505 y315 w115 h30, Launch All Mumu


; ========== Download Settings Section (Bottom right) ==========
Gui, Add, GroupBox, x255 y385 w490 h110 cWhite, Download Settings ;

if(StrLen(mainIdsURL) < 3)
    mainIdsURL =
if(StrLen(vipIdsURL) < 3)
    vipIdsURL =

Gui, Add, Text, x270 y405 cWhite, ids.txt API:
Gui, Add, Edit, vmainIdsURL w460 x270 y425 h20 -E0x200 Background2A2A2A cWhite, %mainIdsURL%
Gui, Add, Text, x270 y445 cWhite, vip_ids.txt (GP Test Mode) API:
Gui, Add, Edit, vvipIdsURL w460 x270 y465 h20 -E0x200 Background2A2A2A cWhite, %vipIdsURL%

;move to line 138
; if (defaultLanguage = "Scale125") {
; 	defaultLang := 1
; 	scaleParam := 277
; } else if (defaultLanguage = "Scale100") {
; 	defaultLang := 2
; 	scaleParam := 287
; }

;Gui, Add, Text, x270 y400 cWhite, Scale:
;Gui, Add, DropDownList, x310 y395 w145 vdefaultLanguage choose%defaultLang%, Scale125

Gui, Show, , %localVersion% PTCGPB Bot Setup [Non-Commercial 4.0 International License]
Return


CheckForUpdates:
	CheckForUpdate()
return

mainSettings:
	Gui, Submit, NoHide

	if (runMain) {
		GuiControl, Show, Mains
	}
	else {
		GuiControl, Hide, Mains
	}
return

discordSettings:
	Gui, Submit, NoHide

	if (heartBeat) {
		GuiControl, Show, heartBeatName
		GuiControl, Show, heartBeatWebhookURL
		GuiControl, Show, hbName
		GuiControl, Show, hbURL
	}
	else {
		GuiControl, Hide, heartBeatName
		GuiControl, Hide, heartBeatWebhookURL
		GuiControl, Hide, hbName
		GuiControl, Hide, hbURL
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

ArrangeWindows:
	GuiControlGet, runMain,, runMain
	GuiControlGet, Mains,, Mains
	GuiControlGet, Instances,, Instances
	GuiControlGet, Columns,, Columns
	GuiControlGet, SelectedMonitorIndex,, SelectedMonitorIndex
	if (runMain) {
		Loop %Mains% {
			mainInstanceName := "Main" . (A_Index > 1 ? A_Index : "")
			resetWindows(mainInstanceName, SelectedMonitorIndex)
			sleep, 10
		}
	}
	Loop %Instances% {
		resetWindows(A_Index, SelectedMonitorIndex)
		sleep, 10
	}
return

LaunchAllMumu:
	GuiControlGet, Instances,, Instances
	GuiControlGet, folderPath,, folderPath
	GuiControlGet, runMain,, runMain
	GuiControlGet, Mains,, Mains
	GuiControlGet, instanceLaunchDelay,, instanceLaunchDelay

	IniWrite, %Instances%, Settings.ini, UserSettings, Instances
	IniWrite, %folderPath%, Settings.ini, UserSettings, folderPath
	IniWrite, %runMain%, Settings.ini, UserSettings, runMain
	IniWrite, %Mains%, Settings.ini, UserSettings, Mains
	IniWrite, %instanceLaunchDelay%, Settings.ini, UserSettings, instanceLaunchDelay

	launchAllFile := "LaunchAllMumu.ahk"
	if(FileExist(launchAllFile)) {
		Run, %launchAllFile%
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

	; Create the second page dynamically based on the number of instances
	Gui, Destroy ; Close the first page

	IniWrite, %FriendID%, Settings.ini, UserSettings, FriendID
	IniWrite, %waitTime%, Settings.ini, UserSettings, waitTime
	IniWrite, %Delay%, Settings.ini, UserSettings, Delay
	IniWrite, %folderPath%, Settings.ini, UserSettings, folderPath
	IniWrite, %discordWebhookURL%, Settings.ini, UserSettings, discordWebhookURL
	IniWrite, %discordUserId%, Settings.ini, UserSettings, discordUserId
	IniWrite, %Columns%, Settings.ini, UserSettings, Columns
	IniWrite, %openPack%, Settings.ini, UserSettings, openPack
	IniWrite, %godPack%, Settings.ini, UserSettings, godPack
	IniWrite, %Instances%, Settings.ini, UserSettings, Instances
	IniWrite, %instanceStartDelay%, Settings.ini, UserSettings, instanceStartDelay
	;IniWrite, %setSpeed%, Settings.ini, UserSettings, setSpeed
	IniWrite, %defaultLanguage%, Settings.ini, UserSettings, defaultLanguage
	IniWrite, %SelectedMonitorIndex%, Settings.ini, UserSettings, SelectedMonitorIndex
	IniWrite, %swipeSpeed%, Settings.ini, UserSettings, swipeSpeed
	IniWrite, %deleteMethod%, Settings.ini, UserSettings, deleteMethod
	IniWrite, %runMain%, Settings.ini, UserSettings, runMain
	IniWrite, %Mains%, Settings.ini, UserSettings, Mains
	IniWrite, %heartBeat%, Settings.ini, UserSettings, heartBeat
	IniWrite, %heartBeatWebhookURL%, Settings.ini, UserSettings, heartBeatWebhookURL
	IniWrite, %heartBeatName%, Settings.ini, UserSettings, heartBeatName
	IniWrite, %nukeAccount%, Settings.ini, UserSettings, nukeAccount
	IniWrite, %packMethod%, Settings.ini, UserSettings, packMethod
	IniWrite, %TrainerCheck%, Settings.ini, UserSettings, TrainerCheck
	IniWrite, %FullArtCheck%, Settings.ini, UserSettings, FullArtCheck
	IniWrite, %RainbowCheck%, Settings.ini, UserSettings, RainbowCheck
	IniWrite, %CrownCheck%, Settings.ini, UserSettings, CrownCheck
	IniWrite, %ImmersiveCheck%, Settings.ini, UserSettings, ImmersiveCheck
	IniWrite, %PseudoGodPack%, Settings.ini, UserSettings, PseudoGodPack
	IniWrite, %minStars%, Settings.ini, UserSettings, minStars
	IniWrite, %Palkia%, Settings.ini, UserSettings, Palkia
	IniWrite, %Dialga%, Settings.ini, UserSettings, Dialga
	IniWrite, %Arceus%, Settings.ini, UserSettings, Arceus
	IniWrite, %Mew%, Settings.ini, UserSettings, Mew
	IniWrite, %Pikachu%, Settings.ini, UserSettings, Pikachu
	IniWrite, %Charizard%, Settings.ini, UserSettings, Charizard
	IniWrite, %Mewtwo%, Settings.ini, UserSettings, Mewtwo
	IniWrite, %slowMotion%, Settings.ini, UserSettings, slowMotion

	IniWrite, %ocrLanguage%, Settings.ini, UserSettings, ocrLanguage
	IniWrite, %clientLanguage%, Settings.ini, UserSettings, clientLanguage
	IniWrite, %mainIdsURL%, Settings.ini, UserSettings, mainIdsURL
	IniWrite, %vipIdsURL%, Settings.ini, UserSettings, vipIdsURL
	IniWrite, %autoLaunchMonitor%, Settings.ini, UserSettings, autoLaunchMonitor
	IniWrite, %instanceLaunchDelay%, Settings.ini, UserSettings, instanceLaunchDelay


	; Using FriendID field to provide a URL to download ids.txt is deprecated.
    if (inStr(FriendID, "http")) {
    	MsgBox, To provide a URL for friend IDs, please use the ids.txt API field and leave the Friend ID field empty.

    	if (mainIdsURL = "") {
			IniWrite, "", Settings.ini, UserSettings, FriendID
			IniWrite, %FriendID%, Settings.ini, UserSettings, mainIdsURL
		}

    	Reload
    }

	; Download a new Main ID file prior to running the rest of the below
	if (mainIdsURL != "") {
		DownloadFile(mainIdsURL, "ids.txt")
	}

	; Run main before instances to account for instance start delay
	if (runMain) {
		Loop, %Mains%
		{
			if (A_Index != 1) {
				SourceFile := "Scripts\Main.ahk" ; Path to the source .ahk file
				TargetFolder := "Scripts\" ; Path to the target folder
				TargetFile := TargetFolder . "Main" . A_Index . ".ahk" ; Generate target file path
				FileDelete, %TargetFile%
				FileCopy, %SourceFile%, %TargetFile%, 1 ; Copy source file to target
				if (ErrorLevel)
					MsgBox, Failed to create %TargetFile%. Ensure permissions and paths are correct.
			}

			mainInstanceName := "Main" . (A_Index > 1 ? A_Index : "")
			FileName := "Scripts\" . mainInstanceName . ".ahk"
			Command := FileName

			if (A_Index > 1 && instanceStartDelay > 0) {
				instanceStartDelayMS := instanceStartDelay * 1000
				Sleep, instanceStartDelayMS
			}

			Run, %Command%
		}
	}

	; Loop to process each instance
	Loop, %Instances%
	{
		if (A_Index != 1) {
			SourceFile := "Scripts\1.ahk" ; Path to the source .ahk file
			TargetFolder := "Scripts\" ; Path to the target folder
			TargetFile := TargetFolder . A_Index . ".ahk" ; Generate target file path
			if(Instances > 1) {
				FileDelete, %TargetFile%
				FileCopy, %SourceFile%, %TargetFile%, 1 ; Copy source file to target
			}
			if (ErrorLevel)
				MsgBox, Failed to create %TargetFile%. Ensure permissions and paths are correct.
		}

		FileName := "Scripts\" . A_Index . ".ahk"
		Command := FileName

		if ((Mains > 1 || A_Index > 1) && instanceStartDelay > 0) {
			instanceStartDelayMS := instanceStartDelay * 1000
			Sleep, instanceStartDelayMS
		}

		; Clear out the last run time so that our monitor script doesn't try to kill and refresh this instance right away
		metricFile := A_ScriptDir . "\Scripts\" . A_Index . ".ini"
		if (FileExist(metricFile)) {
			IniWrite, 0, %metricFile%, Metrics, LastEndEpoch
		}

		Run, %Command%
	}

	if(autoLaunchMonitor) {
		monitorFile := "Monitor.ahk"
		if(FileExist(monitorFile)) {
			Run, %monitorFile%
		}
	}

	SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
	SysGet, Monitor, Monitor, %SelectedMonitorIndex%
	rerollTime := A_TickCount

	typeMsg := "\nType: " . deleteMethod
	injectMethod := false
	if(InStr(deleteMethod, "Inject"))
		injectMethod := true
	if(packMethod)
		typeMsg .= " (1P Method)"
	if(nukeAccount && !injectMethod)
		typeMsg .= " (Menu Delete)"

	selectMsg := "\nSelect: "
	if(Arceus)
		selectMsg .= "Arceus, "
	if(Palkia)
		selectMsg .= "Palkia, "
	if(Dialga)
		selectMsg .= "Dialga, "
	if(Mew)
		selectMsg .= "Mew, "
	if(Pikachu)
		selectMsg .= "Pikachu, "
	if(Charizard)
		selectMsg .= "Charizard, "
	if(Mewtwo)
		selectMsg .= "Mewtwo, "

	Loop {
		Sleep, 30000

		; Every 5 minutes, pull down the main ID list
		if(mainIdsURL != "" && Mod(A_Index, 10) = 0) {
			DownloadFile(mainIdsURL, "ids.txt")
		}

		; Sum all variable values and write to total.json
		total := SumVariablesInJsonFile()
		totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
		mminutes := Floor(totalSeconds / 60)

		packStatus := "Time: " . mminutes . "m Packs: " . total
		packStatus .= "   |   Avg: " . Round(total / mminutes, 2) . " packs/min"

		; Display pack status at the bottom of the first reroll instance
		CreateStatusMessage(packStatus, ((Mains * scaleParam) + 5), 490)

		if(heartBeat)
			if((A_Index = 1 || (Mod(A_Index, 60) = 0))) {
				onlineAHK := "Online: "
				offlineAHK := "Offline: "
				Online := []
				if(runMain) {
					IniRead, value, HeartBeat.ini, HeartBeat, Main
					if(value)
						onlineAHK := "Online: Main, "
					else
						offlineAHK := "Offline: Main, "
					IniWrite, 0, HeartBeat.ini, HeartBeat, Main
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
				discMessage .= typeMsg
				discMessage .= selectMsg
				if(heartBeatName)
					discordUserID := heartBeatName
				LogToDiscord(discMessage, , discordUserID)
			}
	}
Return

GuiClose:
ExitApp

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

resetWindows(Title, SelectedMonitorIndex) {
	global Columns, runMain, Mains
	RetryCount := 0
	MaxRetries := 10
	Loop
	{
		try {
			; Get monitor origin from index
			SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
			SysGet, Monitor, Monitor, %SelectedMonitorIndex%
			if (runMain) {
				if (InStr(Title, "Main") = 1) {
					instanceIndex := StrReplace(Title, "Main", "")
					if (instanceIndex = "")
						instanceIndex := 1
				} else {
					instanceIndex := (Mains - 1) + Title + 1
				}
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
		X := MonitorLeft + X
		Y := MonitorTop + Y
		Gui %GuiName%:+LastFoundExist
		if WinExist() {
			GuiControl, , PacksText, %Message%
		} else {			OwnerWND := WinExist(1)
			if(!OwnerWND)
				Gui, %GuiName%:New, +ToolWindow -Caption +LastFound
			else
				Gui, %GuiName%:New, +Owner%OwnerWND% +ToolWindow -Caption +LastFound
			Gui, %GuiName%:Margin, 2, 2  ; Set margin for the GUI
			Gui, %GuiName%:Font, s8  ; Set the font size to 8 (adjust as needed)
			Gui, %GuiName%:Add, Text, vPacksText, %Message%
			DllCall("SetWindowPos", "Ptr", WinExist(), "Ptr", WinExist("A")  ; set behind active window
				, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)  ; SWP_NOSIZE, SWP_NOMOVE, SWP_NOACTIVATE
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

CheckForUpdate() {
	global githubUser, repoName, localVersion, zipPath, extractPath, scriptFolder
	url := "https://api.github.com/repos/" githubUser "/" repoName "/releases/latest"

	response := HttpGet(url)
	if !response
	{
		MsgBox, Failed to fetch release info.
		return
	}
	latestReleaseBody := FixFormat(ExtractJSONValue(response, "body"))
	latestVersion := ExtractJSONValue(response, "tag_name")
	zipDownloadURL := ExtractJSONValue(response, "zipball_url")
	Clipboard := latestReleaseBody
	if (zipDownloadURL = "" || !InStr(zipDownloadURL, "http"))
	{
		MsgBox, Failed to find the ZIP download URL in the release.
		return
	}

	if (latestVersion = "")
	{
		MsgBox, Failed to retrieve version info.
		return
	}

	if (VersionCompare(latestVersion, localVersion) > 0)
	{
		; Get release notes from the JSON (ensure this is populated earlier in the script)
		releaseNotes := latestReleaseBody  ; Assuming `latestReleaseBody` contains the release notes

		; Show a message box asking if the user wants to download
		MsgBox, 4, Update Available %latestVersion%, %releaseNotes%`n`nDo you want to download the latest version?

		; If the user clicks Yes (return value 6)
		IfMsgBox, Yes
		{
			MsgBox, 64, Downloading..., Downloading the latest version...

			; Proceed with downloading the update
			URLDownloadToFile, %zipDownloadURL%, %zipPath%
			if ErrorLevel
			{
				MsgBox, Failed to download update.
				return
			}
			else {
				MsgBox, Download complete. Extracting...

				; Create a temporary folder for extraction
				tempExtractPath := A_Temp "\PTCGPB_Temp"
				FileCreateDir, %tempExtractPath%

				; Extract the ZIP file into the temporary folder
				RunWait, powershell -Command "Expand-Archive -Path '%zipPath%' -DestinationPath '%tempExtractPath%' -Force",, Hide

				; Check if extraction was successful
				if !FileExist(tempExtractPath)
				{
					MsgBox, Failed to extract the update.
					return
				}

				; Get the first subfolder in the extracted folder
				Loop, Files, %tempExtractPath%\*, D
				{
					extractedFolder := A_LoopFileFullPath
					break
				}

				; Check if a subfolder was found and move its contents recursively to the script folder
				if (extractedFolder)
				{
					MoveFilesRecursively(extractedFolder, scriptFolder)

					; Clean up the temporary extraction folder
					FileRemoveDir, %tempExtractPath%, 1
					MsgBox, Update installed. Restarting...
					Reload
				}
				else
				{
					MsgBox, Failed to find the extracted contents.
					return
				}
			}
		}
		else
		{
			MsgBox, The update was canceled.
			return
		}
	}
	else
	{
		MsgBox, You are running the latest version (%localVersion%).
	}
}

MoveFilesRecursively(srcFolder, destFolder) {
	; Loop through all files and subfolders in the source folder
	Loop, Files, % srcFolder . "\*", R
	{
		; Get the relative path of the file/folder from the srcFolder
		relativePath := SubStr(A_LoopFileFullPath, StrLen(srcFolder) + 2)

		; Create the corresponding destination path
		destPath := destFolder . "\" . relativePath

		; If it's a directory, create it in the destination folder
		if (A_LoopIsDir)
		{
			; Ensure the directory exists, if not, create it
			FileCreateDir, % destPath
		}
		else
		{
			if ((relativePath = "ids.txt" && FileExist(destPath)) || (relativePath = "usernames.txt" && FileExist(destPath)) || (relativePath = "discord.txt" && FileExist(destPath))) {
                continue
            }
			if (relativePath = "usernames.txt" && FileExist(destPath)) {
                continue
            }
			if (relativePath = "usernames.txt" && FileExist(destPath)) {
                continue
            }
			; If it's a file, move it to the destination folder
			; Ensure the directory exists before moving the file
			FileCreateDir, % SubStr(destPath, 1, InStr(destPath, "\", 0, 0) - 1)
			FileMove, % A_LoopFileFullPath, % destPath, 1
		}
	}
}

HttpGet(url) {
	http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	http.Open("GET", url, false)
	http.Send()
	return http.ResponseText
}

; Existing function to extract value from JSON
ExtractJSONValue(json, key1, key2:="", ext:="") {
	value := ""
	json := StrReplace(json, """", "")
	lines := StrSplit(json, ",")

	Loop, % lines.MaxIndex()
	{
		if InStr(lines[A_Index], key1 ":") {
			; Take everything after the first colon as the value
			value := SubStr(lines[A_Index], InStr(lines[A_Index], ":") + 1)
			if (key2 != "")
			{
				if InStr(lines[A_Index+1], key2 ":") && InStr(lines[A_Index+1], ext)
					value := SubStr(lines[A_Index+1], InStr(lines[A_Index+1], ":") + 1)
			}
			break
		}
	}
	return Trim(value)
}

FixFormat(text) {
	; Replace carriage return and newline with an actual line break
	text := StrReplace(text, "\r\n", "`n")  ; Replace \r\n with actual newlines
	text := StrReplace(text, "\n", "`n")    ; Replace \n with newlines

	; Remove unnecessary backslashes before other characters like "player" and "None"
	text := StrReplace(text, "\player", "player")   ; Example: removing backslashes around words
	text := StrReplace(text, "\None", "None")       ; Remove backslash around "None"
	text := StrReplace(text, "\Welcome", "Welcome") ; Removing \ before "Welcome"

	; Escape commas by replacing them with %2C (URL encoding)
	text := StrReplace(text, ",", "")

	return text
}

VersionCompare(v1, v2) {
	; Remove non-numeric characters (like 'alpha', 'beta')
	cleanV1 := RegExReplace(v1, "[^\d.]")
	cleanV2 := RegExReplace(v2, "[^\d.]")

	v1Parts := StrSplit(cleanV1, ".")
	v2Parts := StrSplit(cleanV2, ".")

	Loop, % Max(v1Parts.MaxIndex(), v2Parts.MaxIndex()) {
		num1 := v1Parts[A_Index] ? v1Parts[A_Index] : 0
		num2 := v2Parts[A_Index] ? v2Parts[A_Index] : 0
		if (num1 > num2)
			return 1
		if (num1 < num2)
			return -1
	}

	; If versions are numerically equal, check if one is an alpha version
	isV1Alpha := InStr(v1, "alpha") || InStr(v1, "beta")
	isV2Alpha := InStr(v2, "alpha") || InStr(v2, "beta")

	if (isV1Alpha && !isV2Alpha)
		return -1 ; Non-alpha version is newer
	if (!isV1Alpha && isV2Alpha)
		return 1 ; Alpha version is older

	return 0 ; Versions are equal
}

~+F7::ExitApp
