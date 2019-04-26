SuperStrict

Framework gfx.bgfxmax2d

Graphics 800, 600, 0


SetClsColor 0, 0, 0

Local stats:Int = BGFX_DEBUG_TEXT

Local ESC:String = Chr(27)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	If KeyHit(key_f1) Then
		If stats = BGFX_DEBUG_TEXT Then
			stats = BGFX_DEBUG_STATS
		Else
			stats = BGFX_DEBUG_TEXT
		End If
	End If
	
	TBGFX.DebugTextClear()
	TBGFX.DebugTextPrint(0, 0, $0f, "Press F1 to toggle stats.")
	TBGFX.DebugTextPrint(0, 1, $0f, "Color can be changed with ANSI " + ESC + "[9;me" + ESC + "[10;ms" + ESC + "[11;mc" + ESC + "[12;ma" + ESC + "[13;mp" + ESC + "[14;me" + ESC + "[0m code too.")
	TBGFX.DebugTextPrint(65, 1, $0f, ESC + "[;0m    " + ESC + "[;1m    " + ESC + "[; 2m    " + ESC + "[; 3m    " + ESC + "[; 4m    " + ESC + "[; 5m    " + ESC + "[; 6m    " + ESC + "[; 7m    " + ESC + "[0m")
	TBGFX.DebugTextPrint(65, 2, $0f, ESC + "[;8m    " + ESC + "[;9m    " + ESC + "[;10m    " + ESC + "[;11m    " + ESC + "[;12m    " + ESC + "[;13m    " + ESC + "[;14m    " + ESC + "[;15m    " + ESC + "[0m")
		
	TBGFX.SetDebug(stats)
	
	Flip

Wend
