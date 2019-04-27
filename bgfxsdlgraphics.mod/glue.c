/*
 Copyright (c) 2014-2019 Bruce A Henderson

 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
*/

#include "SDL_config.h"

#include "SDL_video.h"
#include "SDL_mouse.h"
#include "SDL_syswm.h"

#include "bgfx/c99/bgfx.h"
#include <brl.mod/blitz.mod/blitz.h>

enum{
	MODE_SHARED=0,
	MODE_WIDGET=1,
	MODE_WINDOW=2,
	MODE_DISPLAY=3
};

enum{
	FLAGS_BACKBUFFER    = 0x02,
	FLAGS_ALPHABUFFER   = 0x04,
	FLAGS_DEPTHBUFFER   = 0x08,
	FLAGS_STENCILBUFFER = 0x10,
	FLAGS_ACCUMBUFFER   = 0x20,
	FLAGS_BORDERLESS    = 0x40,
	FLAGS_RPI_TV_FULLSCREEN = 0x1000,
	FLAGS_DX            = 0x1000000,
	FLAGS_FULLSCREEN    = 0x80000000
};

typedef struct BBGfxContext BBGfxContext;

struct BBGfxContext{
	BBGfxContext *succ;
	int mode,width,height,depth,hertz,flags,sync;
	SDL_Window * window;
	//SDL_GLContext context;
	SDL_SysWMinfo info;
};


int bbGfxGraphicsGraphicsModes( int display, int *imodes,int maxcount );
void bbGfxGraphicsFlip( int sync );
void bbGfxGraphicsSetGraphics( BBGfxContext *context );
void bbGfxGraphicsGetSettings( BBGfxContext *context, int * width,int * height,int * depth,int * hertz,int * flags);
void bbGfxGraphicsClose( BBGfxContext *context );
void bmx_SDL_Poll();
void bmx_SDL_WaitEvent();
void * bbSDLGraphicsGetHandle(BBGfxContext *context);
void bbGfxGraphicsCls();
void bbGfxSetPlatformData(SDL_Window * window);

static BBGfxContext *_contexts;
static BBGfxContext *_currentContext;

int bbGfxGraphicsGraphicsModes( int display, int *imodes,int maxcount ) {
	SDL_DisplayMode mode;
	int count,i;

	count = SDL_GetNumDisplayModes(display);
	if (count>maxcount) count=maxcount;
	for (i=0;i<count;i++) {
		SDL_GetDisplayMode(display, i, &mode);

		*imodes++=mode.w;
		*imodes++=mode.h;
		*imodes++=SDL_BITSPERPIXEL(mode.format);
		*imodes++=mode.refresh_rate;
	}
	return count;
}

static void * bbGfxGetWindowHandle(SDL_Window * window) {
	SDL_SysWMinfo wmi;
	SDL_VERSION(&wmi.version);
	if (!SDL_GetWindowWMInfo(window, &wmi) ) {
		return NULL;
	}
#if BX_PLATFORM_LINUX || BX_PLATFORM_BSD
#if ENTRY_CONFIG_USE_WAYLAND
	wl_egl_window *win_impl = (wl_egl_window*)SDL_GetWindowData(window, "wl_egl_window");
	if (!win_impl) {
		int width, height;
		SDL_GetWindowSize(window, &width, &height);
		struct wl_surface* surface = wmi.info.wl.surface;
		if (!surface) {
			return NULL;
		}
		win_impl = wl_egl_window_create(surface, width, height);
		SDL_SetWindowData(window, "wl_egl_window", win_impl);
	}
	return (void*)(uintptr_t)win_impl;
#else
	return (void*)wmi.info.x11.window;
#endif
#elif BX_PLATFORM_OSX
	return wmi.info.cocoa.window;
#elif BX_PLATFORM_WINDOWS
	return wmi.info.win.window;
#elif BX_PLATFORM_STEAMLINK
	return wmi.info.vivante.window;
#endif // BX_PLATFORM_
}

void bbGfxSetPlatformData(SDL_Window * window) {
	SDL_SysWMinfo info;
	SDL_VERSION(&info.version);
	if (!SDL_GetWindowWMInfo(window, &info)) {
		bbExThrow("Error getting window info");
	}

	bgfx_platform_data_t pd;
#if BX_PLATFORM_LINUX || BX_PLATFORM_BSD
#if ENTRY_CONFIG_USE_WAYLAND
	pd.ndt          = info.info.wl.display;
#else
	pd.ndt          = info.info.x11.display;
#endif
#elif BX_PLATFORM_OSX
	pd.ndt          = NULL;
#elif BX_PLATFORM_WINDOWS
	pd.ndt          = NULL;
#elif BX_PLATFORM_STEAMLINK
	pd.ndt          = info.info.vivante.display;
#endif // BX_PLATFORM_
	pd.nwh          = bbGfxGetWindowHandle(window);
	pd.context      = NULL;
	pd.backBuffer   = NULL;
	pd.backBufferDS = NULL;
	bgfx_set_platform_data(&pd);	
}

void bbGfxGraphicsFlip( int sync ) {
	//if( !_currentContext ) return;
//printf("flip\n");fflush(stdout);
//bgfx_set_view_rect_ratio(0, 0, 0, BGFX_BACKBUFFER_RATIO_EQUAL);

	bmx_bgfx_frame(0);

	bmx_SDL_Poll();
}

void bbGfxGraphicsClose( BBGfxContext *context ){
	BBGfxContext **p,*t;
	
	for( p=&_contexts;(t=*p) && (t!=context);p=&t->succ ){}
	if( !t ) return;
	
	if( t==_currentContext ){
		bbGfxGraphicsSetGraphics( 0 );
	}
	
	if( t->mode==MODE_DISPLAY || t->mode==MODE_WINDOW ){
		SDL_DestroyWindow(context->window);
	}
}

void bbGfxGraphicsSetGraphics( BBGfxContext *context ) {
	//if( context ){
	//	SDL_GL_MakeCurrent(context->window, context->context);
	//}
	_currentContext=context;
}

void bmx_SDL_WarpMouseInWindow(int x, int y) {
	if( _currentContext ){
		SDL_WarpMouseInWindow(_currentContext->window, x, y);
	} else {
		SDL_WarpMouseInWindow(SDL_GL_GetCurrentWindow(), x, y);
	}
}

void bbGfxGraphicsGetSettings( BBGfxContext *context, int * width,int * height,int * depth,int * hertz,int * flags) {
	if( context ){
		SDL_GetWindowSize(context->window, &context->width, &context->height);
		*width=context->width;
		*height=context->height;
		*depth=context->depth;
		*hertz=context->hertz;
		*flags=context->flags;
	}
}

void bbGfxGraphicsCls() {
	bgfx_encoder_t* encoder = bgfx_encoder_begin(true);
	bgfx_encoder_touch(encoder, 0);
	bgfx_encoder_end(encoder);
}

/*
void bbSDLExit(){
	bbGfxGraphicsClose( _currentContext );
	_currentContext=0;
#ifdef __RASPBERRYPI__
	SDL_VideoQuit();
#endif
}
*/
