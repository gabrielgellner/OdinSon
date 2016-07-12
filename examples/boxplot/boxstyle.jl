include("categorical.jl")

#=
# gpar functionality
=#
gray = NC"gray"
core_style = gpar(
    boxes=gpar(fill=colors, stroke=gray, stroke_width=2, zorder=0.9),
    whiskers=gpar(stroke=gray, stroke_width=2, stroke_dash=:none),
    fences=gpar(stroke=gray, stroke_width=2),
    medians=gpar(stroke=gray, stroke_width=2),
    outliers=gpar(marker_fill=gray, marker="d", marker_stroke=gray, marker_size=5))

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

# regular merge doesn't deal with the nested structure
merge(core_style, style2)
gparmerge(core_style, style2)

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
render(boxplot2(data, style=gpar(boxes=gpar(fill=OdinSon.SEABORN_PALETTES[:deep]))))

# Experiments. Making some styles that recreate R styles
# Base
#TODO: need to make the boxes wider, need to clip the median line to the box
style_base = gpar(
    boxes=gpar(fill=NC"white", stroke=NC"black", stroke_width=1.0),
    medians=gpar(stroke=NC"black", stroke_width=2.5),
    whiskers=gpar(stroke=NC"black", stroke_dash=(4, 2.5), stroke_width=1.0),
    fences=gpar(stroke=NC"black", stroke_width=1.0),
    outliers=gpar(marker="o", marker_fill=:none, marker_stroke=NC"black", marker_stroke_width=0.8, marker_size=6))
render(boxplot2(data, style=style_base))

# ggplot2
style_ggplot = gpar(
    boxes=gpar(fill=NC"white", stroke=NC"black", stroke_width=1.0),
    medians=gpar(stroke=NC"black", stroke_width=1.5),
    whiskers=gpar(stroke=NC"black", stroke_width=1.2),
    fences=gpar(stroke=:none),
    outliers=gpar(marker="o", marker_fill=NC"black"))
bp = boxplot2(data, style=style_ggplot)
render(bp)

gparmerge(core_style, style_ggplot)

axes = gpar(
    bottom=gpar(
        ticks=gpar(stroke=NC"black", stroke_width=1.0, labels=:none, padding=3),
        stroke=NC"black",
        stroke_width=1.0,
        label=:none,
        padding=3,
        domain=(:all, :all) # not sure how to deal with the domain as they really need to come in pairs
    ),
    left=gpar(),
    top=gpar(),
    right=gpar(),
    grid=gpar()
)
# a little verbose for some basic stuff
gpar(bottom=gpar(label="Interaction Strength"), left=gpar(label="Stability"))
gpar(bottom=gpar(domain=(-10, 10)), left=gpar(domain=(-5, 3)))

type PlotAxes
    items::Array
    style::Dict
end

function Base.render(pa::PlotAxes)
    f = figure()
    ax = f[:add_suplot](111)
    ax[:set_xlim](pa.style[:bottom][:domain])
    ax[:set_ylim](pa.style[:left][:domain])
    for loc in [:bottom, :top, :left, :right]
        ax[:spines][loc][:set_color](pa.style[loc][:stroke])
    end
    if pa.style[:bottom][:ticks] != :none
        pass
    end
end
