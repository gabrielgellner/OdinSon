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
