module OdinSon

# Seaborn like exports
export set_palette

# Custom Odinson exports
export PyObject

include("color_data/crayon.jl")
include("color_data/xkcd.jl")
include("color_data/svg.jl")
include("color.jl")
export crayons, xkcd_rgb, svg_rgb
export @C_str

end # module
