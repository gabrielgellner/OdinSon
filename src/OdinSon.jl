module OdinSon

# Seaborn like exports
export set_palette

# Custom Odinson exports

include("color.jl")
include("color_data/crayon.jl")
include("color_data/xkcd.jl")
export crayons, xkcd_rgb

end # module
