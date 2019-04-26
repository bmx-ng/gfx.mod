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

Import gfx.bx
Import gfx.bimg

?linux
Import "-lGL"
Import "-lX11"
Import "-ldl"
Import "-lrt"
?

Import "source.bmx"

?macos
'Import Pub.OpenGL
Import "-framework OpenGL"
?

Extern

'	Function bgfx_init(renderType:Int, vendorId:Short, deviceId:Short, cb1:Byte Ptr, cb2:Byte Ptr)
	Function bmx_bgfx_init:Int(width:Int, height:Int, rendererType:Int, reset:Int, format:Int)
	Function bmx_bgfx_frame:Int(capture:Int)
	Function bmx_bgfx_reset(width:Int, height:Int, flags:Int, format:Int)
	Function bmx_bgfx_shutdown()
	Function bgfx_alloc:Byte Ptr(size:Int)
	Function bgfx_copy:Byte Ptr(data:Byte Ptr, size:Int)
	Function bmx_bgfx_render_frame:Int(msecs:Int)
	
	Function bmx_bgfx_get_caps:Byte Ptr()
	
	Function bmx_bgfx_set_view_rect(id:Short, x:Int, y:Int, width:Int, height:Int)
	Function bmx_bgfx_set_view_clear(id:Short, flags:Short, rgba:Int, depth:Float, stencil:Byte)
	Function bmx_bgfx_set_view_transform(id:Short, view:Byte Ptr, proj:Byte Ptr)
	Function bmx_bgfx_set_view_scissor(id:Short, x:Short, y:Short, width:Short, height:Short)
	Function bmx_bgfx_set_view_rect_ratio(id:Short, x:Short, y:Short, ratio:Int)
	Function bmx_bgfx_set_view_clear_mrt(id:Short, flags:Short, depth:Float, stencil:Byte, p0:Byte, p1:Byte, p2:Byte, p3:Byte, p4:Byte, p5:Byte, p6:Byte, p7:Byte)
	Function bmx_bgfx_set_view_mode(id:Short, viewMode:Int)
	Function bmx_bgfx_set_view_order(id:Short, num:Short, order:Short Ptr)
	Function bmx_bgfx_set_view_frame_buffer(id:Short, frameBuffer:Short)
	
	Function bmx_bgfx_create_program:Short(vsh:Short, fsh:Short, destroyShaders:Int)
	Function bmx_bgfx_create_compute_program:Short(csh:Short, destroyShaders:Int)
	Function bmx_bgfx_destroy_program(handle:Short)

	Function bmx_bgfx_create_shader:Short(mem:Byte Ptr)
	Function bmx_bgfx_get_shader_uniforms:Short(handle:Short, uniforms:Short Ptr, maximum:Short)
	Function bmx_bgfx_set_shader_name(handle:Short, name:String)
	Function bmx_bgfx_destroy_shader(handle:Short)

	Function bmx_bgfx_create_uniform:Short(name:String, uniformType:Int, num:Short)
	Function bmx_bgfx_destroy_uniform(handle:Short)
	Function bmx_bgfx_get_uniform_info:Byte Ptr(handle:Short)
	Function bmx_bgfx_uniform_info_free(handle:Byte Ptr)

'	Function bmx_bgfx_set_transform:Int(matrix:Float Ptr, num:Int)

	Function bmx_bgfx_set_clear_color(index:Int, r:Int, g:Int, b:Int, a:Int)
'	Function bmx_bgfx_set_state(state:Long, r:Int, g:Int, b:Int, a:Int)

	Function bmx_bgfx_create_index_buffer:Byte Ptr(mem:Byte Ptr, flags:Int)
	Function bmx_bgfx_destroy_index_buffer(buffer:Byte Ptr)

	Function bmx_bgfx_set_debug(debugFlags:Int)
	Function bmx_bgfx_dbg_text_clear(attr:Byte, small:Int)
	Function bmx_bgfx_dbg_text_printf(x:Short, y:Short, attr:Byte, Text:String)
	Function bmx_bgfx_dbg_text_image(x:Short, y:Short, width:Short, height:Short, data:Byte Ptr, pitch:Short)


