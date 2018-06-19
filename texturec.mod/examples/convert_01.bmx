SuperStrict

Framework gfx.texturec


Local in:TStream = ReadStream("22dry.png")
Local out:TStream = WriteStream("22dry.dds")

Local options:TOptions = New TOptions
options.SetOutputType(OUTPUT_DDS)
options.SetMips(True)

TextureC(in, out, options)
