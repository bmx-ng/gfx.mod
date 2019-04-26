/*
  Copyright (c) 2015-2019 Bruce A Henderson
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "bgfx/c99/bgfx.h"

#include "brl.mod/blitz.mod/blitz.h"

/* ----------------------------------------------------- */

int bmx_bgfx_init(int width, int height, int rendererType, int reset, int format);

uint32_t bmx_bgfx_frame(int capture);
void bmx_bgfx_reset(uint32_t width, uint32_t height, uint32_t flags, int format);
void bmx_bgfx_shutdown();
int bmx_bgfx_render_frame(int msecs);

//void bmx_bgfx_set_clear_color(int index, int r, int g, int b, int a);
//void bmx_bgfx_set_state(BBInt64 state, int r, int g, int b, int a);

//struct MaxBGFXIndexBuffer * bmx_bgfx_create_index_buffer(bgfx_memory_t * mem, int flags);
//void bmx_bgfx_destroy_index_buffer(struct MaxBGFXIndexBuffer * buffer);

//void bmx_bgfx_set_index_buffer(struct MaxBGFXIndexBuffer * buffer, int firstIndex, int numIndices);

bgfx_texture_handle_t bmx_bgfx_create_texture(bgfx_memory_t * _mem, int flags, int skip , bgfx_texture_info_t * info);
bgfx_texture_handle_t bmx_bgfx_create_texture_2d(uint16_t width, uint16_t height, int hasMips, uint16_t numLayers, bgfx_texture_format_t format, int flags, bgfx_memory_t * mem);
bgfx_texture_handle_t bmx_bgfx_create_texture_2d_scaled(int ratio, int hasMips, uint16_t numLayers, bgfx_texture_format_t  format, int flags);

int bmx_bgfx_is_texture_valid(uint16_t depth, int cubeMap, uint16_t numLayers, bgfx_texture_format_t format, uint32_t flags);
void bmx_bgfx_calc_texture_size(bgfx_texture_info_t * info, uint16_t width, uint16_t height, uint16_t depth, int cubeMap, int hasMips, uint16_t numLayers, bgfx_texture_format_t format);

//void bmx_bgfx_destroy_texture(struct MaxBGFXTexture * texture);

void bmx_bgfx_set_view_rect(bgfx_view_id_t id, uint16_t x, uint16_t y, uint16_t width, uint16_t height);
void bmx_bgfx_set_view_clear(bgfx_view_id_t id, uint16_t flags, uint32_t rgba, float depth, uint8_t stencil);
void bmx_bgfx_set_view_transform(bgfx_view_id_t id, void * view, void * proj);
void bmx_bgfx_set_view_scissor(bgfx_view_id_t id, uint16_t x, uint16_t y, uint16_t width, uint16_t eight);
void bmx_bgfx_set_view_rect_auto(bgfx_view_id_t id, uint16_t x, uint16_t y, int ratio);
void bmx_bgfx_set_view_clear_mrt(bgfx_view_id_t id, uint16_t flags, float depth, uint8_t stencil, uint8_t p0, uint8_t p1, uint8_t p2, uint8_t p3, uint8_t p4, uint8_t p5, uint8_t p6, uint8_t p7);
void bmx_bgfx_set_view_mode(bgfx_view_id_t id, int mode);
void bmx_bgfx_set_view_order(bgfx_view_id_t id, uint16_t num, uint16_t * order);
void bmx_bgfx_set_view_frame_buffer(bgfx_view_id_t id, uint16_t frameBuffer);

bgfx_program_handle_t bmx_bgfx_create_program(uint16_t vsh, uint16_t fsh, int destroyShaders);
bgfx_program_handle_t bmx_bgfx_create_compute_program(uint16_t csh, int destroyShaders);
void bmx_bgfx_destroy_program(uint16_t program);

bgfx_shader_handle_t bmx_bgfx_create_shader(bgfx_memory_t * mem);
uint16_t bmx_bgfx_get_shader_uniforms(uint16_t shader, uint16_t * uniforms, uint16_t maximum);
void bmx_bgfx_set_shader_name(uint16_t shader, BBString * name);
void bmx_bgfx_destroy_shader(uint16_t shader);

bgfx_uniform_handle_t bmx_bgfx_create_uniform(BBString * name, int uniformType, uint16_t num);
void bmx_bgfx_destroy_uniform(uint16_t handle);
bgfx_uniform_info_t * bmx_bgfx_get_uniform_info(uint16_t uniform);
void bmx_bgfx_uniform_info_free(bgfx_uniform_info_t * info);

void bmx_bgfx_set_debug(int debugFlags);
void bmx_bgfx_dbg_text_clear(uint8_t attr, int small);
void bmx_bgfx_dbg_text_printf(uint16_t x, uint16_t y, uint8_t attr, BBString * text);
void bmx_bgfx_dbg_text_image(uint16_t x, uint16_t y, uint16_t width, uint16_t height, void * data, uint16_t pitch);

bgfx_texture_info_t * bmx_bgfx_texture_info_new();
void bmx_bgfx_texture_info_free(bgfx_texture_info_t * info);
bgfx_texture_format_t bmx_bgfx_texture_format(bgfx_texture_info_t * info);
int bmx_bgfx_texture_width(bgfx_texture_info_t * info);
int bmx_bgfx_texture_height(bgfx_texture_info_t * info);
int bmx_bgfx_texture_depth(bgfx_texture_info_t * info);
int bmx_bgfx_texture_mips(bgfx_texture_info_t * info);
int bmx_bgfx_texture_bitsperpixel(bgfx_texture_info_t * info);
int bmx_bgfx_texture_cubemap(bgfx_texture_info_t * info);
int bmx_bgfx_texture_storageSize(bgfx_texture_info_t * info);

bgfx_caps_t * bmx_bgfx_get_caps();
bgfx_caps_limits_t * bmx_bgfx_caps_limits(bgfx_caps_t * caps);