'	Function bmx_bgfx_set_index_buffer(buffer:Byte Ptr, firstIndex:Int, numIndices:Int)

	Function bmx_bgfx_create_texture:Short(mem:Byte Ptr, flags:Int, skip:Int, info:Byte Ptr)
	Function bmx_bgfx_create_texture_2d:Short(width:Short, height:Short, hasMips:Int, numLayers:Short, format:Short, flags:Int, mem:Byte Ptr)
	Function bmx_bgfx_create_texture_2d_scaled:Short(ratio:Int, hasMips:Int, numLayers:Short, format:Short, flags:Int)
	Function bmx_bgfx_destroy_texture(texture:Short)
	Function bmx_bgfx_is_texture_valid:Int(depth:Short, cubeMap:Int, numLayers:Short, format:Short, flags:Int)
	Function bmx_bgfx_calc_texture_size(info:Byte Ptr, width:Short, height:Short, depth:Short, cubeMap:Int, hasMips:Int, numLayers:Short, format:Short)

	Function bmx_bgfx_texture_info_new:Byte Ptr()
	Function bmx_bgfx_texture_info_free(info:Byte Ptr)
	Function bmx_bgfx_texture_format:Int(info:Byte Ptr)
	Function bmx_bgfx_texture_width:Int(info:Byte Ptr)
	Function bmx_bgfx_texture_height:Int(info:Byte Ptr)
	Function bmx_bgfx_texture_depth:Int(info:Byte Ptr)
	Function bmx_bgfx_texture_mips:Int(info:Byte Ptr)
	Function bmx_bgfx_texture_bitsperpixel:Int(info:Byte Ptr)
	Function bmx_bgfx_texture_cubemap:Int(info:Byte Ptr)
	Function bmx_bgfx_texture_storageSize:Int(info:Byte Ptr)

	Function bmx_bgfx_set_marker(marker:String)
	Function bmx_bgfx_set_state(state:Long, rgba:Int)
	Function bmx_bgfx_set_condition(occlusionQuery:Short, visible:Int)
	Function bmx_bgfx_set_stencil(fstencil:Int, bstencil:Int)
	Function bmx_bgfx_set_scissor:Short(x:Short, y:Short, width:Short, height:Short)
	Function bmx_bgfx_set_scissor_cached(cache:Short)
	Function bmx_bgfx_set_transform:Int(matrix:Float Ptr, num:Short)
	Function bmx_bgfx_alloc_transform:Int(transform:Byte Ptr, num:Short)
	Function bmx_bgfx_set_transform_cached(cache:Int, num:Short)
	Function bmx_bgfx_set_uniform(uniform:Short, value:Byte Ptr, num:Short)
	Function bmx_bgfx_set_index_buffer(indexBuffer:Int, firstIndex:Int, numIndices:Int)
	Function bmx_bgfx_set_dynamic_index_buffer(dynamicIndexBuffer:Short, firstIndex:Int, numIndices:Int)
	Function bmx_bgfx_set_transient_index_buffer(transientIndexBuffer:Short, firstIndex:Int, numIndices:Int)
	Function bmx_bgfx_set_vertex_buffer(stream:Byte, vertexBuffer:Short, startVertex:Int, numVertices:Int)
	Function bmx_bgfx_set_dynamic_vertex_buffer(stream:Byte, dynamicVertexBuffer:Short, startVertex:Int, numVertices:Int)
	Function bmx_bgfx_set_transient_vertex_buffer(stream:Byte, transientVertexBuffer:Short, startVertex:Int, numVertices:Int)
	Function bmx_bgfx_set_vertex_count(numVertices:Int)
	Function bmx_bgfx_set_instance_data_buffer(idb:Byte Ptr, start:Int, num:Int)
	Function bmx_bgfx_set_instance_data_from_vertex_buffer(vertexBuffer:Short, startVertex:Int, num:Int)
	Function bmx_bgfx_set_instance_data_from_dynamic_vertex_buffer(dynamicVertexBuffer:Short, startVertex:Int, num:Int)
	Function bmx_bgfx_set_texture(stage:Byte, uniform:Short, texture:Int, flags:Int)
	Function bmx_bgfx_touch(id:Short)
	Function bmx_bgfx_submit(id:Short, program:Short, depth:Int, preserveState:Int)
	Function bmx_bgfx_submit_occlusion_query(id:Short, program:Short, occlusionQuery:Short, depth:Int, preserveState:Int)
	Function bmx_bgfx_submit_indirect(id:Short, program:Short, indirectBuffer:Short, start:Short, num:Short, depth:Int, preserveState:Int)
	Function bmx_bgfx_set_image(stage:Byte, texture:Short, mip:Byte, access:Int, format:Int)
	Function bmx_bgfx_set_compute_index_buffer(stage:Byte, indexBuffer:Short, access:Int)
	Function bmx_bgfx_set_compute_vertex_buffer(stage:Byte, vertexBuffer:Short, access:Int)
	Function bmx_bgfx_set_compute_dynamic_index_buffer(stage:Byte, dynamicIndexBuffer:Short, access:Int)
	Function bmx_bgfx_set_compute_dynamic_vertex_buffer(stage:Byte, dynamicVertexBuffer:Short, access:Int)
	Function bmx_bgfx_set_compute_indirect_buffer(stage:Byte, indirectBuffer:Short, access:Int)
	Function bmx_bgfx_dispatch(id:Short, program:Short, numX:Int, numY:Int, numZ:Int)
	Function bmx_bgfx_dispatch_indirect(id:Short, program:Short, indirectBuffer:Short, start:Short, num:Short)
	Function bmx_bgfx_discard()
	Function bmx_bgfx_blit(id:Short, dstTexture:Short, dstMip:Byte, dstX:Short, dstY:Short, dstZ:Short, srcTexture:Int, srcMip:Byte, srcX:Short, srcY:Short, srcZ:Short, width:Short, height:Short, depth:Short)

	Function bgfx_begin:Byte Ptr()
	Function bgfx_end(handle:Byte Ptr)
	Function bmx_bgfx_encoder_set_marker(handle:Byte Ptr, marker:String)
	Function bmx_bgfx_encoder_set_state(handle:Byte Ptr, state:Long, rgba:Int)
	Function bmx_bgfx_encoder_set_condition(handle:Byte Ptr, occlusionQuery:Short, visible:Int)
	Function bmx_bgfx_encoder_set_stencil(handle:Byte Ptr, fstencil:Int, bstencil:Int)
	Function bmx_bgfx_encoder_set_scissor:Short(handle:Byte Ptr, x:Short, y:Short, width:Short, height:Short)
	Function bmx_bgfx_encoder_set_scissor_cached(handle:Byte Ptr, cache:Short)
	Function bmx_bgfx_encoder_set_transform:Int(handle:Byte Ptr, matrix:Byte Ptr, num:Short)
	Function bmx_bgfx_encoder_alloc_transform:Int(handle:Byte Ptr, transform:Byte Ptr, num:Short)
	Function bmx_bgfx_encoder_set_transform_cached(handle:Byte Ptr, cache:Int, num:Short)
	Function bmx_bgfx_encoder_set_uniform(handle:Byte Ptr, uniform:Short, value:Byte Ptr, num:Short)
	Function bmx_bgfx_encoder_set_index_buffer(handle:Byte Ptr, indexBuffer:Int, firstIndex:Int, numIndices:Int)
	Function bmx_bgfx_encoder_set_dynamic_index_buffer(handle:Byte Ptr, dynamicIndexBuffer:Short, firstIndex:Int, numIndices:Int)
	Function bmx_bgfx_encoder_set_transient_index_buffer(handle:Byte Ptr, transientIndexBuffer:Short, firstIndex:Int, numIndices:Int)
	Function bmx_bgfx_encoder_set_vertex_buffer(handle:Byte Ptr, stream:Byte, vertexBuffer:Short, startVertex:Int, numVertices:Int, declHandle:Short)
	Function bmx_bgfx_encoder_set_dynamic_vertex_buffer(handle:Byte Ptr, stream:Byte, dynamicVertexBuffer:Short, startVertex:Int, numVertices:Int, declHandle:Short)
	Function bmx_bgfx_encoder_set_transient_vertex_buffer(handle:Byte Ptr, stream:Byte, transientVertexBuffer:Short, startVertex:Int, numVertices:Int, declHandle:Short)
	Function bmx_bgfx_encoder_set_vertex_count(handle:Byte Ptr, numVertices:Int)
	Function bmx_bgfx_encoder_set_instance_data_buffer(handle:Byte Ptr, idb:Byte Ptr, start:Int, num:Int)
	Function bmx_bgfx_encoder_set_instance_data_from_vertex_buffer(handle:Byte Ptr, vertexBuffer:Int, startVertex:Int, num:Int)
	Function bmx_bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer(handle:Byte Ptr, dynamicVertexBuffer:Int, startVertex:Int, num:Int)
	Function bmx_bgfx_encoder_set_texture(handle:Byte Ptr, stage:Byte, uniform:Int, texture:Int, flags:Int)
	Function bmx_bgfx_encoder_touch(handle:Byte Ptr, id:Short)
	Function bmx_bgfx_encoder_submit(handle:Byte Ptr, id:Short, program:Int, depth:Int, preserveState:Int)
	Function bmx_bgfx_encoder_submit_occlusion_query(handle:Byte Ptr, id:Short, program:Int, occlusionQuery:Int, depth:Int, preserveState:Int)
	Function bmx_bgfx_encoder_submit_indirect(handle:Byte Ptr, id:Short, program:Int, indirectBuffer:Int, start:Short, num:Short, depth:Int, preserveState:Int)
	Function bmx_bgfx_encoder_set_image(handle:Byte Ptr, stage:Byte, texture:Int, mip:Byte, access:Int, format:Int)
	Function bmx_bgfx_encoder_set_compute_index_buffer(handle:Byte Ptr, stage:Byte, indexBuffer:Int, access:Int)
	Function bmx_bgfx_encoder_set_compute_vertex_buffer(handle:Byte Ptr, stage:Byte, vertexBuffer:Int, access:Int)
	Function bmx_bgfx_encoder_set_compute_dynamic_index_buffer(handle:Byte Ptr, stage:Byte, dynamicIndexBuffer:Int, access:Int)
	Function bmx_bgfx_encoder_set_compute_dynamic_vertex_buffer(handle:Byte Ptr, stage:Byte, dynamicVertexBuffer:Int, access:Int)
	Function bmx_bgfx_encoder_set_compute_indirect_buffer(handle:Byte Ptr, stage:Byte, indirectBuffer:Int, access:Int)
	Function bmx_bgfx_encoder_dispatch(handle:Byte Ptr, id:Short, program:Int, numX:Int, numY:Int, numZ:Int)
	Function bmx_bgfx_encoder_dispatch_indirect(handle:Byte Ptr, id:Short, program:Short, indirectBuffer:Int, start:Short, num:Short)
	Function bmx_bgfx_encoder_discard(handle:Byte Ptr)
	Function bmx_bgfx_encoder_blit(handle:Byte Ptr, id:Short, dstTexture:Short, dstMip:Byte, dstX:Short, dstY:Short, dstZ:Short, srcTexture:Int, srcMip:Byte, srcX:Short, srcY:Short, srcZ:Short, width:Short, height:Short, depth:Short)

	Function bmx_bgfx_capslimits_maxDrawCalls:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxBlits:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxTextureSize:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxTextureLayers:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxViews:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxFrameBuffers:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxFBAttachments:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxPrograms:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxShaders:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxTextures:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxTextureSamplers:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxVertexDecls:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxVertexStreams:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxIndexBuffers:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxVertexBuffers:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxDynamicIndexBuffers:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxDynamicVertexBuffers:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxUniforms:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxOcclusionQueries:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_maxEncoders:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_transientVbSize:Int(handle:Byte Ptr)
	Function bmx_bgfx_capslimits_transientIbSize:Int(handle:Byte Ptr)

	Function bmx_bgfx_caps_limits:Byte Ptr(handle:Byte Ptr)
	
