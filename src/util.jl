import PyPlot: rc, matplotlib

# Set the default style for matplotlib to be less ugly
function _set_mpl_kws()
    # these names are defined in seaborn. I should somehow add them to the
    # color defs
    dark_gray = HC"#262626"
    light_gray = HC"#CCCCCC"
    set_palette(:deep) # set line color cycle
    style_dict = Dict(
        "figure.facecolor" => NC"white",
        "axes.axisbelow" => true,
        "axes.labelcolor" => dark_gray,
        "axes.facecolor" => NC"white",
        "axes.edgecolor" => dark_gray,
        "axes.linewidth" => 1,

        "xtick.direction" => "out",
        "ytick.direction" => "out",
        # don't have ticks on top or left by default
        #TODO: this can not be done in rcParams, hence seaborns `despine function`
        "xtick.color" => dark_gray,
        "ytick.color" => dark_gray,
        "xtick.major.width" => 1,
        "ytick.major.width" => 1,
        "xtick.minor.width" => 0.5,
        "ytick.minor.width" => 0.5,
        "xtick.major.pad" => 7,
        "ytick.major.pad" => 7,

        "grid.linestyle" => "-",

        "lines.solid_capstyle" => "round",
        "lines.linewidth" => 1.75,
        "lines.markersize" => 7,
        "lines.markeredgewidth" => 0,
        "patch.linewidth" => 0.3,

        "font.family" => ["sans-serif"],
        "font.sans-serif" => ["Arial", "Liberation Sans", "Bitstream Vera Sans", "sans-serif"],
        "text.color" => dark_gray,

        "image.cmap" => "Greys",

        "legend.frameon" => false,
        "legend.numpoints" => 1,
        "legend.scatterpoints" => 1,

        # "Context" settings
        "font.size" => 12,
        "axes.labelsize" => 11,
        "axes.titlesize" => 12,
        "xtick.labelsize" => 10,
        "ytick.labelsize" => 10,
        "legend.fontsize" => 10,
        "grid.linewidth" => 1
    )
    matplotlib["rcParams"][:update](style_dict)
    return nothing
end
    # I want nice defaults for general plots which I will just lift from seaborn
    #
    # "figure.figsize": np.array([8, 5.5]),

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
