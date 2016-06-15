module OdinSon

# Seaborn like exports
export set_palette, color_cycle

# Custom Odinson exports

# Colors
include("color_data/crayon.jl")
include("color_data/xkcd.jl")
include("color_data/svg.jl")
include("color.jl")
export PyObject # my overload so that RGB types are turned to python tuples
export crayons, xkcd_rgb, svg_rgb
export @NC_str, @HC_str

end # module
