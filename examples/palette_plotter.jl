using OdinSon
import PyPlot: subplots, matplotlib
using PyCall
@pyimport matplotlib as mpl
@pyimport copy as pycopy

# Utilities
# A simple function from seaborn that displays color palettes
function palplot(pal, psize=1)
    # set the grids to be like the seaborn default: "darkgrid" which gives nice white gridlines
    old_style = pycopy.copy(matplotlib["rcParams"])
    style_kw = Dict(
    "axes.facecolor" => "#EAEAF2",
    "axes.edgecolor" => NC"white",
    "axes.linewidth" => 0,
    "grid.color" => NC"white",
    "axes.grid" => true,
    # hide the ticks
    "xtick.major.size" => 0,
    "ytick.major.size" => 0,
    "xtick.minor.size" => 0,
    "ytick.minor.size" => 0
    )
    matplotlib["rcParams"][:update](style_kw)

    n = length(pal)
    (f, ax) = subplots(1, 1, figsize=(n*psize, psize))
    ax[:imshow](
        reshape(1:n, 1, n),
        cmap=mpl.colors[:ListedColormap](pal),
        interpolation="nearest",
        aspect="auto"
    )
    ax[:set_xticks]((1:n) - 0.5)
    ax[:set_yticks]([-0.5, 0.5])
    ax[:set_xticklabels]([])
    ax[:set_yticklabels]([])

    # restore the original plot settings
    matplotlib["rcParams"][:update](old_style)

    return nothing
end

palplot(OdinSon.SEABORN_PALETTES[:deep])
plot([1, 2, 3])
