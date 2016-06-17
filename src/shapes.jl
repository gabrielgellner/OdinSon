#using PyPlot
import Colors: RGB
using PyCall
import PyPlot: subplots
@pyimport matplotlib.patches as mpatches
@pyimport matplotlib.collections as mcol
@pyimport matplotlib.lines as mlines

type Style
    stroke::RGB
    stroke_width::Float64
    fill::RGB # should also be able to be some kind of none, for not filled
    fill_opacity::Float64 # should check for being between 0-1
    function Style(;stroke=NC"black", stroke_width=1.0, fill=NC"white", fill_opacity=1.0)
        new(stroke, stroke_width, fill, fill_opacity)
    end
end

# keywords for matplotlib patches are uniform
function style2kw(s::Style)
    Dict(:edgecolor => s.stroke, :linewidth => s.stroke_width, :facecolor => s.fill, :alpha => s.fill_opacity)
end

# keyworks for Line2D are different than patches
function style2kw_l(s::Style)
    Dict(:color => s.stroke, :linewidth => s.stroke_width)
end

# make the base shape types
abstract Grob

type Canvas <: Grob
    grobs::AbstractArray
    style::Style
    function Canvas(grobs; style=Style(fill=NC"white"))
        new(grobs, style)
    end
end

function render(go::Canvas)
    patches = []
    for g in go.grobs
        push!(patches, render(g))
    end
    # using collections removes all styling, style must be passed into the PatchCollection
    #pcol = mcol.PatchCollection(patches)
    (fig, ax) = subplots()
    # apply style to axes
    ax[:patch][:set_facecolor](go.style.fill)
    for p in patches
        # assume that we have either lines or patches
        if pyisinstance(p, mlines.Line2D)
            ax[:add_line](p)
        else
            ax[:add_patch](p)
        end
    end
    ax[:relim]() # resize the axes limits
    ax[:autoscale_view]() # make sure everyting is visable
    ax[:set_aspect]("equal") # TODO: make this an option
    return fig
end

type Point
    x::Float64
    y::Float64
end
function Base.convert(::Type{Point}, t::Union{Tuple, AbstractArray})
    if length(t) != 2
        throw(ArgumentError("Only length 2 objects can be converted to Point"))
    end
    Point(t[1], t[2])
end
PyCall.PyObject(t::Point) = PyObject((t.x, t.y))

type Circle <: Grob
    c::Point
    r::Float64
    style::Style
    function Circle(p, r; style=Style())
        new(p, r, style)
    end
end

function render(go::Circle)
    mpatches.Circle(go.c, go.r; style2kw(go.style)...)
end

type PolyLine <: Grob
    points::AbstractArray{Point}
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
    points::AbstractArray{Point}
    style::Style
    function Polygon(points; style=Style(fill=NC"black"))
        new(points, style)
    end
end

function render(go::Polygon)
    mpatches.Polygon(go.points; style2kw(go.style)...)
end
