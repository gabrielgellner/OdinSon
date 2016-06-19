using OdinSon

Polygon([1 2 3; 3 4 5])
render(PolyLine(Array[[1, 2], [3, 4], [5, 6]]))

diagram = Canvas([Circle([0, 0], 1), Circle([1, 1], 0.5, style=Style(fill=NC"violet", stroke_width=2))])
render(diagram)
xlim(-2, 2)
ylim(-2, 2)
gca()[:set_aspect]("equal")

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
