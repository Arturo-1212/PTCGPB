; Resizes a GDI+ bitmap by a percentage or to specific dimensions.
Gdip_ResizeBitmap(pBitmap, PercentOrWH, Dispose=1) {
	; ------------------------------------------------------------------------------
	; Source: http://www.autohotkey.com/forum/post-477333.html#477333
	; Parameters:
	;   pBitmap (Ptr)        - Pointer to the source GDI+ bitmap.
	;   PercentOrWH (String | Number) - Percentage (e.g., 50 for 50%) or a string specifying width/height (e.g., "w200,h100").
	;   Dispose (Boolean)    - If true (default: 1), disposes of the original bitmap after resizing.
	; Returns:
	;   (Ptr) - Pointer to the new resized GDI+ bitmap. Caller must dispose of it.
	; ------------------------------------------------------------------------------
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

; Crops, resizes, converts to grayscale, and adjusts contrast of a GDI+ bitmap.
Gdip_CropResizeGreyscaleContrast(pBitmap, x, y, w, h, resizePercent := 100, contrast := 0) {
	; ------------------------------------------------------------------------------
	; Parameters:
	;   pBitmap (Ptr)       - Pointer to the source GDI+ bitmap.
	;   x (Int)             - X-coordinate of the crop region.
	;   y (Int)             - Y-coordinate of the crop region.
	;   w (Int)             - Width of the crop region.
	;   h (Int)             - Height of the crop region.
	;   resizePercent (Int) - Scaling percentage for resizing (default: 100, no scaling).
	;   contrast (Int)      - Contrast adjustment level (-100 to 100, default: 0).
	;
	; Returns:
	;   (Ptr) - Pointer to the new processed GDI+ bitmap. Caller must dispose of it.
	; ------------------------------------------------------------------------------
	; Calculate new width and height
	newW := w*resizePercent/100, newH := h*resizePercent/100

	; Create new bitmap
	pBitmap2 := Gdip_CreateBitmap(newW, newH), pGraphics2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetSmoothingMode(pGraphics2, 4), Gdip_SetInterpolationMode(pGraphics2, 7)

	; Increase contrast and convert to grayscale using a color matrix
	factor := (100.0 + contrast) / 100.0
	factor := factor * factor

	; Grayscale conversion with contrast applied
	redFactor := 0.299 * factor
	greenFactor := 0.587 * factor
	blueFactor := 0.114 * factor
	xFactor := 0.5 * (1 - factor)
	colorMatrix := redFactor . "|" . redFactor . "|" . redFactor . "|0|0|" . greenFactor . "|" . greenFactor . "|" . greenFactor . "|0|0|" . blueFactor . "|" . blueFactor . "|" . blueFactor . "|0|0|0|0|0|1|0|" . xFactor . "|" . xFactor . "|" . xFactor . "|0|1"

	; Draw onto pBitmap2
	Gdip_DrawImage(pGraphics2, pBitmap, 0, 0, newW, newH, x, y, w, h, colorMatrix)

	; Clean up
	Gdip_DeleteGraphics(pGraphics2)

	return pBitmap2
}