version = Arturos PTCGP Bot
#SingleInstance, force
CoordMode, Mouse, Screen
SetTitleMatchMode, 3

githubUser := "Arturo-1212"
repoName := "PTCGPB"
localVersion := "v6.3.26"
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
IniRead, CheckShiningPackOnly, Settings.ini, UserSettings, CheckShiningPackOnly, 0
IniRead, TrainerCheck, Settings.ini, UserSettings, TrainerCheck, 0
IniRead, FullArtCheck, Settings.ini, UserSettings, FullArtCheck, 0
IniRead, RainbowCheck, Settings.ini, UserSettings, RainbowCheck, 0
IniRead, ShinyCheck, Settings.ini, UserSettings, ShinyCheck, 0
IniRead, CrownCheck, Settings.ini, UserSettings, CrownCheck, 0
IniRead, ImmersiveCheck, Settings.ini, UserSettings, ImmersiveCheck, 0
IniRead, InvalidCheck, Settings.ini, UserSettings, InvalidCheck, 0
IniRead, PseudoGodPack, Settings.ini, UserSettings, PseudoGodPack, 0
IniRead, minStars, Settings.ini, UserSettings, minStars, 0
IniRead, Palkia, Settings.ini, UserSettings, Palkia, 0
IniRead, Dialga, Settings.ini, UserSettings, Dialga, 0
IniRead, Arceus, Settings.ini, UserSettings, Arceus, 0
IniRead, Shining, Settings.ini, UserSettings, Shining, 1
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

IniRead, minStarsA1Charizard, Settings.ini, UserSettings, minStarsA1Charizard, 0
IniRead, minStarsA1Mewtwo, Settings.ini, UserSettings, minStarsA1Mewtwo, 0
IniRead, minStarsA1Pikachu, Settings.ini, UserSettings, minStarsA1Pikachu, 0
IniRead, minStarsA1a, Settings.ini, UserSettings, minStarsA1a, 0
IniRead, minStarsA2Dialga, Settings.ini, UserSettings, minStarsA2Dialga, 0
IniRead, minStarsA2Palkia, Settings.ini, UserSettings, minStarsA2Palkia, 0
IniRead, minStarsA2a, Settings.ini, UserSettings, minStarsA2a, 0
IniRead, minStarsA2b, Settings.ini, UserSettings, minStarsA2b, 0

IniRead, heartBeatDelay, Settings.ini, UserSettings, heartBeatDelay, 30
IniRead, sendAccountXml, Settings.ini, UserSettings, sendAccountXml, 0

; Create a stylish GUI with custom colors and modern look
Gui, Color, 1E1E1E, 333333 ; Dark theme background
Gui, Font, s10 cWhite, Segoe UI ; Modern font



; ========== Column 1 ==========
; ==============================

; ========== Friend ID Section ==========
sectionColor := "cWhite"
Gui, Add, GroupBox, x5 y0 w240 h50 %sectionColor%, Friend ID
if(FriendID = "ERROR" || FriendID = "")
	FriendID =
Gui, Add, Edit, vFriendID w180 x35 y20 h20 -E0x200 Background2A2A2A cWhite, %FriendID%

; ========== Instance Settings Section ==========
sectionColor := "cWhite"
Gui, Add, GroupBox, x5 y50 w240 h130 %sectionColor%, Instance Settings
Gui, Add, Text, x20 y75 %sectionColor%, Instances:
Gui, Add, Edit, vInstances w50 x125 y73 h20 -E0x200 Background2A2A2A cWhite Center, %Instances%
Gui, Add, Text, x20 y100 %sectionColor%, Columns:
Gui, Add, Edit, vColumns w50 x125 y98 h20 -E0x200 Background2A2A2A cWhite Center, %Columns%
Gui, Add, Text, x20 y125 %sectionColor%, Start Delay (sec):
Gui, Add, Edit, vinstanceStartDelay w50 x125 y123 h20 -E0x200 Background2A2A2A cWhite Center, %instanceStartDelay%