End Extern

Rem
bbdoc: No reset flags.
End Rem
Const BGFX_RESET_NONE:Int = $00000000

Rem
bbdoc: Not supported yet.
End Rem
Const BGFX_RESET_FULLSCREEN:Int = $00000001

Rem
bbdoc: Fullscreen bit shift.
end rem
Const BGFX_RESET_FULLSCREEN_SHIFT:Int = 0        

Rem
bbdoc: Fullscreen bit mask.
end rem
Const BGFX_RESET_FULLSCREEN_MASK:Int = $00000001

Rem
bbdoc: Enable 2x MSAA.
end rem
Const BGFX_RESET_MSAA_X2:Int = $00000010

Rem
bbdoc: Enable 4x MSAA.
end rem
Const BGFX_RESET_MSAA_X4:Int = $00000020

Rem
bbdoc: Enable 8x MSAA.
end rem
Const BGFX_RESET_MSAA_X8:Int = $00000030

Rem
bbdoc: Enable 16x MSAA.
end rem
Const BGFX_RESET_MSAA_X16:Int = $00000040

Rem
bbdoc: MSAA mode bit shift.
end rem
Const BGFX_RESET_MSAA_SHIFT:Int = 4        

Rem
bbdoc: MSAA mode bit mask.
end rem
Const BGFX_RESET_MSAA_MASK:Int = $00000070

