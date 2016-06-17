# Containers

## Root Element
In matplotlib we have the container structure Figure -> Axes, where you can draw on the
Figure, or the Axes (which can be more than one). I think there can be only one Figure, that
is, it is the root of all other graphics.

So we have the following names for the root object:

* SVG: svg
* Matplotlib/PlotlyJS: Figure
* Mathematica: Graphics
* Vega.js: scene (I think, it seems largely implicit)

I am tempted to use `Canvas` as it feels the most general (though `Graphics` also seems
decent, I just don't love the plural nature of it. I think it is worth distinguishing
the root versus having a Graphics contain other Graphics, but I maybe the later is better).

## Axes
Now the real key is the container that has coordinate information (or data co-ordinates,
versus "device" co-ordinates of the root item).

Names from other packages

* SVG: no builtin, the viewport attribute can make different linear scales I think
* Matplotlib: Axes
* Mathematica: I am not sure how it works, as I think each nested Graphics will have
relative coordinates and alignment
* Vega.js: axes + scales (I think they interact)

So axes seems pretty common. For some reason I don't love the name. I think of the axes as
being the a synonym for the "spines" or "scales", the visual representation of the
co-ordinates not the container.
