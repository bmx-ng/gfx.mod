/*
  Copyright (c) 2015-2018 Bruce A Henderson
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
#include <windows.h>

#include "bgfx/c99/bgfx.h"
#include <brl.mod/systemdefault.mod/system.h>

static const wchar_t *CLASS_NAMEW=L"BlitzMax BgfxGraphics";

enum{
	MODE_SHARED,
	MODE_WIDGET,
	MODE_WINDOW,
	MODE_DISPLAY
};


typedef struct BBGfxContext BBGfxContext;

struct BBGfxContext{
	BBGfxContext *succ;
	int mode,width,height,depth,hertz,flags;
	
	HWND hwnd;
};

static BBGfxContext *_contexts;
static BBGfxContext *_currentContext;

static const wchar_t *appTitleW(){
	return bbTmpWString( bbAppTitle );
}

static _stdcall LRESULT _wndProc( HWND hwnd,UINT msg,WPARAM wp,LPARAM lp ){

	static HWND _fullScreen;

	BBGfxContext *c;
	for( c=_contexts;c && c->hwnd!=hwnd;c=c->succ ){}
	if( !c ){
		return DefWindowProcW( hwnd,msg,wp,lp );
	}

	bbSystemEmitOSEvent( hwnd,msg,wp,lp,&bbNullObject );

	switch( msg ){
	case WM_CLOSE:
		return 0;
	case WM_SYSCOMMAND:
		if (wp==SC_SCREENSAVE) return 1;
		if (wp==SC_MONITORPOWER) return 1;
		break;
	case WM_SYSKEYDOWN:
		if( wp!=VK_F4 ) return 0;
		break;
	case WM_SETFOCUS:
		if( c && c->mode==MODE_DISPLAY && hwnd!=_fullScreen ){
			DEVMODE dm;
			int swapInt=0;
			memset( &dm,0,sizeof(dm) );
			dm.dmSize=sizeof(dm);
			dm.dmPelsWidth=c->width;
			dm.dmPelsHeight=c->height;
			dm.dmBitsPerPel=c->depth;
			dm.dmFields=DM_PELSWIDTH|DM_PELSHEIGHT|DM_BITSPERPEL;
			if( c->hertz ){
				dm.dmDisplayFrequency=c->hertz;
				dm.dmFields|=DM_DISPLAYFREQUENCY;
				swapInt=1;
			}
			if( ChangeDisplaySettings( &dm,CDS_FULLSCREEN )==DISP_CHANGE_SUCCESSFUL ){
				_fullScreen=hwnd;
			}else if( dm.dmFields & DM_DISPLAYFREQUENCY ){
				dm.dmDisplayFrequency=0;
				dm.dmFields&=~DM_DISPLAYFREQUENCY;
				if( ChangeDisplaySettings( &dm,CDS_FULLSCREEN )==DISP_CHANGE_SUCCESSFUL ){
					_fullScreen=hwnd;
					swapInt=0;
				}
			}

			if( !_fullScreen ) bbExThrowCString( "GraphicsDriver failed to set display mode" );
			
			//_setSwapInterval( swapInt );
		}
		return 0;
	case WM_DESTROY:
	case WM_KILLFOCUS:
		if( hwnd==_fullScreen ){
			ChangeDisplaySettings( 0,CDS_FULLSCREEN );
			ShowWindow( hwnd,SW_MINIMIZE );
			//_setSwapInterval( 0 );
			_fullScreen=0;
		}
		return 0;
	case WM_PAINT:
		ValidateRect( hwnd,0 );
		return 0;
	}
	return DefWindowProcW( hwnd,msg,wp,lp );
}

static void _initWndClass(){
	static int _done;
	if( _done ) return;

	WNDCLASSEXW wc={sizeof(wc)};
	wc.style=CS_HREDRAW|CS_VREDRAW;
	wc.lpfnWndProc=(WNDPROC)_wndProc;
	wc.hInstance=GetModuleHandle(0);
	wc.lpszClassName=CLASS_NAMEW;
	wc.hCursor=(HCURSOR)LoadCursor( 0,IDC_ARROW );
	wc.hbrBackground=0;
	if( !RegisterClassExW( &wc ) ) exit( -1 );

	_done=1;
}

BBGfxContext *bbGfxGraphicsCreateGraphics( int width,int height,int depth,int hertz,int flags ){
	BBGfxContext *context;
	
	int mode;
	HWND hwnd;
	
	int hwnd_style;
	RECT rect={0,0,width,height};
	
	_initWndClass();
	
	if( depth ){
		mode=MODE_DISPLAY;
		hwnd_style=WS_POPUP;
	}else{
		HWND desktop = GetDesktopWindow();
		RECT desktopRect;
		GetWindowRect(desktop, &desktopRect);

		rect.left=desktopRect.right/2-width/2;		
		rect.top=desktopRect.bottom/2-height/2;		
		rect.right=rect.left+width;
		rect.bottom=rect.top+height;
		
		mode=MODE_WINDOW;
		hwnd_style=WS_CAPTION|WS_SYSMENU|WS_MINIMIZEBOX;
	}
		
	AdjustWindowRectEx( &rect,hwnd_style,0,0 );
	
	hwnd=CreateWindowExW(0, CLASS_NAMEW, appTitleW(),
		hwnd_style,rect.left,rect.top,rect.right-rect.left,rect.bottom-rect.top,0,0,GetModuleHandle(0),0 );
		
	if( !hwnd ) return 0;

	GetClientRect( hwnd,&rect );
	width=rect.right-rect.left;
	height=rect.bottom-rect.top;
		
	context=(BBGfxContext*)malloc( sizeof(BBGfxContext) );
	memset( context,0,sizeof(context) );
	
	context->mode=mode;
	context->width=width;
	context->height=height;
	context->depth=depth;
	context->hertz=hertz;
	context->flags=flags;
	
	context->hwnd=hwnd;
	
	context->succ=_contexts;
	_contexts=context;

	bgfx_platform_data_t pd;
	pd.ndt          = NULL;
	pd.nwh          = hwnd;
	pd.context      = NULL;
	pd.backBuffer   = NULL;
	pd.backBufferDS = NULL;
	bgfx_set_platform_data(&pd);
		
	ShowWindow( hwnd,SW_SHOW );
	
	return context;
}

void bbGfxGraphicsClose( BBGfxContext *context ){
	BBGfxContext **p,*t;
	
	for( p=&_contexts;(t=*p) && (t!=context);p=&t->succ ){}
	if( !t ) return;
	
	if( t==_currentContext ){
		bbGfxGraphicsSetGraphics( 0 );
	}
	
	if( t->mode==MODE_DISPLAY || t->mode==MODE_WINDOW ){
		DestroyWindow( t->hwnd );
	}
	
	*p=t->succ;
}

void bbGfxGraphicsSetGraphics( BBGfxContext *context ){

	if( context==_currentContext ) return;
	
	_currentContext=context;
	
}

void bbGfxGraphicsFlip( int sync ){
	if( !_currentContext ) return;
	
	bmx_bgfx_frame(0);
}

int bbGfxGraphicsGraphicsModes( int *modes,int count ){
	int i=0,n=0;
	while( n<count ){
		DEVMODE	mode;
		mode.dmSize=sizeof(DEVMODE);
		mode.dmDriverExtra=0;

		if( !EnumDisplaySettings(0,i++,&mode) ) break;

		if( mode.dmBitsPerPel<16 ) continue;

		*modes++=mode.dmPelsWidth;
		*modes++=mode.dmPelsHeight;
		*modes++=mode.dmBitsPerPel;
		*modes++=mode.dmDisplayFrequency;
		++n;
	}
	return n;
}

static void _validateSize( BBGfxContext *context ){
	if( context->mode==MODE_WIDGET ){
		RECT rect;
		GetClientRect( context->hwnd,&rect );
		context->width=rect.right-rect.left;
		context->height=rect.bottom-rect.top;
	}
}

void bbGfxGraphicsGetSettings( BBGfxContext *context,int *width,int *height,int *depth,int *hertz,int *flags ){
	_validateSize( context );
	*width=context->width;
	*height=context->height;
	*depth=context->depth;
	*hertz=context->hertz;
	*flags=context->flags;
}
