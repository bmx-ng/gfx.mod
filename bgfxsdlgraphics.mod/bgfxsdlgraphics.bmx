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

Module gfx.bgfxsdlgraphics


Import "common.bmx"

Private
Global _currentContext:TGraphicsContext
Public

Type TGraphicsContext
	Field Mode:Int
	Field width:Int
	Field height:Int
	Field depth:Int
	Field hertz:Int
	Field flags:Int
	Field sync:Int

	Field window:TSDLWindow
'	Field context:TSDLGLContext
	Field info:Byte Ptr
	Field data:Object
End Type

Private

Extern
	Function bbGfxGraphicsShareContexts()
	Function bbGfxGraphicsGraphicsModes:Int( display:Int, buf:Byte Ptr, size:Int )
	Function bbGfxGraphicsAttachGraphics:Byte Ptr( widget:Byte Ptr,flags:Int )
	Function bbGfxGraphicsGetSettings( context:Byte Ptr, width:Int Var, height:Int Var, depth:Int Var, hertz:Int Var, flags:Int Var )
	Function bbGfxGraphicsClose( context:Byte Ptr )	
	Function bbGfxGraphicsSetGraphics( context:Byte Ptr )
	Function bbGfxGraphicsFlip( sync:Int )
	Function bbGfxGraphicsCls()
	Function bbGfxSetPlatformData(handle:Byte Ptr)
End Extern

Public

Type TGfxGraphics Extends TGraphics

	Method Driver:TGfxGraphicsDriver()
		Assert _context
		Return GfxGraphicsDriver()
	End Method
	
	Method GetSettings:Int( width:Int Var,height:Int Var,depth:Int Var,hertz:Int Var,flags:Int Var, x:Int var, y:Int var)
		Assert _context
		width=_context.width
		height=_context.height
		depth=_context.depth
		hertz=_context.hertz
		flags=_context.flags
	End Method
	
	Method Close:Int()
		If Not _context Return 0

		If _currentContext = _context Then
			_currentContext = Null
		End If

		If _context.window Then
			_context.window.Destroy()
		End If
		_context=Null
	End Method

	Method GetHandle:Byte Ptr()
		If _context Then
			Return _context.window.GetWindowHandle()
		End If
	End Method

	Method Resize:Int(width:Int, height:Int)
		TBGFX.Reset(width, height, BGFX_RESET_VSYNC | BGFX_RESET_HIDPI)
	End Method

	Method Position:Int(x:Int, y:Int)
		'
	End Method

	Field _context:TGraphicsContext
	
End Type

Type TGfxGraphicsDriver Extends TGraphicsDriver

	Global _inited:Int

	Method GraphicsModes:TGraphicsMode[]()
		Local buf:Int[1024*4]
		Local count:Int=bbGfxGraphicsGraphicsModes( 0,buf,1024 )
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
	
	Method CreateGraphics:TGfxGraphics( width:Int, height:Int, depth:Int, hertz:Int, flags:Int, x:Int, y:Int )
		Local t:TGfxGraphics=New TGfxGraphics
		t._context=GfxGraphicsCreateGraphics( width,height,depth,hertz,flags )

		If Not _inited Then
			Local rtype:EBGFXRenderType
?win32
			' hard coded for now until I can work out how to get the others to render correctly...
			rtype = EBGFXRenderType.DIRECT3D9
?Not win32
			rtype = EBGFXRenderType.OPENGL
?		
			InitGraphics(width, height, rtype)
		End If

		Return t
	End Method

	Method GfxGraphicsCreateGraphics:TGraphicsContext(width:Int,height:Int,depth:Int,hertz:Int,flags:Int)
		Local context:TGraphicsContext = New TGraphicsContext

		Local windowFlags:UInt '= SDL_WINDOW_ALLOW_HIGHDPI
		Local gFlags:UInt
		Local glFlags:UInt = flags
Rem
		If flags & SDL_GRAPHICS_NATIVE Then

			flags :~ SDL_GRAPHICS_NATIVE

			gFlags = flags & (SDL_GRAPHICS_BACKBUFFER | SDL_GRAPHICS_ALPHABUFFER | SDL_GRAPHICS_DEPTHBUFFER | SDL_GRAPHICS_STENCILBUFFER | SDL_GRAPHICS_ACCUMBUFFER)

			flags :~ SDL_GRAPHICS_GL

			flags :~ (SDL_GRAPHICS_BACKBUFFER | SDL_GRAPHICS_ALPHABUFFER | SDL_GRAPHICS_DEPTHBUFFER | SDL_GRAPHICS_STENCILBUFFER | SDL_GRAPHICS_ACCUMBUFFER)

			windowFlags :| flags

			If glFlags Then
				If gFlags & SDL_GRAPHICS_BACKBUFFER Then SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
				If gFlags & SDL_GRAPHICS_ALPHABUFFER Then SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 1)
				If gFlags & SDL_GRAPHICS_DEPTHBUFFER Then SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
				If gFlags & SDL_GRAPHICS_STENCILBUFFER Then SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 1)
			End If

		Else

			If depth Then
				windowFlags :| SDL_WINDOW_FULLSCREEN
				' mode = MODE_DISPLAY
			Else
				If flags & $80000000 Then
					windowFlags :| SDL_WINDOW_FULLSCREEN_DESKTOP
				End If
				' mode = MODE_WINDOW
			End If

			gFlags = flags & (GRAPHICS_BACKBUFFER | GRAPHICS_ALPHABUFFER | GRAPHICS_DEPTHBUFFER | GRAPHICS_STENCILBUFFER | GRAPHICS_ACCUMBUFFER)

			If glFlags Then
				If gFlags & GRAPHICS_BACKBUFFER Then SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
				If gFlags & GRAPHICS_ALPHABUFFER Then SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 1)
				If gFlags & GRAPHICS_DEPTHBUFFER Then SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
				If gFlags & GRAPHICS_STENCILBUFFER Then SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE, 1)
			End If
		End If

End Rem
		'End If

		context.window = TSDLWindow.Create(AppTitle, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, windowFlags)
		'If glFlags Then
		'	context.context = context.window.GLCreateContext()
		'	SDL_GL_SetSwapInterval(-1)
		'	context.sync = -1
		'End If

		context.width = width
		context.height = height
		context.depth = depth
		context.hertz = hertz
		context.flags = flags
		
		bbGfxSetPlatformData(context.window.WindowPtr)
		
		TBGFX.RenderFrame()

		AddHook EmitEventHook,GraphicsHook,context,0

		Return context
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
	
	Method SetViewRect()
		TBGFX.SetViewRectRatio(0, 0, 0, 0)
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

	Function GraphicsHook:Object( id:Int,data:Object,context:Object )
		Local ev:TEvent=TEvent(data)
		If Not ev Return data

		Select ev.id
			Case EVENT_WINDOWSIZE
				Local ctxt:TGraphicsContext = TGraphicsContext(context)
				If ctxt Then
					If ctxt.window.GetID() = ev.data Then
						ctxt.width = ev.x
						ctxt.height = ev.y
						GraphicsResize(ev.x, ev.y)
					End If
				End If
		End Select

		Return data
	End Function

	Method CanResize:Int()
		Return True
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
Function GfxGraphics:TGraphics( width:Int, height:Int, depth:Int = 0, hertz:Int = 60, flags:Int = 0 )
	SetGraphicsDriver GfxGraphicsDriver()
	Return Graphics( width,height,depth,hertz,flags )
End Function
	
SetGraphicsDriver GfxGraphicsDriver()
