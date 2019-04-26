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

Import "../bimg.mod/bimg/include/*.h"
Import "../bimg.mod/bimg/3rdparty/*.h"
Import "../bimg.mod/bimg/3rdparty/iqa/include/*.h"
Import "../bimg.mod/bimg/3rdparty/libsquish/*.h"
Import "../bimg.mod/bimg/3rdparty/pvrtc/*.h"
Import "../bimg.mod/bimg/3rdparty/etdaa3/*.h"
Import "../bimg.mod/bimg/3rdparty/etc1/*.h"
Import "../bimg.mod/bimg/3rdparty/etc2/*.h"
Import "../bimg.mod/bimg/3rdparty/nvtt/*.h"
Import "../bimg.mod/bimg/3rdparty/astc/*.h"
Import "../bx.mod/bx/include/*.h"
Import "../bxstream.mod/*.h"

?macos
Import "../bx.mod/bx/include/compat/osx/*.h"
?win32
Import "../bx.mod/bx/include/compat/mingw/*.h"
?

Import "../bimg.mod/bimg/src/image_cubemap_filter.cpp"
Import "../bimg.mod/bimg/src/image_decode.cpp"
Import "../bimg.mod/bimg/src/image_encode.cpp"

Import "../bimg.mod/bimg/3rdparty/libsquish/alpha.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/clusterfit.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/colourblock.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/colourfit.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/colourset.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/maths.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/rangefit.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/singlecolourfit.cpp"
Import "../bimg.mod/bimg/3rdparty/libsquish/squish.cpp"

Import "../bimg.mod/bimg/3rdparty/pvrtc/BitScale.cpp"
Import "../bimg.mod/bimg/3rdparty/pvrtc/MortonTable.cpp"
Import "../bimg.mod/bimg/3rdparty/pvrtc/PvrTcDecoder.cpp"
Import "../bimg.mod/bimg/3rdparty/pvrtc/PvrTcEncoder.cpp"
Import "../bimg.mod/bimg/3rdparty/pvrtc/PvrTcPacket.cpp"

Import "../bimg.mod/bimg/3rdparty/edtaa3/edtaa3func.cpp"

Import "../bimg.mod/bimg/3rdparty/etc1/etc1.cpp"

Import "../bimg.mod/bimg/3rdparty/etc2/ProcessRGB.cpp"
Import "../bimg.mod/bimg/3rdparty/etc2/Tables.cpp"

Import "../bimg.mod/bimg/3rdparty/nvtt/nvtt.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc6h/zoh.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc6h/zohone.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc6h/zohtwo.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc6h/zoh_utils.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode0.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode1.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode2.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode3.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode4.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode5.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode6.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_mode7.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/bc7/avpcl_utils.cpp"
Import "../bimg.mod/bimg/3rdparty/nvtt/nvmath/fitting.cpp"

Import "../bimg.mod/bimg/3rdparty/astc/astc_averages_and_directions.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_block_sizes2.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_color_quantize.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_color_unquantize.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_compress_symbolic.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_compute_variance.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_decompress_symbolic.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_encoding_choice_error.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_find_best_partitioning.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_ideal_endpoints_and_weights.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_imageblock.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_integer_sequence.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_kmeans_partitioning.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_lib.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_partition_tables.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_percentile_tables.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_pick_best_endpoint_format.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_quantization.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_symbolic_physical.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_weight_align.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/astc_weight_quant_xfer_tables.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/mathlib.cpp"
Import "../bimg.mod/bimg/3rdparty/astc/softfloat.cpp"

Import "texturec.cpp"
