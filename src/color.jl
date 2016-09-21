import Colors: Colorant, Color, RGB, red, green, blue, parse, convert
import PyCall: @pyimport, PyObject
@pyimport cycler
import PyPlot: plt


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

function colorname2rgb(name::String)
    for def in color_defs
        if haskey(def, name)
            return parse(Colorant, def[name])
        end
    end
    throw(ArgumentError("Not a Color name: $name"))
end

#NC for Named Color
macro NC_str(name::String)
    c = colorname2rgb(name)
    return :($c)
end

#HC for Hex Color
macro HC_str(hexstr::String)
    #TODO: test to ensure actually a hex string
    c = parse(Colorant, hexstr)
    return :($c)
end

# Named color palettes
SEABORN_PALETTES = Dict(
:deep => [HC"#4C72B0", HC"#55A868", HC"#C44E52", HC"#8172B2", HC"#CCB974", HC"#64B5CD"],
:muted => [HC"#4878CF", HC"#6ACC65", HC"#D65F5F", HC"#B47CC7", HC"#C4AD66", HC"#77BEDB"],
:pastel => [HC"#92C6FF", HC"#97F0AA", HC"#FF9F9A", HC"#D0BBFF", HC"#FFFEA3", HC"#B0E0E6"],
:bright => [HC"#003FFF", HC"#03ED3A", "#E8000B", HC"#8A2BE2", HC"#FFC400", HC"#00D7FF"],
:dark => [HC"#001C7F", HC"#017517", "#8C0900", HC"#7600A1", HC"#B8860B", HC"#006374"],
:colorblind => [HC"#0072B2", HC"#009E73", HC"#D55E00", HC"#CC79A7", HC"#F0E442", HC"#56B4E9"])

color_cycle(carr::AbstractArray) = cycler.cycler("color", carr)

#TODO: this needs a more a more julian name something like style!, palette!
function set_palette(name::Symbol)
    colprop = color_cycle(SEABORN_PALETTES[name])
    plt[:rc]("axes", prop_cycle=colprop)
end
