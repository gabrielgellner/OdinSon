module OdinSon

# Seaborn like exports TODO: make these names more julian
export set_palette, color_cycle

# Colors
import ColorTypes: HSV, RGB
include("color_data/crayon.jl")
include("color_data/xkcd.jl")
include("color_data/svg.jl")
include("color.jl")
export PyObject # my overload so that RGB types are turned to python tuples
export crayons, xkcd_rgb, svg_rgb
export @NC_str, @HC_str, HSV, RGB

# Basic SVG/Mathematica like language
include("shapes.jl")
export Canvas, Style, PolyLine, Polygon, Circle, render

end # module
