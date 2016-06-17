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
* Compose: Context
* Grid: viewPort (the default one made that covers the entire device)

I am tempted to use `Canvas` as it feels the most general (though `Graphics` also seems
decent, I just don't love the plural nature of it. I think it is worth distinguishing
the root versus having a Graphics contain other Graphics, but I maybe the later is better).

## Axes
Now the real key is the container that has coordinate information (or data co-ordinates,
versus "device" co-ordinates of the root item).

Names from other packages

* SVG: no built in, the viewBox attribute can make different linear scales I think
* Matplotlib: Axes
* Mathematica: I am not sure how it works, as I think each nested Graphics will have
relative coordinates and alignment
* Vega.js: axes + scales (I think they interact)
* Compose: Form
* Grid: viewport, plotViewport, dataViewport (where the later two are styled versions of
    the first. I like this way of doing it.)

It seems to me that Matplotlibs Axes can act like Grid's viewports, that is they can
overlap. I am not sure how the nested coordinates are handled. I imagine it would be like
Grid and depend on if the Axes is added to another Axes or the top level Figure.

So axes seems pretty common. For some reason I don't love the name. I think of the axes as
being the a synonym for the "spines" or "scales", the visual representation of the
co-ordinates not the container. This seems to be the view taken by Grid, which uses axes
to mean the spines as well. Maybe I use ViewPort, it has a nice feel to it. And even though
it might be a little confusing with the concept from SVG, as there is not conflicting
attribute name in the SVG spec I think I am fine.

## Conclusions
I will have the hierarchy root(Canvas) -many-> leaf(ViewPort) -many-> leaf(ViewPort). If no
ViewPort is given in the Canvas item list, then a default one will be created. I can then
have a Grid container that will do what Matplotlib does with a GridSpec, which will contain
a Grid of aligned ViewPorts.

## Styling

* SVG: style, and element parameters, CSS
* Matplotlib: rcParams, kwargs
* Mathematica: Directive, kwargs
* Compose: Parameters
* Grid: gpar (Graphical Parameters)