Gui, Add, Checkbox, % (runMain ? "Checked" : "") " vrunMain gmainSettings x20 y150 " . sectionColor, Run Main(s)
Gui, Add, Edit, % "vMains w50 x125 y148 h20 -E0x200 Background2A2A2A " . sectionColor . " Center" . (runMain ? "" : " Hidden"), %Mains%

; ========== Time Settings Section ==========
sectionColor := "c9370DB" ; Purple
Gui, Add, GroupBox, x5 y180 w240 h125 %sectionColor%, Time Settings
Gui, Add, Text, x20 y205 %sectionColor%, Action Delay (ms):
Gui, Add, Edit, vDelay w60 x145 y203 h20 -E0x200 Background2A2A2A cWhite Center, %Delay%
Gui, Add, Text, x20 y230 %sectionColor%, Swipe Speed (ms):
Gui, Add, Edit, vswipeSpeed w60 x145 y228 h20 -E0x200 Background2A2A2A cWhite Center, %swipeSpeed%
Gui, Add, Text, x20 y255 %sectionColor%, Wait Time (sec):
Gui, Add, Edit, vwaitTime w60 x145 y253 h20 -E0x200 Background2A2A2A cWhite Center, %waitTime%
Gui, Add, Checkbox, % (slowMotion ? "Checked" : "") " vslowMotion x20 y280 " . sectionColor, Base Game Compatibility

; ========== System Settings Section ==========
sectionColor := "c4169E1" ; Royal Blue
Gui, Add, GroupBox, x5 y305 w240 h210 %sectionColor%, System Settings
Gui, Add, Text, x20 y325 %sectionColor%, Monitor:
SysGet, MonitorCount, MonitorCount
MonitorOptions := ""
Loop, %MonitorCount% {
	SysGet, MonitorName, MonitorName, %A_Index%
	SysGet, Monitor, Monitor, %A_Index%
	MonitorOptions .= (A_Index > 1 ? "|" : "") "" A_Index ": (" MonitorRight - MonitorLeft "x" MonitorBottom - MonitorTop ")"
}
SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
Gui, Add, DropDownList, x20 y345 w125 vSelectedMonitorIndex Choose%SelectedMonitorIndex% Background2A2A2A cWhite, %MonitorOptions%
Gui, Add, Text, x155 y325 %sectionColor%, Scale:
if (defaultLanguage = "Scale125") {
	defaultLang := 1
	scaleParam := 277
} else if (defaultLanguage = "Scale100") {
	defaultLang := 2  
	scaleParam := 287
}
Gui, Add, DropDownList, x155 y345 w75 vdefaultLanguage choose%defaultLang% Background2A2A2A cWhite, Scale125|Scale100
Gui, Add, Text, x20 y375 %sectionColor%, Folder Path:
Gui, Add, Edit, vfolderPath w210 x20 y395 h20 -E0x200 Background2A2A2A cWhite, %folderPath%

Gui, Add, Text, x20 y425 %sectionColor%, OCR:

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

Gui, Add, DropDownList, vocrLanguage choose%defaultOcrLang% x60 y420 w50 Background2A2A2A cWhite, %ocrLanguageList%

Gui, Add, Text, x125 y425 %sectionColor%, Client:

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

Gui, Add, DropDownList, vclientLanguage choose%defaultClientLang% x170 y420 w50 Background2A2A2A cWhite, %clientLanguageList%

Gui, Add, Text, x20 y455 %sectionColor%, Launch All Mumu Delay:
Gui, Add, Edit, vinstanceLaunchDelay w50 x170 y453 h20 -E0x200 Background2A2A2A cWhite Center, %instanceLaunchDelay%
Gui, Add, Checkbox, % (autoLaunchMonitor ? "Checked" : "") " vautoLaunchMonitor x20 y480 " . sectionColor, Auto Launch Monitor



; ========== Column 2 ==========
; ==============================

; ========== God Pack Settings Section ==========
sectionColor := "c39FF14" ; Neon green
Gui, Add, GroupBox, x255 y0 w240 h130 %sectionColor%, God Pack Settings
Gui, Add, Text, x270 y25 %sectionColor%, Min. 2 Stars:
Gui, Add, Edit, vminStars w25 x350 y23 h20 -E0x200 Background2A2A2A cWhite Center, %minStars%
Gui, Add, Text, x390 y25 %sectionColor%, 2* for SR:
Gui, Add, Edit, vminStarsA2b w25 x450 y23 h20 -E0x200 Background2A2A2A cWhite Center, %minStarsA2b%