Rem
bbdoc: Enable V-Sync.
end rem
Const BGFX_RESET_VSYNC:Int = $00000080

Rem
bbdoc: Turn on/off max anisotropy.
end rem
Const BGFX_RESET_MAXANISOTROPY:Int = $00000100

Rem
bbdoc: Begin screen capture.
end rem
Const BGFX_RESET_CAPTURE:Int = $00000200

Rem
bbdoc: HMD stereo rendering.
end rem
Const BGFX_RESET_HMD:Int = $00000400

Rem
bbdoc: HMD stereo rendering debug mode.
End Rem
Const BGFX_RESET_HMD_DEBUG:Int = $00000800

Rem
bbdoc: HMD calibration.
End Rem
Const BGFX_RESET_HMD_RECENTER:Int = $00001000

Rem
bbdoc: Flush rendering after submitting To GPU.
End Rem
Const BGFX_RESET_FLUSH_AFTER_RENDER:Int = $00002000

Rem
bbdoc: This flag  specifies where flip occurs.
about: Default behavior is that flip occurs before rendering new frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.
End Rem
Const BGFX_RESET_FLIP_AFTER_RENDER:Int = $00004000

Rem
bbdoc: Enable sRGB backbuffer.
End Rem
Const BGFX_RESET_SRGB_BACKBUFFER:Int = $00008000

