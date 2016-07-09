using OdinSon
using Distributions

# API ideas
function gpar(;kwargs...)
    Dict{Symbol, Any}(kwargs)
end

gray = NC"gray"
style1 = gpar(
    boxes=gpar(stroke=gray, stroke_width=2, zorder=0.9),
    whiskers=gpar(stroke=gray, stroke_width=2, linestyle="-"),
    fences=gpar(stroke=gray, stroke_width=2),
    medians=gpar(stroke=gray, stroke_width=2),
    outliers=gpar(markerfacecolor=gray, marker="d", markeredgecolor=gray, markersize=5))

style2 = gpar(
    boxes=gpar(zorder=0.9, stroke=gray, stroke_width=2),
    whiskers=gpar(stroke=NC"red", stroke_width=5, linestyle="-"),
    outliers=gpar(markerfacecolor=gray, marker="d", markeredgecolor=gray, markersize=5))

# how do I do updates/mergers for these kinds of tree structures
merge(style1, style2) # so merge just works

# can I make a simple function that does validation?

# some utilities to convert OdinSon like parameter names to matplotlib names
#TODO: sadly patch and line objects in matplotlib use inconsistent names
translation_key = Dict{Symbol, Symbol}(
    :fill => :color,
    :stroke => :edgecolor,
    :stroke_width => :linewidth)

translation_key_line = Dict{Symbol, Symbol}(
    :stroke => :color,
    :stroke_width => :linewidth)

translation_boxplot = Dict{Symbol, Dict}(
    :boxes => translation_key,
    :whiskers => translation_key_line,
    :fences => translation_key_line,
    :medians => translation_key_line,
    :outliers => translation_key_line)

function _process_keys(kwdict, translation)
    kwd = Dict{Symbol, Any}()
    for (key, val) in kwdict
        if typeof(val) <: Dict
            kwd[key] = _process_keys(val, translation_boxplot[key])
        elseif haskey(translation, key)
            kwd[translation[key]] = val
        else
            kwd[key] = val
        end
    end
    return kwd
end

function gpar2mpl(kwdict)
    newkw = _process_keys(kwdict, nothing)
    return newkw
end

gpar2mpl(style1)

# Attempt at API

type AxesView
    items::Array{Any}
    scales::Dict{Symbol, Any}
end

function OdinSon.render(av::AxesView)
    f = figure()
    ax = f[:add_subplot](111)
    ax[:spines]["right"][:set_color]("none")
    ax[:spines]["top"][:set_color]("none")
    ax[:xaxis][:set_ticks_position]("bottom")
    ax[:spines]["bottom"][:set_position](("axes", -0.05))
    ax[:yaxis][:set_ticks_position]("left")
    ax[:spines]["left"][:set_position](("axes", -0.05))
    for item in av.items
        render!(ax, item)
    end
    return f
end

type Boxplot
    data::Array{Float64}
    style::Dict{Symbol, Any}
end

function render!(ax, bp::Boxplot)
    _style = gpar2mpl(bp.style)
    #TODO: I would rather not create a new figure, how do I return something composable
    vert = true
    colors = OdinSon.SEABORN_PALETTES[:deep]
    adict = ax[:boxplot](bp.data, vert=vert, patch_artist=true)
    # currently I only change the box on a per column basis
    @show size(adict["boxes"])
    for (j, box) in enumerate(adict["boxes"])
        box[:update](merge(_style[:boxes], gpar(color=colors[j])))
    end
    for whisk in adict["whiskers"]
        whisk[:update](_style[:whiskers])
    end
    for cap in adict["caps"]
        cap[:update](_style[:fences])
    end
    for med in adict["medians"]
        med[:update](_style[:medians])
    end
    for fly in adict["fliers"]
        fly[:update](_style[:outliers])
    end

    return nothing
end

function Boxplot(data; style=Dict{Symbol, Any}())
    colors = OdinSon.SEABORN_PALETTES[:deep]
    l = minimum([convert(HSL, convert(RGB{Float32}, color)).l for color in colors])
    gray = RGB(l*0.6, l*0.6, l*0.6)
    #TODO: think of a better name for _style
    _style = gpar(
        boxes=gpar(fill=colors[1], zorder=0.9, stroke=gray, stroke_width=2),
        whiskers=gpar(stroke=gray, stroke_width=2, linestyle="-"),
        fences=gpar(stroke=gray, stroke_width=2),
        medians=gpar(stroke=gray, stroke_width=2),
        outliers=gpar(markerfacecolor=gray, marker="d", markeredgecolor=gray, markersize=5)
    )
    merge!(_style, style)
    return Boxplot(data, _style)
end

boxplot2(data; style=Dict{Symbol, Any}()) = AxesView([Boxplot(data, style=style)], Dict{Symbol, Any}())

#=
# Examples
=#
data = rand(100, 6)
bp = boxplot2(data, style=style1)
render(bp)

data = rand(100)
bp = boxplot2(data)
render(bp)

#TODO: I really don't like th (1:6)'/2 bit, is this idomatic? Find out best way.
data = rand(Normal(0, 1), 20, 6) .+ (1:6)'/2
render(boxplot2(data))
