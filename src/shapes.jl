#using PyPlot
import Colors: RGB
using PyCall
@pyimport matplotlib.patches as mpatches
@pyimport matplotlib.collections as mcol
@pyimport matplotlib.lines as mlines

type Circle <: Grob
    c::Point
    r::Float64
    style::Style
    # by default it seems svg has stroke=nothing, fill=NC"black", not sure if that is good
    function Circle(p, r; style=Style(stroke=nothing, fill=NC"black"))
        new(p, r, style)
    end
end

function render(go::Circle)
    mpatches.Circle(go.c, go.r; style2kw(go.style)...)
end

type PolyLine <: Grob
    points::Array{Point}
    style::Style
    function PolyLine(points; style=Style())
        new(points, style)
    end
end

function render(go::PolyLine)
    #TODO: likely super slow to have to reshape every time. Think of general way
    # looks like I could do Line2D(go.points...; style2kw_l(go.style)...) the only issue
    # I see with this is that that could be a stupid number of arguments being passed
    n = length(go.points)
    x = zeros(n)
    y = zeros(n)
    for (i, p) in enumerate(go.points)
        x[i] = p.x
        y[i] = p.y
    end
    mlines.Line2D(x, y; style2kw_l(go.style)...)
end

type Polygon <: Grob
    points::Array{Point}
    style::Style
    function Polygon(points; style=Style(fill=NC"black"))
        new(points, style)
    end
end

function render(go::Polygon)
    mpatches.Polygon(go.points; style2kw(go.style)...)
end
