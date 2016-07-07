using OdinSon
import PyPlot: rc

# Utilities
# A simple function from seaborn that displays color palettes
function palplot(pal, psize=1)
    n = length(pal)
    (f, ax) = plt[:subplots](1, 1, figsize=(n*psize, psize))
    ax[:imshow](reshape(1:n, 1, n), cmap=mpl.colors[:ListedColormap](pal), interpolation="nearest", aspect="auto")
    ax[:set_xticks](1:n - 0.5)
    ax[:set_yticks]([-0.5, 0.5])
    ax[:set_xticklabels]([])
    ax[:set_yticklabels]([])
    # set the grids to be like the seaborn default: "dark" which gives nice white gridlines
    rc("axes", facecolor="#EAEAF2")
    rc("axes", edgecolor="white")
    rc("axes", linewidth=0)
    rc("axes", grid=false)
    rc("axes")
    rc("grid", color="white")
end

palplot(SEABORN_PALETTES[:deep])
