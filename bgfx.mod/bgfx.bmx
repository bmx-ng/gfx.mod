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
bbdoc: 
End Rem
Module gfx.bgfx

ModuleInfo "Version: 1.00"
ModuleInfo "License: BSD"
ModuleInfo "Copyright: BGFX - 2011-2018 Branimir Karadzic. All rights reserved"
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


'ModuleInfo "CC_OPTS: -DBGFX_CONFIG_DEBUG"


Import brl.standardio

Import "common.bmx"

Rem
bbdoc: 
End Rem
Type TBGFX

	Function Init:Int(width:Int, height:Int, rendererType:Int = BGFX_RENDERER_TYPE_COUNT)
		Return bmx_bgfx_init(width, height, rendererType)
	End Function

	Rem
	bbdoc: Resets graphic settings and back-buffer size.
	about: This call doesn't actually change window size, it just resizes back-buffer. Windowing code has to change window size.
	End Rem
	Function Reset(width:Int, height:Int, flags:Int = BGFX_RESET_NONE)
		bmx_bgfx_reset(width, height, flags)
	End Function

'	Rem
'	bbdoc: 
'	End Rem
'	Function Submit:Int(id:Short, depth:Int)
'		Return bmx_bgfx_submit(id, depth)
'	End Function
	
	Rem
	bbdoc: Advances to next frame.
	returns: Current frame number. This might be used in conjunction with double/multi buffering data outside the library and passing it to library via makeRef calls.
	about: When using multithreaded renderer, this call just swaps internal buffers, kicks render thread, and returns. In
	singlethreaded renderer this call does frame rendering.
	End Rem
	Function Frame:Int(capture:Int = False)
		Return bmx_bgfx_frame(capture)
	End Function
	
	Function SetDebug(debugFlags:Int)
		bmx_bgfx_set_debug(debugFlags)
	End Function
	
	Function DebugTextClear(attr:Byte = 0, small:Int = False)
		bmx_bgfx_dbg_text_clear(attr, small)
	End Function
	
	Function DebugTextPrint(x:Short, y:Short, attr:Byte, text:String)
		bmx_bgfx_dbg_text_printf(x, y, attr, text)
	End Function
	
	Function DebugTextImage(x:Short, y:Short, width:Short, height:Short, data:Byte Ptr, pitch:Short)
		bmx_bgfx_dbg_text_image(x, y, width, height, data, pitch)
	End Function
	
	Function GetRenderType:Int()
		' TODO
	End Function
	
	Rem
	bbdoc: Returns renderer capabilities.
	End Rem
	Function GetCaps:TBGFXCaps()
		Return TBGFXCaps._Create(bmx_bgfx_get_caps())
	End Function
	
	Function GetStats:TBGFXStats()
		' TODO
	End Function
	
	Function GetHMD:TBGFXHMD()
		' TODO
	End Function
	
	Rem
	bbdoc: Sets view rectangle.
	about: Draw primitive outside view will be clipped.
	End Rem
	Function SetViewRect(id:Short, x:Int, y:Int, width:Int, height:Int)
		bmx_bgfx_set_view_rect(id, x, y, width, height)
	End Function
	
	Rem
	bbdoc: Sets view rectangle.
	about: Draw primitive outside view will be clipped.
	End Rem
	Function SetViewRectAuto(id:Short, x:Short, y:Short, ratio:Int)
		bmx_bgfx_set_view_rect_auto(id, x, y, ratio)
	End Function

	Rem
	bbdoc: Sets view clear flags with different clear color for each frame buffer texture.
	about: Must use SetClearColor to setup clear color palette. Use BGFX_CLEAR_NONE to remove any clear.
	End Rem
	Function SetViewClear(id:Short, flags:Short, rgba:Int = $000000ff, depth:Float = 1.0, stencil:Byte = 0)
		bmx_bgfx_set_view_clear(id, flags, rgba, depth, stencil)
	End Function
	
	Rem
	bbdoc: Sets view sorting mode.
	about: View mode must be set prior calling Submit for the view.
	End Rem
	Function SetViewClearMrt(id:Short, flags:Short, depth:Float, stencil:Byte, p0:Byte = $FF, p1:Byte = $FF, p2:Byte = $FF, p3:Byte = $FF, p4:Byte = $FF, p5:Byte = $FF, p6:Byte = $FF, p7:Byte = $FF)
		bmx_bgfx_set_view_clear_mrt(id, flags, depth, stencil, p0, p1, p2, p3, p4, p5, p6, p7)
	End Function
	
	Rem
	bbdoc: 
	End Rem
	Function SetViewMode(id:Short, viewMode:Int)
		bmx_bgfx_set_view_mode(id, viewMode)
	End Function
	
	Rem
	bbdoc: Sets the view and projection matrices, all draw primitives in this view will use these matrices.
	End Rem
	Function SetViewTransform(id:Short, view:Byte Ptr, proj:Byte Ptr)
		bmx_bgfx_set_view_transform(id, view, proj)
	End Function

	Rem
	bbdoc: Posts submit view reordering.
	End Rem
	Function SetViewOrder(id:Short = 0, num:Short = $FFFF, order:Short Ptr = Null)
		bmx_bgfx_set_view_order(id, num, order)
	End Function
	
	Rem
	bbdoc: Sets view frame buffer.
	about: Not persistent after Reset() call.
	End Rem
	Function SetViewFrameBuffer(id:Short, frameBuffer:Short)
		bmx_bgfx_set_view_frame_buffer(id, frameBuffer)
	End Function
		
	Rem
	bbdoc: Sets view scissor.
	about: Draw primitive outside view will be clipped. When @x, @y, @width and @height are set to 0, scissor will be disabled.
	End Rem
	Function SetViewScissor(id:Short, x:Short, y:Short, width:Short, height:Short)
		bmx_bgfx_set_view_scissor(id, x, y, width, height)
	End Function

	Rem
	bbdoc: Sets clear color palette value.
	about: 
	End Rem
	Function SetClearColor(index:Int, r:Int, g:Int, b:Int, a:Int)
		'bmx_bgfx_set_clear_color(index, r, g, b, a)
	End Function
	
	Rem
	bbdoc: Shutdowns bgfx library.
	End Rem
	Function Shutdown()
		bmx_bgfx_shutdown()
	End Function
	
