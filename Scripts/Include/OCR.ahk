; SOURCE: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=72674

HBitmapToRandomAccessStream(hBitmap) {
    static IID_IRandomAccessStream := "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}"
          , IID_IPicture            := "{7BF80980-BF32-101A-8BBB-00AA00300CAB}"
          , PICTYPE_BITMAP := 1
          , BSOS_DEFAULT   := 0

    DllCall("Ole32\CreateStreamOnHGlobal", "Ptr", 0, "UInt", true, "PtrP", pIStream, "UInt")

    VarSetCapacity(PICTDESC, sz := 8 + A_PtrSize*2, 0)
    NumPut(sz, PICTDESC)
    NumPut(PICTYPE_BITMAP, PICTDESC, 4)
    NumPut(hBitmap, PICTDESC, 8)
    riid := CLSIDFromString(IID_IPicture, GUID1)
    DllCall("OleAut32\OleCreatePictureIndirect", "Ptr", &PICTDESC, "Ptr", riid, "UInt", false, "PtrP", pIPicture, "UInt")
    ; IPicture::SaveAsFile
    DllCall(NumGet(NumGet(pIPicture+0) + A_PtrSize*15), "Ptr", pIPicture, "Ptr", pIStream, "UInt", true, "UIntP", size, "UInt")
    riid := CLSIDFromString(IID_IRandomAccessStream, GUID2)
    DllCall("ShCore\CreateRandomAccessStreamOverStream", "Ptr", pIStream, "UInt", BSOS_DEFAULT, "Ptr", riid, "PtrP", pIRandomAccessStream, "UInt")
    ObjRelease(pIPicture)
    ObjRelease(pIStream)
    Return pIRandomAccessStream
}

CLSIDFromString(IID, ByRef CLSID) {
    VarSetCapacity(CLSID, 16, 0)
    if res := DllCall("ole32\CLSIDFromString", "WStr", IID, "Ptr", &CLSID, "UInt")
        throw Exception("CLSIDFromString failed. Error: " . Format("{:#x}", res))
    Return &CLSID
}

