SuperStrict

Framework gfx.bx
Import brl.standardio

Local mat:Float[16]


PrintMatrix(mat)

mtxIdentity(mat)

PrintMatrix(mat, "Identity")

mtxTranslate(mat, 5, 6, 0)

PrintMatrix(mat, "Translate")

mtxScale(mat, 2, 4, 0)

PrintMatrix(mat, "Scale")


mtxIdentity(mat)
mtxRotateX(mat, 45)

PrintMatrix(mat, "45 degree X Rotation")

mtxRotateXYZ(mat, 45, 90, 0)

PrintMatrix(mat, "45, 90, 0 degree YYZ Rotation")


Function PrintMatrix(mat:Float Ptr, text:String = Null)
	If text Then
		Print text
	End If
	Local i:Int
	Local s:String
	For Local x:Int = 0 Until 4
		If text Then
			s = "    "
		Else
			s = ""
		End If
		For Local y:Int = 0 Until 4
			s :+ mat[i] + " "
			i:+ 1
		Next
		Print s
	Next
End Function

