#Include %A_ScriptDir%\..\Include\Gdip_All.ahk
#Include %A_ScriptDir%\..\Include\Gdip_Imagesearch.ahk

#SingleInstance, Force
SetBatchLines, -1
SetTitleMatchMode, 3
CoordMode, Pixel, Screen

if not A_IsAdmin {
    ; Relaunch script with admin rights.
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

global scriptName, screenshotFilePath, minStars

scriptName := StrReplace(A_ScriptName, ".ahk")
screenshotFilePath := A_ScriptDir . "\_CheckPack\screenshot.png"

if (!FileExist(screenshotFilePath)) {
    MsgBox, % "No screenshot found! Exiting..."
    ExitApp
}

IniRead, minStars, %A_ScriptDir%\..\..\Settings.ini, UserSettings, minStars, 0

pToken := Gdip_Startup()

CheckPack() {
    foundGP := FindGodPack()
    foundFullArt := FindBorders("fullart")
    foundRainbow := FindBorders("rainbow")
    found2starCount := FindBorders("trainer") + FindBorders("rainbow") + FindBorders("fullart")
    foundImmersive := FindBorders("immersive")
    foundCrown := FindBorders("crown")

    messageArray := ["The pack in the screenshot..."]

    if (foundGP = "Invalid")
        messageArray.push("- is an invalid God Pack")
    else if (foundGP)
        messageArray.push("- is a God Pack!")
    if (foundFullArt)
        messageArray.push("- contains " . foundFullArt . " full art cards")
    if (foundRainbow)
        messageArray.push("- contains " . foundRainbow . " rainbow cards")
    if (found2starCount > 0)
        messageArray.push("- contains " . found2starCount . " 2-star cards")
    if (foundImmersive)
        messageArray.push("- contains " . foundImmersive . " immersive cards")
    if (foundCrown)
        messageArray.push("- contains " . foundCrown . " crown cards")

    if (messageArray.Length() = 1)
        messageArray.push("...doesn't contain any rare cards.")

    MsgBox % ArrayJoin(messageArray)
}

FindGodPack() {
    global screenshotFilePath, minStars

    searchVariation := 5
    borderCoords := [[20, 284, 90, 286]
        ,[103, 284, 173, 286]]

    Loop {
        normalBorders := false
        pBitmap := Gdip_CreateBitmapFromFile(screenshotFilePath)
        Path = %A_ScriptDir%\..\Scale125\Border.png
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
            return false
        } else {
            foundImmersive := FindBorders("immersive")
            foundCrown := FindBorders("crown")
            if(foundImmersive || foundCrown) {
                invalidGP := true
            }
            if(!invalidGP && minStars > 0) {
                starCount := 5 - FindBorders("1star")
                if(starCount < minStars) {
                    invalidGP := true
                }
            }
            if(invalidGP) {
                return "Invalid"
            }
            else {
                return true
            }
        }
    }
}

FindBorders(prefix) {
    global screenshotFilePath

    count := 0
    searchVariation := 40
    borderCoords := [[30, 284, 83, 286]
        ,[113, 284, 166, 286]
        ,[196, 284, 249, 286]
        ,[70, 399, 123, 401]
        ,[155, 399, 208, 401]]
    pBitmap := Gdip_CreateBitmapFromFile(screenshotFilePath)
    for index, value in borderCoords {
        coords := borderCoords[A_Index]
        Path = %A_ScriptDir%\..\Scale125\%prefix%%A_Index%.png
        pNeedle := GetNeedle(Path)
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, coords[1], coords[2], coords[3], coords[4], searchVariation)
        if (vRet = 1) {
            count += 1
        }
    }
    Gdip_DisposeImage(pBitmap)
    return count
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

ArrayJoin(Array) {
    for k, v in Array
        Out .= "`n" . v
    return Out
}

CheckPack()
ExitApp
