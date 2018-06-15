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
bbdoc: BGFX Utilities.
End Rem
Module gfx.bx

ModuleInfo "Version: 1.00"
ModuleInfo "License: BSD"
ModuleInfo "Copyright: BX - 2011-2018 Branimir Karadzic. All rights reserved"
ModuleInfo "Copyright: Wrapper - 2015-2018 Bruce A Henderson"

ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release."

?linuxx86
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++0x"
?linuxx64
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++0x"
?macos
ModuleInfo "CC_OPTS: -msse2"
?win32
ModuleInfo "CC_OPTS: -mfpmath=sse -msse2 -std=c++0x"

?raspberrypi
ModuleInfo "CC_OPTS: -std=c++0x"
?

ModuleInfo "CC_OPTS: -D__STDC_LIMIT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS"


Import "common.bmx"


Rem
bbdoc: Sets the 4x4 matrix to an identity matrix.
End Rem
Function mtxIdentity(result:Float Ptr)
	bmx_bx_mtxIdentity(result)
End Function

Rem
bbdoc: Sets the 4x4 matrix to the translation matrix tx, ty, tz.
End Rem
Function mtxTranslate(result:Float Ptr, tx:Float, ty:Float, tz:Float)
	bmx_bx_mtxTranslate(result, tx, ty, tz)
End Function

Rem
bbdoc: Sets the 4x4 matrix to the scale matrix sx, sy, sz.
End Rem
Function mtxScale(result:Float Ptr, sx:Float, sy:Float, sz:Float)
	bmx_bx_mtxScale(result, sx, sy, sz)
End Function

Rem
bbdoc: 
End Rem
Function mtxQuat(result:Float Ptr, quatVec4:Float Ptr)
	bmx_bx_mtxQuat(result, quatVec4)
End Function

Rem
bbdoc: 
End Rem
Function mtxQuatTranslation(result:Float Ptr, quatVec4:Float Ptr, translationVec3:Float Ptr)
	bmx_bx_mtxQuatTranslation(result, quatVec4, translationVec3)
End Function

Rem
bbdoc: 
End Rem
Function mtxQuatTranslationHMD(result:Float Ptr, quatVec4:Float Ptr, translationVec3:Float Ptr)
	bmx_bx_mtxQuatTranslationHMD(result, quatVec4, translationVec3)
End Function

Rem
bbdoc: 
End Rem
Function mtxLookAt(result:Float Ptr, eyeVec3:Float Ptr, atVec3:Float Ptr, upVec3:Float Ptr = Null)
	If upVec3 Then
		bmx_bx_mtxLookAt(result, eyeVec3, atVec3, upVec3)
	Else
		bmx_bx_mtxLookAt(result, eyeVec3, atVec3, Null)
	End If
End Function

'Rem
'bbdoc: 
'End Rem
'Function mtxProjXYWH(result:Float Ptr, x:Float, y:Float, width:Float, height:Float, near:Float, far:Float, oglNdc:Int = False)
'	bmx_bx_mtxProjXYWH(result, x, y, width, height, near, far, oglNdc)
'End Function

Rem
bbdoc: 
End Rem
Function mtxProj(result:Float Ptr, ut:Float, dt:Float, lt:Float, rt:Float, near:Float, far:Float, oglNdc:Int = False)
	bmx_bx_mtxProj(result, ut, dt, lt, rt, near, far, oglNdc)
End Function

Rem
bbdoc: 
End Rem
Function mtxProjFovyAspet(result:Float Ptr, fovy:Float, aspect:Float, near:Float, far:Float, oglNdc:Int = False)
	bmx_bx_mtxProjFovyAspet(result, fovy, aspect, near, far, oglNdc)
End Function

Rem
bbdoc: 
End Rem
Function mtxOrtho(result:Float Ptr, Left:Float, Right:Float, bottom:Float, top:Float, near:Float, far:Float, offset:Float = 0, oglNdc:Int = False)
	bmx_bx_mtxOrtho(result, Left, Right, bottom, top, near, far, offset, oglNdc)
End Function

Rem
bbdoc: Sets the 4x4 matrix to a rotation matrix rotated by ax degrees.
End Rem
Function mtxRotateX(result:Float Ptr, ax:Float)
	bmx_bx_mtxRotateX(result, ax)
End Function

Rem
bbdoc: Sets the 4x4 matrix to a rotation matrix rotated by ay degrees.
End Rem
Function mtxRotateY(result:Float Ptr, ay:Float)
	bmx_bx_mtxRotateY(result, ay)
End Function

Rem
bbdoc: Sets the 4x4 matrix to a rotation matrix rotated by az degrees.
End Rem
Function mtxRotateZ(result:Float Ptr, az:Float)
	bmx_bx_mtxRotateZ(result, az)
End Function

Rem
bbdoc: Sets the 4x4 matrix to a rotation matrix rotated by ax and ay degrees.
End Rem
Function mtxRotateXY(result:Float Ptr, ax:Float, ay:Float)
	bmx_bx_mtxRotateXY(result, ax, ay)
End Function

Rem
bbdoc: Sets the 4x4 matrix to a rotation matrix rotated by ax, ay and az degrees.
End Rem
Function mtxRotateXYZ(result:Float Ptr, ax:Float, ay:Float, az:Float)
	bmx_bx_mtxRotateXYZ(result, ax, ay, az)
End Function

Rem
bbdoc: Sets the 4x4 matrix to a rotation matrix rotated by az, ay and ax degrees.
End Rem
Function mtxRotateZYX(result:Float Ptr, ax:Float, ay:Float, az:Float)
	bmx_bx_mtxRotateZYX(result, ax, ay, az)
End Function

Rem
bbdoc: 
End Rem
Function mtxMul(result:Float Ptr, a:Float Ptr, b:Float Ptr)
	bmx_bx_mtxMul(result, a, b)
End Function

Rem
bbdoc: 
End Rem
Function mtxTranspose(result:Float Ptr, a:Float Ptr)
	bmx_bx_mtxTranspose(result, a)
End Function