Rem
bbdoc: Enable HiDPI rendering.
End Rem
Const BGFX_RESET_HIDPI:Int = $00010000

Rem
bbdoc: Enable depth clamp.
End Rem
Const BGFX_RESET_DEPTH_CLAMP:Int = $00020000

Rem
bbdoc: Suspend rendering.
End Rem
Const BGFX_RESET_SUSPEND:Int = $00040000


Const BGFX_CLEAR_NONE:Int = $0000
Const BGFX_CLEAR_COLOR:Int = $0001
Const BGFX_CLEAR_DEPTH:Int = $0002
Const BGFX_CLEAR_STENCIL:Int = $0004
Const BGFX_CLEAR_DISCARD_COLOR_0:Int = $0008
Const BGFX_CLEAR_DISCARD_COLOR_1:Int = $0010
Const BGFX_CLEAR_DISCARD_COLOR_2:Int = $0020
Const BGFX_CLEAR_DISCARD_COLOR_3:Int = $0040
Const BGFX_CLEAR_DISCARD_COLOR_4:Int = $0080
Const BGFX_CLEAR_DISCARD_COLOR_5:Int = $0100
Const BGFX_CLEAR_DISCARD_COLOR_6:Int = $0200
Const BGFX_CLEAR_DISCARD_COLOR_7:Int = $0400
Const BGFX_CLEAR_DISCARD_DEPTH:Int = $0800
Const BGFX_CLEAR_DISCARD_STENCIL:Int = $1000

Const BGFX_CLEAR_DISCARD_COLOR_MASK:Int = BGFX_CLEAR_DISCARD_COLOR_0 | BGFX_CLEAR_DISCARD_COLOR_1 | BGFX_CLEAR_DISCARD_COLOR_2 ..
		| BGFX_CLEAR_DISCARD_COLOR_3 | BGFX_CLEAR_DISCARD_COLOR_4 | BGFX_CLEAR_DISCARD_COLOR_5 | BGFX_CLEAR_DISCARD_COLOR_6 ..
		| BGFX_CLEAR_DISCARD_COLOR_7

Const BGFX_CLEAR_DISCARD_MASK:Int = BGFX_CLEAR_DISCARD_COLOR_MASK | BGFX_CLEAR_DISCARD_DEPTH | BGFX_CLEAR_DISCARD_STENCIL


Const BGFX_STATE_RGB_WRITE:Long = $0000000000000001:Long
Const BGFX_STATE_ALPHA_WRITE:Long = $0000000000000002:Long
Const BGFX_STATE_DEPTH_WRITE:Long = $0000000000000004:Long