ocr(fileOrStream, lang := "FirstFromAvailableLanguages")
{
    static OcrEngineStatics, OcrEngine, MaxDimension, LanguageFactory, Language, CurrentLanguage, BitmapDecoderStatics, GlobalizationPreferencesStatics
    if (OcrEngineStatics = "")
    {
        CreateClass("Windows.Globalization.Language", ILanguageFactory := "{9B0252AC-0C27-44F8-B792-9793FB66C63E}", LanguageFactory)
        CreateClass("Windows.Graphics.Imaging.BitmapDecoder", IBitmapDecoderStatics := "{438CCB26-BCEF-4E95-BAD6-23A822E58D01}", BitmapDecoderStatics)
        CreateClass("Windows.Media.Ocr.OcrEngine", IOcrEngineStatics := "{5BFFA85A-3384-3540-9940-699120D428A8}", OcrEngineStatics)
        DllCall(NumGet(NumGet(OcrEngineStatics+0)+6*A_PtrSize), "ptr", OcrEngineStatics, "uint*", MaxDimension)   ; MaxImageDimension
    }
    if (fileOrStream = "ShowAvailableLanguages")
    {
        if (GlobalizationPreferencesStatics = "")
            CreateClass("Windows.System.UserProfile.GlobalizationPreferences", IGlobalizationPreferencesStatics := "{01BF4326-ED37-4E96-B0E9-C1340D1EA158}", GlobalizationPreferencesStatics)
        DllCall(NumGet(NumGet(GlobalizationPreferencesStatics+0)+9*A_PtrSize), "ptr", GlobalizationPreferencesStatics, "ptr*", LanguageList)   ; get_Languages
        DllCall(NumGet(NumGet(LanguageList+0)+7*A_PtrSize), "ptr", LanguageList, "int*", count)   ; count
        loop % count
        {
            DllCall(NumGet(NumGet(LanguageList+0)+6*A_PtrSize), "ptr", LanguageList, "int", A_Index-1, "ptr*", hString)   ; get_Item
            DllCall(NumGet(NumGet(LanguageFactory+0)+6*A_PtrSize), "ptr", LanguageFactory, "ptr", hString, "ptr*", LanguageTest)   ; CreateLanguage
            DllCall(NumGet(NumGet(OcrEngineStatics+0)+8*A_PtrSize), "ptr", OcrEngineStatics, "ptr", LanguageTest, "int*", bool)   ; IsLanguageSupported
            if (bool = 1)
            {
                DllCall(NumGet(NumGet(LanguageTest+0)+6*A_PtrSize), "ptr", LanguageTest, "ptr*", hText)
                buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
                text .= StrGet(buffer, "UTF-16") "`n"
            }
            ObjRelease(LanguageTest)
        }
        ObjRelease(LanguageList)
        return text
    }
    if (lang != CurrentLanguage) or (lang = "FirstFromAvailableLanguages")
    {
        if (OcrEngine != "")
        {
            ObjRelease(OcrEngine)
            if (CurrentLanguage != "FirstFromAvailableLanguages")
                ObjRelease(Language)
        }
        if (lang = "FirstFromAvailableLanguages")
            DllCall(NumGet(NumGet(OcrEngineStatics+0)+10*A_PtrSize), "ptr", OcrEngineStatics, "ptr*", OcrEngine)   ; TryCreateFromUserProfileLanguages
        else
        {
            CreateHString(lang, hString)
            DllCall(NumGet(NumGet(LanguageFactory+0)+6*A_PtrSize), "ptr", LanguageFactory, "ptr", hString, "ptr*", Language)   ; CreateLanguage
            DeleteHString(hString)
            DllCall(NumGet(NumGet(OcrEngineStatics+0)+9*A_PtrSize), "ptr", OcrEngineStatics, ptr, Language, "ptr*", OcrEngine)   ; TryCreateFromLanguage
        }
        if (OcrEngine = 0)
        {
            ; msgbox Can not use language "%lang%" for OCR, please install language pack.
            ; ExitApp
            return False
        }
        CurrentLanguage := lang
    }
    if (SubStr(fileOrStream, 2, 1) = ":") ; FilePath
    {
        if !FileExist(fileOrStream) or InStr(FileExist(fileOrStream), "D")
        {
            ; msgbox File "%fileOrStream%" does not exist
            ; ExitApp
            return False
        }
        VarSetCapacity(GUID, 16)
        DllCall("ole32\CLSIDFromString", "wstr", IID_RandomAccessStream := "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}", "ptr", &GUID)
        DllCall("ShCore\CreateRandomAccessStreamOnFile", "wstr", fileOrStream, "uint", Read := 0, "ptr", &GUID, "ptr*", IRandomAccessStream)
    }
    else ; IRandomAccessStream
    {
        IRandomAccessStream := fileOrStream
    }
    DllCall(NumGet(NumGet(BitmapDecoderStatics+0)+14*A_PtrSize), "ptr", BitmapDecoderStatics, "ptr", IRandomAccessStream, "ptr*", BitmapDecoder)   ; CreateAsync
    WaitForAsync(BitmapDecoder)
    BitmapFrame := ComObjQuery(BitmapDecoder, IBitmapFrame := "{72A49A1C-8081-438D-91BC-94ECFC8185C6}")
    DllCall(NumGet(NumGet(BitmapFrame+0)+12*A_PtrSize), "ptr", BitmapFrame, "uint*", width)   ; get_PixelWidth
    DllCall(NumGet(NumGet(BitmapFrame+0)+13*A_PtrSize), "ptr", BitmapFrame, "uint*", height)   ; get_PixelHeight
    if (width > MaxDimension) or (height > MaxDimension)
    {
        ; msgbox Image is too big - %width%x%height%.`nIt should be maximum - %MaxDimension% pixels
        ; ExitApp
        return False
    }
    BitmapFrameWithSoftwareBitmap := ComObjQuery(BitmapDecoder, IBitmapFrameWithSoftwareBitmap := "{FE287C9A-420C-4963-87AD-691436E08383}")
    DllCall(NumGet(NumGet(BitmapFrameWithSoftwareBitmap+0)+6*A_PtrSize), "ptr", BitmapFrameWithSoftwareBitmap, "ptr*", SoftwareBitmap)   ; GetSoftwareBitmapAsync
    WaitForAsync(SoftwareBitmap)
    DllCall(NumGet(NumGet(OcrEngine+0)+6*A_PtrSize), "ptr", OcrEngine, ptr, SoftwareBitmap, "ptr*", OcrResult)   ; RecognizeAsync
    WaitForAsync(OcrResult)
    DllCall(NumGet(NumGet(OcrResult+0)+6*A_PtrSize), "ptr", OcrResult, "ptr*", LinesList)   ; get_Lines
    DllCall(NumGet(NumGet(LinesList+0)+7*A_PtrSize), "ptr", LinesList, "int*", count)   ; count
    loop % count
    {
        DllCall(NumGet(NumGet(LinesList+0)+6*A_PtrSize), "ptr", LinesList, "int", A_Index-1, "ptr*", OcrLine)
        DllCall(NumGet(NumGet(OcrLine+0)+7*A_PtrSize), "ptr", OcrLine, "ptr*", hText)
        buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
        text .= StrGet(buffer, "UTF-16") "`n"
        ObjRelease(OcrLine)
    }
    Close := ComObjQuery(IRandomAccessStream, IClosable := "{30D5A829-7FA4-4026-83BB-D75BAE4EA99E}")
    DllCall(NumGet(NumGet(Close+0)+6*A_PtrSize), "ptr", Close)   ; Close
    ObjRelease(Close)
    Close := ComObjQuery(SoftwareBitmap, IClosable := "{30D5A829-7FA4-4026-83BB-D75BAE4EA99E}")
    DllCall(NumGet(NumGet(Close+0)+6*A_PtrSize), "ptr", Close)   ; Close
    ObjRelease(Close)
    ObjRelease(IRandomAccessStream)
    ObjRelease(BitmapDecoder)
    ObjRelease(BitmapFrame)
    ObjRelease(BitmapFrameWithSoftwareBitmap)
    ObjRelease(SoftwareBitmap)
    ObjRelease(OcrResult)
    ObjRelease(LinesList)
    return text
}

