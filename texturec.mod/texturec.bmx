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

Rem
bbdoc: BGFX Texture Compiler
End Rem
Module gfx.texturec

?linuxx86
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++0x"
?linuxx64
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++0x"
?macos
ModuleInfo "CC_OPTS: -msse2"
?win32
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++0x"

ModuleInfo "CC_OPTS: -D__STDC_LIMIT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS"

?raspberrypi
ModuleInfo "CC_OPTS: -std=c++0x"
?

Import "common.bmx"

Type TOptions

	Field optionsPtr:Byte Ptr
	
	Method New()
		optionsPtr = bmx_bimg_options_new()
	End Method

	Method SetMaxSize:TOptions(maxSize:Int)
		bmx_bimg_options_setMaxSize(optionsPtr, maxSize)
		Return Self
	End Method
	
	Method SetEdge:TOptions(edge:Float = 0.0)
		bmx_bimg_options_setEdge(optionsPtr, edge)
		Return Self
	End Method
	
	Method SetFormat:TOptions(format:Int)
		bmx_bimg_options_setFormat(optionsPtr, format)
		Return Self
	End Method
	
	Method SetQuality:TOptions(quality:Int)
		bmx_bimg_options_setQuality(optionsPtr, quality)
		Return Self
	End Method
	
	Method SetMips:TOptions(mips:Int)
		bmx_bimg_options_setMips(optionsPtr, mips)
		Return Self
	End Method
	
	Method SetNormalMap:TOptions(normalMap:Int)
		bmx_bimg_options_setNormalMap(optionsPtr, normalMap)
		Return Self
	End Method
	
	Method SetEquirect:TOptions(equirect:Int)
		bmx_bimg_options_setEquirect(optionsPtr, equirect)
		Return Self
	End Method
	
	Method SetIqa:TOptions(iqa:Int)
		bmx_bimg_options_setIqa(optionsPtr, iqa)
		Return Self
	End Method
	
	Method SetPma:TOptions(pma:Int)
		bmx_bimg_options_setPma(optionsPtr, pma)
		Return Self
	End Method
	
	Method SetSdf:TOptions(sdf:Int)
		bmx_bimg_options_setSdf(optionsPtr, sdf)
		Return Self
	End Method
	
	Method SetAlphaTest:TOptions(alphaTest:Int)
		bmx_bimg_options_setAlphaTest(optionsPtr, alphaTest)
		Return Self
	End Method
	
	Method SetOutputType:TOptions(outputType:Int)
		bmx_bimg_options_setOutputType(optionsPtr, outputType)
		Return Self
	End Method

	Method Delete()
		If optionsPtr Then
			bmx_bimg_options_free(optionsPtr)
			optionsPtr = Null
		End If
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Function TextureC(in:TStream, out:TStream, options:TOptions = Null)
	Local iStream:TBxStreamWrapper = New TBxStreamWrapper.Create(in)
	Local oStream:TBxStreamWrapper = New TBxStreamWrapper.Create(out)
	
	If options Then
		bmx_bimg_texturec_convert(iStream.bxStreamPtr, oStream.bxStreamPtr, options.optionsPtr)
	Else
		bmx_bimg_texturec_convert(iStream.bxStreamPtr, oStream.bxStreamPtr, Null)
	End If
	
	iStream.Free()
	oStream.Free()
End Function