Const BGFX_STATE_DEPTH_TEST_LESS:Long = $0000000000000010:Long
Const BGFX_STATE_DEPTH_TEST_LEQUAL:Long = $0000000000000020:Long
Const BGFX_STATE_DEPTH_TEST_EQUAL:Long = $0000000000000030:Long
Const BGFX_STATE_DEPTH_TEST_GEQUAL:Long = $0000000000000040:Long
Const BGFX_STATE_DEPTH_TEST_GREATER:Long = $0000000000000050:Long
Const BGFX_STATE_DEPTH_TEST_NOTEQUAL:Long = $0000000000000060:Long
Const BGFX_STATE_DEPTH_TEST_NEVER:Long = $0000000000000070:Long
Const BGFX_STATE_DEPTH_TEST_ALWAYS:Long = $0000000000000080:Long
Const BGFX_STATE_DEPTH_TEST_SHIFT:Long = 4
Const BGFX_STATE_DEPTH_TEST_MASK:Long = $00000000000000f0:Long

Const BGFX_STATE_BLEND_ZERO:Long = $0000000000001000:Long
Const BGFX_STATE_BLEND_ONE:Long = $0000000000002000:Long
Const BGFX_STATE_BLEND_SRC_COLOR:Long = $0000000000003000:Long
Const BGFX_STATE_BLEND_INV_SRC_COLOR:Long = $0000000000004000:Long
Const BGFX_STATE_BLEND_SRC_ALPHA:Long = $0000000000005000:Long
Const BGFX_STATE_BLEND_INV_SRC_ALPHA:Long = $0000000000006000:Long
Const BGFX_STATE_BLEND_DST_ALPHA:Long = $0000000000007000:Long
Const BGFX_STATE_BLEND_INV_DST_ALPHA:Long = $0000000000008000:Long
Const BGFX_STATE_BLEND_DST_COLOR:Long = $0000000000009000:Long
Const BGFX_STATE_BLEND_INV_DST_COLOR:Long = $000000000000a000:Long
Const BGFX_STATE_BLEND_SRC_ALPHA_SAT:Long = $000000000000b000:Long
Const BGFX_STATE_BLEND_FACTOR:Long = $000000000000c000:Long
Const BGFX_STATE_BLEND_INV_FACTOR:Long = $000000000000d000:Long
Const BGFX_STATE_BLEND_SHIFT:Long = 12
Const BGFX_STATE_BLEND_MASK:Long = $000000000ffff000:Long

Const BGFX_STATE_BLEND_EQUATION_ADD:Long = $0000000000000000:Long
Const BGFX_STATE_BLEND_EQUATION_SUB:Long = $0000000010000000:Long
Const BGFX_STATE_BLEND_EQUATION_REVSUB:Long = $0000000020000000:Long
Const BGFX_STATE_BLEND_EQUATION_MIN:Long = $0000000030000000:Long
Const BGFX_STATE_BLEND_EQUATION_MAX:Long = $0000000040000000:Long
Const BGFX_STATE_BLEND_EQUATION_SHIFT:Long = 28
Const BGFX_STATE_BLEND_EQUATION_MASK:Long = $00000003f0000000:Long

Const BGFX_STATE_BLEND_INDEPENDENT:Long = $0000000400000000:Long

Const BGFX_STATE_CULL_CW:Long = $0000001000000000:Long
Const BGFX_STATE_CULL_CCW:Long = $0000002000000000:Long
Const BGFX_STATE_CULL_SHIFT:Long = 36
Const BGFX_STATE_CULL_MASK:Long = $0000003000000000:Long

Const BGFX_STATE_ALPHA_REF_SHIFT:Long = 40
Const BGFX_STATE_ALPHA_REF_MASK:Long = $0000ff0000000000:Long

Const BGFX_STATE_PT_TRISTRIP:Long = $0001000000000000:Long
Const BGFX_STATE_PT_LINES:Long = $0002000000000000:Long
Const BGFX_STATE_PT_LINESTRIP:Long = $0003000000000000:Long
Const BGFX_STATE_PT_POINTS:Long = $0004000000000000:Long
Const BGFX_STATE_PT_SHIFT:Long = 48
Const BGFX_STATE_PT_MASK:Long = $0007000000000000:Long

Const BGFX_STATE_POINT_SIZE_SHIFT:Long = 52
Const BGFX_STATE_POINT_SIZE_MASK:Long = $0ff0000000000000:Long