void bmx_bgfx_set_marker(BBString * marker);
void bmx_bgfx_set_state(uint64_t state, int rgba);
void bmx_bgfx_set_condition(uint16_t occlusionQuery, int visible);
void bmx_bgfx_set_stencil(int fstencil, int bstencil);
uint16_t bmx_bgfx_set_scissor(uint16_t x, uint16_t y, uint16_t width, uint16_t height);
void bmx_bgfx_set_scissor_cached(uint16_t cache);
int bmx_bgfx_set_transform(void * matrix, uint16_t num);
int bmx_bgfx_alloc_transform(bgfx_transform_t * transform, uint16_t num);
void bmx_bgfx_set_transform_cached(int cache, uint16_t num);
void bmx_bgfx_set_uniform(uint16_t uniform, void * value, uint16_t num);
void bmx_bgfx_set_index_buffer(uint16_t indexBuffer, int firstIndex, int numIndices);
void bmx_bgfx_set_dynamic_index_buffer(uint16_t dynamicIndexBuffer, int firstIndex, int numIndices);
void bmx_bgfx_set_transient_index_buffer(bgfx_transient_index_buffer_t * transientIndexBuffer, int firstIndex, int numIndices);
void bmx_bgfx_set_vertex_buffer(uint8_t stream, uint16_t vertexBuffer, int startVertex, int numVertices);
void bmx_bgfx_set_dynamic_vertex_buffer(uint8_t stream, uint16_t dynamicVertexBuffer, int startVertex, int numVertices);
void bmx_bgfx_set_transient_vertex_buffer(uint8_t stream, bgfx_transient_vertex_buffer_t * transientVertexBuffer, int startVertex, int numVertices);
void bmx_bgfx_set_vertex_count(int numVertices);
void bmx_bgfx_set_instance_data_buffer(bgfx_instance_data_buffer_t * idb, int start, int num);
void bmx_bgfx_set_instance_data_from_vertex_buffer(uint16_t vertexBuffer, int startVertex, int num);
void bmx_bgfx_set_instance_data_from_dynamic_vertex_buffer(uint16_t dynamicVertexBuffer, int startVertex, int num);
void bmx_bgfx_set_texture(uint8_t stage, uint16_t uniform, uint16_t texture, int flags);
void bmx_bgfx_touch(uint16_t id);
void bmx_bgfx_submit(uint16_t id, uint16_t program, int depth, int preserveState);
void bmx_bgfx_submit_occlusion_query(uint16_t id, uint16_t program, uint16_t occlusionQuery, int depth, int preserveState);
void bmx_bgfx_submit_indirect(uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num, int depth, int preserveState);
void bmx_bgfx_set_image(uint8_t stage, uint16_t texture, uint8_t mip, int access, int format);
void bmx_bgfx_set_compute_index_buffer(uint8_t stage, uint16_t indexBuffer, int access);
void bmx_bgfx_set_compute_vertex_buffer(uint8_t stage, uint16_t vertexBuffer, int access);
void bmx_bgfx_set_compute_dynamic_index_buffer(uint8_t stage, uint16_t dynamicIndexBuffer, int access);
void bmx_bgfx_set_compute_dynamic_vertex_buffer(uint8_t stage, uint16_t dynamicVertexBuffer, int access);
void bmx_bgfx_set_compute_indirect_buffer(uint8_t stage, uint16_t indirectBuffer, int access);
void bmx_bgfx_dispatch(uint16_t id, uint16_t program, int numX, int numY, int numZ);
void bmx_bgfx_dispatch_indirect(uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num);
void bmx_bgfx_discard();
void bmx_bgfx_blit(uint16_t id, uint16_t dstTexture, uint8_t dstMip, uint16_t dstX, uint16_t dstY, uint16_t dstZ, uint16_t srcTexture, uint8_t srcMip, uint16_t srcX, uint16_t srcY, uint16_t srcZ, uint16_t width, uint16_t height, uint16_t depth);

