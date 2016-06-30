module OdinSon


# core types
include("coretypes.jl")
export Point

# Colors
import ColorTypes: HSV, RGB
include("color_data/crayon.jl")
include("color_data/xkcd.jl")
include("color_data/svg.jl")
include("color.jl")
export PyObject # my overload so that RGB types are turned to python tuples
export crayons, xkcd_rgb, svg_rgb
export @NC_str, @HC_str, HSV, RGB
# Seaborn like exports TODO: make these names more julian
export set_palette, color_cycle

include("util.jl")
# setup the default styling
_set_mpl_kws()

# Styling
include("style.jl")
export Style

# Containers
include("containers.jl")
export Canvas

# Basic SVG/Mathematica like language
include("shapes.jl")
export PolyLine, Polygon, Circle

# basic method for all graphic types
export render

end # module
