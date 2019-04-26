' Copyright (c) 2015-2018 Bruce A Henderson
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

Module gfx.bgfxgraphics


Import "common.bmx"

Private

Extern
	Function bbGfxGraphicsShareContexts()
	Function bbGfxGraphicsGraphicsModes:Int( buf:Byte Ptr, size:Int )
	Function bbGfxGraphicsAttachGraphics:Byte Ptr( widget:Byte Ptr,flags:Int )
	Function bbGfxGraphicsCreateGraphics:Byte Ptr( width:Int, height:Int, depth:Int, hertz:Int, flags:Int )
	Function bbGfxGraphicsGetSettings( context:Byte Ptr, width:Int Var, height:Int Var, depth:Int Var, hertz:Int Var, flags:Int Var )
	Function bbGfxGraphicsClose( context:Byte Ptr )	
	Function bbGfxGraphicsSetGraphics( context:Byte Ptr )
	Function bbGfxGraphicsFlip( sync:Int )
End Extern

Public

Type TGfxGraphics Extends TGraphics

	Method Driver:TGfxGraphicsDriver()
		Assert _context
		Return GfxGraphicsDriver()
	End Method
	
	Method GetSettings:Int( width:Int Var,height:Int Var,depth:Int Var,hertz:Int Var,flags:Int Var )
		Assert _context
		Local w:Int, h:Int, d:Int, r:Int, f:Int
		bbGfxGraphicsGetSettings _context,w,h,d,r,f
		width=w
		height=h
		depth=d
		hertz=r
		flags=f
	End Method
	
	Method Close:Int()
		If Not _context Return 0
		bbGfxGraphicsClose( _context )
		_context=0
	End Method
	
	Field _context:Byte Ptr
	
End Type

Type TGfxGraphicsDriver Extends TGraphicsDriver

	Global _inited:Int

	Method GraphicsModes:TGraphicsMode[]()
		Local buf:Int[1024*4]
		Local count:Int=bbGfxGraphicsGraphicsModes( buf,1024 )
		Local modes:TGraphicsMode[count],p:Int Ptr=buf
		For Local i:Int=0 Until count
			Local t:TGraphicsMode=New TGraphicsMode
			t.width=p[0]
			t.height=p[1]
			t.depth=p[2]
			t.hertz=p[3]
			modes[i]=t
			p:+4
		Next
		Return modes
	End Method
	
	Method AttachGraphics:TGfxGraphics( widget:Byte Ptr,flags:Int )
		'Local t:TGfxGraphics=New TGfxGraphics
		't._context=bbGLGraphicsAttachGraphics( widget,flags )
		'Return t
	End Method
	
	Method CreateGraphics:TGfxGraphics( width:Int, height:Int, depth:Int, hertz:Int, flags:Int )
		Local t:TGfxGraphics=New TGfxGraphics
		t._context=bbGfxGraphicsCreateGraphics( width,height,depth,hertz,flags )

		If Not _inited Then
			InitGraphics(width, height)
		End If
		
		Return t
	End Method
	
	Method SetGraphics:Int( g:TGraphics )
		Local context:Byte Ptr
		Local t:TGfxGraphics=TGfxGraphics( g )
		If t context=t._context
		bbGfxGraphicsSetGraphics context
	End Method
	
	Method Flip:Int( sync:Int )
		bbGfxGraphicsFlip sync
	End Method

	Rem
	bbdoc: 
	End Rem
	Method InitGraphics(width:Int, height:Int, rendererType:EBGFXRenderType = EBGFXRenderType.COUNT)
		If Not TBGFX.Init(width, height, rendererType) Then
			Throw "Failed to initialise graphics"
		End If
		_inited = True
	End Method

End Type


Function GfxGraphicsDriver:TGfxGraphicsDriver()
	Global _driver:TGfxGraphicsDriver=New TGfxGraphicsDriver
	Return _driver
End Function

Rem
bbdoc: Create graphics
returns: A graphics object
about:
This is a convenience function that allows you to easily create a graphics context.
End Rem
Function GfxGraphics:TGraphics( width:Int, height:Int, depth:Int = 0, hertz:Int = 60, flags:Int = GRAPHICS_BACKBUFFER|GRAPHICS_DEPTHBUFFER )
	SetGraphicsDriver GfxGraphicsDriver()
	Return Graphics( width,height,depth,hertz,flags )
End Function
	
SetGraphicsDriver GfxGraphicsDriver()
