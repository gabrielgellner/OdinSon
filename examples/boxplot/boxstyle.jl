include("categorical.jl")

#=
# gpar functionality
=#
gray = NC"gray"
style1 = gpar(
    boxes=gpar(stroke=gray, stroke_width=2, zorder=0.9),
    whiskers=gpar(stroke=gray, stroke_width=2, stroke_dash="-"),
    fences=gpar(stroke=gray, stroke_width=2),
    medians=gpar(stroke=gray, stroke_width=2),
    outliers=gpar(marker_fill=gray, marker="d", marker_stroke=gray, marker_size=5))

style2 = gpar(
    boxes=gpar(zorder=0.9, stroke=gray, stroke_width=2),
    whiskers=gpar(stroke=NC"red", stroke_width=5, stroke_dash="-"),
    outliers=gpar(marker_fill=gray, marker="d", marker_stroke=gray, marker_size=5))

# how do I do updates/mergers for these kinds of tree structures
merge(style1, style2) # so merge just works

#=
# nextval checks
=#
mpl1 = gpar2mpl(style1)
nextval(mpl1[:boxes][:edgecolor], 10)
[(k, v) for (k, v) in mpl1[:boxes]]
[(k, nextval(v, 1)) for (k, v) in mpl1[:boxes]]
process_style(mpl1[:boxes], 1)

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
render(boxplot2(data, style=gpar(boxes=gpar(fill=[NC"red", NC"blue"]))))

# Experiments. Making some styles that recreate R styles
# Base
style_base = gpar(
    boxes=gpar(fill=NC"white", stroke=NC"black", stroke_width=1.0),
    medians=gpar(stroke=NC"black", stroke_width=1.5),
    whiskers=gpar(stroke=NC"black", stroke_dash="--", dashes=(5, 1.5)), #TODO: need to process the dash together under stroke_dash
    fences=gpar(stroke=NC"black"),
    outliers=gpar(marker="o", marker_fill="none", marker_stroke=NC"black", marker_stroke_width=1))
render(boxplot2(data, style=style_base))
