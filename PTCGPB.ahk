version = Arturos PTCGP Bot
#SingleInstance, force
CoordMode, Mouse, Screen
SetTitleMatchMode, 3

global Instances, adbPorts, jsonFileName, PacksText

totalFile := A_ScriptDir . "\json\total.json"
totalContent := "{""total_sum"": " sum "}"
FileDelete, %totalFile%
InitializeJsonFile() ; Create or open the JSON file

; Create the main GUI for selecting number of instances
    IniRead, Name, Settings.ini, UserSettings, Name, player1
    IniRead, Delay, Settings.ini, UserSettings, Delay, 250
    IniRead, folderPath, Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
    IniRead, discordWebhookURL, Settings.ini, UserSettings, discordWebhookURL, ""
    IniRead, discordUserId, Settings.ini, UserSettings, discordUserId, ""
    IniRead, telegramToken, Settings.ini, UserSettings, telegramToken, ""
    IniRead, telegramChatID, Settings.ini, UserSettings, telegramChatID, ""
    IniRead, telegramTopicID, Settings.ini, UserSettings, telegramTopicID, ""
    IniRead, changeDate, Settings.ini, UserSettings, ChangeDate, 0100
    IniRead, Columns, Settings.ini, UserSettings, Columns, 5
    IniRead, openPack, Settings.ini, UserSettings, openPack, Mew
    IniRead, godPack, Settings.ini, UserSettings, godPack, Close
    IniRead, Instances, Settings.ini, UserSettings, Instances, 10
	IniRead, setSpeed, Settings.ini, UserSettings, setSpeed, 2x
    IniRead, defaultLanguage, Settings.ini, UserSettings, defaultLanguage, English
    IniRead, SelectedMonitorIndex, Settings.ini, UserSettings, SelectedMonitorIndex, 1
    IniRead, swipeSpeed, Settings.ini, UserSettings, swipeSpeed, 600
    IniRead, falsePositive, Settings.ini, UserSettings, falsePositive, No
    IniRead, skipInvalidGP, Settings.ini, UserSettings, skipInvalidGP, Yes

; Main GUI setup
; Add the link text at the bottom of the GUI

Gui, Show, w500 h570, Arturo's PTCGPB Bot Setup ;' Ensure the GUI size is appropriate

Gui, Color, White  ; Set the background color to white
Gui, Font, s10 Bold , Segoe UI 
; Add the button image on top of the GUI
;Gui, Add, Picture, gStart x196 y196 w108 h108 vImageButton  +BackgroundTrans, %normalImage%
Gui, Add, Button, gArrangeWindows x215 y208 w70 h32, Arrange Windows
Gui, Add, Button, gStart x227 y258 w46 h32 vArrangeWindows, Start

Gui, Add, Text, x0 y534 w570 h30 vLinkText gOpenLink cBlue Center +BackgroundTrans
Gui, Font, s15 Bold , Segoe UI
; Add the background image to the GUI
Gui, Add, Picture, x0 y0 w500 h570, %A_ScriptDir%\Scripts\GUI\GUI.png

; Add input controls
Gui, Add, Edit, vName x80 y95 w145 Center, %Name%
Gui, Add, Edit, vInstances x275 y95 w72 Center, %Instances%
Gui, Add, Edit, vColumns x348 y95 w72 Center, %Columns%

; Pack selection logic
if (openPack = "Mewtwo") {
    defaultPack := 1
} else if (openPack = "Pikachu") {
    defaultPack := 2
} else if (openPack = "Charizard") {
    defaultPack := 3
} else if (openPack = "Mew") {
    defaultPack := 4
} else if (openPack = "Random") {
    defaultPack := 5
}

Gui, Add, DropDownList, x80 y166 w145 vopenPack choose%defaultPack% Center, Mewtwo|Pikachu|Charizard|Mew|Random

if (defaultLanguage = "English") {
    defaultLang := 1
} else if (defaultLanguage = "Japanese") {
    defaultLang := 2
} else if (defaultLanguage = "French") {
    defaultLang := 3
} else if (defaultLanguage = "Korean") {
    defaultLang := 4
} else if (defaultLanguage = "Chinese") {
    defaultLang := 5
} else if (defaultLanguage = "Italian") {
    defaultLang := 6
}

global scaleParam
if (defaultLanguage = "English100") {
    defaultLang := 7
    scaleParam := 287
} else {
    scaleParam := 277
}

Gui, Add, DropDownList, x80 y245 w145 vdefaultLanguage choose%defaultLang%, English|Japanese|French|Korean|Chinese|Italian|English100

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
if (godPack = "Close") {
    defaultgodPack := 1
} else if (godPack = "Pause") {
    defaultgodPack := 2
}

Gui, Add, DropDownList, x275 y166 w72 vgodPack choose%defaultgodPack% Center, Close|Pause

; Pack selection logic
if (falsePositive = "No") {
    defaultFP := 1
} else if (falsePositive = "Yes") {
    defaultFP := 2
}

Gui, Add, DropDownList, x348 y166 w72 vfalsePositive choose%defaultFP% Center, No|Yes

; Pack selection logic
if (skipInvalidGP = "No") {
    defaultskipGP := 1
} else if (skipInvalidGP = "Yes") {
    defaultskipGP := 2
}

Gui, Add, DropDownList, x80 y476 w145 vskipInvalidGP choose%defaultskipGP% Center, No|Yes

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
Gui Add, Button, x337 y145 w17 h19 gShowMsgGodPacks, ? ;Questionmark box for God Pack to Open Field
Gui Add, Button, x423 y145 w17 h19 gShowMsgFP, ? ;Questionmark box for God Pack to Open Field

