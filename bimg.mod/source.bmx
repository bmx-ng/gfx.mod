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

Import "bimg/include/*.h"
Import "../bx.mod/bx/include/*.h"
Import "bimg/3rdparty/*.h"
Import "bimg/3rdparty/iqa/include/*.h"

?macos
Import "../bx.mod/bx/include/compat/osx/*.h"
?win32
Import "../bx.mod/bx/include/compat/mingw/*.h"
?

Import "bimg/src/image.cpp"
Import "bimg/src/image_decode.cpp"
Import "bimg/src/image_encode.cpp"
Import "bimg/src/image_gnf.cpp"

Import "bimg/3rdparty/iqa/source/convolve.c"
Import "bimg/3rdparty/iqa/source/decimate.c"
Import "bimg/3rdparty/iqa/source/math_utils.c"
Import "bimg/3rdparty/iqa/source/mse.c"
Import "bimg/3rdparty/iqa/source/ms_ssim.c"
Import "bimg/3rdparty/iqa/source/psnr.c"
Import "bimg/3rdparty/iqa/source/ssim.c"

