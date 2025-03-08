#SingleInstance, force
CoordMode, Mouse, Screen
SetTitleMatchMode, 3

if not A_IsAdmin
{
    ; Relaunch script with admin rights
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

IniRead, instanceLaunchDelay, Settings.ini, UserSettings, instanceLaunchDelay, 5000
IniRead, waitAfterBulkLaunch, Settings.ini, UserSettings, waitAfterBulkLaunch, 20000
IniRead, Instances, Settings.ini, UserSettings, Instances, 1
IniRead, folderPath, Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
mumuFolder = %folderPath%\MuMuPlayerGlobal-12.0
if !FileExist(mumuFolder)
    mumuFolder = %folderPath%\MuMu Player 12
if !FileExist(mumuFolder){
	MsgBox, 16, , Double check your folder path! It should be the one that contains the MuMuPlayer 12 folder! `nDefault is just C:\Program Files\Netease
	ExitApp
}
Loop {
    ; Loop through each instance, check if it's started, and start it if it's not
    launched := 0

    nowEpoch := A_NowUTC
    EnvSub, nowEpoch, 1970, seconds

    Loop %Instances% {
        instanceNum := Format("{:u}", A_Index)

        IniRead, LastEndEpoch, %A_ScriptDir%\Scripts\%instanceNum%.ini, Metrics, LastEndEpoch, 0
        secondsSinceLastEnd := nowEpoch - LastEndEpoch
        if(LastEndEpoch > 0 && secondsSinceLastEnd > (15 * 60))
        {
            ; msgbox, Killing Instance %instanceNum%! Last Run Completed %secondsSinceLastEnd% Seconds Ago
            msg := "Killing Instance " . instanceNum . "! Last Run Completed " . secondsSinceLastEnd . " Seconds Ago"
            LogToFile(msg, "Monitor.txt")
            
            scriptName := instanceNum . ".ahk"

            pID := checkInstance(instanceNum)
            if(pID)
            {
                killAHK(scriptName)
                killInstance(instanceNum)
                Sleep, 3000
            }
            
            pID := checkInstance(instanceNum)
            if not pID {
                launchInstance(instanceNum)
        
                Sleep, %instanceLaunchDelay%
                launched := launched + 1

                Sleep, %waitAfterBulkLaunch%

                ;Command := "Scripts\" . scriptName
                ;Run, %Command%
			    scriptPath = %A_ScriptDir%\Scripts\%scriptName%
			    Run "%A_AhkPath%" /restart "%scriptPath%"
                
                ; Change the last end date to now so that we don't keep trying to restart this beast
                IniWrite, %nowEpoch%, %A_ScriptDir%\Scripts\%instanceNum%.ini, Metrics, LastEndEpoch
            }
        }
    }

    ; Check for dead instances every 30 seconds
    Sleep, 30000
}

LogToFile(message, logFile) {
	logFile := A_ScriptDir . "\Logs\" . logFile

	FormatTime, readableTime, %A_Now%, MMMM dd, yyyy HH:mm:ss
	FileAppend, % "[" readableTime "] " message "`n", %logFile%
}

killAHK(scriptName := "")
{
    if(scriptName != "") {
        DetectHiddenWindows, On
        WinGet, IDList, List, ahk_class AutoHotkey
        Loop %IDList%
        {
            ID:=IDList%A_Index%
            WinGetTitle, ATitle, ahk_id %ID%
            if InStr(ATitle, "\" . scriptName) {
                ; MsgBox, Killing: %ATitle%
                WinKill, ahk_id %ID% ;kill
                ; WinClose, %fullScriptPath% ahk_class AutoHotkey
                return
            }
        }
    }
}

killInstance(instanceNum := "")
{
    
    pID := checkInstance(instanceNum)
    if pID {
        Process, Close, %pID%
    }
}

checkInstance(instanceNum := "")
{
    ret := WinExist(instanceNum)
    if(ret)
    {
        WinGet, temp_pid, PID, ahk_id %ret%
        return temp_pid
    }
    
    return ""
}

launchInstance(instanceNum := "")
{
    global mumuFolder

    if(instanceNum != "") {
        mumuNum := getMumuInstanceNumFromPlayerName(instanceNum)
        if(mumuNum != "") {
            ; Run, %mumuFolder%\shell\MuMuPlayer.exe -v %mumuNum%
			Run_(mumuFolder . "\shell\MuMuPlayer.exe", "-v " . mumuNum)
        }
    }
}

getMumuInstanceNumFromPlayerName(scriptName := "") {
    global mumuFolder

    if(scriptName == "") {
        return ""
    }

	; Loop through all directories in the base folder
	Loop, Files, %mumuFolder%\vms\*, D  ; D flag to include directories only
	{
		folder := A_LoopFileFullPath
		configFolder := folder "\configs"  ; The config folder inside each directory

		; Check if config folder exists
		IfExist, %configFolder%
		{
			; Define paths to vm_config.json and extra_config.json
			extraConfigFile := configFolder "\extra_config.json"

			; Check if extra_config.json exists and read playerName
			IfExist, %extraConfigFile%
			{
				FileRead, extraConfigContent, %extraConfigFile%
				; Parse the JSON for playerName
				RegExMatch(extraConfigContent, """playerName"":\s*""(.*?)""", playerName)
				if(playerName1 == scriptName) {
                    RegExMatch(A_LoopFileFullPath, "[^-]+$", mumuNum)
					return mumuNum
				}
			}
		}
	}
}

; Function to run as a NON-adminstrator, since MuMu has issues if run as Administrator
; See: https://www.reddit.com/r/AutoHotkey/comments/bfd6o1/how_to_run_without_administrator_privileges/
/*
  ShellRun by Lexikos
    requires: AutoHotkey v1.1
    license: http://creativecommons.org/publicdomain/zero/1.0/

  Credit for explaining this method goes to BrandonLive:
  http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/
 
  Shell.ShellExecute(File [, Arguments, Directory, Operation, Show])
  http://msdn.microsoft.com/en-us/library/windows/desktop/gg537745
*/
Run_(target, args:="", workdir:="") {
    try
        ShellRun(target, args, workdir)
    catch e
        Run % args="" ? target : target " " args, % workdir
}
ShellRun(prms*)
{
    shellWindows := ComObjCreate("Shell.Application").Windows
    VarSetCapacity(_hwnd, 4, 0)
    desktop := shellWindows.FindWindowSW(0, "", 8, ComObj(0x4003, &_hwnd), 1)
   
    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(desktop
        , "{4C96BE40-915C-11CF-99D3-00AA004AE837}"  ; SID_STopLevelBrowser
        , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    {
        ; IShellBrowser.QueryActiveShellView -> IShellView
        if DllCall(NumGet(NumGet(ptlb+0)+15*A_PtrSize), "ptr", ptlb, "ptr*", psv:=0) = 0
        {
            ; Define IID_IDispatch.
            VarSetCapacity(IID_IDispatch, 16)
            NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "int64"), "int64")
           
            ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
            DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize), "ptr", psv
                , "uint", 0, "ptr", &IID_IDispatch, "ptr*", pdisp:=0)
           
            ; Get Shell object.
            shell := ComObj(9,pdisp,1).Application
           
            ; IShellDispatch2.ShellExecute
            shell.ShellExecute(prms*)
           
            ObjRelease(psv)
        }
        ObjRelease(ptlb)
    }
}

~+F7::ExitApp