Gui Add, Button, x215 y219 w17 h19 gShowMsgLanguage, ? ;Questionmark box for God Pack to Open Field
Gui Add, Button, x400 y219 w17 h19 gShowMsgMonitor, ? ;Questionmark box for God Pack to Open Field

Gui Add, Button, x192 y307 w17 h19 gShowMsgDelay, ? ;Questionmark box for Delay in ms Field
Gui Add, Button, x411 y307 w17 h19 gShowMsgTimeZone, ? ;Questionmark box for Timezone Field

Gui Add, Button, x193 y378 w17 h19 gShowMsgFolder, ? ;Questionmark box for SwipeSpeed Field
Gui Add, Button, x343 y378 w17 h19 gShowMsgSpeed, ? ;Questionmark box for Speed Field
Gui Add, Button, x408 y378 w17 h19 gShowMsgSwipeSpeed, ? ;Questionmark box for SwipeSpeed Field

Gui Add, Button, x428 y448 w17 h19 gShowMsgdiscordwebHook, ? ;Questionmark box for discord id Field
Gui Add, Button, x330 y448 w17 h19 gShowMsgdiscordID, ? ;Questionmark box for discord web hook Field

; Show the GUI
Gui, Show
return

ShowMsgName:
    MsgBox, Input the name you want the accounts to have. `nIf it's getting stuck inputting the name then make sure your dpi is set to 220. ;'
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
    MsgBox, Select the behavior you want when finding a god pack. `nClose will close the emulator and stop the script to save resources. `nPause will only pause the script on the opening screen.
return

ShowMsgFP:
    MsgBox, If you're getting frequent false positives change this option to Yes. If you aren't getting any false positives then leave it on No.
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
    MsgBox, Where the "MuMuPlayerGlobal-12.0" folder is located. Typically it's in the Netease folder: C:\Program Files\Netease ;'
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

Start:
Gui, Submit  ; Collect the input values from the first page
Instances := Instances  ; Directly reference the "Instances" variable

; Validate if instances is a valid number
If (Instances < 1) or (Instances > 20)
{
    MsgBox, Please enter a number between 1 and 20.
    Return
}

; Create the second page dynamically based on the number of instances
Gui, Destroy ; Close the first page

findAdbPorts(folderPath)

IniWrite, %Name%, Settings.ini, UserSettings, Name
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
IniWrite, %falsePositive%, Settings.ini, UserSettings, falsePositive
IniWrite, %skipInvalidGP%, Settings.ini, UserSettings, skipInvalidGP

; Loop to process each instance
Loop, %Instances%
{
	SourceFile := "Scripts\1.ahk" ; Path to the source .ahk file
	TargetFolder := "Scripts\" ; Path to the target folder
	TargetFile := TargetFolder . "\" . A_Index . ".ahk" ; Generate target file path
	if !FileExist(TargetFile) ; Check if the file doesn't exist
    {
        FileCopy, %SourceFile%, %TargetFile%, 1 ; Copy source file to target
        if (ErrorLevel)
            MsgBox, Failed to create %TargetFile%. Ensure permissions and paths are correct.
    }
    ; Create a command line to run the pre-existing script and pass the variables
	adbPort := adbPorts[A_Index]
	
    IniWrite, %adbPort%, Settings.ini, UserSettings, adbPort%A_Index%
	
    FileName := "Scripts\"A_Index ".ahk"
    Command := FileName
	
    Run, %Command%
	Sleep, 1000
}
SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
SysGet, Monitor, Monitor, %SelectedMonitorIndex%
rerollTime := A_TickCount

Loop {
	; Sum all variable values and write to total.json
	total := SumVariablesInJsonFile()
	totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
	mminutes := Floor(totalSeconds / 60)
	CreateStatusMessage("Time: " . mminutes . "m Packs: " . total, 5, 490)
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

			CreateStatusMessage("Arranging window positions and sizes")
            rowHeight := 533  ; Adjust the height of each row
            currentRow := Floor((Title - 1) / Columns)
            y := currentRow * rowHeight	
            x := Mod((Title - 1), Columns) * scaleParam
	
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

CreateStatusMessage(Message, X := 0, Y := 80) {
	global PacksText, SelectedMonitorIndex
	MaxRetries := 10
	RetryCount := 0
	try {
	GuiName := 22
	PacksText := 22
		SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
		SysGet, Monitor, Monitor, %SelectedMonitorIndex%
		X := MonitorLeft + X
		Y := MonitorTop + Y
	; Create a new GUI with the given name, position, and message
		Gui, %GuiName%:New, -AlwaysOnTop +ToolWindow -Caption 
	Gui, %GuiName%:Margin, 2, 2  ; Set margin for the GUI
	Gui, %GuiName%:Font, s8  ; Set the font size to 8 (adjust as needed)
	Gui, %GuiName%:Add, Text, vPacksText, %Message%
		Gui, %GuiName%:Show,NoActivate x%X% y%Y% AutoSize, %GuiName%
	}
}


findAdbPorts(baseFolder := "C:\Program Files\Netease") {
global adbPorts
; Initialize variables
adbPorts := {}  ; Create an empty associative array for adbPorts
baseFolder = %baseFolder%\MuMuPlayerGlobal-12.0\vms\*
; Loop through all directories in the base folder
Loop, Files, %baseFolder%, D  ; D flag to include directories only
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
            instanceName := playerName1  ; Capture the player name (instance name)
            
            ; Store the adbPort in the object, using instanceName as the key
            adbPorts[instanceName] := adbPort
        }
    }
}

; Example of how to retrieve the adbPort by instanceName
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
        MsgBox, JSON file not initialized. Call InitializeJsonFile() first.
        return 0
    }

    ; Read the file content
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "") {
        MsgBox, The JSON file is empty.
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

~F7::ExitApp
