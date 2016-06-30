function lineplot(x, y, style::Style)
    # I want nice defaults for general plots which I will just lift from seaborn
    #
    # "figure.facecolor": "white",
    # "figure.figsize": np.array([8, 5.5]),
    #
    # "axes.axisbelow": True,
    # "axes.labelcolor": dark_gray,
    # "axes.facecolor": "white",
    # "axes.edgecolor": light_gray,
    # "axes.linewidth": 1,
    # "axes.labelsize": 11,
    # "axes.titlesize": 12,
    #
    # "xtick.direction": "out",
    # "ytick.direction": "out",
    # "xtick.color": dark_gray,
    # "ytick.color": dark_gray,
    # "xtick.labelsize": 10,
    # "ytick.labelsize": 10,
    # "xtick.major.width": 1,
    # "ytick.major.width": 1,
    # "xtick.minor.width": 0.5,
    # "ytick.minor.width": 0.5,
    # "xtick.major.pad": 7,
    # "ytick.major.pad": 7
    #
    # "legend.frameon": False,
    # "legend.numpoints": 1,
    # "legend.scatterpoints": 1,
    # "legend.fontsize": 10,
    #
    # "lines.solid_capstyle": "round",
    # "lines.linewidth": 1.75,
    # "lines.markersize": 7,
    # "lines.markeredgewidth": 0,
    # "patch.linewidth": 0.3,
    #
    # "image.cmap": "Greys",
    #
    # "grid.linestyle": "-",
    # "grid.linewidth": 1,
    # "grid.color": light_gray
    #
    # "font.family": ["sans-serif"],
    # "font.sans-serif": ["Arial", "Liberation Sans", "Bitstream Vera Sans", "sans-serif"],
    # "font.size": 12,
    # "text.color": dark_gray,
end

#lineplot(x, y, linestyle=())
