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
#include "glue.h"

extern "C" {

	BBLONG gfx_bxstream_TBxStreamWrapper__seek(BBObject *, BBLONG, int);
	int gfx_bxstream_TBxStreamWrapper__read(BBObject *, void *, int);
	int gfx_bxstream_TBxStreamWrapper__write(BBObject *, const void *, int);
	int gfx_bxstream_TBxStreamWrapper__close(BBObject *);

	MaxBxStream * bmx_bx_stream_new(BBObject * obj);
	void bmx_bx_stream_free(MaxBxStream * stream);

}


// --------------------------------------------------------


MaxBxStream::MaxBxStream(BBObject * stream)
	: maxStream(stream) {
	BBRETAIN(stream);
}

MaxBxStream::~MaxBxStream() {
	BBRELEASE(maxStream);
}

int64_t MaxBxStream::seek(int64_t offset, bx::Whence::Enum whence) {
	return gfx_bxstream_TBxStreamWrapper__seek(maxStream, offset, whence);
}

int32_t MaxBxStream::write(const void* data, int32_t size, bx::Error * err) {
	return gfx_bxstream_TBxStreamWrapper__write(maxStream, data, size);
}

int32_t MaxBxStream::read(void* data, int32_t size, bx::Error* err) {
	return gfx_bxstream_TBxStreamWrapper__read(maxStream, data, size);
}

void MaxBxStream::close() {
	gfx_bxstream_TBxStreamWrapper__close(maxStream);
}

// --------------------------------------------------------

MaxBxStream * bmx_bx_stream_new(BBObject * obj) {
	return new MaxBxStream(obj);
}

void bmx_bx_stream_free(MaxBxStream * stream) {
	delete stream;
}