End Type

Rem
bbdoc: A memory buffer.
End Rem
Type TBGFXMemory

	Field memPtr:Byte Ptr
	
	Rem
	bbdoc: Allocates buffer to pass to bgfx calls.
	about: Data will be freed inside bgfx.
	End Rem
	Function Alloc:TBGFXMemory(size:Int)
		Local this:TBGFXMemory = New TBGFXMemory
		this.memPtr = bgfx_alloc(size)
		Return this
	End Function
	
	Rem
	bbdoc: Allocates buffer and copy data into it.
	about: Data will be freed inside bgfx.
	End Rem
	Function Copy:TBGFXMemory(data:Byte Ptr, size:Int)
		Local this:TBGFXMemory = New TBGFXMemory
		this.memPtr = bgfx_copy(data, size)
		Return this
	End Function
	
End Type

Rem
bbdoc: A static index buffer.
End Rem
Type TBGFXIndexBuffer

	Field bufferPtr:Byte Ptr

	Method Create:TBGFXIndexBuffer(mem:TBGFXMemory, flags:Int = BGFX_BUFFER_NONE)
		'bufferPtr = bmx_bgfx_create_index_buffer(mem.memPtr, flags)
		Return Self
	End Method
	
	Method Destroy()
		If bufferPtr Then
			'bmx_bgfx_destroy_index_buffer(bufferPtr)
			bufferPtr = Null
		End If
	End Method
	
End Type

Type TBGFXShader
	
	Field shaderHandle:Short
	
	Method Create:TBGFXShader(mem:TBGFXMemory)
		shaderHandle = bmx_bgfx_create_shader(mem.memPtr)
		Return Self
	End Method
	
	Method GetUniforms:Short(uniforms:Short Ptr, maximum:Short)
		Return bmx_bgfx_get_shader_uniforms(shaderHandle, uniforms, maximum)
	End Method
	
	Method SetName(name:String)
		bmx_bgfx_set_shader_name(shaderHandle, name)
	End Method
	
	Method Destroy()
		If shaderHandle Then
			bmx_bgfx_destroy_shader(shaderHandle)
			shaderHandle = Null
		End If
	End Method
	
End Type

Type TBGFXUniform

	Field uniformHandle:Short
	
	Field info:TBGFXUniformInfo
	
	Method Create:TBGFXUniform(name:String, uniformType:Int, num:Short)
		uniformHandle = bmx_bgfx_create_uniform(name, uniformType, num)
		Return Self
	End Method

	Method GetInfo:TBGFXUniformInfo()
		If Not info Then
			info = TBGFXUniformInfo._Create(uniformHandle)
		End If
		Return info
	End Method
		
	Method Destroy()
		If uniformHandle Then
			bmx_bgfx_destroy_uniform(uniformHandle)
			uniformHandle = 0
		End If
	End Method

End Type


Type TBGFXUniformInfo

	Field infoPtr:Byte Ptr
	
	Function _Create:TBGFXUniformInfo(uniform:Short)
		If uniform Then
			Local this:TBGFXUniformInfo = New TBGFXUniformInfo
			this.infoPtr = bmx_bgfx_get_uniform_info(uniform)
			Return this
		End If
	End Function	
	
	Method Delete()
		If infoPtr Then
			bmx_bgfx_uniform_info_free(infoPtr)
		End If
	End Method
	
End Type

Type TBGFXProgram

	Field programHandle:Short
	
	Method Create:TBGFXProgram(vsh:TBGFXShader, fsh:TBGFXShader, destroyShaders:Int)
		programHandle = bmx_bgfx_create_program(vsh.shaderHandle, fsh.shaderHandle, destroyShaders)
		Return Self
	End Method

	Method ComputeProgram:TBGFXProgram(csh:TBGFXShader, destroyShaders:Int)
		programHandle = bmx_bgfx_create_compute_program(csh.shaderHandle, destroyShaders)
		Return Self
	End Method
	
	Method Destroy()
		If programHandle Then
			bmx_bgfx_destroy_program(programHandle)
			programHandle = 0
		End If
	End Method
	
End Type


Rem
bbdoc: 
End Rem
Type TBGFXTexture

	Field textureHandle:Short
	
	Rem
	bbdoc: Creates a texture from memory buffer.
	about: 
	End Rem
	Method Create:TBGFXTexture(mem:TBGFXMemory, flags:Int, skip:Int, info:TBGFXTextureInfo = Null)
		If info Then
			textureHandle = bmx_bgfx_create_texture(mem.memPtr, flags, skip, info.infoPtr)
		Else
			textureHandle = bmx_bgfx_create_texture(mem.memPtr, flags, skip, Null)
		End If
		Return Self
	End Method

	Rem
	bbdoc: 
	End Rem
	Method Create2D:TBGFXTexture(width:Short, height:Short, hasMips:Int, numLayers:Short, format:Short, flags:Int, mem:TBGFXMemory)
		textureHandle = bmx_bgfx_create_texture_2d(width, height, hasMips, numLayers, format, flags, mem.memPtr)
		Return Self
	End Method
	
	Method Create2DScaled:TBGFXTexture(ratio:Int, hasMips:Int, numLayers:Short, format:Short, flags:Int)
		textureHandle = bmx_bgfx_create_texture_2d_scaled(ratio, hasMips, numLayers, format, flags)
		Return Self
	End Method

	Rem
	bbdoc: 
	End Rem
	Method Destroy()
		If textureHandle Then
			bmx_bgfx_destroy_texture(textureHandle)
			textureHandle = 0
		End If
	End Method
	
	Rem
	bbdoc: Validates texture parameters.
	returns: True if texture can be successfully created.
	End Rem
	Function IsValid:Int(depth:Short, cubeMap:Int, numLayers:Short, format:Short, flags:Int)
		Return bmx_bgfx_is_texture_valid(depth, cubeMap, numLayers, format, flags)
	End Function
	
	Rem
	bbdoc: Calculates amount of memory required for texture.
	End Rem
	Function CalcSize(info:TBGFXTextureInfo, width:Short, height:Short, depth:Short, cubeMap:Int, hasMips:Int, numLayers:Short, format:Short)
		bmx_bgfx_calc_texture_size(info.infoPtr, width, height, depth, cubeMap, hasMips, numLayers, format)
	End Function
	
