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

Import "source.bmx"

?win32
Import "-lpsapi"
?

Extern

	Function bmx_bx_mtxIdentity(result:Float Ptr)
	Function bmx_bx_mtxTranslate(result:Float Ptr, tx:Float, ty:Float, tz:Float)
	Function bmx_bx_mtxScale(result:Float Ptr, sx:Float, sy:Float, sz:Float)
	Function bmx_bx_mtxQuat(result:Float Ptr, quat:Float Ptr)
	Function bmx_bx_mtxQuatTranslation(result:Float Ptr, quat:Float Ptr, translation:Float Ptr)
	Function bmx_bx_mtxQuatTranslationHMD(result:Float Ptr, quat:Float Ptr, translation:Float Ptr)
	Function bmx_bx_mtxLookAt(result:Float Ptr, eye:Float Ptr, at:Float Ptr, up:Float Ptr)
	'Function bmx_bx_mtxProjXYWH(result:Float Ptr, x:Float, y:Float, width:Float, height:Float, near:Float, far:Float, oglNdc:Int)
	Function bmx_bx_mtxProj(result:Float Ptr, ut:Float, dt:Float, lt:Float, rt:Float, near:Float, far:Float, oglNdc:Int)
	Function bmx_bx_mtxProjFovyAspet(result:Float Ptr, fovy:Float, aspect:Float, near:Float, far:Float, oglNdc:Int)
	Function bmx_bx_mtxOrtho(result:Float Ptr, Left:Float, Right:Float, bottom:Float, top:Float, near:Float, far:Float, offset:Float, oglNdc:Int)
	Function bmx_bx_mtxRotateX(result:Float Ptr, ax:Float)
	Function bmx_bx_mtxRotateY(result:Float Ptr, ay:Float)
	Function bmx_bx_mtxRotateZ(result:Float Ptr, az:Float)
	Function bmx_bx_mtxRotateXY(result:Float Ptr, ax:Float, ay:Float)
	Function bmx_bx_mtxRotateXYZ(result:Float Ptr, ax:Float, ay:Float, az:Float)
	Function bmx_bx_mtxRotateZYX(result:Float Ptr, ax:Float, ay:Float, az:Float)
	Function bmx_bx_mtxMul(result:Float Ptr, a:Float Ptr, b:Float Ptr)
	Function bmx_bx_mtxTranspose(result:Float Ptr, a:Float Ptr)

End Extern