void bmx_bgfx_encoder_set_marker(struct bgfx_encoder_s * encoder, BBString * marker);
void bmx_bgfx_encoder_set_state(struct bgfx_encoder_s * encoder, uint64_t state, int rgba);
void bmx_bgfx_encoder_set_condition(struct bgfx_encoder_s * encoder, uint16_t occlusionQuery, int visible);
void bmx_bgfx_encoder_set_stencil(struct bgfx_encoder_s * encoder, int fstencil, int bstencil);
uint16_t bmx_bgfx_encoder_set_scissor(struct bgfx_encoder_s * encoder, uint16_t x, uint16_t y, uint16_t width, uint16_t height);
void bmx_bgfx_encoder_set_scissor_cached(struct bgfx_encoder_s * encoder, uint16_t cache);
int bmx_bgfx_encoder_set_transform(struct bgfx_encoder_s * encoder, void * matrix, uint16_t num);
int bmx_bgfx_encoder_alloc_transform(struct bgfx_encoder_s * encoder, bgfx_transform_t * transform, uint16_t num);
void bmx_bgfx_encoder_set_transform_cached(struct bgfx_encoder_s * encoder, int cache, uint16_t num);
void bmx_bgfx_encoder_set_uniform(struct bgfx_encoder_s * encoder, uint16_t uniform, void * value, uint16_t num);
void bmx_bgfx_encoder_set_index_buffer(struct bgfx_encoder_s * encoder, uint16_t indexBuffer, int firstIndex, int numIndices);
void bmx_bgfx_encoder_set_dynamic_index_buffer(struct bgfx_encoder_s * encoder, uint16_t dynamicIndexBuffer, int firstIndex, int numIndices);
void bmx_bgfx_encoder_set_transient_index_buffer(struct bgfx_encoder_s * encoder, bgfx_transient_index_buffer_t * transientIndexBuffer, int firstIndex, int numIndices);
void bmx_bgfx_encoder_set_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stream, uint16_t vertexBuffer, int startVertex, int numVertices, uint16_t declHandle);
void bmx_bgfx_encoder_set_dynamic_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stream, uint16_t dynamicVertexBuffer, int startVertex, int numVertices, uint16_t declHandle);
void bmx_bgfx_encoder_set_transient_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stream, bgfx_transient_vertex_buffer_t * transientVertexBuffer, int startVertex, int numVertices, uint16_t declHandle);
void bmx_bgfx_encoder_set_vertex_count(struct bgfx_encoder_s * encoder, int numVertices);
void bmx_bgfx_encoder_set_instance_data_buffer(struct bgfx_encoder_s * encoder, bgfx_instance_data_buffer_t * idb, int start, int num);
void bmx_bgfx_encoder_set_instance_data_from_vertex_buffer(struct bgfx_encoder_s * encoder, uint16_t vertexBuffer, int startVertex, int num);
void bmx_bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer(struct bgfx_encoder_s * encoder, uint16_t dynamicVertexBuffer, int startVertex, int num);
void bmx_bgfx_encoder_set_texture(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t uniform, uint16_t texture, int flags);
void bmx_bgfx_encoder_touch(struct bgfx_encoder_s * encoder, uint16_t id);
void bmx_bgfx_encoder_submit(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, int depth, int preserveState);
void bmx_bgfx_encoder_submit_occlusion_query(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, uint16_t occlusionQuery, int depth, int preserveState);
void bmx_bgfx_encoder_submit_indirect(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num, int depth, int preserveState);
void bmx_bgfx_encoder_set_image(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t texture, uint8_t mip, int access, int format);
void bmx_bgfx_encoder_set_compute_index_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t indexBuffer, int access);
void bmx_bgfx_encoder_set_compute_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t vertexBuffer, int access);
void bmx_bgfx_encoder_set_compute_dynamic_index_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t dynamicIndexBuffer, int access);
void bmx_bgfx_encoder_set_compute_dynamic_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t dynamicVertexBuffer, int access);
void bmx_bgfx_encoder_set_compute_indirect_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t indirectBuffer, int access);
void bmx_bgfx_encoder_dispatch(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, int numX, int numY, int numZ);
void bmx_bgfx_encoder_dispatch_indirect(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num);
void bmx_bgfx_encoder_discard(struct bgfx_encoder_s * encoder);
void bmx_bgfx_encoder_blit(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t dstTexture, uint8_t dstMip, uint16_t dstX, uint16_t dstY, uint16_t dstZ, uint16_t srcTexture, uint8_t srcMip, uint16_t srcX, uint16_t srcY, uint16_t srcZ, uint16_t width, uint16_t height, uint16_t depth);