CreateClass(string, interface, ByRef Class)
{
    CreateHString(string, hString)
    VarSetCapacity(GUID, 16)
    DllCall("ole32\CLSIDFromString", "wstr", interface, "ptr", &GUID)
    result := DllCall("Combase.dll\RoGetActivationFactory", "ptr", hString, "ptr", &GUID, "ptr*", Class)
    if (result != 0)
    {
        if (result = 0x80004002)
            msgbox No such interface supported
        else if (result = 0x80040154)
            msgbox Class not registered
        else
            msgbox error: %result%
        ExitApp
    }
    DeleteHString(hString)
}

CreateHString(string, ByRef hString)
{
     DllCall("Combase.dll\WindowsCreateString", "wstr", string, "uint", StrLen(string), "ptr*", hString)
}

DeleteHString(hString)
{
    DllCall("Combase.dll\WindowsDeleteString", "ptr", hString)
}

WaitForAsync(ByRef Object)
{
    AsyncInfo := ComObjQuery(Object, IAsyncInfo := "{00000036-0000-0000-C000-000000000046}")
    loop
    {
        DllCall(NumGet(NumGet(AsyncInfo+0)+7*A_PtrSize), "ptr", AsyncInfo, "uint*", status)   ; IAsyncInfo.Status
        if (status != 0)
        {
            if (status != 1)
            {
                DllCall(NumGet(NumGet(AsyncInfo+0)+8*A_PtrSize), "ptr", AsyncInfo, "uint*", ErrorCode)   ; IAsyncInfo.ErrorCode
                ; msgbox AsyncInfo status error: %ErrorCode%
                ; ExitApp
                return False
            }
            ObjRelease(AsyncInfo)
            break
        }
        sleep 10
    }
    DllCall(NumGet(NumGet(Object+0)+8*A_PtrSize), "ptr", Object, "ptr*", ObjectResult)   ; GetResults
    ObjRelease(Object)
    Object := ObjectResult
}
