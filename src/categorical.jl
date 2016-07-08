using OdinSon
using PyPlot

function _establish_colors()
    return OdinSon.SEABORN_PALETTES[:deep]
end

# Attempt to port some of the Seaborn functions for plotting categorical data
function _restyle_boxplot(adict, colors)
    # take a drawn matplotlib boxplot and make it look nice.
    linewidth = 2
    #gray = NC"gray" #TODO: recreate the logic from seaborn for setting this
    #TODO: can replace with convert(HSL, col) once the fix is merged upstream
    l = minimum([convert(HSL, convert(RGB{Float32}, color)).l for color in colors])
    gray = RGB(l*0.6, l*0.6, l*0.6)
    fliersize = 5

    # currently I only change the box on a per column basis
    for (j, box) in enumerate(adict["boxes"])
        box[:update](Dict(:facecolor => colors[j], :zorder => 0.9, :edgecolor => gray, :linewidth => linewidth))
    end
    for whisk in adict["whiskers"]
        whisk[:update](Dict(:color => gray, :linewidth => linewidth, :linestyle => "-"))
    end
    for cap in adict["caps"]
        cap[:update](Dict(:color => gray, :linewidth => linewidth))
    end
    for med in adict["medians"]
        med[:update](Dict(:color => gray, :linewidth => linewidth))
    end
    for fly in adict["fliers"]
        fly[:update](Dict(:markerfacecolor => gray, :marker => "d", :markeredgecolor => gray, :markersize => fliersize))
    end
end

function _draw_boxplot(ax, data)
    colors = _establish_colors()
    vert = true
    artist_dict = ax[:boxplot](data, vert=vert, patch_artist=true)
    _restyle_boxplot(artist_dict, colors)
end

#TODO: I need to use a funny name since otherwise I have problems with overwriting PyPlot
function oboxplot(data)
    # first lets just get the nicer styling of seaborn
    ax = gca()
    _draw_boxplot(ax, data)
end

# test remove once ready
using Distributions
#TODO: I really don't like th (1:6)'/2 bit, is this idomatic? Find out best way.
data = rand(Normal(0, 1), 20, 6) .+ (1:6)'/2
oboxplot(data)

#API ideas
type BoxPlotStyle
    boxes::Dict{Symbol, Any}
    whiskers::Dict{Symbol, Any}
    fences::Dict{Symbol, Any} # base R calls this staple, matplotlib calls this caps
    medians::Dict{Symbol, Any} # base R: med
    outliers::Dict{Symbol, Any} # base R: outl, fliers
    #notch::BoxPlotStyle
    function BoxPlotStyle(;
        boxes=Dict(:zorder => 0.9, :edgecolor => gray, :linewidth => linewidth),
        whiskers=Dict(:color => gray, :linewidth => linewidth, :linestyle => "-"),
        fences=Dict(:color => gray, :linewidth => linewidth),
        medians=Dict(:color => gray, :linewidth => linewidth),
        outliers=Dict(:markerfacecolor => gray, :marker => "d", :markeredgecolor => gray, :markersize => fliersize)
        )
        new(boxes, whiskers, fences, medians, outliers)
    end
end

function gpar(;kwargs...)
    Dict{Symbol, Any}(kwargs)
end

gray = NC"gray"
style1 = gpar(
    boxes=gpar(zorder=0.9, stroke=gray, stroke_width=2),
    whiskers=gpar(color=gray, stroke_width=2, linestyle="-"),
    fences=gpar(color=gray, stroke_width=2),
    medians=gpar(color=gray, stroke_width=2),
    outliers=gpar(markerfacecolor=gray, marker="d", markeredgecolor=gray, markersize=5))

style2 = gpar(
    boxes=gpar(zorder=0.9, edgecolor=gray, linewidth=2),
    whiskers=gpar(color=NC"red", linewidth=5, linestyle="-"),
    outliers=gpar(markerfacecolor=gray, marker="d", markeredgecolor=gray, markersize=5))

# how do I do updates/mergers for these kinds of tree structures
merge(style1, style2) # so merge just works

# can I make a simple function that does validation?

# some utilities to convert OdinSon like parameter names to matplotlib names
translation_key = Dict{Symbol, Symbol}(
    :fill => :color,
    :stroke => :edgecolor,
    :stroke_width => :linewidth)

function gpar2mpl(kwdict)
    newkw = copy(kwdict)
    for (key, val) in kwdict
        if haskey(translation_key, key)
            newkw[translation_key[key]] = val
        end
    end
    return newkw
end

gpar2mpl(style1)

# Attempt at API
type Boxplot
    data::AbstractArray
    style::Dict{Symbol, Any}
end

function OdinSon.render(bp::Boxplot)
    #TODO: I would rather not create a new figure, how do I return something composable
    f = figure()
    ax = f[:add_subplot](111)
    vert = true
    colors = OdinSon.SEABORN_PALETTES[:deep]
    adict = ax[:boxplot](bp.data, vert=vert, patch_artist=true)
    # currently I only change the box on a per column basis
    for (j, box) in enumerate(adict["boxes"])
        box[:update](merge(bp.style[:boxes], gpar(color=colors[j])))
    end
    for whisk in adict["whiskers"]
        whisk[:update](bp.style[:whiskers])
    end
    for cap in adict["caps"]
        cap[:update](bp.style[:fences])
    end
    for med in adict["medians"]
        med[:update](bp.style[:medians])
    end
    for fly in adict["fliers"]
        fly[:update](bp.style[:outliers])
    end

    return f
end

function boxplot2(data; style=Dict{Symbol, Any}())
    colors = OdinSon.SEABORN_PALETTES[:deep]
    l = minimum([convert(HSL, convert(RGB{Float32}, color)).l for color in colors])
    gray = RGB(l*0.6, l*0.6, l*0.6)
    #TODO: think of a better name for _style
    _style = gpar(
        boxes=gpar(color=colors[1], zorder=0.9, edgecolor=gray, linewidth=2),
        whiskers=gpar(color=gray, linewidth=2, linestyle="-"),
        fences=gpar(color=gray, linewidth=2),
        medians=gpar(color=gray, linewidth=2),
        outliers=gpar(markerfacecolor=gray, marker="d", markeredgecolor=gray, markersize=5)
    )
    merge!(_style, style)
    return Boxplot(data, _style)
end

data = rand(100, 6)
bp = boxplot2(data)
render(bp)

data = rand(100)
bp = boxplot2(data)
render(bp)