uint32_t bmx_bgfx_capslimits_maxDrawCalls(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxBlits(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxTextureSize(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxTextureLayers(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxViews(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxFrameBuffers(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxFBAttachments(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxPrograms(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxShaders(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxTextures(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxTextureSamplers(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxVertexDecls(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxVertexStreams(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxIndexBuffers(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxVertexBuffers(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxDynamicIndexBuffers(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxDynamicVertexBuffers(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxUniforms(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxOcclusionQueries(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_maxEncoders(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_transientVbSize(bgfx_caps_limits_t * limits);
uint32_t bmx_bgfx_capslimits_transientIbSize(bgfx_caps_limits_t * limits);


/* ----------------------------------------------------- */

int bmx_bgfx_init(int width, int height, int rendererType, int reset, int format) {
	bgfx_init_t init;
	bgfx_init_ctor(&init);

	init.type = rendererType;

	if (!bgfx_init(&init)) {
		printf("failed\n");
		return 0;
	}

	bmx_bgfx_reset(width, height, BGFX_RESET_VSYNC, BGFX_TEXTURE_FORMAT_COUNT);	

	return 1;
}

uint32_t bmx_bgfx_frame(int capture) {
	return bgfx_frame(capture);
}

void bmx_bgfx_reset(uint32_t width, uint32_t height, uint32_t flags, int format) {
	bgfx_reset(width, height, flags, format);
}

void bmx_bgfx_shutdown() {
	bgfx_shutdown();
}

int bmx_bgfx_render_frame(int msecs) {
	return bgfx_render_frame(msecs);
}

/*
void bmx_bgfx_set_clear_color(int index, int r, int g, int b, int a) {
	float rgba[4];
	rgba[0] = r / 255.0f;
	rgba[1] = g / 255.0f;
	rgba[2] = b / 255.0f;
	rgba[3] = a / 255.0f;
	bgfx_set_clear_color(index, rgba);
}

//void bmx_bgfx_set_state(BBInt64 state, int r, int g, int b, int a) {
//	bgfx_set_state(state, r << 24 | g << 16 | b << 8 | a);
//}

struct MaxBGFXIndexBuffer * bmx_bgfx_create_index_buffer(bgfx_memory_t * mem, int flags) {
	struct MaxBGFXIndexBuffer * buffer = malloc(sizeof(struct MaxBGFXIndexBuffer));
	buffer->buf = bgfx_create_index_buffer(mem, flags);
	return buffer;
}

void bmx_bgfx_destroy_index_buffer(struct MaxBGFXIndexBuffer * buffer) {
	bgfx_destroy_index_buffer(buffer->buf);
	free(buffer);
}

//void bmx_bgfx_set_index_buffer(struct MaxBGFXIndexBuffer * buffer, int firstIndex, int numIndices) {
//	bgfx_set_index_buffer(buffer->buf, firstIndex, numIndices);
//}
*/

void bmx_bgfx_set_debug(int debugFlags)	{
	bgfx_set_debug(debugFlags);
}

void bmx_bgfx_dbg_text_clear(uint8_t attr, int small)	{
	bgfx_dbg_text_clear(attr, small);
}

void bmx_bgfx_dbg_text_printf(uint16_t x, uint16_t y, uint8_t attr, BBString * text)	{
	char * t = bbStringToUTF8String(text);
	bgfx_dbg_text_printf(x, y, attr, "%s", t);
	bbMemFree(t);
}

void bmx_bgfx_dbg_text_image(uint16_t x, uint16_t y, uint16_t width, uint16_t height, void * data, uint16_t pitch)	{
	bgfx_dbg_text_image(x, y, width, height, data, pitch);
}

bgfx_caps_t * bmx_bgfx_get_caps() {
	return bgfx_get_caps();
}

bgfx_caps_limits_t * bmx_bgfx_caps_limits(bgfx_caps_t * caps) {
	return &caps->limits;
}

/* ----------------------------------------------------- */

void bmx_bgfx_set_view_rect(bgfx_view_id_t id, uint16_t x, uint16_t y, uint16_t width, uint16_t height) {
	bgfx_set_view_rect(id, x, y, width, height);
}

void bmx_bgfx_set_view_clear(bgfx_view_id_t id, uint16_t flags, uint32_t rgba, float depth, uint8_t stencil) {
	bgfx_set_view_clear(id, flags, rgba, depth, stencil);
}

void bmx_bgfx_set_view_transform(bgfx_view_id_t id, void * view, void * proj) {
	bgfx_set_view_transform(id, view, proj);
}

void bmx_bgfx_set_view_scissor(bgfx_view_id_t id, uint16_t x, uint16_t y, uint16_t width, uint16_t height) {
	bgfx_set_view_scissor(id, x, y, width, height);
}

void bmx_bgfx_set_view_rect_ratio(bgfx_view_id_t id, uint16_t x, uint16_t y, int ratio) {
	bgfx_set_view_rect_ratio(id, x, y, ratio);
}

void bmx_bgfx_set_view_clear_mrt(bgfx_view_id_t id, uint16_t flags, float depth, uint8_t stencil, uint8_t p0, uint8_t p1, uint8_t p2, uint8_t p3, uint8_t p4, uint8_t p5, uint8_t p6, uint8_t p7) {
	bgfx_set_view_clear_mrt(id, flags, depth, stencil, p0, p1, p2, p3, p4, p5, p6, p7);
}

void bmx_bgfx_set_view_mode(bgfx_view_id_t id, int mode) {
	bgfx_set_view_mode(id, mode);
}

void bmx_bgfx_set_view_order(bgfx_view_id_t id, uint16_t num, uint16_t * order) {
	bgfx_set_view_order(id, num, order);
}

void bmx_bgfx_set_view_frame_buffer(bgfx_view_id_t id, uint16_t frameBuffer) {
	bgfx_set_view_frame_buffer(id, *(bgfx_frame_buffer_handle_t*)(&frameBuffer));
}


/* ----------------------------------------------------- */

bgfx_program_handle_t bmx_bgfx_create_program(uint16_t vsh, uint16_t fsh, int destroyShaders) {
	return bgfx_create_program(*(bgfx_shader_handle_t*)(&vsh), *(bgfx_shader_handle_t*)(&fsh), destroyShaders);
}

bgfx_program_handle_t bmx_bgfx_create_compute_program(uint16_t csh, int destroyShaders) {
	return bgfx_create_compute_program(*(bgfx_shader_handle_t*)(&csh), destroyShaders);
}

void bmx_bgfx_destroy_program(uint16_t program) {
	bgfx_destroy_program(*(bgfx_program_handle_t*)(&program));
}

/* ----------------------------------------------------- */

bgfx_shader_handle_t bmx_bgfx_create_shader(bgfx_memory_t * mem) {
	return bgfx_create_shader(mem);
}

uint16_t bmx_bgfx_get_shader_uniforms(uint16_t shader, uint16_t * uniforms, uint16_t maximum) {
	return bgfx_get_shader_uniforms(*(bgfx_shader_handle_t*)(&shader), (bgfx_uniform_handle_t*)uniforms, maximum);
}

void bmx_bgfx_set_shader_name(uint16_t shader, BBString * name) {
	char * n = bbStringToUTF8String(name);
	int len = strlen(n);
	bgfx_set_shader_name(*(bgfx_shader_handle_t*)(&shader), n, len);
	bbMemFree(n);
}

void bmx_bgfx_destroy_shader(uint16_t shader) {
	bgfx_destroy_shader(*(bgfx_shader_handle_t*)(&shader));
}

/* ----------------------------------------------------- */

bgfx_uniform_handle_t bmx_bgfx_create_uniform(BBString * name, int uniformType, uint16_t num) {
	char * n = bbStringToUTF8String(name);
	bgfx_uniform_handle_t uniform = bgfx_create_uniform(n, uniformType, num);
	bbMemFree(n);
	return uniform;
}

void bmx_bgfx_destroy_uniform(uint16_t uniform) {
	bgfx_destroy_uniform(*(bgfx_uniform_handle_t*)(&uniform));
}

bgfx_uniform_info_t * bmx_bgfx_get_uniform_info(uint16_t uniform) {
	bgfx_uniform_info_t * info = malloc(sizeof(bgfx_uniform_info_t));
	bgfx_get_uniform_info(*(bgfx_uniform_handle_t*)(&uniform), info);
	return info;
}

void bmx_bgfx_uniform_info_free(bgfx_uniform_info_t * info) {
	free(info);
}

/* ----------------------------------------------------- */

bgfx_texture_handle_t bmx_bgfx_create_texture(bgfx_memory_t * _mem, int flags, int skip, bgfx_texture_info_t * info) {
	bgfx_texture_handle_t texture;
	//struct MaxBGFXTexture * texture = malloc(sizeof(struct MaxBGFXTexture));
	if (info) {
		texture = bgfx_create_texture(_mem, flags, skip, info);
	} else {
		texture = bgfx_create_texture(_mem, flags, skip, 0);
	}
	return texture;
}

bgfx_texture_handle_t bmx_bgfx_create_texture_2d(uint16_t width, uint16_t height, int hasMips, uint16_t numLayers, bgfx_texture_format_t format, int flags, bgfx_memory_t * mem) {
	return bgfx_create_texture_2d(width, height, hasMips, numLayers, format, flags, mem);
}

bgfx_texture_handle_t bmx_bgfx_create_texture_2d_scaled(int ratio, int hasMips, uint16_t numLayers, bgfx_texture_format_t format, int flags) {
	return bgfx_create_texture_2d_scaled(ratio, hasMips, numLayers, format, flags);
}

void bmx_bgfx_destroy_texture(bgfx_texture_handle_t texture) {
	bgfx_destroy_texture(texture);
}

int bmx_bgfx_is_texture_valid(uint16_t depth, int cubeMap, uint16_t numLayers, bgfx_texture_format_t format, uint32_t flags) {
	return bgfx_is_texture_valid(depth, cubeMap, numLayers, format, flags);
}

void bmx_bgfx_calc_texture_size(bgfx_texture_info_t * info, uint16_t width, uint16_t height, uint16_t depth, int cubeMap, int hasMips, uint16_t numLayers, bgfx_texture_format_t format) {
	bgfx_calc_texture_size(info, width, height, depth, cubeMap, hasMips, numLayers, format);
}

bgfx_texture_info_t * bmx_bgfx_texture_info_new() {
	return calloc(1, sizeof(bgfx_texture_info_t));
}

void bmx_bgfx_texture_info_free(bgfx_texture_info_t * info) {
	free(info);
}

bgfx_texture_format_t bmx_bgfx_texture_format(bgfx_texture_info_t * info) {
	return info->format;
}

int bmx_bgfx_texture_width(bgfx_texture_info_t * info) {
	return info->width;
}

int bmx_bgfx_texture_height(bgfx_texture_info_t * info) {
	return info->height;
}

int bmx_bgfx_texture_depth(bgfx_texture_info_t * info) {
	return info->depth;
}

int bmx_bgfx_texture_mips(bgfx_texture_info_t * info) {
	return info->numMips;
}

int bmx_bgfx_texture_bitsperpixel(bgfx_texture_info_t * info) {
	return info->bitsPerPixel;
}

int bmx_bgfx_texture_cubemap(bgfx_texture_info_t * info) {
	return info->cubeMap;
}

int bmx_bgfx_texture_storageSize(bgfx_texture_info_t * info) {
	return info->storageSize;
}

/* ----------------------------------------------------- */

void bmx_bgfx_set_marker(BBString * marker) {
	char * m = bbStringToUTF8String(marker);
	bgfx_set_marker(m);
	bbMemFree(m);
}

void bmx_bgfx_set_state(uint64_t state, int rgba) {
	bgfx_set_state(state, rgba);
}

void bmx_bgfx_set_condition(uint16_t occlusionQuery, int visible) {
	bgfx_set_condition(*(bgfx_occlusion_query_handle_t*)(&occlusionQuery), visible);
}

void bmx_bgfx_set_stencil(int fstencil, int bstencil) {
	bgfx_set_stencil(fstencil, bstencil);
}

uint16_t bmx_bgfx_set_scissor(uint16_t x, uint16_t y, uint16_t width, uint16_t height) {
	return bgfx_set_scissor(x, y, width, height);
}

void bmx_bgfx_set_scissor_cached(uint16_t cache) {
	bgfx_set_scissor_cached(cache);
}

int bmx_bgfx_set_transform(void * matrix, uint16_t num) {
	return bgfx_set_transform(matrix, num);
}

int bmx_bgfx_alloc_transform(bgfx_transform_t * transform, uint16_t num) {
	return bgfx_alloc_transform(transform, num);
}

void bmx_bgfx_set_transform_cached(int cache, uint16_t num) {
	bgfx_set_transform_cached(cache, num);
}

void bmx_bgfx_set_uniform(uint16_t uniform, void * value, uint16_t num) {
	bgfx_set_uniform(*(bgfx_uniform_handle_t*)(&uniform), value, num);
}

void bmx_bgfx_set_index_buffer(uint16_t indexBuffer, int firstIndex, int numIndices) {
	bgfx_set_index_buffer(*(bgfx_index_buffer_handle_t*)(&indexBuffer), firstIndex, numIndices);
}

void bmx_bgfx_set_dynamic_index_buffer(uint16_t dynamicIndexBuffer, int firstIndex, int numIndices) {
	bgfx_set_dynamic_index_buffer(*(bgfx_dynamic_index_buffer_handle_t*)(&dynamicIndexBuffer), firstIndex, numIndices);
}

void bmx_bgfx_set_transient_index_buffer(bgfx_transient_index_buffer_t * transientIndexBuffer, int firstIndex, int numIndices) {
	bgfx_set_transient_index_buffer(transientIndexBuffer, firstIndex, numIndices);
}

void bmx_bgfx_set_vertex_buffer(uint8_t stream, uint16_t vertexBuffer, int startVertex, int numVertices) {
	bgfx_set_vertex_buffer(stream, *(bgfx_vertex_buffer_handle_t*)(&vertexBuffer), startVertex, numVertices);
}

void bmx_bgfx_set_dynamic_vertex_buffer(uint8_t stream, uint16_t dynamicVertexBuffer, int startVertex, int numVertices) {
	bgfx_set_dynamic_vertex_buffer(stream, *(bgfx_dynamic_vertex_buffer_handle_t*)(&dynamicVertexBuffer), startVertex, numVertices);
}

void bmx_bgfx_set_transient_vertex_buffer(uint8_t stream, bgfx_transient_vertex_buffer_t * transientVertexBuffer, int startVertex, int numVertices) {
	bgfx_set_transient_vertex_buffer(stream, transientVertexBuffer, startVertex, numVertices);
}

void bmx_bgfx_set_vertex_count(int numVertices) {
	bgfx_set_vertex_count(numVertices);
}

void bmx_bgfx_set_instance_data_buffer(bgfx_instance_data_buffer_t * idb, int start, int num) {
	bgfx_set_instance_data_buffer(idb, start, num);
}

void bmx_bgfx_set_instance_data_from_vertex_buffer(uint16_t vertexBuffer, int startVertex, int num) {
	bgfx_set_instance_data_from_vertex_buffer(*(bgfx_vertex_buffer_handle_t*)(&vertexBuffer), startVertex, num);
}

void bmx_bgfx_set_instance_data_from_dynamic_vertex_buffer(uint16_t dynamicVertexBuffer, int startVertex, int num) {
	bgfx_set_instance_data_from_dynamic_vertex_buffer(*(bgfx_dynamic_vertex_buffer_handle_t*)(&dynamicVertexBuffer), startVertex, num);
}

void bmx_bgfx_set_texture(uint8_t stage, uint16_t uniform, uint16_t texture, int flags) {
	bgfx_set_texture(stage, *(bgfx_uniform_handle_t*)(&uniform), *(bgfx_texture_handle_t*)(&texture), flags);
}

void bmx_bgfx_touch(uint16_t id) {
	bgfx_touch(id);
}

void bmx_bgfx_submit(uint16_t id, uint16_t program, int depth, int preserveState) {
	bgfx_submit(id, *(bgfx_program_handle_t*)(&program), depth, preserveState);
}

void bmx_bgfx_submit_occlusion_query(uint16_t id, uint16_t program, uint16_t occlusionQuery, int depth, int preserveState) {
	bgfx_submit_occlusion_query(id, *(bgfx_program_handle_t*)(&program), *(bgfx_occlusion_query_handle_t*)(&occlusionQuery), depth, preserveState);
}

void bmx_bgfx_submit_indirect(uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num, int depth, int preserveState) {
	bgfx_submit_indirect(id, *(bgfx_program_handle_t*)(&program), *(bgfx_indirect_buffer_handle_t*)(&indirectBuffer), start, num, depth, preserveState);
}

void bmx_bgfx_set_image(uint8_t stage, uint16_t texture, uint8_t mip, int access, int format) {
	bgfx_set_image(stage, *(bgfx_texture_handle_t*)(&texture), mip, access, format);
}

void bmx_bgfx_set_compute_index_buffer(uint8_t stage, uint16_t indexBuffer, int access) {
	bgfx_set_compute_index_buffer(stage, *(bgfx_index_buffer_handle_t*)(&indexBuffer), access);
}

void bmx_bgfx_set_compute_vertex_buffer(uint8_t stage, uint16_t vertexBuffer, int access) {
	bgfx_set_compute_vertex_buffer(stage, *(bgfx_vertex_buffer_handle_t*)(&vertexBuffer), access);
}

void bmx_bgfx_set_compute_dynamic_index_buffer(uint8_t stage, uint16_t dynamicIndexBuffer, int access) {
	bgfx_set_compute_dynamic_index_buffer(stage, *(bgfx_dynamic_index_buffer_handle_t*)(&dynamicIndexBuffer), access);
}

void bmx_bgfx_set_compute_dynamic_vertex_buffer(uint8_t stage, uint16_t dynamicVertexBuffer, int access) {
	bgfx_set_compute_dynamic_vertex_buffer(stage, *(bgfx_dynamic_vertex_buffer_handle_t*)(&dynamicVertexBuffer), access);
}

void bmx_bgfx_set_compute_indirect_buffer(uint8_t stage, uint16_t indirectBuffer, int access) {
	bgfx_set_compute_indirect_buffer(stage, *(bgfx_indirect_buffer_handle_t*)(&indirectBuffer), access);
}

void bmx_bgfx_dispatch(uint16_t id, uint16_t program, int numX, int numY, int numZ) {
	bgfx_dispatch(id, *(bgfx_program_handle_t*)(&program), numX, numY, numZ);
}

void bmx_bgfx_dispatch_indirect(uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num) {
	bgfx_dispatch_indirect(id, *(bgfx_program_handle_t*)(&program), *(bgfx_indirect_buffer_handle_t*)(&indirectBuffer), start, num);
}

void bmx_bgfx_discard(struct bgfx_s * encoder) {
	bgfx_discard();
}

void bmx_bgfx_blit(uint16_t id, uint16_t dstTexture, uint8_t dstMip, uint16_t dstX, uint16_t dstY, uint16_t dstZ, uint16_t srcTexture, uint8_t srcMip, uint16_t srcX, uint16_t srcY, uint16_t srcZ, uint16_t width, uint16_t height, uint16_t depth) {
	bgfx_blit(id, *(bgfx_texture_handle_t*)(&dstTexture), dstMip, dstX, dstY, dstZ, *(bgfx_texture_handle_t*)(&srcTexture), srcMip, srcX, srcY, srcZ, width, height, depth);
}

/* ----------------------------------------------------- */

void bmx_bgfx_encoder_set_marker(struct bgfx_encoder_s * encoder, BBString * marker) {
	char * m = bbStringToUTF8String(marker);
	bgfx_encoder_set_marker(encoder, m);
	bbMemFree(m);
}

void bmx_bgfx_encoder_set_state(struct bgfx_encoder_s * encoder, uint64_t state, int rgba) {
	bgfx_encoder_set_state(encoder, state, rgba);
}

void bmx_bgfx_encoder_set_condition(struct bgfx_encoder_s * encoder, uint16_t occlusionQuery, int visible) {
	bgfx_encoder_set_condition(encoder, *(bgfx_occlusion_query_handle_t*)(&occlusionQuery), visible);
}

void bmx_bgfx_encoder_set_stencil(struct bgfx_encoder_s * encoder, int fstencil, int bstencil) {
	bgfx_encoder_set_stencil(encoder, fstencil, bstencil);
}

uint16_t bmx_bgfx_encoder_set_scissor(struct bgfx_encoder_s * encoder, uint16_t x, uint16_t y, uint16_t width, uint16_t height) {
	return bgfx_encoder_set_scissor(encoder, x, y, width, height);
}

void bmx_bgfx_encoder_set_scissor_cached(struct bgfx_encoder_s * encoder, uint16_t cache) {
	bgfx_encoder_set_scissor_cached(encoder, cache);
}

int bmx_bgfx_encoder_set_transform(struct bgfx_encoder_s * encoder, void * matrix, uint16_t num) {
	return bgfx_encoder_set_transform(encoder, matrix, num);
}

int bmx_bgfx_encoder_alloc_transform(struct bgfx_encoder_s * encoder, bgfx_transform_t * transform, uint16_t num) {
	return bgfx_encoder_alloc_transform(encoder, transform, num);
}

void bmx_bgfx_encoder_set_transform_cached(struct bgfx_encoder_s * encoder, int cache, uint16_t num) {
	bgfx_encoder_set_transform_cached(encoder, cache, num);
}

void bmx_bgfx_encoder_set_uniform(struct bgfx_encoder_s * encoder, uint16_t uniform, void * value, uint16_t num) {
	bgfx_encoder_set_uniform(encoder, *(bgfx_uniform_handle_t*)(&uniform), value, num);
}

void bmx_bgfx_encoder_set_index_buffer(struct bgfx_encoder_s * encoder, uint16_t indexBuffer, int firstIndex, int numIndices) {
	bgfx_encoder_set_index_buffer(encoder, *(bgfx_index_buffer_handle_t*)(&indexBuffer), firstIndex, numIndices);
}

void bmx_bgfx_encoder_set_dynamic_index_buffer(struct bgfx_encoder_s * encoder, uint16_t dynamicIndexBuffer, int firstIndex, int numIndices) {
	bgfx_encoder_set_dynamic_index_buffer(encoder, *(bgfx_dynamic_index_buffer_handle_t*)(&dynamicIndexBuffer), firstIndex, numIndices);
}

void bmx_bgfx_encoder_set_transient_index_buffer(struct bgfx_encoder_s * encoder, bgfx_transient_index_buffer_t * transientIndexBuffer, int firstIndex, int numIndices) {
	bgfx_encoder_set_transient_index_buffer(encoder, transientIndexBuffer, firstIndex, numIndices);
}

void bmx_bgfx_encoder_set_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stream, uint16_t vertexBuffer, int startVertex, int numVertices, uint16_t declHandle) {
	bgfx_encoder_set_vertex_buffer(encoder, stream, *(bgfx_vertex_buffer_handle_t*)(&vertexBuffer), startVertex, numVertices, *(bgfx_vertex_decl_handle_t*)(&declHandle));
}

void bmx_bgfx_encoder_set_dynamic_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stream, uint16_t dynamicVertexBuffer, int startVertex, int numVertices, uint16_t declHandle) {
	bgfx_encoder_set_dynamic_vertex_buffer(encoder, stream, *(bgfx_dynamic_vertex_buffer_handle_t*)(&dynamicVertexBuffer), startVertex, numVertices, *(bgfx_vertex_decl_handle_t*)(&declHandle));
}

void bmx_bgfx_encoder_set_transient_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stream, bgfx_transient_vertex_buffer_t * transientVertexBuffer, int startVertex, int numVertices, uint16_t declHandle) {
	bgfx_encoder_set_transient_vertex_buffer(encoder, stream, transientVertexBuffer, startVertex, numVertices, *(bgfx_vertex_decl_handle_t*)(&declHandle));
}

void bmx_bgfx_encoder_set_vertex_count(struct bgfx_encoder_s * encoder, int numVertices) {
	bgfx_encoder_set_vertex_count(encoder, numVertices);
}

void bmx_bgfx_encoder_set_instance_data_buffer(struct bgfx_encoder_s * encoder, bgfx_instance_data_buffer_t * idb, int start, int num) {
	bgfx_encoder_set_instance_data_buffer(encoder, idb, start, num);
}

void bmx_bgfx_encoder_set_instance_data_from_vertex_buffer(struct bgfx_encoder_s * encoder, uint16_t vertexBuffer, int startVertex, int num) {
	bgfx_encoder_set_instance_data_from_vertex_buffer(encoder, *(bgfx_vertex_buffer_handle_t*)(&vertexBuffer), startVertex, num);
}

void bmx_bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer(struct bgfx_encoder_s * encoder, uint16_t dynamicVertexBuffer, int startVertex, int num) {
	bgfx_encoder_set_instance_data_from_dynamic_vertex_buffer(encoder, *(bgfx_dynamic_vertex_buffer_handle_t*)(&dynamicVertexBuffer), startVertex, num);
}

void bmx_bgfx_encoder_set_texture(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t uniform, uint16_t texture, int flags) {
	bgfx_encoder_set_texture(encoder, stage, *(bgfx_uniform_handle_t*)(&uniform), *(bgfx_texture_handle_t*)(&texture), flags);
}

void bmx_bgfx_encoder_touch(struct bgfx_encoder_s * encoder, uint16_t id) {
	bgfx_encoder_touch(encoder, id);
}

void bmx_bgfx_encoder_submit(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, int depth, int preserveState) {
	bgfx_encoder_submit(encoder, id, *(bgfx_program_handle_t*)(&program), depth, preserveState);
}

void bmx_bgfx_encoder_submit_occlusion_query(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, uint16_t occlusionQuery, int depth, int preserveState) {
	bgfx_encoder_submit_occlusion_query(encoder, id, *(bgfx_program_handle_t*)(&program), *(bgfx_occlusion_query_handle_t*)(&occlusionQuery), depth, preserveState);
}

void bmx_bgfx_encoder_submit_indirect(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num, int depth, int preserveState) {
	bgfx_encoder_submit_indirect(encoder, id, *(bgfx_program_handle_t*)(&program), *(bgfx_indirect_buffer_handle_t*)(&indirectBuffer), start, num, depth, preserveState);
}

void bmx_bgfx_encoder_set_image(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t texture, uint8_t mip, int access, int format) {
	bgfx_encoder_set_image(encoder, stage, *(bgfx_texture_handle_t*)(&texture), mip, access, format);
}

void bmx_bgfx_encoder_set_compute_index_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t indexBuffer, int access) {
	bgfx_encoder_set_compute_index_buffer(encoder, stage, *(bgfx_index_buffer_handle_t*)(&indexBuffer), access);
}

void bmx_bgfx_encoder_set_compute_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t vertexBuffer, int access) {
	bgfx_encoder_set_compute_vertex_buffer(encoder, stage, *(bgfx_vertex_buffer_handle_t*)(&vertexBuffer), access);
}

void bmx_bgfx_encoder_set_compute_dynamic_index_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t dynamicIndexBuffer, int access) {
	bgfx_encoder_set_compute_dynamic_index_buffer(encoder, stage, *(bgfx_dynamic_index_buffer_handle_t*)(&dynamicIndexBuffer), access);
}

void bmx_bgfx_encoder_set_compute_dynamic_vertex_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t dynamicVertexBuffer, int access) {
	bgfx_encoder_set_compute_dynamic_vertex_buffer(encoder, stage, *(bgfx_dynamic_vertex_buffer_handle_t*)(&dynamicVertexBuffer), access);
}

void bmx_bgfx_encoder_set_compute_indirect_buffer(struct bgfx_encoder_s * encoder, uint8_t stage, uint16_t indirectBuffer, int access) {
	bgfx_encoder_set_compute_indirect_buffer(encoder, stage, *(bgfx_indirect_buffer_handle_t*)(&indirectBuffer), access);
}

void bmx_bgfx_encoder_dispatch(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, int numX, int numY, int numZ) {
	bgfx_encoder_dispatch(encoder, id, *(bgfx_program_handle_t*)(&program), numX, numY, numZ);
}

void bmx_bgfx_encoder_dispatch_indirect(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t program, uint16_t indirectBuffer, uint16_t start, uint16_t num) {
	bgfx_encoder_dispatch_indirect(encoder, id, *(bgfx_program_handle_t*)(&program), *(bgfx_indirect_buffer_handle_t*)(&indirectBuffer), start, num);
}

void bmx_bgfx_encoder_discard(struct bgfx_encoder_s * encoder) {
	bgfx_encoder_discard(encoder);
}

void bmx_bgfx_encoder_blit(struct bgfx_encoder_s * encoder, uint16_t id, uint16_t dstTexture, uint8_t dstMip, uint16_t dstX, uint16_t dstY, uint16_t dstZ, uint16_t srcTexture, uint8_t srcMip, uint16_t srcX, uint16_t srcY, uint16_t srcZ, uint16_t width, uint16_t height, uint16_t depth) {
	bgfx_encoder_blit(encoder, id, *(bgfx_texture_handle_t*)(&dstTexture), dstMip, dstX, dstY, dstZ, *(bgfx_texture_handle_t*)(&srcTexture), srcMip, srcX, srcY, srcZ, width, height, depth);
}

/* ----------------------------------------------------- */

uint32_t bmx_bgfx_capslimits_maxDrawCalls(bgfx_caps_limits_t * limits) {
	return limits->maxDrawCalls;
}

uint32_t bmx_bgfx_capslimits_maxBlits(bgfx_caps_limits_t * limits) {
	return limits->maxBlits;
}

uint32_t bmx_bgfx_capslimits_maxTextureSize(bgfx_caps_limits_t * limits) {
	return limits->maxTextureSize;
}

uint32_t bmx_bgfx_capslimits_maxTextureLayers(bgfx_caps_limits_t * limits) {
	return limits->maxTextureLayers;
}

uint32_t bmx_bgfx_capslimits_maxViews(bgfx_caps_limits_t * limits) {
	return limits->maxViews;
}

uint32_t bmx_bgfx_capslimits_maxFrameBuffers(bgfx_caps_limits_t * limits) {
	return limits->maxFrameBuffers;
}

uint32_t bmx_bgfx_capslimits_maxFBAttachments(bgfx_caps_limits_t * limits) {
	return limits->maxFBAttachments;
}

uint32_t bmx_bgfx_capslimits_maxPrograms(bgfx_caps_limits_t * limits) {
	return limits->maxPrograms;
}

uint32_t bmx_bgfx_capslimits_maxShaders(bgfx_caps_limits_t * limits) {
	return limits->maxShaders;
}

uint32_t bmx_bgfx_capslimits_maxTextures(bgfx_caps_limits_t * limits) {
	return limits->maxTextures;
}

uint32_t bmx_bgfx_capslimits_maxTextureSamplers(bgfx_caps_limits_t * limits) {
	return limits->maxTextureSamplers;
}

uint32_t bmx_bgfx_capslimits_maxVertexDecls(bgfx_caps_limits_t * limits) {
	return limits->maxVertexDecls;
}

uint32_t bmx_bgfx_capslimits_maxVertexStreams(bgfx_caps_limits_t * limits) {
	return limits->maxVertexStreams;
}

uint32_t bmx_bgfx_capslimits_maxIndexBuffers(bgfx_caps_limits_t * limits) {
	return limits->maxIndexBuffers;
}

uint32_t bmx_bgfx_capslimits_maxVertexBuffers(bgfx_caps_limits_t * limits) {
	return limits->maxVertexBuffers;
}

uint32_t bmx_bgfx_capslimits_maxDynamicIndexBuffers(bgfx_caps_limits_t * limits) {
	return limits->maxDynamicIndexBuffers;
}

uint32_t bmx_bgfx_capslimits_maxDynamicVertexBuffers(bgfx_caps_limits_t * limits) {
	return limits->maxDynamicVertexBuffers;
}

uint32_t bmx_bgfx_capslimits_maxUniforms(bgfx_caps_limits_t * limits) {
	return limits->maxUniforms;
}

uint32_t bmx_bgfx_capslimits_maxOcclusionQueries(bgfx_caps_limits_t * limits) {
	return limits->maxOcclusionQueries;
}

uint32_t bmx_bgfx_capslimits_maxEncoders(bgfx_caps_limits_t * limits) {
	return limits->maxEncoders;
}

uint32_t bmx_bgfx_capslimits_transientVbSize(bgfx_caps_limits_t * limits) {
	return limits->transientVbSize;
}

uint32_t bmx_bgfx_capslimits_transientIbSize(bgfx_caps_limits_t * limits) {
	return limits->transientIbSize;
}

