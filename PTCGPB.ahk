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

KillADBProcesses()

global Instances, jsonFileName, PacksText

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

; Create the main GUI for selecting number of instances
	IniRead, FriendID, Settings.ini, UserSettings, FriendID
	IniRead, waitTime, Settings.ini, UserSettings, waitTime, 5
	IniRead, Delay, Settings.ini, UserSettings, Delay, 250
	IniRead, folderPath, Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
	IniRead, discordWebhookURL, Settings.ini, UserSettings, discordWebhookURL, ""
	IniRead, discordUserId, Settings.ini, UserSettings, discordUserId, ""
	IniRead, changeDate, Settings.ini, UserSettings, ChangeDate, 0100
	IniRead, Columns, Settings.ini, UserSettings, Columns, 5
	IniRead, openPack, Settings.ini, UserSettings, openPack, Palkia
	IniRead, godPack, Settings.ini, UserSettings, godPack, Continue
	IniRead, Instances, Settings.ini, UserSettings, Instances, 1
	IniRead, setSpeed, Settings.ini, UserSettings, setSpeed, 1x/3x
	IniRead, defaultLanguage, Settings.ini, UserSettings, defaultLanguage, Scale125
	IniRead, SelectedMonitorIndex, Settings.ini, UserSettings, SelectedMonitorIndex, 1
	IniRead, swipeSpeed, Settings.ini, UserSettings, swipeSpeed, 600
	IniRead, skipInvalidGP, Settings.ini, UserSettings, skipInvalidGP, Yes
	IniRead, deleteMethod, Settings.ini, UserSettings, deleteMethod, 3Pack

; Main GUI setup
; Add the link text at the bottom of the GUI

Gui, Show, w500 h640, Arturo's PTCGPB Bot Setup ;' Ensure the GUI size is appropriate

Gui, Color, White  ; Set the background color to white
Gui, Font, s10 Bold , Segoe UI 
; Add the button image on top of the GUI
;Gui, Add, Picture, gStart x196 y196 w108 h108 vImageButton  +BackgroundTrans, %normalImage%
Gui, Add, Button, gArrangeWindows x215 y208 w70 h32, Arrange Windows
Gui, Add, Button, gStart x227 y258 w46 h32 vArrangeWindows, Start

Gui, Add, Text, x0 y604 w640 h30 gOpenLink cBlue Center +BackgroundTrans
Gui, Add, Text, x265 y532 w167 h50 gOpenDiscord cBlue Center +BackgroundTrans
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
	
Gui, Add, Edit, vInstances x275 y95 w72 Center, %Instances%
Gui, Add, Edit, vColumns x348 y95 w72 Center, %Columns%

; Pack selection logic
if (openPack = "Palkia") {
	defaultPack := 1
} else if (openPack = "Dialgia") {
	defaultPack := 2
} else if (openPack = "Mew") {
	defaultPack := 3
} 

Gui, Add, DropDownList, x80 y166 w145 vopenPack choose%defaultPack% Center, Palkia|Dialgia|Mew
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
if (setSpeed = "2x") {
	defaultSpeed := 1
} else if (setSpeed = "1x/2x") {
	defaultSpeed := 2
} else if (setSpeed = "1x/3x") {
	defaultSpeed := 3
}
Gui, Add, DropDownList, x275 y404 w72 vsetSpeed choose%defaultSpeed% Center, 2x|1x/2x|1x/3x


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

Gui, Add, Edit, vwaitTime x275 y166 w145 Center, %waitTime%

; Pack selection logic
if (skipInvalidGP = "No") {
	defaultskipGP := 1
} else if (skipInvalidGP = "Yes") {
	defaultskipGP := 2
}

Gui, Add, DropDownList, x80 y476 w145 vskipInvalidGP choose%defaultskipGP% Center, No|Yes

; Pack selection logic
if (deleteMethod = "3Pack") {
	defaultDelete := 1
} else if (deleteMethod = "1Pack") {
	defaultDelete := 2
} else if (deleteMethod = "Inject(Not available yet)") {
	defaultDelete := 3
} else if (deleteMethod = "Safer(not available yet)") {
	defaultDelete := 4
}

Gui, Add, DropDownList, x80 y546 w145 vdeleteMethod choose%defaultDelete% Center, 3Pack|1Pack|Inject(Not available yet)|Safer(not available yet)

Gui, Font, s10 Bold, Segoe UI 
Gui, Add, Edit, vfolderPath x80 y404 w145 h35 Center, %folderPath%

if(StrLen(discordUserID) > 2)
	Gui, Add, Edit, vdiscordUserId x273 y476 w72 h35 Center, %discordUserId%
else
	Gui, Add, Edit, vdiscordUserId x273 y476 w72 h35 Center
	