Const BGFX_STATE_MSAA:Long = $1000000000000000:Long

Const BGFX_STATE_RESERVED_MASK:Long = $e000000000000000:Long

Const BGFX_STATE_NONE:Long = $0000000000000000:Long
Const BGFX_STATE_MASK:Long = $ffffffffffffffff:Long
Const BGFX_STATE_DEFAULT:Long = BGFX_STATE_RGB_WRITE | BGFX_STATE_ALPHA_WRITE ..
					| BGFX_STATE_DEPTH_TEST_LESS | BGFX_STATE_DEPTH_WRITE | BGFX_STATE_CULL_CW ..
					| BGFX_STATE_MSAA

Const BGFX_BUFFER_NONE:Int = $00
Const BGFX_BUFFER_COMPUTE_READ:Int = $01
Const BGFX_BUFFER_COMPUTE_WRITE:Int = $02
Const BGFX_BUFFER_ALLOW_RESIZE:Int = $04
Const BGFX_BUFFER_INDEX32:Int = $08
Const BGFX_BUFFER_COMPUTE_READ_WRITE:Int = BGFX_BUFFER_COMPUTE_READ | BGFX_BUFFER_COMPUTE_WRITE

Enum EBGFXTextureFormat
	BC1
	BC2
	BC3
	BC4
	BC5
	BC6H
	BC7
	ETC1
	ETC2
	ETC2A
	ETC2A1
	PTC12
	PTC14
	PTC12A
	PTC14A
	PTC22
	PTC24
	ATC
	ATCE
	ATCI
	ASTC4X4
	ASTC5X5
	ASTC6X6
	ASTC8X5
	ASTC8X6
	ASTC10X5
	UNKNOWN
	R1
	A8
	R8
	R8I
	R8U
	R8S
	R16
	R16I
	R16U
	R16F
	R16S
	R32I
	R32U
	R32F
	RG8
	RG8I
	RG8U
	RG8S
	RG16
	RG16I
	RG16U
	RG16F
	RG16S
	RG32I
	RG32U
	RG32F
	RGB8
	RGB8I
	RGB8U
	RGB8S
	RGB9E5F
	BGRA8
	RGBA8
	RGBA8I
	RGBA8U
	RGBA8S
	RGBA16
	RGBA16I
	RGBA16U
	RGBA16F
	RGBA16S
	RGBA32I
	RGBA32U
	RGBA32F
	R5G6B5
	RGBA4
	RGB5A1
	RGB10A2
	RG11B10F
	UNKNOWNDEPTH
	D16
	D24
	D24S8
	D32
	D16F
	D24F
	D32F
	D0S8
	COUNT
End Enum

Enum EBGFXAttrib
	POSITION = 0
	NORMAL
	TANGENT
	BITANGENT
	COLOR0
	COLOR1
	COLOR2
	COLOR3
	INDICES
	WEIGHT
	TEXCOORD0
	TEXCOORD1
	TEXCOORD2
	TEXCOORD3
	TEXCOORD4
	TEXCOORD5
	TEXCOORD6
	TEXCOORD7
End Enum

Enum EBGFXRenderType
	NOOP = 0
	DIRECT3D9
	DIRECT3D11
	DIRECT3D12
	GNM
	METAL
	NVN
	OPENGLES
	OPENGL
	VULKAN
	COUNT
End Enum

Const BGFX_STENCIL_NONE:Int = $00000000
Const BGFX_STENCIL_MASK:Int = $FFFFFFFF
Const BGFX_STENCIL_DEFAULT:Int = $00000000

Rem
bbdoc: Default sort order.
End Rem
Const BGFX_VIEW_MODE_DEFAULT:Int = 0
Rem
bbdoc: Sort in the same order in which submit calls were called.
End Rem
Const BGFX_VIEW_MODE_SEQUENTIAL:Int = 1
Rem
bbdoc: Sort draw call depth in ascending order.
End Rem
Const BGFX_VIEW_MODE_DEPTH_ASCENDING:Int = 2
Rem
bbdoc: Sort draw call depth in descending order.
End Rem
Const BGFX_VIEW_MODE_DEPTH_DESCENDING:Int = 3

Rem
bbdoc: Alpha to coverage is supported.
End Rem
Const BGFX_CAPS_ALPHA_TO_COVERAGE:Long = $0000000000000001:Long

