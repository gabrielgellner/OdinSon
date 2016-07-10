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
"""
    set_spine_position(spine, position)

Set the spine's position without resetting an associated axis.

As of matplotlib v. 1.0.0, if a spine has an associated axis, then
spine.set_position() calls axis.cla(), which resets locators, formatters,
etc.  We temporarily replace that call with axis.reset_ticks(), which is
sufficient for our purposes.
"""
function _set_spine_position(spine, position)
    axis = spine[:axis]
    if axis != nothing
        cla = axis[:cla]
        axis[:cla] = axis[:reset_ticks]
    end
    spine[:set_position](position)
    if axis != nothing
        axis[:cla] = cla
    end
end

function despine!(ax; top=true, right=true, left=false, bottom=false, offset=nothing, trim=false)
    for (side, vis) in Dict("top" => top, "right" => right, "left" => left, "bottom" => bottom)
        # Toggle the spine objects
        is_visible = !vis #TODO, why use the inverse?
        ax[:spines][side][:set_visible](is_visible)
        if offset != nothing && is_visible
            _set_spine_position(ax[:spines][side], ("outward", offset))
        end
    end
    # Set the ticks appropriately
    if bottom
        ax[:xaxis][:tick_top]()
    end
    if top
        ax[:xaxis][:tick_bottom]()
    end
    if left
        ax[:yaxis][:tick_right]()
    end
    if right
        ax[:yaxis][:tick_left]()
    end

    if trim
        # clip off the parts of the spines that extend past major ticks
        xticks = ax[:get_xticks]()
        if length(xticks) > 0
            #TODO: this ports over the idioms of the seaborn code (though compress might be faster)
            # but I should see what is the idiomatic way of doing this in julia, should I use `filter`?
            #firsttick = np.compress(xticks >= min(ax[:get_xlim]()), xticks)[0]
            firsttick = xticks[xticks .>= minimum(ax[:get_xlim]())][1]
            #lasttick = np.compress(xticks <= max(ax[:get_xlim]()), xticks)[-1]
            lasttick = xticks[xticks .<= maximum(ax[:get_xlim]())][end]
            ax[:spines]["bottom"][:set_bounds](firsttick, lasttick)
            ax[:spines]["top"][:set_bounds](firsttick, lasttick)
            #newticks = xticks.compress(xticks <= lasttick)
            newticks = xticks[xticks .<= lasttick]
            #newticks = newticks.compress(newticks >= firsttick)
            newticks = newticks[newticks .>= firsttick]
            ax[:set_xticks](newticks)
        end
        yticks = ax[:get_yticks]()
        if length(yticks) > 0
            #firsttick = np.compress(yticks >= min(ax[:get_ylim]()), yticks)[0]
            firsttick = yticks[yticks .>= minimum(ax[:get_ylim]())][1]
            #lasttick = np.compress(yticks <= max(ax[:get_ylim]()), yticks)[-1]
            lasttick = yticks[yticks .<= maximum(ax[:get_ylim]())][end]
            ax[:spines]["left"][:set_bounds](firsttick, lasttick)
            ax[:spines]["right"][:set_bounds](firsttick, lasttick)
            #newticks = yticks.compress(yticks <= lasttick)
            newticks = yticks[yticks .<= lasttick]
            #newticks = newticks.compress(newticks >= firsttick)
            newticks = newticks[newticks .>= firsttick]
            ax[:set_yticks](newticks)
        end
    end
    return nothing
end

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

function render!(ax, bp::Boxplot)
    _style = gpar2mpl(bp.style)
    #TODO: I would rather not create a new figure, how do I return something composable
    vert = true
    colors = OdinSon.SEABORN_PALETTES[:deep]
    adict = ax[:boxplot](bp.data, vert=vert, patch_artist=true)
    #TODO: currently I only change the box on a per column basis. How to I deal with multiple
    # style options per boxplot, versus just a single.
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
        boxes=gpar(fill=NC"white", stroke=gray, stroke_width=2, zorder=0.9),
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
#TODO: this example the gray stroke of is too light
data = rand(100, 6)
bp = boxplot2(data, style=style1)
render(bp)

#TODO: this example the bottom spine is "missing" since there is only a single tick
data = rand(100)
bp = boxplot2(data)
render(bp)

#TODO: I really don't like th (1:6)'/2 bit, is this idomatic? Find out best way.
data = rand(Normal(0, 1), 20, 6) .+ (1:6)'/2
render(boxplot2(data))

# Experiments. Making some styles that recreate R styles
# Base
style_base = gpar(
    boxes=gpar(fill=NC"white", stroke=NC"black", stroke_width=1.5),
    whiskers=gpar(stroke=NC"black", linestyle="--"),
    fences=gpar(stroke=NC"black"))
render(boxplot2(data, style=style_base))
