import PyPlot: rc
# Set the default style for matplotlib to be less ugly
function _set_mpl_kws()
    set_palette(:deep) # set line color cycle
    rc("figure", facecolor=NC"white")
    rc("axes", axisbelow=true)
    rc("axes", labelcolor=NC"darkgray")
    rc("axes", facecolor=NC"white")
    rc("axes", edgecolor=NC"lightgray")
    rc("axes", linewidth=1)
    rc("axes", labelsize=11)
    rc("axes", titlesize=12)

    rc("xtick", direction="out")
    rc("ytick", direction="out")
    rc("xtick", color=NC"darkgray")
    rc("ytick", color=NC"darkgray")
    rc("xtick", labelsize=10)
    rc("ytick", labelsize=10)
    rc("xtick.major", width=1)
    rc("ytick.major", width=1)
    rc("xtick.minor", width=0.5)
    rc("ytick.minor", width=0.5)
    rc("xtick.major", pad=7)
    rc("ytick.major", pad=7)
    #rc("lines.solid", capstyle="round")
    rc("lines", linewidth=1.75)
    rc("lines", markersize=7)
    rc("lines", markeredgewidth=0)
    rc("patch", linewidth=0.3)
    rc("font", family=["sans-serif"])
    rc("font", size=12)
    rc("text", color=NC"darkgray")
end
    # I want nice defaults for general plots which I will just lift from seaborn
    #
    # "figure.figsize": np.array([8, 5.5]),
    #
    # "legend.frameon": False,
    # "legend.numpoints": 1,
    # "legend.scatterpoints": 1,
    # "legend.fontsize": 10,
    #
    # "image.cmap": "Greys",
    #
    # "grid.linestyle": "-",
    # "grid.linewidth": 1,
    # "grid.color": light_gray
    #
    # "font.sans-serif": ["Arial", "Liberation Sans", "Bitstream Vera Sans", "sans-serif"]