Rem
bbdoc: Blend independent is supported.
End Rem
Const BGFX_CAPS_BLEND_INDEPENDENT:Long = $0000000000000002:Long

Rem
bbdoc: Compute shaders are supported.
End Rem
Const BGFX_CAPS_COMPUTE:Long = $0000000000000004:Long

Rem
bbdoc: Conservative rasterization is supported.
End Rem
Const BGFX_CAPS_CONSERVATIVE_RASTER:Long = $0000000000000008:Long

Rem
bbdoc: Draw indirect is supported.
End Rem
Const BGFX_CAPS_DRAW_INDIRECT:Long = $0000000000000010:Long

Rem
bbdoc: Fragment depth is accessible in fragment shader.
End Rem
Const BGFX_CAPS_FRAGMENT_DEPTH:Long = $0000000000000020:Long

Rem
bbdoc: Fragment ordering is available in fragment shader.
End Rem
Const BGFX_CAPS_FRAGMENT_ORDERING:Long = $0000000000000040:Long

Rem
bbdoc: Graphics debugger is present.
End Rem
Const BGFX_CAPS_GRAPHICS_DEBUGGER:Long = $0000000000000080:Long

Rem
bbdoc: HiDPI rendering is supported.
End Rem
Const BGFX_CAPS_HIDPI:Long = $0000000000000100:Long

Rem
bbdoc: Head Mounted Display is available.
End Rem
Const BGFX_CAPS_HMD:Long = $0000000000000200:Long

Rem
bbdoc: 32-bit indices are supported.
End Rem
Const BGFX_CAPS_INDEX32:Long = $0000000000000400:Long

Rem
bbdoc: Instancing is supported.
End Rem
Const BGFX_CAPS_INSTANCING:Long = $0000000000000800:Long

Rem
bbdoc: Occlusion query is supported.
End Rem
Const BGFX_CAPS_OCCLUSION_QUERY:Long = $0000000000001000:Long

Rem
bbdoc: Renderer is on separate thread.
End Rem
Const BGFX_CAPS_RENDERER_MULTITHREADED:Long = $0000000000002000:Long

Rem
bbdoc: Multiple windows are supported.
End Rem
Const BGFX_CAPS_SWAP_CHAIN:Long = $0000000000004000:Long

Rem
bbdoc: 2D texture array is supported.
End Rem
Const BGFX_CAPS_TEXTURE_2D_ARRAY:Long = $0000000000008000:Long

Rem
bbdoc: 3D textures are supported.
End Rem
Const BGFX_CAPS_TEXTURE_3D:Long = $0000000000010000:Long

Rem
bbdoc: Texture blit is supported.
End Rem
Const BGFX_CAPS_TEXTURE_BLIT:Long = $0000000000020000:Long

Rem
bbdoc: All texture compare modes are supported.
End Rem
Const BGFX_CAPS_TEXTURE_COMPARE_ALL:Long = $00000000000c0000:Long

Rem
bbdoc: Texture compare less equal mode is supported.
End Rem
Const BGFX_CAPS_TEXTURE_COMPARE_LEQUAL:Long = $0000000000080000:Long

Rem
bbdoc: Cubemap texture array is supported.
End Rem
Const BGFX_CAPS_TEXTURE_CUBE_ARRAY:Long = $0000000000100000:Long

Rem
bbdoc: CPU direct access to GPU texture memory.
End Rem
Const BGFX_CAPS_TEXTURE_DIRECT_ACCESS:Long = $0000000000200000:Long

Rem
bbdoc: Read-back texture is supported.
End Rem
Const BGFX_CAPS_TEXTURE_READ_BACK:Long = $0000000000400000:Long

Rem
bbdoc: Vertex attribute half-float is supported.
End Rem
Const BGFX_CAPS_VERTEX_ATTRIB_HALF:Long = $0000000000800000:Long

Rem
bbdoc: Vertex attribute 10_10_10_2 is supported.
End Rem
Const BGFX_CAPS_VERTEX_ATTRIB_UINT10:Long = $0000000000800000:Long

Rem
bbdoc: Rendering with VertexID only is supported.
End Rem
Const BGFX_CAPS_VERTEX_ID:Long = $0000000001000000:Long

Const BGFX_DEBUG_STATS:Int = $4
Const BGFX_DEBUG_TEXT:Int = $8