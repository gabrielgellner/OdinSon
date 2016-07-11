using OdinSon
using Distributions

# API ideas
function gpar(;kwargs...)
    Dict{Symbol, Any}(kwargs)
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
            firsttick = xticks[xticks .>= minimum(ax[:get_xlim]())][1]
            lasttick = xticks[xticks .<= maximum(ax[:get_xlim]())][end]
            ax[:spines]["bottom"][:set_bounds](firsttick, lasttick)
            ax[:spines]["top"][:set_bounds](firsttick, lasttick)
            newticks = xticks[xticks .<= lasttick]
            newticks = newticks[newticks .>= firsttick]
            ax[:set_xticks](newticks)
        end
        yticks = ax[:get_yticks]()
        if length(yticks) > 0
            firsttick = yticks[yticks .>= minimum(ax[:get_ylim]())][1]
            lasttick = yticks[yticks .<= maximum(ax[:get_ylim]())][end]
            ax[:spines]["left"][:set_bounds](firsttick, lasttick)
            ax[:spines]["right"][:set_bounds](firsttick, lasttick)
            newticks = yticks[yticks .<= lasttick]
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
    #TODO: think of a better name for _style
    _style = gpar(
        boxes=gpar(fill=colors, stroke=gray, stroke_width=2, zorder=0.9),
        whiskers=gpar(stroke=gray, stroke_width=2, stroke_dash=:none),
        fences=gpar(stroke=gray, stroke_width=2),
        medians=gpar(stroke=gray, stroke_width=2),
        outliers=gpar(marker_fill=gray, marker="d", marker_stroke=gray, marker_size=5)
    )
    merge!(_style, style)
    return Boxplot(data, _style)
end

boxplot2(data; style=Dict{Symbol, Any}()) = AxesView([Boxplot(data, style=style)], Dict{Symbol, Any}())
