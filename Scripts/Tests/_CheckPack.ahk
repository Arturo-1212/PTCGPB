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

global scriptName, screenshotFilePath, ExCheck, OneStarCheck, TrainerCheck, FullArtCheck, RainbowCheck, CrownCheck, ImmersiveCheck, PseudoGodPack, minStars

scriptName := StrReplace(A_ScriptName, ".ahk")
screenshotFilePath := A_ScriptDir . "\_CheckPack\screenshot.png"

if (!FileExist(screenshotFilePath)) {
    MsgBox, % "No screenshot found! Exiting..."
    ExitApp
}

IniRead, ExCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ExCheck, 0
IniRead, OneStarCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, OneStarCheck, 0
IniRead, TrainerCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, TrainerCheck, 0
IniRead, FullArtCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, FullArtCheck, 0
IniRead, RainbowCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, RainbowCheck, 0
IniRead, CrownCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, CrownCheck, 0
IniRead, ImmersiveCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ImmersiveCheck, 0
IniRead, PseudoGodPack, %A_ScriptDir%\..\..\Settings.ini, UserSettings, PseudoGodPack, 0
IniRead, minStars, %A_ScriptDir%\..\..\Settings.ini, UserSettings, minStars, 0

pToken := Gdip_Startup()

CheckPack() {
    foundGP := false
    foundFullArt := false
    foundRainbow := false
    found2starCount := 0
    foundEx := false
    foundTrainer := false
    found1starCount := 0
    foundImmersive := false
    foundCrown := false

    foundLabel := ["The pack in the screenshot..."]

    foundGP := FindGodPack()
    if (foundGP = "Invalid")
        foundLabel.push("- is an invalid God Pack")
    else if (foundGP)
        foundLabel.push("- is a God Pack!")

    if (FullArtCheck) {
        foundFullArt := FindBorders("fullart")
        if (foundFullArt)
            foundLabel.push("- contains " . foundFullArt . " full art cards")
    }
    if (RainbowCheck) {
        foundRainbow := FindBorders("rainbow")
        if (foundRainbow)
            foundLabel.push("- contains " . foundRainbow . " rainbow cards")
    }
    if (PseudoGodPack) {
        found2starCount := FindBorders("trainer") + FindBorders("rainbow") + FindBorders("fullart")
        if (found2starCount > 1)
            foundLabel.push("- contains " . found2starCount . " 2-star cards")
    }
    if (TrainerCheck) {
        foundTrainer := FindBorders("trainer")
        if (foundTrainer)
            foundLabel.push("- contains " . foundTrainer . " 2-star trainer cards")
    }
    if (ExCheck) {
        foundInvalid := FindBorders("immersive") + FindBorders("crown")
        if (foundInvalid = 0) {
            foundEx := FindExRule()
            if (foundEx)
                foundLabel.push("- contains " . foundEx . " EX cards")
        }
    }
    if (OneStarCheck) {
        found1starCount := FindBorders("1star")
        if (found1starCount > 1)
            foundLabel.push("- contains " . found1starCount . " 2-star trainer cards")
    }
    if (ImmersiveCheck) {
        foundImmersive := FindBorders("immersive")
        if (foundImmersive)
            foundLabel.push("- contains " . foundImmersive . " immersive cards")
    }
    if (CrownCheck) {
        foundCrown := FindBorders("crown")
        if (foundCrown)
            foundLabel.push("- contains " . foundCrown . " crown cards")
    }

    if (foundLabel.Length() = 1)
        foundLabel.push("...doesn't contain any rare cards.")

    MsgBox % ArrayJoin(foundLabel)
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

FindExRule() {
    global screenshotFilePath

    count := 0
    searchVariation := 40
    ruleCoords := [[45, 277, 88, 279]
        ,[128, 277, 171, 279]
        ,[211, 277, 254, 279]
        ,[85, 392, 128, 394]
        ,[170, 392, 213, 394]]
    pBitmap := Gdip_CreateBitmapFromFile(screenshotFilePath)
    for index, value in ruleCoords {
        coords := ruleCoords[A_Index]
        ; @TODO Add support for other languages. Needles for each supported language required.
        Path = %A_ScriptDir%\..\Scale125\ENG\4diamond%A_Index%.png
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