if(StrLen(discordWebhookURL) > 2)
	Gui, Add, Edit, vdiscordWebhookURL x348 y476 w72 h35 Center, %discordWebhookURL%
else
	Gui, Add, Edit, vdiscordWebhookURL x348 y476 w72 h35 Center



Gui, Font, s10 cGray Norm Bold, Segoe UI  ; Normal font for input labels
Gui Add, Button, x190 y72 w17 h19 gShowMsgName, ? ;Questionmark box for Name Field
Gui Add, Button, x342 y77 w17 h19 gShowMsgInstances, ? ;Questionmark box for Instance Field
Gui Add, Button, x415 y77 w17 h19 gShowMsgColumns, ? ;Questionmark box for Instance Per Row Field

Gui Add, Button, x190 y145 w17 h19 gShowMsgPacks, ? ;Questionmark box for Pack to Open Field
Gui Add, Button, x423 y145 w17 h19 gShowMsgGodPacks, ? ;Questionmark box for God Pack to Open Field

Gui Add, Button, x78 y219 w17 h19 gShowMsgLanguage, ? ;Questionmark box for God Pack to Open Field
Gui Add, Button, x400 y219 w17 h19 gShowMsgMonitor, ? ;Questionmark box for God Pack to Open Field

Gui Add, Button, x192 y307 w17 h19 gShowMsgDelay, ? ;Questionmark box for Delay in ms Field
Gui Add, Button, x411 y307 w17 h19 gShowMsgTimeZone, ? ;Questionmark box for Timezone Field

Gui Add, Button, x193 y378 w17 h19 gShowMsgFolder, ? ;Questionmark box for SwipeSpeed Field
Gui Add, Button, x343 y378 w17 h19 gShowMsgSpeed, ? ;Questionmark box for Speed Field
Gui Add, Button, x408 y378 w17 h19 gShowMsgSwipeSpeed, ? ;Questionmark box for SwipeSpeed Field

Gui Add, Button, x428 y448 w17 h19 gShowMsgdiscordwebHook, ? ;Questionmark box for discord id Field
Gui Add, Button, x330 y448 w17 h19 gShowMsgdiscordID, ? ;Questionmark box for discord web hook Field

Gui Add, Button, x230 y518 w17 h19 gShowMsgAccountDeletion, ? ;Questionmark box for Account Deletion to Open Field
Gui Add, Button, x235 y448 w17 h19 gShowMsgSkipGP, ? ;Questionmark box for Account Deletion to Open Field

; Show the GUI
Gui, Show
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

; Create the second page dynamically based on the number of instances
Gui, Destroy ; Close the first page

IniWrite, %FriendID%, Settings.ini, UserSettings, FriendID
IniWrite, %waitTime%, Settings.ini, UserSettings, waitTime
IniWrite, %Delay%, Settings.ini, UserSettings, Delay
IniWrite, %folderPath%, Settings.ini, UserSettings, folderPath
IniWrite, %discordWebhookURL%, Settings.ini, UserSettings, discordWebhookURL
IniWrite, %discordUserId%, Settings.ini, UserSettings, discordUserId
IniWrite, %ChangeDate%, Settings.ini, UserSettings, ChangeDate
IniWrite, %Columns%, Settings.ini, UserSettings, Columns
IniWrite, %openPack%, Settings.ini, UserSettings, openPack
IniWrite, %godPack%, Settings.ini, UserSettings, godPack
IniWrite, %Instances%, Settings.ini, UserSettings, Instances
IniWrite, %setSpeed%, Settings.ini, UserSettings, setSpeed
IniWrite, %defaultLanguage%, Settings.ini, UserSettings, defaultLanguage
IniWrite, %SelectedMonitorIndex%, Settings.ini, UserSettings, SelectedMonitorIndex
IniWrite, %swipeSpeed%, Settings.ini, UserSettings, swipeSpeed
IniWrite, %skipInvalidGP%, Settings.ini, UserSettings, skipInvalidGP
IniWrite, %deleteMethod%, Settings.ini, UserSettings, deleteMethod

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
if(FriendID) {
	FileName := "Scripts\Main.ahk"
	Run, %FileName%
}
SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
SysGet, Monitor, Monitor, %SelectedMonitorIndex%
rerollTime := A_TickCount

Loop {
	; Sum all variable values and write to total.json
	total := SumVariablesInJsonFile()
	totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
	mminutes := Floor(totalSeconds / 60)
	if(total = 0)
	total := "0                             "
	CreateStatusMessage("Time: " . mminutes . "m Packs: " . total, 287, 490)
	Sleep, 10000
}
Return

GuiClose:
ExitApp

resetWindows(Title, SelectedMonitorIndex){
	global Columns
	RetryCount := 0
	MaxRetries := 10
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
