using OdinSon
using Distributions

# API ideas
function gpar(;kwargs...)
    Dict{Symbol, Any}(kwargs)
end

# A recursive merge is needed to deal with nested dicts
#TODO: this needs tests. It also might not do the write thing if one value is a dict, and the other is not.
# though I am not sure this is even valid gpar specification
#TODO: also I should have an inplace version
function gparmerge(s1::Dict, s2::Dict)
    snew = copy(s1)
    for (k, v) in s2
        if typeof(v) <: Dict && typeof(snew[k]) <: Dict
            snew[k] = gparmerge(snew[k], v)
        else
            snew[k] = v
        end
    end
    return snew
end
# can I make a simple function that does validation?

# some utilities to convert OdinSon like parameter names to matplotlib names
#TODO: sadly patch and line objects in matplotlib use inconsistent names
translation_key = Dict{Symbol, Symbol}(
    :fill => :color,
    :stroke => :edgecolor,
    :stroke_width => :linewidth,
    #:stroke_dash => :linestyle,
    :marker_fill => :markerfacecolor,
    :marker_stroke => :markeredgecolor,
    :marker_stroke_width => :markeredgewidth,
    :marker_size => :markersize
)

translation_key_line = Dict{Symbol, Symbol}(
    :stroke => :color,
    :stroke_width => :linewidth,
    #:stroke_dash => :linestyle,
    :marker_stroke => :markeredgecolor,
    :marker_size => :markersize,
    :marker_fill => :markerfacecolor,
    :marker_stroke_width => :markeredgewidth
)

translation_boxplot = Dict{Symbol, Dict}(
    :boxes => translation_key,
    :whiskers => translation_key_line,
    :fences => translation_key_line,
    :medians => translation_key_line,
    :outliers => translation_key_line
)

# for array style arguments values I really need them to be able to cycle
nextval(it::Base.Cycle, i) = it.xs[(i - 1)%length(it.xs) + 1]

function _process_dash(val)
    if val in ["-", :none]
        return "-"
    elseif val == "--"
        return (0, (6.5, 5.5))
    elseif val == "-."
        return (0, (5.0, 5.0, 2.0, 5.0))
    elseif val == ":"
        return (0, (2.0, 2.5))
    else
        return (0, val) # how do I deal with when it has the offset
    end
end

function _process_keys(kwdict, translation)
    kwd = Dict{Symbol, Any}()
    for (key, val) in kwdict
        if typeof(val) <: Dict
            kwd[key] = _process_keys(val, translation_boxplot[key])
        elseif key == :stroke_dash
            kwd[:linestyle] = cycle([_process_dash(val)])
        elseif haskey(translation, key)
            kwd[translation[key]] = cycle([val])
        else
            kwd[key] = cycle([val])
        end
    end
    return kwd
end

function gpar2mpl(kwdict)
    newkw = _process_keys(kwdict, nothing)
    return newkw
end

# Attempt at API
type AxesView
    items::Array{Any}
    scales::Dict{Symbol, Any}
end

function OdinSon.render(av::AxesView)
    f = figure()
    ax = f[:add_subplot](111)
    for item in av.items
        render!(ax, item)
    end
    # run this after the elements have been added so the spine ranges are set
    despine!(ax, offset=10, trim=true)
    return f
end

type Boxplot
    data::Array{Float64}
    style::Dict{Symbol, Any}
end

process_style(styledict::Dict, idx::Int) = Dict([k => nextval(v, idx) for (k, v) in styledict])

function render!(ax, bp::Boxplot)
    _style = gpar2mpl(bp.style)
    #TODO: I would rather not create a new figure, how do I return something composable
    vert = true
    colors = OdinSon.SEABORN_PALETTES[:deep]
    adict = ax[:boxplot](bp.data, vert=vert, patch_artist=true)
    #TODO: currently I only change the box on a per column basis. How to I deal with multiple
    # style options per boxplot, versus just a single.
    for (j, box) in enumerate(adict["boxes"])
        box[:update](process_style(_style[:boxes], j))
    end
    for (j, whisk) in enumerate(adict["whiskers"])
        whisk[:update](process_style(_style[:whiskers], j))
    end
    for (j, cap) in enumerate(adict["caps"])
        cap[:update](process_style(_style[:fences], j))
    end
    for (j, med) in enumerate(adict["medians"])
        med[:update](process_style(_style[:medians], j))
    end
    for (j, fly) in enumerate(adict["fliers"])
        fly[:update](process_style(_style[:outliers], j))
    end

    return nothing
end

function Boxplot(data; style=Dict{Symbol, Any}())
    colors = OdinSon.SEABORN_PALETTES[:deep]
    l = minimum([convert(HSL, convert(RGB{Float32}, color)).l for color in colors])
    gray = RGB(l*0.6, l*0.6, l*0.6)
    #TODO: should this be moved to a global const?
    core_style = gpar(
        boxes=gpar(fill=colors, stroke=gray, stroke_width=2, zorder=0.9),
        whiskers=gpar(stroke=gray, stroke_width=2, stroke_dash=:none),
        fences=gpar(stroke=gray, stroke_width=2),
        medians=gpar(stroke=gray, stroke_width=2),
        outliers=gpar(marker_fill=gray, marker="d", marker_stroke=gray, marker_size=5)
    )
    return Boxplot(data, gparmerge(core_style, style))
end

boxplot2(data; style=Dict{Symbol, Any}()) = AxesView([Boxplot(data, style=style)], Dict{Symbol, Any}())
