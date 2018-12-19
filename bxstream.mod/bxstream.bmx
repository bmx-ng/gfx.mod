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

Module gfx.bxstream

?linuxx86
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++14"
?linuxx64
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++14"
?macos
ModuleInfo "CC_OPTS: -msse2"
?win32
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++14"

?raspberrypi
ModuleInfo "CC_OPTS: -std=c++14"
?

ModuleInfo "CC_OPTS: -D__STDC_LIMIT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS"


Import "common.bmx"


Type TBxStreamWrapper

	Field bxStreamPtr:Byte Ptr

	Method Create:TBxStreamWrapper(stream:TStream)
		bxStreamPtr = bmx_bx_stream_new(stream)
		Return Self
	End Method
	
	Method Free()
		If bxStreamPtr Then
			bmx_bx_stream_free(bxStreamPtr)
			bxStreamPtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method

	Function _seek:Long(stream:TStream, offset:Long, whence:Int) { nomangle }
		Return stream.Seek(offset, whence)
	End Function

	Function _write:Int(stream:TStream, data:Byte Ptr, size:Int) { nomangle }
		Return stream.Write(data, size)
	End Function
	
	Function _read:Int(stream:TStream, data:Byte Ptr, size:Int) { nomangle }
		Return stream.Read(data, size)
	End Function
	
	Function _close(stream:TStream) { nomangle }
		stream.Close()
	End Function

End Type
