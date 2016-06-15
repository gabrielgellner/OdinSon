using OdinSon
using Colors
using PyPlot

style(axes=AxesStyle(stroke_width=0.8, stroke="red"))

# the order will matter ... or maybe I should have it return multiple
color_defs = [Colors.color_names, crayons, xkcd_rgb]

function parse_cstring(name::ASCIIString)
    for def in color_defs
        if haskey(def, name)
            return parse(Colorant, def[name])
        end
    end
    throw(ArgumentError("Not a Color name: $name"))
end

macro C_str(name::String)
    c = parse_cstring(name)
    return :( $c )
end

parse_cstring("Almond")

C"Almond"

C"Red"

C"red"