End Type

Rem
bbdoc: 
End Rem
Type TBGFXTextureInfo

	Field infoPtr:Byte Ptr

	Method New()
		infoPtr = bmx_bgfx_texture_info_new()
	End Method

	Rem
	bbdoc: 
	End Rem
	Method Format:Short()
		Return bmx_bgfx_texture_format(infoPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method StorageSize:Int()
		Return bmx_bgfx_texture_storageSize(infoPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Width:Int()
		Return bmx_bgfx_texture_width(infoPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Height:Int()
		Return bmx_bgfx_texture_height(infoPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Depth:Int()
		Return bmx_bgfx_texture_depth(infoPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Mips:Int()
		Return bmx_bgfx_texture_mips(infoPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method BitsPerPixel:Int()
		Return bmx_bgfx_texture_bitsperpixel(infoPtr)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method CubeMap:Int()
		Return bmx_bgfx_texture_cubemap(infoPtr)
	End Method

	Method Delete()
		If infoPtr Then
			bmx_bgfx_texture_info_free(infoPtr)
			infoPtr = Null
		End If
	End Method
	
End Type

Type TBGFXTransform
	Field transformPtr:Byte Ptr
End Type

Type TBGFXInstanceDataBuffer
	Field bufferPtr:Byte Ptr
End Type

Type TBGFXCaps

	Field capsPtr:Byte Ptr
	
	Field _limits:TBGFXCapsLimits
	
	Function _Create:TBGFXCaps(capsPtr:Byte Ptr)
		If capsPtr Then
			Local this:TBGFXCaps = New TBGFXCaps
			this.capsPtr = capsPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Renderer backend type.
	End Rem
	Method RenderType:Int()
	End Method
	
	Rem
	bbdoc: Supported functionality.
	End Rem
	Method Supported:Long()
		' TODO use var ptr
	End Method
	
	Rem
	bbdoc: Selected GPU vendor PCI id.
	End Rem
	Method VendorId:Short()
	End Method
	
	Rem
	bbdoc: Selected GPU device id.
	End Rem
	Method DeviceId:Short()
	End Method
	
	Rem
	bbdoc: True when NDC depth is in [-1, 1] range, otherwise its [0, 1].
	End Rem
	Method HomogeneousDepth:Int()
	End Method
	
	Rem
	bbdoc: True when NDC origin is at bottom left.
	End Rem
	Method OriginBottomLeft:Int()
	End Method
	
	Rem
	bbdoc: Number of enumerated GPUs.
	End Rem
	Method NumGPUs:Byte()
	End Method
	
	Rem
	bbdoc: Enumerated GPUs.
	End Rem
	Method GPUCaps(index:Int, vendorId:Short Var, deviceId:Short Var)
	End Method

	Rem
	bbdoc: Capability limits.
	End Rem
	Method Limits:TBGFXCapsLimits()
		If Not _limits Then
			_limits = TBGFXCapsLimits._Create(bmx_bgfx_caps_limits(capsPtr))
		End If
		Return _limits
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Format:Int(index:Int)
	End Method
	
End Type

Type TBGFXCapsLimits

	Field limitsPtr:Byte Ptr
	
	Function _Create:TBGFXCapsLimits(limitsPtr:Byte Ptr)
		If limitsPtr Then
			Local this:TBGFXCapsLimits = New TBGFXCapsLimits
			this.limitsPtr = limitsPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Maximum number of draw calls.
	End Rem
	Method MaxDrawCalls:Int()
		Return bmx_bgfx_capslimits_maxDrawCalls(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of blit calls.
	End Rem
	Method MaxBlits:Int()
		Return bmx_bgfx_capslimits_maxBlits(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum texture size.
	End Rem
	Method MaxTextureSize:Int()
		Return bmx_bgfx_capslimits_maxTextureSize(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum texture layers.
	End Rem
	Method MaxTextureLayers:Int()
		Return bmx_bgfx_capslimits_maxTextureLayers(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of views.
	End Rem
	Method MaxViews:Int()
		Return bmx_bgfx_capslimits_maxViews(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of frame buffer handles.
	End Rem
	Method MaxFrameBuffers:Int()
		Return bmx_bgfx_capslimits_maxFrameBuffers(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of frame buffer attachments.
	End Rem
	Method MaxFBAttachments:Int()
		Return bmx_bgfx_capslimits_maxFBAttachments(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of program handles.
	End Rem
	Method MaxPrograms:Int()
		Return bmx_bgfx_capslimits_maxPrograms(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of shader handles.
	End Rem
	Method MaxShaders:Int()
		Return bmx_bgfx_capslimits_maxShaders(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of texture handles.
	End Rem
	Method MaxTextures:Int()
		Return bmx_bgfx_capslimits_maxTextures(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of texture samplers.
	End Rem
	Method MaxTextureSamplers:Int()
		Return bmx_bgfx_capslimits_maxTextureSamplers(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of vertex format declarations.
	End Rem
	Method MaxVertexDecls:Int()
		Return bmx_bgfx_capslimits_maxVertexDecls(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of vertex streams.
	End Rem
	Method MaxVertexStreams:Int()
		Return bmx_bgfx_capslimits_maxVertexStreams(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of index buffer handles.
	End Rem
	Method MaxIndexBuffers:Int()
		Return bmx_bgfx_capslimits_maxIndexBuffers(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of vertex buffer handles.
	End Rem
	Method MaxVertexBuffers:Int()
		Return bmx_bgfx_capslimits_maxVertexBuffers(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of dynamic index buffer handles.
	End Rem
	Method MaxDynamicIndexBuffers:Int()
		Return bmx_bgfx_capslimits_maxDynamicIndexBuffers(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of dynamic vertex buffer handles.
	End Rem
	Method MaxDynamicVertexBuffers:Int()
		Return bmx_bgfx_capslimits_maxDynamicVertexBuffers(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of uniform handles.
	End Rem
	Method MaxUniforms:Int()
		Return bmx_bgfx_capslimits_maxUniforms(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of occlusion query handles.
	End Rem
	Method MaxOcclusionQueries:Int()
		Return bmx_bgfx_capslimits_maxOcclusionQueries(limitsPtr)
	End Method

	Rem
	bbdoc: Maximum number of encoder threads.
	End Rem
	Method MaxEncoders:Int()
		Return bmx_bgfx_capslimits_maxEncoders(limitsPtr)
	End Method

	Rem
	bbdoc: 
	End Rem
	Method TransientVbSize:Int()
		Return bmx_bgfx_capslimits_transientVbSize(limitsPtr)
	End Method

	Rem
	bbdoc: 
	End Rem
	Method TransientIbSize:Int()
		Return bmx_bgfx_capslimits_transientIbSize(limitsPtr)
	End Method

End Type


Type TBGFXStats
End Type

Type TBGFXHMD
End Type

Type TBGFXRenderBase Abstract

	Method SetMarker(marker:String) Abstract
	Method SetState(state:Long, rgba:Int) Abstract
	Method SetCondition(occlusionQuery:Short, visible:Int) Abstract
	Method SetStencil(fstencil:Int, bstencil:Int = BGFX_STENCIL_NONE) Abstract
	Method SetScissor:Short(x:Short, y:Short, width:Short, height:Short) Abstract
	Method SetScissorCached(cache:Short = $FFFF) Abstract
	Method SetTransform:Int(matrix:Float Ptr, num:Short = 1) Abstract
	Method AllocTransform:Int(transform:TBGFXTransform, num:Short) Abstract
	Method SetTransformCached(cache:Int, num:Short) Abstract
	Method SetUniform(uniform:TBGFXUniform, value:Byte Ptr, num:Short = 1) Abstract
	Method SetIndexBuffer(indexBuffer:Short, firstIndex:Int, numIndices:Int) Abstract
	Method SetDynamicIndexBuffer(dynamicIndexBuffer:Short, firstIndex:Int, numIndices:Int) Abstract
	Method SetTransientIndexBuffer(transientIndexBuffer:Short, firstIndex:Int, numIndices:Int) Abstract
	Method SetVertexBuffer(stream:Byte, vertexBuffer:Short, startVertex:Int, numVertices:Int) Abstract
	Method SetDynamicVertexBuffer(stream:Byte, dynamicVertexBuffer:Short, startVertex:Int, numVertices:Int) Abstract
	Method SetTransientVertexBuffer(stream:Byte, transientVertexBuffer:Short, startVertex:Int, numVertices:Int) Abstract
	Method SetVertexCount(numVertices:Int) Abstract
	Method SetInstanceDataBuffer(idb:TBGFXInstanceDataBuffer, start:Int, num:Int) Abstract
	Method SetInstanceDataFromVertexBuffer(vertexBuffer:Short, startVertex:Int, num:Int) Abstract
	Method SetInstanceDataFromDynamicVertexBuffer(dynamicVertexBuffer:Short, startVertex:Int, num:Int) Abstract
	Method SetTexture(stage:Byte, uniform:TBGFXUniform, texture:Int, flags:Int) Abstract
	Method Touch(id:Short) Abstract
	Method Submit(id:Short, program:TBGFXProgram, depth:Int = 0, preserveState:Int = False) Abstract
	Method SubmitOcclusionQuery(id:Short, program:TBGFXProgram, occlusionQuery:Short, depth:Int = 0, preserveState:Int = False) Abstract
	Method SubmitIndirect(id:Short, program:TBGFXProgram, indirectBuffer:Short, start:Short, num:Short, depth:Int = 0, preserveState:Int = False) Abstract
	Method SetImage(stage:Byte, texture:Short, mip:Byte, access:Int, format:Int) Abstract
	Method SetComputeIndexBuffer(stage:Byte, indexBuffer:Short, access:Int) Abstract
	Method SetComputeVertexBuffer(stage:Byte, vertexBuffer:Short, access:Int) Abstract
	Method SetComputeDynamicIndexBuffer(stage:Byte, dynamicIndexBuffer:Short, access:Int) Abstract
	Method SetComputeDynamicVertexBuffer(stage:Byte, dynamicVertexBuffer:Short, access:Int) Abstract
	Method SetComputeIndirectBuffer(stage:Byte, indirectBuffer:Short, access:Int) Abstract
	Method Dispatch(id:Short, program:TBGFXProgram, numX:Int, numY:Int, numZ:Int, flags:Byte) Abstract
	Method DispatchIndirect(id:Short, program:TBGFXProgram, indirectBuffer:Short, start:Short, num:Short, flags:Byte) Abstract
	Method Discard() Abstract
	Method Blit(id:Short, dstTexture:Short, dstMip:Byte, dstX:Short, dstY:Short, dstZ:Short, srcTexture:Short, srcMip:Byte, srcX:Short, srcY:Short, srcZ:Short, width:Short, height:Short, depth:Short) Abstract

End Type

Type TBGFXRender Extends TBGFXRenderBase

	Function _create:TBGFXRender()
		Return New TBGFXRender
	End Function
		
	Rem
	bbdoc: Sets a debug marker.
	about: This allows you to group graphics calls together for easy browsing in graphics debugging tools.
	End Rem
	Method SetMarker(marker:String)
		bmx_bgfx_set_marker(marker)
	End Method
	
	Rem
	bbdoc: Sets render states for draw primitive.
	End Rem
	Method SetState(state:Long, rgba:Int)
		bmx_bgfx_set_state(state, rgba)
	End Method
	
	Rem
	bbdoc: Sets condition for rendering.
	End Rem
	Method SetCondition(occlusionQuery:Short, visible:Int)
		bmx_bgfx_set_condition(occlusionQuery, visible)
	End Method
	
	Rem
	bbdoc: Sets stencil test state.
	End Rem
	Method SetStencil(fstencil:Int, bstencil:Int = BGFX_STENCIL_NONE)
		bmx_bgfx_set_stencil(fstencil, bstencil)
	End Method
	
	Rem
	bbdoc: Sets scissor for draw primitive.
	returns: Scissor cache index.
	about: To scissor for all primitives in view see TBGFX.SetViewScissor
	End Rem
	Method SetScissor:Short(x:Short, y:Short, width:Short, height:Short)
		Return bmx_bgfx_set_scissor(x, y, width, height)
	End Method
	
	Rem
	bbdoc: Set scissor from cache for draw primitive.
	End Rem
	Method SetScissorCached(cache:Short = $FFFF)
		bmx_bgfx_set_scissor_cached(cache)
	End Method
	
	Rem
	bbdoc: Sets model matrix for draw primitive.
	returns: Index into matrix cache in case the same model matrix has to be used for other draw primitive call.
	about: If it is not called, model will be rendered with identity model matrix.
	End Rem
	Method SetTransform:Int(matrix:Float Ptr, num:Short = 1)
		Return bmx_bgfx_set_transform(matrix, num)
	End Method
	
	Rem
	bbdoc: Reserves @num matrices in internal matrix cache.
	returns: Index into matrix cache.
	End Rem
	Method AllocTransform:Int(transform:TBGFXTransform, num:Short)
		Return bmx_bgfx_alloc_transform(transform.transformPtr, num)
	End Method
	
	Rem
	bbdoc: Sets model matrix from matrix cache for draw primitive.
	End Rem
	Method SetTransformCached(cache:Int, num:Short)
		bmx_bgfx_set_transform_cached(cache, num)
	End Method
	
	Rem
	bbdoc: Sets shader uniform parameter for draw primitive.
	End Rem
	Method SetUniform(uniform:TBGFXUniform, value:Byte Ptr, num:Short = 1)
		bmx_bgfx_set_uniform(uniform.uniformHandle, value, num)
	End Method
	
	Rem
	bbdoc: Sets index buffer for draw primitive.
	End Rem
	Method SetIndexBuffer(indexBuffer:Short, firstIndex:Int, numIndices:Int)
		bmx_bgfx_set_index_buffer(indexBuffer, firstIndex, numIndices)
	End Method
	
	Rem
	bbdoc: Sets index buffer for draw primitive.
	End Rem
	Method SetDynamicIndexBuffer(dynamicIndexBuffer:Short, firstIndex:Int, numIndices:Int)
		bmx_bgfx_set_dynamic_index_buffer(dynamicIndexBuffer, firstIndex, numIndices)
	End Method
	
	Rem
	bbdoc: Sets index buffer for draw primitive.
	End Rem
	Method SetTransientIndexBuffer(transientIndexBuffer:Short, firstIndex:Int, numIndices:Int)
		bmx_bgfx_set_transient_index_buffer(transientIndexBuffer, firstIndex, numIndices)
	End Method
	
	Rem
	bbdoc: Sets vertex buffer for draw primitive.
	End Rem
	Method SetVertexBuffer(stream:Byte, vertexBuffer:Short, startVertex:Int, numVertices:Int)
		bmx_bgfx_set_vertex_buffer(stream, vertexBuffer, startVertex, numVertices)
	End Method
	
	Rem
	bbdoc: Sets vertex buffer for draw primitive.
	End Rem
	Method SetDynamicVertexBuffer(stream:Byte, dynamicVertexBuffer:Short, startVertex:Int, numVertices:Int)
		bmx_bgfx_set_dynamic_vertex_buffer(stream, dynamicVertexBuffer, startVertex, numVertices)
	End Method
	
	Rem
	bbdoc: Sets vertex buffer for draw primitive.
	End Rem
	Method SetTransientVertexBuffer(stream:Byte, transientVertexBuffer:Short, startVertex:Int, numVertices:Int)
		bmx_bgfx_set_transient_vertex_buffer(stream, transientVertexBuffer, startVertex, numVertices)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetVertexCount(numVertices:Int)
		bmx_bgfx_set_vertex_count(numVertices)
	End Method
	
	Rem
	bbdoc: Sets instance data buffer for draw primitive.
	End Rem
	Method SetInstanceDataBuffer(idb:TBGFXInstanceDataBuffer, start:Int, num:Int)
		bmx_bgfx_set_instance_data_buffer(idb.bufferPtr, start, num)
	End Method
	
	Rem
	bbdoc: Sets instance data buffer for draw primitive.
	End Rem
	Method SetInstanceDataFromVertexBuffer(vertexBuffer:Short, startVertex:Int, num:Int)
		bmx_bgfx_set_instance_data_from_vertex_buffer(vertexBuffer, startVertex, num)
	End Method
	
	Rem
	bbdoc: Sets instance data buffer for draw primitive.
	End Rem
	Method SetInstanceDataFromDynamicVertexBuffer(dynamicVertexBuffer:Short, startVertex:Int, num:Int)
		bmx_bgfx_set_instance_data_from_dynamic_vertex_buffer(dynamicVertexBuffer, startVertex, num)
	End Method
	
	Rem
	bbdoc: Set texture stage for draw primitive.
	End Rem
	Method SetTexture(stage:Byte, uniform:TBGFXUniform, texture:Int, flags:Int)
		bmx_bgfx_set_texture(stage, uniform.uniformHandle, texture, flags)
	End Method
	
	Rem
	bbdoc: Submit an empty primitive for rendering.
	about: Uniforms and draw state will be applied but no geometry will be submitted.
	These empty draw calls will sort before ordinary draw calls.
	End Rem
	Method Touch(id:Short)
		bmx_bgfx_touch(id)
	End Method
	
	Rem
	bbdoc: Submit primitive for rendering.
	End Rem
	Method Submit(id:Short, program:TBGFXProgram, depth:Int = 0, preserveState:Int = False)
		bmx_bgfx_submit(id, program.programHandle, depth, preserveState)
	End Method
	
	Rem
	bbdoc: Submit primitive with occlusion query for rendering.
	End Rem
	Method SubmitOcclusionQuery(id:Short, program:TBGFXProgram, occlusionQuery:Short, depth:Int = 0, preserveState:Int = False)
		bmx_bgfx_submit_occlusion_query(id, program.programHandle, occlusionQuery, depth, preserveState)
	End Method
	
	Rem
	bbdoc: Submits primitive for rendering with index and instance data info from indirect buffer.
	End Rem
	Method SubmitIndirect(id:Short, program:TBGFXProgram, indirectBuffer:Short, start:Short, num:Short, depth:Int = 0, preserveState:Int = False)
		bmx_bgfx_submit_indirect(id, program.programHandle, indirectBuffer, start, num, depth, preserveState)
	End Method
	
	Rem
	bbdoc: Sets compute image from texture.
	End Rem
	Method SetImage(stage:Byte, texture:Short, mip:Byte, access:Int, format:Int)
		bmx_bgfx_set_image(stage, texture, mip, access, format)
	End Method
	
	Rem
	bbdoc: Sets compute index buffer.
	End Rem
	Method SetComputeIndexBuffer(stage:Byte, indexBuffer:Short, access:Int)
		bmx_bgfx_set_compute_index_buffer(stage, indexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute vertex buffer.
	End Rem
	Method SetComputeVertexBuffer(stage:Byte, vertexBuffer:Short, access:Int)
		bmx_bgfx_set_compute_vertex_buffer(stage, vertexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute dynamic index buffer.
	End Rem
	Method SetComputeDynamicIndexBuffer(stage:Byte, dynamicIndexBuffer:Short, access:Int)
		bmx_bgfx_set_compute_dynamic_index_buffer(stage, dynamicIndexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute dynamic vertex buffer.
	End Rem
	Method SetComputeDynamicVertexBuffer(stage:Byte, dynamicVertexBuffer:Short, access:Int)
		bmx_bgfx_set_compute_dynamic_vertex_buffer(stage, dynamicVertexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute indirect buffer.
	End Rem
	Method SetComputeIndirectBuffer(stage:Byte, indirectBuffer:Short, access:Int)
		bmx_bgfx_set_compute_indirect_buffer(stage, indirectBuffer, access)
	End Method
	
	Rem
	bbdoc: Dispatches compute.
	End Rem
	Method Dispatch(id:Short, program:TBGFXProgram, numX:Int, numY:Int, numZ:Int, flags:Byte)
		bmx_bgfx_dispatch(id, program.programHandle, numX, numY, numZ, flags)
	End Method
	
	Rem
	bbdoc: Dispatches compute indirect.
	End Rem
	Method DispatchIndirect(id:Short, program:TBGFXProgram, indirectBuffer:Short, start:Short, num:Short, flags:Byte)
		bmx_bgfx_dispatch_indirect(id, program.programHandle, indirectBuffer, start, num, flags)
	End Method
	
	Rem
	bbdoc: Discards all previously set state for draw or compute call.
	End Rem
	Method Discard()
		bmx_bgfx_discard()
	End Method
	
	Rem
	bbdoc: Blits texture 2D region between two 2D textures.
	End Rem
	Method Blit(id:Short, dstTexture:Short, dstMip:Byte, dstX:Short, dstY:Short, dstZ:Short, srcTexture:Short, srcMip:Byte, srcX:Short, srcY:Short, srcZ:Short, width:Short, height:Short, depth:Short)
		bmx_bgfx_blit(id, dstTexture, dstMip, dstX, dstY, dstZ, srcTexture, srcMip, srcX, srcY, srcZ, width, height, depth)
	End Method
	
End Type

Rem
bbdoc: API for multi-threaded submission.
End Rem
Type TBGFXEncoder Extends TBGFXRenderBase

	Field encoderPtr:Byte Ptr
	
	Function _create:TBGFXEncoder(encoderPtr:Byte Ptr)
		If encoderPtr Then
			Local this:TBGFXEncoder = New TBGFXEncoder
			this.encoderPtr = encoderPtr
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Begins submitting draw calls from thread.
	End Rem
	Function BeginDraw:TBGFXEncoder()
		Return _create(bgfx_begin())
	End Function
	
	Rem
	bbdoc: Ends submitting draw calls from thread.
	End Rem
	Method EndDraw()
		bgfx_end(encoderPtr)
	End Method
	
	Rem
	bbdoc: Sets a debug marker.
	about: This allows you to group graphics calls together for easy browsing in graphics debugging tools.
	End Rem
	Method SetMarker(marker:String)
		bmx_bgfx_encoder_set_marker(encoderPtr, marker)
	End Method
	
	Rem
	bbdoc: Sets render states for draw primitive.
	End Rem
	Method SetState(state:Long, rgba:Int)
		bmx_bgfx_encoder_set_state(encoderPtr, state, rgba)
	End Method
	
	Rem
	bbdoc: Sets condition for rendering.
	End Rem
	Method SetCondition(occlusionQuery:Short, visible:Int)
		bmx_bgfx_encoder_set_condition(encoderPtr, occlusionQuery, visible)
	End Method
	
	Rem
	bbdoc: Sets stencil test state.
	End Rem
	Method SetStencil(fstencil:Int, bstencil:Int = BGFX_STENCIL_NONE)
		bmx_bgfx_encoder_set_stencil(encoderPtr, fstencil, bstencil)
	End Method
	
	Rem
	bbdoc: Sets scissor for draw primitive.
	returns: Scissor cache index.
	about: To scissor for all primitives in view see TBGFX.SetViewScissor
	End Rem
	Method SetScissor:Short(x:Short, y:Short, width:Short, height:Short)
		Return bmx_bgfx_encoder_set_scissor(encoderPtr, x, y, width, height)
	End Method
	
	Rem
	bbdoc: Set scissor from cache for draw primitive.
	End Rem
	Method SetScissorCached(cache:Short = $FFFF)
		bmx_bgfx_encoder_set_scissor_cached(encoderPtr, cache)
	End Method
	
	Rem
	bbdoc: Sets model matrix for draw primitive.
	returns: Index into matrix cache in case the same model matrix has to be used for other draw primitive call.
	about: If it is not called, model will be rendered with identity model matrix.
	End Rem
	Method SetTransform:Int(matrix:Float Ptr, num:Short = 1)
		Return bmx_bgfx_encoder_set_transform(encoderPtr, matrix, num)
	End Method
	
	Rem
	bbdoc: Reserves @num matrices in internal matrix cache.
	returns: Index into matrix cache.
	End Rem
	Method AllocTransform:Int(transform:TBGFXTransform, num:Short)
		Return bmx_bgfx_encoder_alloc_transform(encoderPtr, transform.transformPtr, num)
	End Method
	
	Rem
	bbdoc: Sets model matrix from matrix cache for draw primitive.
	End Rem
	Method SetTransformCached(cache:Int, num:Short)
		bmx_bgfx_encoder_set_transform_cached(encoderPtr, cache, num)
	End Method
	
	Rem
	bbdoc: Sets shader uniform parameter for draw primitive.
	End Rem
	Method SetUniform(uniform:TBGFXUniform, value:Byte Ptr, num:Short = 1)
		bmx_bgfx_encoder_set_uniform(encoderPtr, uniform.uniformHandle, value, num)
	End Method
	
	Rem
	bbdoc: Sets index buffer for draw primitive.
	End Rem
	Method SetIndexBuffer(indexBuffer:Short, firstIndex:Int, numIndices:Int)
		bmx_bgfx_encoder_set_index_buffer(encoderPtr, indexBuffer, firstIndex, numIndices)
	End Method
	
	Rem
	bbdoc: Sets index buffer for draw primitive.
	End Rem
	Method SetDynamicIndexBuffer(dynamicIndexBuffer:Short, firstIndex:Int, numIndices:Int)
		bmx_bgfx_encoder_set_dynamic_index_buffer(encoderPtr, dynamicIndexBuffer, firstIndex, numIndices)
	End Method
	
	Rem
	bbdoc: Sets index buffer for draw primitive.
	End Rem
	Method SetTransientIndexBuffer(transientIndexBuffer:Short, firstIndex:Int, numIndices:Int)
		bmx_bgfx_encoder_set_transient_index_buffer(encoderPtr, transientIndexBuffer, firstIndex, numIndices)
	End Method
	
	Rem
	bbdoc: Sets vertex buffer for draw primitive.
	End Rem
	Method SetVertexBuffer(stream:Byte, vertexBuffer:Short, startVertex:Int, numVertices:Int)
		bmx_bgfx_encoder_set_vertex_buffer(encoderPtr, stream, vertexBuffer, startVertex, numVertices)
	End Method
	
	Rem
	bbdoc: Sets vertex buffer for draw primitive.
	End Rem
	Method SetDynamicVertexBuffer(stream:Byte, dynamicVertexBuffer:Short, startVertex:Int, numVertices:Int)
		bmx_bgfx_encoder_set_dynamic_vertex_buffer(encoderPtr, stream, dynamicVertexBuffer, startVertex, numVertices)
	End Method
	
	Rem
	bbdoc: Sets vertex buffer for draw primitive.
	End Rem
	Method SetTransientVertexBuffer(stream:Byte, transientVertexBuffer:Short, startVertex:Int, numVertices:Int)
		bmx_bgfx_encoder_set_transient_vertex_buffer(encoderPtr, stream, transientVertexBuffer, startVertex, numVertices)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method SetVertexCount(numVertices:Int)
		bmx_bgfx_encoder_set_vertex_count(encoderPtr, numVertices)
	End Method
	
	Rem
	bbdoc: Sets instance data buffer for draw primitive.
	End Rem
	Method SetInstanceDataBuffer(idb:TBGFXInstanceDataBuffer, start:Int, num:Int)
		bmx_bgfx_encoder_set_instance_data_buffer(encoderPtr, idb.bufferPtr, start, num)
	End Method
	
	Rem
	bbdoc: Sets instance data buffer for draw primitive.
	End Rem
	Method SetInstanceDataFromVertexBuffer(vertexBuffer:Short, startVertex:Int, num:Int)
		bmx_bgfx_encoder_set_instance_data_from_vertex_buffer(encoderPtr, vertexBuffer, startVertex, num)
	End Method
	
	Rem
	bbdoc: Sets instance data buffer for draw primitive.
	End Rem
	Method SetInstanceDataFromDynamicVertexBuffer(dynamicVertexBuffer:Short, startVertex:Int, num:Int)
		bmx_bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer(encoderPtr, dynamicVertexBuffer, startVertex, num)
	End Method
	
	Rem
	bbdoc: Set texture stage for draw primitive.
	End Rem
	Method SetTexture(stage:Byte, uniform:TBGFXUniform, texture:Int, flags:Int)
		bmx_bgfx_encoder_set_texture(encoderPtr, stage, uniform.uniformHandle, texture, flags)
	End Method
	
	Rem
	bbdoc: Submit an empty primitive for rendering.
	about: Uniforms and draw state will be applied but no geometry will be submitted.
	These empty draw calls will sort before ordinary draw calls.
	End Rem
	Method Touch(id:Short)
		bmx_bgfx_encoder_touch(encoderPtr, id)
	End Method
	
	Rem
	bbdoc: Submit primitive for rendering.
	End Rem
	Method Submit(id:Short, program:TBGFXProgram, depth:Int = 0, preserveState:Int = False)
		bmx_bgfx_encoder_submit(encoderPtr, id, program.programHandle, depth, preserveState)
	End Method
	
	Rem
	bbdoc: Submit primitive with occlusion query for rendering.
	End Rem
	Method SubmitOcclusionQuery(id:Short, program:TBGFXProgram, occlusionQuery:Short, depth:Int = 0, preserveState:Int = False)
		bmx_bgfx_encoder_submit_occlusion_query(encoderPtr, id, program.programHandle, occlusionQuery, depth, preserveState)
	End Method
	
	Rem
	bbdoc: Submits primitive for rendering with index and instance data info from indirect buffer.
	End Rem
	Method SubmitIndirect(id:Short, program:TBGFXProgram, indirectBuffer:Short, start:Short, num:Short, depth:Int = 0, preserveState:Int = False)
		bmx_bgfx_encoder_submit_indirect(encoderPtr, id, program.programHandle, indirectBuffer, start, num, depth, preserveState)
	End Method
	
	Rem
	bbdoc: Sets compute image from texture.
	End Rem
	Method SetImage(stage:Byte, texture:Short, mip:Byte, access:Int, format:Int)
		bmx_bgfx_encoder_set_image(encoderPtr, stage, texture, mip, access, format)
	End Method
	
	Rem
	bbdoc: Sets compute index buffer.
	End Rem
	Method SetComputeIndexBuffer(stage:Byte, indexBuffer:Short, access:Int)
		bmx_bgfx_encoder_set_compute_index_buffer(encoderPtr, stage, indexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute vertex buffer.
	End Rem
	Method SetComputeVertexBuffer(stage:Byte, vertexBuffer:Short, access:Int)
		bmx_bgfx_encoder_set_compute_vertex_buffer(encoderPtr, stage, vertexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute dynamic index buffer.
	End Rem
	Method SetComputeDynamicIndexBuffer(stage:Byte, dynamicIndexBuffer:Short, access:Int)
		bmx_bgfx_encoder_set_compute_dynamic_index_buffer(encoderPtr, stage, dynamicIndexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute dynamic vertex buffer.
	End Rem
	Method SetComputeDynamicVertexBuffer(stage:Byte, dynamicVertexBuffer:Short, access:Int)
		bmx_bgfx_encoder_set_compute_dynamic_vertex_buffer(encoderPtr, stage, dynamicVertexBuffer, access)
	End Method
	
	Rem
	bbdoc: Sets compute indirect buffer.
	End Rem
	Method SetComputeIndirectBuffer(stage:Byte, indirectBuffer:Short, access:Int)
		bmx_bgfx_encoder_set_compute_indirect_buffer(encoderPtr, stage, indirectBuffer, access)
	End Method
	
	Rem
	bbdoc: Dispatches compute.
	End Rem
	Method Dispatch(id:Short, program:TBGFXProgram, numX:Int, numY:Int, numZ:Int, flags:Byte)
		bmx_bgfx_encoder_dispatch(encoderPtr, id, program.programHandle, numX, numY, numZ, flags)
	End Method
	
	Rem
	bbdoc: Dispatches compute indirect.
	End Rem
	Method DispatchIndirect(id:Short, program:TBGFXProgram, indirectBuffer:Short, start:Short, num:Short, flags:Byte)
		bmx_bgfx_encoder_dispatch_indirect(encoderPtr, id, program.programHandle, indirectBuffer, start, num, flags)
	End Method
	
	Rem
	bbdoc: Discards all previously set state for draw or compute call.
	End Rem
	Method Discard()
		bmx_bgfx_encoder_discard(encoderPtr)
	End Method
	
	Rem
	bbdoc: Blits texture 2D region between two 2D textures.
	End Rem
	Method Blit(id:Short, dstTexture:Short, dstMip:Byte, dstX:Short, dstY:Short, dstZ:Short, srcTexture:Short, srcMip:Byte, srcX:Short, srcY:Short, srcZ:Short, width:Short, height:Short, depth:Short)
		bmx_bgfx_encoder_blit(encoderPtr, id, dstTexture, dstMip, dstX, dstY, dstZ, srcTexture, srcMip, srcX, srcY, srcZ, width, height, depth)
	End Method
	
End Type

