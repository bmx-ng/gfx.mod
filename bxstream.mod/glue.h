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
#ifndef GFX_BXSTREAM_GLUE
#define GFX_BXSTREAM_GLUE


#include <bx/readerwriter.h>
#include "brl.mod/blitz.mod/blitz.h"

class MaxBxStream : public bx::ReaderI, public bx::WriterI, public bx::SeekerI, public bx::CloserI {

public:
	MaxBxStream(BBObject * stream);
	
	virtual ~MaxBxStream();
	
	virtual int64_t seek(int64_t offset = 0, bx::Whence::Enum whence = bx::Whence::Current) override;
	
	virtual int32_t write(const void* data, int32_t size, bx::Error * err) override;	

	virtual int32_t read(void* data, int32_t size, bx::Error* err) override;
	
	virtual void close() override;

private:
	BBObject * maxStream;
};


#endif
