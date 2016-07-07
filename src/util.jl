import PyPlot: rc, matplotlib

# Set the default style for matplotlib to be less ugly
function _set_mpl_kws()
    # these names are defined in seaborn. I should somehow add them to the
    # color defs
    dark_grey = HC"#262626"
    light_grey = HC"#CCCCCC"
    set_palette(:deep) # set line color cycle
    style_dict = Dict(
        "figure.facecolor" => NC"white",
        "axes.axisbelow" => true,
        "axes.labelcolor" => dark_grey,
        "axes.facecolor" => NC"white",
        "axes.edgecolor" => dark_grey,
        "axes.linewidth" => 1,

        "xtick.direction" => "out",
        "ytick.direction" => "out",
        "xtick.color" => dark_grey,
        "ytick.color" => dark_grey,
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
        "text.color" => dark_grey,

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
