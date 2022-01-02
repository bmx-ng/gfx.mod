' Copyright (c) 2015-2019 Bruce A Henderson
' All rights reserved.
' 
' Redistribution and use in source and binary forms, with or without
' modification, are permitted provided that the following conditions are met:
' 
' * Redistributions of source code must retain the above copyright notice, this
'   list of conditions and the following disclaimer.
' 
' * Redistributions in binary form must reproduce the above copyright notice,
'   this list of conditions and the following disclaimer in the documentation
'   and/or other materials provided with the distribution.
' 
' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
' IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
' FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
' DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
' SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
' CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
' OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
' OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
SuperStrict

Module gfx.bgfxmax2d

Import brl.max2d
Import gfx.bgfxsdlgraphics
'Import gfx.bgfxgraphics

Private

Global _driver:TBGFXMax2DDriver

Public

Type TBGFXMax2DDriver Extends TMax2DDriver

	Field bgfx:TBGFXRender
	
	Method New()
		bgfx = New TBGFXRender
'		AddHook EmitEventHook,EventHook,Null,0
	End Method

	Method Create:TBGFXMax2DDriver()
		If Not GfxGraphicsDriver() Return Null
		
		Return Self
	End Method

	'graphics driver overrides
	Method GraphicsModes:TGraphicsMode[]()
		Return GfxGraphicsDriver().GraphicsModes()
	End Method
	
	Method AttachGraphics:TMax2DGraphics( widget:Byte Ptr,flags:Long )
	'	Local g:TGLGraphics=GLGraphicsDriver().AttachGraphics( widget,flags )
	'	If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
	Method CreateGraphics:TMax2DGraphics( width:Int, height:Int, depth:Int, hertz:Int, flags:Long, x:Int, y:Int )
		Local g:TGfxGraphics=GfxGraphicsDriver().CreateGraphics( width,height,depth,hertz,flags, x, y)
		If g Return TMax2DGraphics.Create( g,Self )
	End Method
	
	Method SetGraphics( g:TGraphics )
		If Not g
			TMax2DGraphics.ClearCurrent
			GfxGraphicsDriver().SetGraphics Null
			Return
		EndIf
	
		Local t:TMax2DGraphics=TMax2DGraphics(g)
		Assert t And TGfxGraphics( t._graphics )

		GfxGraphicsDriver().SetGraphics t._graphics

		'ResetGLContext t
		
		t.MakeCurrent
	End Method

	Method Flip:Int( sync:Int )
		GfxGraphicsDriver().Flip sync
	End Method
	
	Method ToString$()
		Return "BGFX - " ' todo renderer type
	End Method

	Method CreateFrameFromPixmap:TImageFrame( pixmap:TPixmap,flags:Int )
		' TODO
	End Method
	
	Method SetBlend( blend:Int )
		' TODO
	End Method

	Method SetAlpha( alpha# )
		' TODO
	End Method

	Method SetColor( red:Int,green:Int,blue:Int )
		' TODO
	End Method

	Method SetClsColor( red:Int,green:Int,blue:Int )
		TBGFX.SetViewClear(0, BGFX_CLEAR_COLOR|BGFX_CLEAR_DEPTH, red Shl 24 | green Shl 16 | blue Shl 8 | $ff, 1, 0)
	End Method

	Method SetViewport( x:Int,y:Int,width:Int,height:Int )
		If x = 0 And y = 0 And width = GraphicsWidth() And height = GraphicsHeight() Then
			TBGFX.SetViewScissor(0, 0, 0, 0, 0)
		Else
			TBGFX.SetViewScissor(0, Short(x), Short(y), Short(width), Short(height))
		End If
	End Method

	Method SetTransform( xx#,xy#,yx#,yy# )
		' TODO
	End Method

	Method SetLineWidth( width# )
		' TODO
	End Method
	
	Method Cls()
		GfxGraphicsDriver().SetViewRect()
		bgfx.Touch(0)
	End Method

	Method Plot( x#,y# )
		' TODO
	End Method

	Method DrawLine( x0#,y0#,x1#,y1#,tx#,ty# )
		' TODO
	End Method

	Method DrawRect( x0#,y0#,x1#,y1#,tx#,ty# )
		' TODO
	End Method

	Method DrawOval( x0#,y0#,x1#,y1#,tx#,ty# )
		' TODO
	End Method

	Method DrawPoly( xy#[],handlex#,handley#,originx#,originy# )
		' TODO
	End Method

		
	Method DrawPixmap( pixmap:TPixmap, x:Int, y:Int )
		' TODO
	End Method

	Method GrabPixmap:TPixmap( x:Int, y:Int, width:Int, height:Int )
		' TODO
	End Method

	
	Method SetResolution( width#,height# )
		' TODO
	End Method
Rem
	Function EventHook:Object( id:Int, data:Object, context:Object )
		Local ev:TEvent=TEvent(data)
		If Not ev Return data

		Select ev.id
			Case EVENT_WINDOWSIZE
				Print "window size"
				TBGFX.Reset(ev.x, ev.y, BGFX_RESET_VSYNC | BGFX_RESET_HIDPI)
		End Select
		
		Return data
	End Function
End Rem	

	Method CanResize:Int()
		Return True
	End Method

End Type


Function BGFXMax2DDriver:TBGFXMax2DDriver()
	Global _done:Int
	If Not _done
		_driver=New TBGFXMax2DDriver.Create()
		_done=True
	EndIf
	Return _driver
End Function

Local driver:TBGFXMax2DDriver=BGFXMax2DDriver()
If driver SetGraphicsDriver driver
