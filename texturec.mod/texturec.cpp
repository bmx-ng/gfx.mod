/*
  Copyright 2011-2018 Branimir Karadzic.
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
#include <bx/allocator.h>
#include <bx/readerwriter.h>
#include <bx/endian.h>
#include <bx/math.h>

#include <bimg/decode.h>
#include <bimg/encode.h>


#include "brl.mod/blitz.mod/blitz.h"
#include "gfx.mod/bxstream.mod/glue.h"

enum OutputType {
    KTX,
    DDS,
    PNG,
    EXR
};

struct Options
{
    Options()
            : maxSize(UINT32_MAX)
            , edge(0.0f)
            , format(bimg::TextureFormat::Count)
            , quality(bimg::Quality::Default)
            , mips(false)
            , normalMap(false)
            , equirect(false)
            , iqa(false)
            , pma(false)
            , sdf(false)
            , alphaTest(false)
			, outputType(KTX)
    {
    }

    uint32_t maxSize;
    float edge;
    bimg::TextureFormat::Enum format;
    bimg::Quality::Enum quality;
    bool mips;
    bool normalMap;
    bool equirect;
    bool iqa;
    bool pma;
    bool sdf;
    bool alphaTest;
	OutputType outputType;
};

extern "C" {

	Options * bmx_bimg_options_new();
	void bmx_bimg_options_free(Options * options);
	void bmx_bimg_options_setMaxSize(Options * options, int maxSize);
	void bmx_bimg_options_setEdge(Options * options, float edge);
	void bmx_bimg_options_setFormat(Options * options, int format);
	void bmx_bimg_options_setQuality(Options * options, int quality);
	void bmx_bimg_options_setMips(Options * options, int mips);
	void bmx_bimg_options_setNormalMap(Options * options, int normalMap);
	void bmx_bimg_options_setEquirect(Options * options, int equirect);
	void bmx_bimg_options_setIqa(Options * options, int iqa);
	void bmx_bimg_options_setPma(Options * options, int pma);
	void bmx_bimg_options_setSdf(Options * options, int sdf);
	void bmx_bimg_options_setAlphaTest(Options * options, int alphaTest);
	void bmx_bimg_options_setOutputType(Options * options, int outputType);

    void bmx_bimg_texturec_convert(MaxBxStream * reader, MaxBxStream * writer, Options * options);
}

static void imageRgba32fNormalize(void* _dst, uint32_t _width, uint32_t _height, uint32_t _srcPitch, const void* _src)
{
	const uint8_t* src = (const uint8_t*)_src;
	uint8_t* dst = (uint8_t*)_dst;

	for (uint32_t yy = 0, ystep = _srcPitch; yy < _height; ++yy, src += ystep)
	{
		const float* rgba = (const float*)&src[0];
		for (uint32_t xx = 0; xx < _width; ++xx, rgba += 4, dst += 16)
		{
			float xyz[3];

			xyz[0] = rgba[0];
			xyz[1] = rgba[1];
			xyz[2] = rgba[2];
			bx::vec3Norm( (float*)dst, xyz);
		}
	}
}

static void imagePremultiplyAlpha(void* _inOut, uint32_t _width, uint32_t _height, uint32_t _depth, bimg::TextureFormat::Enum _format)
{
	uint8_t* inOut = (uint8_t*)_inOut;
	uint32_t bpp = bimg::getBitsPerPixel(_format);
	uint32_t pitch = _width*bpp/8;

	bimg::PackFn   pack   = bimg::getPack(_format);
	bimg::UnpackFn unpack = bimg::getUnpack(_format);

	for (uint32_t zz = 0; zz < _depth; ++zz)
	{
		for (uint32_t yy = 0; yy < _height; ++yy)
		{
			for (uint32_t xx = 0; xx < _width; ++xx)
			{
				const uint32_t offset = yy*pitch + xx*bpp/8;

				float rgba[4];
				unpack(rgba, &inOut[offset]);
				const float alpha = rgba[3];
				rgba[0] = bx::toGamma(bx::toLinear(rgba[0]) * alpha);
				rgba[1] = bx::toGamma(bx::toLinear(rgba[1]) * alpha);
				rgba[2] = bx::toGamma(bx::toLinear(rgba[2]) * alpha);
				pack(&inOut[offset], rgba);
			}
		}
	}
}

static bimg::ImageContainer* convert(bx::AllocatorI* _allocator, const void* _inputData, uint32_t _inputSize, const Options& _options, bx::Error* _err)
{
	BX_ERROR_SCOPE(_err);

	const uint8_t* inputData = (uint8_t*)_inputData;

	bimg::ImageContainer* output = NULL;
	bimg::ImageContainer* input  = bimg::imageParse(_allocator, inputData, _inputSize, bimg::TextureFormat::Count, _err);

	if (!_err->isOk() )
	{
		return NULL;
	}

	if (NULL != input)
	{
		bimg::TextureFormat::Enum inputFormat  = input->m_format;
		bimg::TextureFormat::Enum outputFormat = input->m_format;

		if (bimg::TextureFormat::Count != _options.format)
		{
			outputFormat = _options.format;
		}

		if (_options.sdf)
		{
			outputFormat = bimg::TextureFormat::R8;
		}

		const bimg::ImageBlockInfo&  inputBlockInfo  = bimg::getBlockInfo(inputFormat);
		const bimg::ImageBlockInfo&  outputBlockInfo = bimg::getBlockInfo(outputFormat);
		const uint32_t blockWidth  = outputBlockInfo.blockWidth;
		const uint32_t blockHeight = outputBlockInfo.blockHeight;
		const uint32_t minBlockX   = outputBlockInfo.minBlockX;
		const uint32_t minBlockY   = outputBlockInfo.minBlockY;
		uint32_t outputWidth  = bx::uint32_max(blockWidth  * minBlockX, ( (input->m_width  + blockWidth  - 1) / blockWidth )*blockWidth);
		uint32_t outputHeight = bx::uint32_max(blockHeight * minBlockY, ( (input->m_height + blockHeight - 1) / blockHeight)*blockHeight);
		uint32_t outputDepth  = input->m_depth;

		if (outputWidth  > _options.maxSize
		||  outputHeight > _options.maxSize
		||  outputDepth  > _options.maxSize)
		{
			if (outputDepth > outputWidth
			&&  outputDepth > outputHeight)
			{
				outputWidth  = outputWidth  * _options.maxSize / outputDepth;
				outputHeight = outputHeight * _options.maxSize / outputDepth;
				outputDepth  = _options.maxSize;
			}
			else if (outputWidth > outputHeight)
			{
				outputDepth  = outputDepth  * _options.maxSize / outputWidth;
				outputHeight = outputHeight * _options.maxSize / outputWidth;
				outputWidth  = _options.maxSize;
			}
			else
			{
				outputDepth  = outputDepth * _options.maxSize / outputHeight;
				outputWidth  = outputWidth * _options.maxSize / outputHeight;
				outputHeight = _options.maxSize;
			}
		}

		const bool needResize = false
			|| input->m_width  != outputWidth
			|| input->m_height != outputHeight
			;

		const bool passThru = true
			&& !needResize
			&& (1 < input->m_numMips) == _options.mips
			&& !_options.sdf
			&& !_options.alphaTest
			&& !_options.normalMap
			&& !_options.equirect
			&& !_options.iqa
			&& !_options.pma
			;

		if (needResize)
		{
			bimg::ImageContainer* src = bimg::imageConvert(_allocator, bimg::TextureFormat::RGBA32F, *input, false);

			bimg::ImageContainer* dst = bimg::imageAlloc(
				  _allocator
				, bimg::TextureFormat::RGBA32F
				, uint16_t(outputWidth)
				, uint16_t(outputHeight)
				, uint16_t(outputDepth)
				, input->m_numLayers
				, input->m_cubeMap
				, false
				);

			bimg::imageResizeRgba32fLinear(dst, src);

			bimg::imageFree(src);
			bimg::imageFree(input);

			if (bimg::isCompressed(inputFormat) )
			{
				if (inputFormat == bimg::TextureFormat::BC6H)
				{
					inputFormat = bimg::TextureFormat::RGBA32F;
				}
				else
				{
					inputFormat = bimg::TextureFormat::RGBA8;
				}
			}

			input = bimg::imageConvert(_allocator, inputFormat, *dst);
			bimg::imageFree(dst);
		}

		if (passThru)
		{
			if (inputFormat != outputFormat
			&&  bimg::isCompressed(outputFormat) )
			{
				output = bimg::imageEncode(_allocator, outputFormat, _options.quality, *input);
			}
			else
			{
				output = bimg::imageConvert(_allocator, outputFormat, *input);
			}

			bimg::imageFree(input);
			return output;
		}

		if (_options.equirect)
		{
			bimg::ImageContainer* src = bimg::imageConvert(_allocator, bimg::TextureFormat::RGBA32F, *input);
			bimg::imageFree(input);

			bimg::ImageContainer* dst = bimg::imageCubemapFromLatLongRgba32F(_allocator, *src, true, _err);
			bimg::imageFree(src);

			if (!_err->isOk() )
			{
				return NULL;
			}

			input = bimg::imageConvert(_allocator, inputFormat, *dst);
			bimg::imageFree(dst);
		}

		output = bimg::imageAlloc(
			  _allocator
			, outputFormat
			, uint16_t(input->m_width)
			, uint16_t(input->m_height)
			, uint16_t(input->m_depth)
			, input->m_numLayers
			, input->m_cubeMap
			, _options.mips
			);

		const uint8_t  numMips  = output->m_numMips;
		const uint16_t numSides = output->m_numLayers * (output->m_cubeMap ? 6 : 1);

		for (uint16_t side = 0; side < numSides && _err->isOk(); ++side)
		{
			bimg::ImageMip mip;
			if (bimg::imageGetRawData(*input, side, 0, input->m_data, input->m_size, mip) )
			{
				bimg::ImageMip dstMip;
				bimg::imageGetRawData(*output, side, 0, output->m_data, output->m_size, dstMip);
				uint8_t* dstData = const_cast<uint8_t*>(dstMip.m_data);

				void* temp = NULL;

				// Normal map.
				if (_options.normalMap)
				{
					uint32_t size = bimg::imageGetSize(
						  NULL
						, uint16_t(dstMip.m_width)
						, uint16_t(dstMip.m_height)
						, 0
						, false
						, false
						, 1
						, bimg::TextureFormat::RGBA32F
						);
					temp = BX_ALLOC(_allocator, size);
					float* rgba = (float*)temp;
					float* rgbaDst = (float*)BX_ALLOC(_allocator, size);

					bimg::imageDecodeToRgba32f(_allocator
						, rgba
						, mip.m_data
						, dstMip.m_width
						, dstMip.m_height
						, dstMip.m_depth
						, dstMip.m_width*16
						, mip.m_format
						);

					if (bimg::TextureFormat::BC5 != mip.m_format)
					{
						for (uint32_t yy = 0; yy < mip.m_height; ++yy)
						{
							for (uint32_t xx = 0; xx < mip.m_width; ++xx)
							{
								const uint32_t offset = (yy*mip.m_width + xx) * 4;
								float* inout = &rgba[offset];
								inout[0] = inout[0] * 2.0f - 1.0f;
								inout[1] = inout[1] * 2.0f - 1.0f;
								inout[2] = inout[2] * 2.0f - 1.0f;
								inout[3] = inout[3] * 2.0f - 1.0f;
							}
						}
					}

					imageRgba32fNormalize(rgba
						, dstMip.m_width
						, dstMip.m_height
						, dstMip.m_width*16
						, rgba
						);

					bimg::imageRgba32f11to01(rgbaDst
						, dstMip.m_width
						, dstMip.m_height
						, dstMip.m_depth
						, dstMip.m_width*16
						, rgba
						);

					bimg::imageEncodeFromRgba32f(_allocator
						, dstData
						, rgbaDst
						, dstMip.m_width
						, dstMip.m_height
						, dstMip.m_depth
						, outputFormat
						, _options.quality
						, _err
						);

					for (uint8_t lod = 1; lod < numMips && _err->isOk(); ++lod)
					{
						bimg::imageRgba32fDownsample2x2NormalMap(rgba
							, dstMip.m_width
							, dstMip.m_height
							, dstMip.m_width*16
							, bx::strideAlign(dstMip.m_width/2, blockWidth)*16
							, rgba
							);

						bimg::imageRgba32f11to01(rgbaDst
							, dstMip.m_width
							, dstMip.m_height
							, dstMip.m_depth
							, dstMip.m_width*16
							, rgba
							);

						bimg::imageGetRawData(*output, side, lod, output->m_data, output->m_size, dstMip);
						dstData = const_cast<uint8_t*>(dstMip.m_data);

						bimg::imageEncodeFromRgba32f(_allocator
							, dstData
							, rgbaDst
							, dstMip.m_width
							, dstMip.m_height
							, dstMip.m_depth
							, outputFormat
							, _options.quality
							, _err
							);
					}

					BX_FREE(_allocator, rgbaDst);
				}
				// HDR
				else if ( (!bimg::isCompressed(inputFormat) && 8 != inputBlockInfo.rBits)
					 || outputFormat == bimg::TextureFormat::BC6H
					 || outputFormat == bimg::TextureFormat::BC7
						)
				{
					uint32_t size = bimg::imageGetSize(
						  NULL
						, uint16_t(dstMip.m_width)
						, uint16_t(dstMip.m_height)
						, uint16_t(dstMip.m_depth)
						, false
						, false
						, 1
						, bimg::TextureFormat::RGBA32F
						);
					temp = BX_ALLOC(_allocator, size);
					float* rgba32f = (float*)temp;
					float* rgbaDst = (float*)BX_ALLOC(_allocator, size);

					bimg::imageDecodeToRgba32f(_allocator
						, rgba32f
						, mip.m_data
						, mip.m_width
						, mip.m_height
						, mip.m_depth
						, mip.m_width*16
						, mip.m_format
						);

					if (_options.pma)
					{
						imagePremultiplyAlpha(
							  rgba32f
							, dstMip.m_width
							, dstMip.m_height
							, dstMip.m_depth
							, bimg::TextureFormat::RGBA32F
							);
					}

					bimg::imageEncodeFromRgba32f(_allocator
						, dstData
						, rgba32f
						, dstMip.m_width
						, dstMip.m_height
						, dstMip.m_depth
						, outputFormat
						, _options.quality
						, _err
						);

					if (1 < numMips
					&&  _err->isOk() )
					{
						bimg::imageRgba32fToLinear(rgba32f
							, mip.m_width
							, mip.m_height
							, mip.m_depth
							, mip.m_width*16
							, rgba32f
							);

						for (uint8_t lod = 1; lod < numMips && _err->isOk(); ++lod)
						{
							bimg::imageRgba32fLinearDownsample2x2(rgba32f
								, dstMip.m_width
								, dstMip.m_height
								, dstMip.m_depth
								, dstMip.m_width*16
								, rgba32f
								);

							if (_options.pma)
							{
								imagePremultiplyAlpha(
									  rgba32f
									, dstMip.m_width
									, dstMip.m_height
									, dstMip.m_depth
									, bimg::TextureFormat::RGBA32F
									);
							}

							bimg::imageGetRawData(*output, side, lod, output->m_data, output->m_size, dstMip);
							dstData = const_cast<uint8_t*>(dstMip.m_data);

							bimg::imageRgba32fToGamma(rgbaDst
								, mip.m_width
								, mip.m_height
								, mip.m_depth
								, mip.m_width*16
								, rgba32f
								);

							bimg::imageEncodeFromRgba32f(_allocator
								, dstData
								, rgbaDst
								, dstMip.m_width
								, dstMip.m_height
								, dstMip.m_depth
								, outputFormat
								, _options.quality
								, _err
								);
						}
					}

					BX_FREE(_allocator, rgbaDst);
				}
				// SDF
				else if (_options.sdf)
				{
					uint32_t size = bimg::imageGetSize(
						  NULL
						, uint16_t(dstMip.m_width)
						, uint16_t(dstMip.m_height)
						, uint16_t(dstMip.m_depth)
						, false
						, false
						, 1
						, bimg::TextureFormat::R8
						);
					temp = BX_ALLOC(_allocator, size);
					uint8_t* rgba = (uint8_t*)temp;

					bimg::imageDecodeToR8(_allocator
						, rgba
						, mip.m_data
						, mip.m_width
						, mip.m_height
						, mip.m_depth
						, mip.m_width
						, mip.m_format
						);

					bimg::imageGetRawData(*output, side, 0, output->m_data, output->m_size, dstMip);
					dstData = const_cast<uint8_t*>(dstMip.m_data);

					bimg::imageMakeDist(_allocator
						, dstData
						, mip.m_width
						, mip.m_height
						, mip.m_width
						, _options.edge
						, rgba
						);
				}
				// RGBA8
				else
				{
					uint32_t size = bimg::imageGetSize(
						  NULL
						, uint16_t(dstMip.m_width)
						, uint16_t(dstMip.m_height)
						, uint16_t(dstMip.m_depth)
						, false
						, false
						, 1
						, bimg::TextureFormat::RGBA8
						);
					temp = BX_ALLOC(_allocator, size);
					uint8_t* rgba = (uint8_t*)temp;

					bimg::imageDecodeToRgba8(
						  _allocator
						, rgba
						, mip.m_data
						, mip.m_width
						, mip.m_height
						, mip.m_width*4
						, mip.m_format
						);

					float coverage = 0.0f;
					if (_options.alphaTest)
					{
						coverage = bimg::imageAlphaTestCoverage(bimg::TextureFormat::RGBA8
							, mip.m_width
							, mip.m_height
							, mip.m_width*4
							, rgba
							, _options.edge
							);
					}

					void* ref = NULL;
					if (_options.iqa)
					{
						ref = BX_ALLOC(_allocator, size);
						bx::memCopy(ref, rgba, size);
					}

					if (_options.pma)
					{
						imagePremultiplyAlpha(
							  rgba
							, dstMip.m_width
							, dstMip.m_height
							, dstMip.m_depth
							, bimg::TextureFormat::RGBA8
							);
					}

					bimg::imageGetRawData(*output, side, 0, output->m_data, output->m_size, dstMip);
					dstData = const_cast<uint8_t*>(dstMip.m_data);

					bimg::imageEncodeFromRgba8(
						  _allocator
						, dstData
						, rgba
						, dstMip.m_width
						, dstMip.m_height
						, dstMip.m_depth
						, outputFormat
						, _options.quality
						, _err
						);

					for (uint8_t lod = 1; lod < numMips && _err->isOk(); ++lod)
					{
						bimg::imageRgba8Downsample2x2(rgba
							, dstMip.m_width
							, dstMip.m_height
							, dstMip.m_depth
							, dstMip.m_width*4
							, bx::strideAlign(dstMip.m_width/2, blockWidth)*4
							, rgba
							);

						if (_options.alphaTest)
						{
							bimg::imageScaleAlphaToCoverage(bimg::TextureFormat::RGBA8
								, dstMip.m_width
								, dstMip.m_height
								, dstMip.m_width*4
								, rgba
								, coverage
								, _options.edge
								);
						}

						if (_options.pma)
						{
							imagePremultiplyAlpha(
								  rgba
								, dstMip.m_width
								, dstMip.m_height
								, dstMip.m_depth
								, bimg::TextureFormat::RGBA8
								);
						}

						bimg::imageGetRawData(*output, side, lod, output->m_data, output->m_size, dstMip);
						dstData = const_cast<uint8_t*>(dstMip.m_data);

						bimg::imageEncodeFromRgba8(
							  _allocator
							, dstData
							, rgba
							, dstMip.m_width
							, dstMip.m_height
							, dstMip.m_depth
							, outputFormat
							, _options.quality
							, _err
							);
					}

					if (NULL != ref)
					{
						bimg::imageDecodeToRgba8(
							  _allocator
							, rgba
							, output->m_data
							, mip.m_width
							, mip.m_height
							, mip.m_width*mip.m_bpp/8
							, outputFormat
							);

						float result = bimg::imageQualityRgba8(
							  ref
							, rgba
							, uint16_t(mip.m_width)
							, uint16_t(mip.m_height)
							);

						printf("%f\n", result);

						BX_FREE(_allocator, ref);
					}
				}

				BX_FREE(_allocator, temp);
			}
		}

		bimg::imageFree(input);
	}

	if (!_err->isOk()
	&&  NULL != output)
	{
		bimg::imageFree(output);
		output = NULL;
	}

	return output;
}

class AlignedAllocator : public bx::AllocatorI
{
public:
	AlignedAllocator(bx::AllocatorI* _allocator, size_t _minAlignment)
		: m_allocator(_allocator)
		, m_minAlignment(_minAlignment)
	{
	}

	virtual void* realloc(
			void* _ptr
		, size_t _size
		, size_t _align
		, const char* _file
		, uint32_t _line
		)
	{
		return m_allocator->realloc(_ptr, _size, bx::max(_align, m_minAlignment), _file, _line);
	}

	bx::AllocatorI* m_allocator;
	size_t m_minAlignment;
};

class MaxTextureC {

public :
	void convert(MaxBxStream * reader, MaxBxStream * writer, Options * options) {
        bx::Error err;

        Options defaultOptions;

		if (options == NULL)
			options = &defaultOptions;

        uint32_t inputSize = (uint32_t) bx::getSize(reader);
        if (0 == inputSize) {
            //help("Failed to read input file.", err);
            //return bx::kExitFailure;
            return;
        }

        bx::DefaultAllocator defaultAllocator;
        AlignedAllocator allocator(&defaultAllocator, 16);

        uint8_t *inputData = (uint8_t *) BX_ALLOC(&allocator, inputSize);

        bx::read(reader, inputData, inputSize, &err);
        bx::close(reader);

        if (!err.isOk()) {
            //help("Failed to read input file.", err);
            //return bx::kExitFailure;
            return;
        }

        bimg::ImageContainer *output = ::convert(&allocator, inputData, inputSize, *options, &err);

        BX_FREE(&allocator, inputData);

        if (NULL != output) {
            //bx::FileWriter writer;
            //if (bx::open(&writer, outputFileName, false, &err) )
            //{
            if (options->outputType == KTX) {
                bimg::imageWriteKtx(writer, *output, output->m_data, output->m_size, &err);
            } else if (options->outputType == DDS) {
                bimg::imageWriteDds(writer, *output, output->m_data, output->m_size, &err);
            } else if (options->outputType == PNG) {
                if (output->m_format != bimg::TextureFormat::RGBA8) {
                    //help("Incompatible output texture format. Output PNG format must be RGBA8.", err);
                    //return bx::kExitFailure;
                    return;
                }

                bimg::ImageMip mip;
                bimg::imageGetRawData(*output, 0, 0, output->m_data, output->m_size, mip);
                bimg::imageWritePng(writer, mip.m_width, mip.m_height, mip.m_width * 4, mip.m_data, output->m_format,
                                    false, &err);
            } else if (options->outputType == EXR) {
                bimg::ImageMip mip;
                bimg::imageGetRawData(*output, 0, 0, output->m_data, output->m_size, mip);
                bimg::imageWriteExr(writer, mip.m_width, mip.m_height, mip.m_width * 8, mip.m_data, output->m_format,
                                    false, &err);
            }

            bx::close(writer);

            if (!err.isOk()) {
                // help(NULL, err);
                //return bx::kExitFailure;
                return;
            }
            //}
            bimg::imageFree(output);
        }
    }
};

// --------------------------------------------------------

void bmx_bimg_texturec_convert(MaxBxStream * reader, MaxBxStream * writer, Options * options) {
	MaxTextureC textureC;
	
	textureC.convert(reader, writer, options);
};

// --------------------------------------------------------

Options * bmx_bimg_options_new() {
	return new Options;
}

void bmx_bimg_options_free(Options * options) {
	delete options;
}

void bmx_bimg_options_setMaxSize(Options * options, int maxSize) {
	options->maxSize = static_cast<uint32_t>(maxSize);
}

void bmx_bimg_options_setEdge(Options * options, float edge) {
	options->edge = edge;
}

void bmx_bimg_options_setFormat(Options * options, int format) {
	options->format = static_cast<bimg::TextureFormat::Enum>(format);
}

void bmx_bimg_options_setQuality(Options * options, int quality) {
	options->quality = static_cast<bimg::Quality::Enum>(quality);
}

void bmx_bimg_options_setMips(Options * options, int mips) {
	options->mips = static_cast<bool>(mips);
}

void bmx_bimg_options_setNormalMap(Options * options, int normalMap) {
	options->normalMap = static_cast<bool>(normalMap);
}

void bmx_bimg_options_setEquirect(Options * options, int equirect) {
	options->equirect = static_cast<bool>(equirect);
}

void bmx_bimg_options_setIqa(Options * options, int iqa) {
	options->iqa = static_cast<bool>(iqa);
}

void bmx_bimg_options_setPma(Options * options, int pma) {
	options->pma = static_cast<bool>(pma);
}

void bmx_bimg_options_setSdf(Options * options, int sdf) {
	options->sdf = static_cast<bool>(sdf);
}

void bmx_bimg_options_setAlphaTest(Options * options, int alphaTest) {
	options->alphaTest = static_cast<bool>(alphaTest);
}

void bmx_bimg_options_setOutputType(Options * options, int outputType) {
	options->outputType = static_cast<OutputType>(outputType);
}
