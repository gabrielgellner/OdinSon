import Colors: RGB, red, green, blue, parse, Colorant
import PyCall: @pyimport, PyObject
@pyimport cycler
import PyPlot: plt

SEABORN_PALETTES = Dict(
    :deep => ["#4C72B0", "#55A868", "#C44E52", "#8172B2", "#CCB974", "#64B5CD"],
    :muted => ["#4878CF", "#6ACC65", "#D65F5F", "#B47CC7", "#C4AD66", "#77BEDB"],
    :pastel => ["#92C6FF", "#97F0AA", "#FF9F9A", "#D0BBFF", "#FFFEA3", "#B0E0E6"],
    :bright => ["#003FFF", "#03ED3A", "#E8000B", "#8A2BE2", "#FFC400", "#00D7FF"],
    :dark => ["#001C7F", "#017517", "#8C0900", "#7600A1", "#B8860B", "#006374"],
    :colorblind => ["#0072B2", "#009E73", "#D55E00", "#CC79A7", "#F0E442", "#56B4E9"]
)

#this needs a more a more julian name something like style!, palette!
function set_palette(name::Symbol)
    colprop = cycler.cycler("color", SEABORN_PALETTES[name])
    plt[:rc]("axes", prop_cycle=colprop)
end

# I need a way to convert the types from Colors.jl (RGB{8}(r, g, b) -> python tuple)
# this code is directly from PyCall.jl -> conversions.jl for tuple conversion
function PyObject(t::RGB)
    ctup = map(float, (red(t), green(t), blue(t)))
    o = PyObject(ctup)
    return o
end

#TODO: add RGBA versions

# string color names
# the order will matter ... or maybe I should have it return multiple
color_defs = [svg_rgb, crayons, xkcd_rgb]

function parse_cstring(name::ASCIIString)
    for def in color_defs
        if haskey(def, name)
            return parse(Colorant, def[name])
        end
    end
    throw(ArgumentError("Not a Color name: $name"))
end

macro C_str(name::ASCIIString)
    c = parse_cstring(name)
    return :( $c )
end
