import Colors: Colorant, Color, RGB, red, green, blue, parse, convert
import PyCall: @pyimport, PyObject
@pyimport cycler
import PyPlot: plt

SEABORN_PALETTES = Dict(
    :deep => ["#4C72B0", "#55A868", "#C44E52", "#8172B2", "#CCB974", "#64B5CD"],
    :muted => ["#4878CF", "#6ACC65", "#D65F5F", "#B47CC7", "#C4AD66", "#77BEDB"],
    :pastel => ["#92C6FF", "#97F0AA", "#FF9F9A", "#D0BBFF", "#FFFEA3", "#B0E0E6"],
    :bright => ["#003FFF", "#03ED3A", "#E8000B", "#8A2BE2", "#FFC400", "#00D7FF"],
    :dark => ["#001C7F", "#017517", "#8C0900", "#7600A1", "#B8860B", "#006374"],
    :colorblind => ["#0072B2", "#009E73", "#D55E00", "#CC79A7", "#F0E442", "#56B4E9"])

color_cycle(carr::AbstractArray) = cycler.cycler("color", carr)

#TODO: this needs a more a more julian name something like style!, palette!
function set_palette(name::Symbol)
    colprop = color_cycle(SEABORN_PALETTES[name])
    plt[:rc]("axes", prop_cycle=colprop)
end

# I need a way to convert the types from Colors.jl (RGB{8}(r, g, b) -> python tuple)
# this code is directly from PyCall.jl -> conversions.jl for tuple conversion
function PyObject(t::Color)
    trgb = convert(RGB, t)
    ctup = map(float, (red(trgb), green(trgb), blue(trgb)))
    o = PyObject(ctup)
    return o
end

#TODO: add RGBA versions

# string color names
# the order will matter ... or maybe I should have it return multiple
color_defs = [svg_rgb, crayons, xkcd_rgb]

function colorname2rgb(name::ASCIIString)
    for def in color_defs
        if haskey(def, name)
            return parse(Colorant, def[name])
        end
    end
    throw(ArgumentError("Not a Color name: $name"))
end

#NC for Named Color
macro NC_str(name::ASCIIString)
    c = colorname2rgb(name)
    return :($c)
end

#HC for Hex Color
macro HC_str(hexstr::ASCIIString)
    #TODO: test to ensure actually a hex string
    c = parse(Colorant, hexstr)
    return :($c)
end