Gui, Add, Text, x270 y53 %sectionColor%, Method:
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
Gui, Add, Checkbox, % (packMethod ? "Checked" : "") " vpackMethod x280 y80 " . sectionColor, 1 Pack Method
Gui, Add, Checkbox, % (nukeAccount ? "Checked" : "") " vnukeAccount x280 y100 " . sectionColor, Menu Delete Account

; ========== Pack Selection Section ==========
sectionColor := "cFFD700" ; Gold
Gui, Add, GroupBox, x255 y130 w240 h115 %sectionColor%, Pack Selection
Gui, Add, Checkbox, % (Shining ? "Checked" : "") " vShining x280 y155 " . sectionColor, Shining
Gui, Add, Checkbox, % (Arceus ? "Checked" : "") " vArceus x280 y175 " . sectionColor, Arceus
Gui, Add, Checkbox, % (Palkia ? "Checked" : "") " vPalkia x280 y195 " . sectionColor, Palkia
Gui, Add, Checkbox, % (Dialga ? "Checked" : "") " vDialga x280 y215 " . sectionColor, Dialga
Gui, Add, Checkbox, % (Pikachu ? "Checked" : "") " vPikachu x365 y155 " . sectionColor, Pikachu
Gui, Add, Checkbox, % (Charizard ? "Checked" : "") " vCharizard x365 y175 " . sectionColor, Charizard
Gui, Add, Checkbox, % (Mewtwo ? "Checked" : "") " vMewtwo x365 y195 " . sectionColor, Mewtwo
Gui, Add, Checkbox, % (Mew ? "Checked" : "") " vMew x365 y215 " . sectionColor, Mew

; ========== Card Detection Section ==========
sectionColor := "cFF4500" ; Orange Red
Gui, Add, GroupBox, x255 y245 w240 h160 %sectionColor%, Card Detection ; Orange Red
Gui, Add, Checkbox, % (FullArtCheck ? "Checked" : "") " vFullArtCheck x270 y270 " . sectionColor, Single Full Art
Gui, Add, Checkbox, % (TrainerCheck ? "Checked" : "") " vTrainerCheck x385 y270 " . sectionColor, Single Trainer
Gui, Add, Checkbox, % (RainbowCheck ? "Checked" : "") " vRainbowCheck x270 y290 " . sectionColor, Single Rainbow
Gui, Add, Checkbox, % (PseudoGodPack ? "Checked" : "") " vPseudoGodPack x385 y290 " . sectionColor, Double 2 Star
Gui, Add, Checkbox, % (CheckShiningPackOnly ? "Checked" : "") " vCheckShiningPackOnly x270 y310 " . sectionColor, Only for Shining

Gui, Add, Checkbox, % (CrownCheck ? "Checked" : "") " vCrownCheck x270 y335 " . sectionColor, Save Crowns
Gui, Add, Checkbox, % (ShinyCheck ? "Checked" : "") " vShinyCheck x385 y335 " . sectionColor, Save Shiny
Gui, Add, Checkbox, % (ImmersiveCheck ? "Checked" : "") " vImmersiveCheck x270 y355 " . sectionColor, Save Immersives
Gui, Add, Checkbox, % (InvalidCheck ? "Checked" : "") " vInvalidCheck x270 y375 " . sectionColor, Ignore Invalid


; ========== Column 3 ==========
; ==============================

; ========== Discord Settings Section ==========
sectionColor := "cFF69B4" ; Hot pink
Gui, Add, GroupBox, x505 y0 w240 h130 %sectionColor%, Discord Settings
if(StrLen(discordUserID) < 3)
	discordUserID =
if(StrLen(discordWebhookURL) < 3)
	discordWebhookURL =
