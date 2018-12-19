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

Import gfx.bimg
Import gfx.bxstream

Import "source.bmx"

Extern

	Function bmx_bimg_options_new:Byte Ptr()
	Function bmx_bimg_options_free(handle:Byte Ptr)
	Function bmx_bimg_options_setMaxSize(handle:Byte Ptr, maxSize:Int)
	Function bmx_bimg_options_setEdge(handle:Byte Ptr, edge:Float)
	Function bmx_bimg_options_setFormat(handle:Byte Ptr, format:Int)
	Function bmx_bimg_options_setQuality(handle:Byte Ptr, quality:Int)
	Function bmx_bimg_options_setMips(handle:Byte Ptr, mips:Int)
	Function bmx_bimg_options_setNormalMap(handle:Byte Ptr, normalMap:Int)
	Function bmx_bimg_options_setEquirect(handle:Byte Ptr, equirect:Int)
	Function bmx_bimg_options_setIqa(handle:Byte Ptr, iqa:Int)
	Function bmx_bimg_options_setPma(handle:Byte Ptr, pma:Int)
	Function bmx_bimg_options_setSdf(handle:Byte Ptr, sdf:Int)
	Function bmx_bimg_options_setAlphaTest(handle:Byte Ptr, alphaTest:Int)
	Function bmx_bimg_options_setOutputType(handle:Byte Ptr, outputType:Int)
	
	Function bmx_bimg_texturec_convert(iStream:Byte Ptr, oStream:Byte Ptr, options:Byte Ptr)


End Extern

Const OUTPUT_KTX:Int = 0
Const OUTPUT_DDS:Int = 1
Const OUTPUT_PNG:Int = 2
Const OUTPUT_EXR:Int = 3
Const OUTPUT_HDR:Int = 4
