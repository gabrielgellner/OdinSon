using OdinSon
using PyPlot
using PyCall
@pyimport matplotlib.patches as mpp
@pyimport matplotlib.collections as mcol

Style(axes=AxesStyle(stroke_width=0.8, stroke=NC"red"))

#Do I assume a default axes/coordinate system?
Canvas([Circle((x, y), r, style=Style(stroke=NC"red", stroke_width=2)), Line()])

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
    pcol = mcol.PatchCollection(patches)
    (fig, ax) = subplots()
    ax[:add_collection](pcol)
    return fig
end

type Circle <: Grob
    cx::Real
    cy::Real
    r::Real
    function Circle(p::Tuple, r::Real)
        Circle(p[1], p[2], r)
    end
    function Circle(p::AbstractArray, r::Real)
        Circle(p[1], p[2], r)
    end
end

diagram = Canvas([Circle([0, 0], 1), Circle([1, 1], 0.5)])
render(diagram)

# not sure what to do about nesting Canvas
diagram = Canvas([Circle([0, 0], 1), Canvas([Circle([1, 0.5], 0.1), Circle([0.1, 0.1], 0.01)]), Circle([0.1, 0.1], 0.3)])
render(diagram)

Circle((1, 1), 1)
Circle([1, 2], 3)
render(go::Circle) = mpp.Circle((go.cx, go.cy), go.r)

circ = Circle(1, 1, 1)
render(circ)

(fig, ax) = subplots(figsize=(5, 5))
ax[:add_patch](render(circ))
show(fig)