Gui, Add, Text, x520 y20 %sectionColor%, Discord ID:
Gui, Add, Edit, vdiscordUserId w210 x520 y40 h20 -E0x200 Background2A2A2A cWhite, %discordUserId%
Gui, Add, Text, x520 y60 %sectionColor%, Webhook URL:
Gui, Add, Edit, vdiscordWebhookURL w210 x520 y80 h20 -E0x200 Background2A2A2A cWhite, %discordWebhookURL%
Gui, Add, Checkbox, % (sendAccountXml ? "Checked" : "") " vsendAccountXml x520 y105 " . sectionColor, Send Account XML

; ========== Heartbeat Settings Section ==========
sectionColor := "c00FFFF" ; Cyan
Gui, Add, GroupBox, x505 y130 w240 h160 %sectionColor%, Heartbeat Settings
Gui, Add, Checkbox, % (heartBeat ? "Checked" : "") " vheartBeat x520 y155 gdiscordSettings " . sectionColor, Discord Heartbeat

if(StrLen(heartBeatName) < 3)
	heartBeatName =
if(StrLen(heartBeatWebhookURL) < 3)
	heartBeatWebhookURL =

if (heartBeat) {
	Gui, Add, Text, vhbName x520 y175 %sectionColor%, Name:
	Gui, Add, Edit, vheartBeatName w210 x520 y195 h20 -E0x200 Background2A2A2A cWhite, %heartBeatName%
	Gui, Add, Text, vhbURL x520 y215 %sectionColor%, Webhook URL:
	Gui, Add, Edit, vheartBeatWebhookURL w210 x520 y235 h20 -E0x200 Background2A2A2A cWhite, %heartBeatWebhookURL%
	Gui, Add, Text, vhbDelay x520 y260 %sectionColor%, Heartbeat Delay (min):
	Gui, Add, Edit, vheartBeatDelay w50 x660 y260 h20 -E0x200 Background2A2A2A cWhite Center, %heartBeatDelay%
} else {
	Gui, Add, Text, vhbName x520 y175 Hidden %sectionColor%, Name:
	Gui, Add, Edit, vheartBeatName w210 x520 y195 h20 Hidden -E0x200 Background2A2A2A cWhite, %heartBeatName%
	Gui, Add, Text, vhbURL x520 y215 Hidden %sectionColor%, Webhook URL:
	Gui, Add, Edit, vheartBeatWebhookURL w210 x520 y235 h20 Hidden -E0x200 Background2A2A2A cWhite, %heartBeatWebhookURL%
	Gui, Add, Text, vhbDelay x520 y260 Hidden %sectionColor%, Heartbeat Delay (min):
	Gui, Add, Edit, vheartBeatDelay w50 x660 y260 h20 Hidden -E0x200 Background2A2A2A cWhite Center, %heartBeatDelay%
}

; ========== Action Buttons ==========
Gui, Add, Button, gOpenLink x505 y370 w77 h35, Buy Me a Coffee
Gui, Add, Button, gCheckForUpdates x587 y370 w77 h35, Check Updates
Gui, Add, Button, gOpenDiscord x669 y370 w77 h35, Join Discord
Gui, Add, Button, gStart x505 y300 w240 h30, START BOT
Gui, Add, Button, gArrangeWindows x628 y335 w117 h30, Arrange Windows
Gui, Add, Button, gLaunchAllMumu x505 y335 w118 h30, Launch All Mumu


; ========== Download Settings Section (Bottom right) ==========
sectionColor := "cWhite"
Gui, Add, GroupBox, x255 y405 w490 h110 %sectionColor%, Download Settings ;

if(StrLen(mainIdsURL) < 3)
	mainIdsURL =
if(StrLen(vipIdsURL) < 3)
	vipIdsURL =

