# Styling
Currently I have a single Style type. But I likely will need to have more than one type to
deal with Canvas, and Viewport types.

## Axes/Ticks/Spines
Since I am calling the main co-ordinates a Viewport I am free to call the style option that
controls the visual representation of the co-ordinates as axes. Though I need to look at
what other API's use.

### Mathematica
* Frame, FrameStyle, FrameLabel, FrameTicks, FrameTicksStyle
* Axes, AxesStyle, AxesLabel, Ticks, TicksStyle
* GridLines, GridLinesStyle

### Grid
* grid.xaxis, grid.yaxis, xaxisGrob, yaxisGrob, (can change things with grob.edit, which a
    grob! like func would be sweet)

## Axes Type
```julia
type Spine
    position # this needs to deal with inward/outward styles as well as special "center", or the different coordinate locations
    bounds
    visible::Bool # do I want this, is there a more consistent way to have this on/off
    style::Style
end

type Spines
    top::Spine
    bottom::Spine
    left::Spine
    right::Spine
end

type AxesTicks
end

type Axes
    spines::Spines
    ticks::AxesTicks
    labels
end
```

## Some Trials
```julia
# This is pretty verbose
AxesView([g1, g2], axes=Axes(spines=Spines(left=Spine(), bottom=Spine())))
```

## Test of the general design
If I wanted to make a basic plotting function, how would I need to specify the many styling
options
```julia
plot(x, y, linestyle=(), axes=Axes())
```

## Boxplot Style parameters in other packages
# Mathematica
- ChartStyle
    - Outliers: anyting that seems to have a head of "Outliers" can be interpreted as a styling for this

# Matplotlib
- outliers
    - marker, markeredgecolor, markerfacecolor, markersize

# Base R
- pars
    - outpch, outlty, outlwd, outcol, outbg

# Plot.js
- marker_z, markeralpha, markercolor, markershape, markersize, markerstrokealpha, markerstrokecolor, markerstrokewidth

# Conclusions
There are lots of versions of how to do this. What I want is a consistent taxonomy of how to specify these kinds
of styling information for any object: (Try to be as SVG-like as makes sense)

# Line-like (Line, Poly, Path)
stroke, stroke_width, stroke_linecap,
stroke_dash (can be named ("-"/"solid", "--"/"dashed", "-."/"dash_dot", ":"/"dotted" etc), or an array of dash patterns, or nothing (for solid stroke))
fill (? clearly closed versions make sense, need to see what SVG does for open versions)

# Poly-like
stroke, stroke_width
fill
# Marker (should be like line/poly, but with marker_ in front)
marker (the marker name, or object?)
marker_stroke, marker_stroke_width
marker_fill
marker_size (uniform scaling), marker_width, marker_height
