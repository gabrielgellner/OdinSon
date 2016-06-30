using OdinSon

Polygon([1 2 3; 3 4 5])
render(PolyLine(Array[[1, 2], [3, 4], [5, 6]]))

diagram = Canvas([Circle([0, 0], 1), Circle([1, 1], 0.5, style=Style(fill=NC"violet", stroke_width=2))])
render(diagram)
xlim(-2, 2)
ylim(-2, 2)

diagram = Canvas([PolyLine(Array[[1, 2], [2, 3], [3, 2]], style=Style(stroke_width=5, stroke=HSV(180, 1, 1)))])
render(diagram)

p1 = Polygon(Array[[1, 2], [2, 3], [3, 2]])
render(Canvas([p1]))

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
Canvas([Circle((x, y), r, style=Style(stroke=NC"red", stroke_width=2)), PolyLine()])

Style(axes=AxesStyle(stroke_width=0.8, stroke=NC"red"))

convert(Point, (1, 2))
convert(Point, [1, 2])
convert(Point, [1, 2, 3])

const _style_attrs = Dict{Symbol, Any}(
    :stroke => NC"black",
    :fill => :none,
    :stroke_width => 1.0)

function _check_attrs(attrs::Symbol)
    unknown = Symbol[]
    for attr in attrs
        if !haskey(_style_attrs, attr)
            push!(unknown, attr)
        end
    end
    return unknown
end

type Style2
    attrs::Dict{Symbol, Any}
end

function Style2(;kwargs...)
    kw = Dict{Symbol, Any}(kwargs)
    unknown = _check_attrs(keys(kw))
    if length(unknown) == 0
        return Style2(merge(_style_attrs, kw))
    else
        throw(ArgumentError("Unknown style attributes: $unknown"))
    end
end

Base.getindex(s::Style2, key::Symbol) = s.attrs[key]
function Base.setindex!(s::Style2, value, key::Symbol)
    if haskey(s.attrs, key)
        s.attrs[key] = value
        return value
    else
        throw(ArgumentError("Unknown style attribute: $key"))
    end
end

s = Style2(stroke_width=5)
s[:stroke_width]
s[:james] = NC"red"

# so pretty nice, but a lot of work and I don't have type checking on my arguments. The
# Type solution is looking nicer. I just want to add a merge method.
#
# Soooo. What to do about the Union{RGB, Void} issues. I like storing the RGB since
# this would mean I can use all the nice facilities of Colors, but due to the potential
# for nothing, I need to do a lot of checks, and lose type stability. I could go to
# Nullable{RGB}, but I am not sure that is the correct semantics, as it is not missing,
# as much as "not colored". I think I need a new type that is more descriptive. nothing
# is really for functions that don't return anything.
#
Viewport
GraphicsView # instead of Viewport for naming consistency a Viewport could be the abstract type
AxesView
GridView
# This will work from 0.5+ since there will no longer be implicit concat
GridView([[Viewport, AxesView], [AxesView]]) #(2 rows, 2 columns, second column spans)
# Is it worth having something that does a reshape? like:
GridView([v1, v2, v3, v4], layout=Layout([2, 2])) # rows and columns
Viewport([], inset=Inset(Viewport())
Viewport([], inset=Inset([Viewport(), AxesView()]))

Canvas(Viewport)