Gui, Add, Text, x270 y425 %sectionColor%, ids.txt API:
Gui, Add, Edit, vmainIdsURL w460 x270 y445 h20 -E0x200 Background2A2A2A cWhite, %mainIdsURL%
Gui, Add, Text, x270 y465 %sectionColor%, vip_ids.txt (GP Test Mode) API:
Gui, Add, Edit, vvipIdsURL w460 x270 y485 h20 -E0x200 Background2A2A2A cWhite, %vipIdsURL%

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
		GuiControl, Show, heartBeatDelay
		GuiControl, Show, hbName
		GuiControl, Show, hbURL
		GuiControl, Show, hbDelay
	}
	else {
		GuiControl, Hide, heartBeatName
		GuiControl, Hide, heartBeatWebhookURL
		GuiControl, Hide, heartBeatDelay
		GuiControl, Hide, hbName
		GuiControl, Hide, hbURL
		GuiControl, Hide, hbDelay
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

defaultLangSetting:
	global scaleParam
	GuiControlGet, defaultLanguage,, defaultLanguage
	if (defaultLanguage = "Scale125")
		scaleParam := 277
	else if (defaultLanguage = "Scale100")
		scaleParam := 287
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
	IniWrite, %CheckShiningPackOnly%, Settings.ini, UserSettings, CheckShiningPackOnly
	IniWrite, %TrainerCheck%, Settings.ini, UserSettings, TrainerCheck
	IniWrite, %FullArtCheck%, Settings.ini, UserSettings, FullArtCheck
	IniWrite, %RainbowCheck%, Settings.ini, UserSettings, RainbowCheck
	IniWrite, %ShinyCheck%, Settings.ini, UserSettings, ShinyCheck
	IniWrite, %CrownCheck%, Settings.ini, UserSettings, CrownCheck
	IniWrite, %InvalidCheck%, Settings.ini, UserSettings, InvalidCheck
	IniWrite, %ImmersiveCheck%, Settings.ini, UserSettings, ImmersiveCheck
	IniWrite, %PseudoGodPack%, Settings.ini, UserSettings, PseudoGodPack
	IniWrite, %minStars%, Settings.ini, UserSettings, minStars
	IniWrite, %Palkia%, Settings.ini, UserSettings, Palkia
	IniWrite, %Dialga%, Settings.ini, UserSettings, Dialga
	IniWrite, %Arceus%, Settings.ini, UserSettings, Arceus
	IniWrite, %Shining%, Settings.ini, UserSettings, Shining
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

	minStarsA1Charizard := minStars
	minStarsA1Mewtwo := minStars
	minStarsA1Pikachu := minStars
	minStarsA1a := minStars
	minStarsA2Dialga := minStars
	minStarsA2Palkia := minStars
	minStarsA2a := minStars

	IniWrite, %minStarsA1Charizard%, Settings.ini, UserSettings, minStarsA1Charizard
	IniWrite, %minStarsA1Mewtwo%, Settings.ini, UserSettings, minStarsA1Mewtwo
	IniWrite, %minStarsA1Pikachu%, Settings.ini, UserSettings, minStarsA1Pikachu
	IniWrite, %minStarsA1a%, Settings.ini, UserSettings, minStarsA1a
	IniWrite, %minStarsA2Dialga%, Settings.ini, UserSettings, minStarsA2Dialga
	IniWrite, %minStarsA2Palkia%, Settings.ini, UserSettings, minStarsA2Palkia
	IniWrite, %minStarsA2a%, Settings.ini, UserSettings, minStarsA2a
	IniWrite, %minStarsA2b%, Settings.ini, UserSettings, minStarsA2b
	
	IniWrite, %heartBeatDelay%, Settings.ini, UserSettings, heartBeatDelay
	IniWrite, %sendAccountXml%, Settings.ini, UserSettings, sendAccountXml
	
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
	if(Shining)
		selectMsg .= "Shining, "
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
			if((A_Index = 1 || (Mod(A_Index, (heartBeatDelay // 0.5)) = 0))) {
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



				discMessage := "\n" . onlineAHK . "\n" . offlineAHK . "\n" . packStatus . "\nVersion: " . RegExReplace(githubUser, "-.*$") . "-" . localVersion
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
	global Columns, runMain, Mains, scaleParam
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
			if ((relativePath = "ids.txt" && FileExist(destPath))
				|| (relativePath = "usernames.txt" && FileExist(destPath))
				|| (relativePath = "discord.txt" && FileExist(destPath))
				|| (relativePath = "vip_ids.txt" && FileExist(destPath))) {
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
