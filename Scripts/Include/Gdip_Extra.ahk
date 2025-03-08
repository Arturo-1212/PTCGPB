
ToGrayscale(sBM) {                            ; By SKAN on CR7J/D39L @ tiny.cc/tograyscale
   Local  ; Original ver. GDI_GrayscaleBitmap() @ https://autohotkey.com/board/topic/82794-

   P8:=(A_PtrSize=8),  VarSetCapacity(BM,P8? 32:24, 0)
   DllCall("GetObject", "Ptr",sBM, "Int",P8? 32:24, "Ptr",&BM)
   W := NumGet(BM,4,"Int"), H := NumGet(BM,8,"Int")
   sDC := DllCall( "CreateCompatibleDC", "Ptr",0, "Ptr")

   DllCall("DeleteObject", "Ptr",DllCall("SelectObject", "Ptr",sDC, "Ptr",sBM, "Ptr"))

   tBM := DllCall( "CopyImage", "Ptr"
         , DllCall( "CreateBitmap", "Int",1, "Int",1, "Int",0x1, "Int",8, "Ptr",0, "Ptr")
         , "Int",0, "Int",W, "Int",H, "Int",0x2008, "Ptr")

   tDC := DllCall("CreateCompatibleDC", "Ptr",0, "Ptr")
   DllCall("DeleteObject", "Ptr",DllCall("SelectObject", "Ptr",tDC, "Ptr",tBM, "Ptr"))

   Loop % (255, n:=0x000000, VarSetCapacity(RGBQUAD256,256*4,0))
         Numput(n+=0x010101, RGBQUAD256, A_Index*4, "Int")
   DllCall("SetDIBColorTable", "Ptr",tDC, "Int",0, "Int",256, "Ptr",&RGBQUAD256)

   DllCall("BitBlt",   "Ptr",tDC, "Int",0, "Int",0, "Int",W, "Int",H
                     , "Ptr",sDC, "Int",0, "Int",0, "Int",0x00CC0020)

   Return % (tBM, DllCall("DeleteDC", "Ptr",sDC), DllCall("DeleteDC", "Ptr",tDC))
}

SavePicture(hBM, sFile) {                                            ; By SKAN on D293 @ bit.ly/2krOIc9
   Local V,  pBM := VarSetCapacity(V,16,0)>>8,  Ext := LTrim(SubStr(sFile,-3),"."),  E := [0,0,0,0]
   Local Enc := 0x557CF400 | Round({"bmp":0, "jpg":1,"jpeg":1,"gif":2,"tif":5,"tiff":5,"png":6}[Ext])
     E[1] := DllCall("gdi32\GetObjectType", "Ptr",hBM ) <> 7
     E[2] := E[1] ? 0 : DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr",hBM, "UInt",0, "PtrP",pBM)
     NumPut(0x2EF31EF8,NumPut(0x0000739A,NumPut(0x11D31A04,NumPut(Enc+0,V,"UInt"),"UInt"),"UInt"),"UInt")
     E[3] := pBM ? DllCall("gdiplus\GdipSaveImageToFile", "Ptr",pBM, "WStr",sFile, "Ptr",&V, "UInt",0) : 1
     E[4] := pBM ? DllCall("gdiplus\GdipDisposeImage", "Ptr",pBM) : 1
   Return E[1] ? 0 : E[2] ? -1 : E[3] ? -2 : E[4] ? -3 : 1  
}

Gdip_ResizeBitmap(pBitmap, PercentOrWH, Dispose=1) {   ; returns resized bitmap. By Learning one.
	; http://www.autohotkey.com/forum/post-477333.html#477333
   Gdip_GetImageDimensions(pBitmap, origW, origH)
   if PercentOrWH contains w,h
   {
      RegExMatch(PercentOrWH, "i)w(\d*)", w), RegExMatch(PercentOrWH, "i)h(\d*)", h)
      NewWidth := w1, NewHeight := h1
      NewWidth := (NewWidth = "") ? origW/(origH/NewHeight) : NewWidth
      NewHeight := (NewHeight = "") ? origH/(origW/NewWidth) : NewHeight
   }
   else
   NewWidth := origW*PercentOrWH/100, NewHeight := origH*PercentOrWH/100      
   pBitmap2 := Gdip_CreateBitmap(NewWidth, NewHeight)
   G2 := Gdip_GraphicsFromImage(pBitmap2), Gdip_SetSmoothingMode(G2, 4), Gdip_SetInterpolationMode(G2, 7)
   Gdip_DrawImage(G2, pBitmap, 0, 0, NewWidth, NewHeight)
   Gdip_DeleteGraphics(G2)
   if Dispose
      Gdip_DisposeImage(pBitmap)
   return pBitmap2
}

Gdip_CropImage(pBitmap, x, y, w, h) {
	pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
	Gdip_DeleteGraphics(G2)
	return pBitmap2
}