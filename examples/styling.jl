using OdinSon
using PyPlot
#mpp = PyPlot.matplotlib[:patches]
#mcol = PyPlot.matplotlib[:collections]
import Colors: RGB
using PyCall
@pyimport matplotlib.patches as mpp
@pyimport matplotlib.collections as mcol

# make the base shape types
abstract Grob

type Canvas <: Grob
    grobs::AbstractArray
end

function render(go::Canvas)
    patches = []
    for g in go.grobs
        push!(patches, render(g))
    end
    # using collections removes all styling, style must be passed into the PatchCollection
    #pcol = mcol.PatchCollection(patches)
    (fig, ax) = subplots()
    for p in patches
        ax[:add_patch](p)
    end
    return fig
end

type Style
    stroke::RGB
    stroke_width::Real
    fill::RGB # should also be able to be some kind of none, for not filled
    function Style(;stroke=NC"black", stroke_width=1.0, fill=NC"white")
        new(stroke, stroke_width, fill)
    end
end

function style2kw(s::Style)
    Dict(:edgecolor => s.stroke, :linewidth => s.stroke_width, :facecolor => s.fill)
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

convert(Point, (1, 2))
convert(Point, [1, 2])
convert(Point, [1, 2, 3])

type Circle <: Grob
    c::Point
    r::Float64
    style::Style
    function Circle(p, r; style=Style())
        new(p, r, style)
    end
end

function render(go::Circle)
    mpp.Circle(go.c, go.r; style2kw(go.style)...)
end

Circle([0, 0], 1)
render(Circle([0, 0], 1, style=Style(fill=NC"aqua")))
diagram = Canvas([Circle([0, 0], 1), Circle([1, 1], 0.5, style=Style(fill=NC"violet", stroke_width=2))])
render(diagram)
xlim(-2, 2)
ylim(-2, 2)
gca()[:set_aspect]("equal")

# not sure what to do about nesting Canvas
diagram = Canvas([Circle([0, 0], 1), Canvas([Circle([1, 0.5], 0.1), Circle([0.1, 0.1], 0.01)]), Circle([0.1, 0.1], 0.3)])
render(diagram)

Circle((1, 1), 1)
Circle([1, 2], 3)

circ = Circle(1, 1, 1)
render(circ)

(fig, ax) = subplots(figsize=(5, 5))
ax[:add_patch](render(circ))
show(fig)

#Do I assume a default axes/coordinate system?
Canvas([Circle((x, y), r, style=Style(stroke=NC"red", stroke_width=2)), Line()])

Style(axes=AxesStyle(stroke_width=0.8, stroke=NC"red"))
