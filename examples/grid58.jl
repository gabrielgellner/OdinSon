# Recreate:
# ```R
# angle <- seq(0, 2*pi, length=100)[-11]
# grid.polygon(x=0.25 + 0.15*cos(angle), y=0.5 + 0.3*sin(angle),
#              id=rep(1:2, c(7, 3)), gp=gpar(fill=c("grey", "white")))
# angle[4] <- NA
# grid.polygon(x=0.75 + 0.15*cos(angle), y=0.5 + 0.3*sin(angle),
#              id=rep(1:2, c(7, 3)), gp=gpar(fill=c("grey", "white")))
# ```
# Again this has a lot of behavior I don't like in R, implicit recyclign of the fill in the
# second example. Using id to slice the points. The magical use of NA, to make three
# polygons. And the vectorization of the primatives. But I want to be able to make the same
# kind of figure
using OdinSon
using PyPlot

angle = linspace(0, 2*pi, 11)[1:(end - 1)]
#TODO: I should support giving two arrays instead of having to hcat them
points1 = hcat(0.25 + 0.15*cos(angle), 0.5 + 0.3*sin(angle))
p11 = Polygon(points1[1:(end - 3), :], style=Style(fill=NC"gray"))
p12 = Polygon(points1[(end - 2):end, :], style=Style(fill=NC"white"))
points2 = hcat(0.75 + 0.15*cos(angle), 0.5 + 0.3*sin(angle))
p21 = Polygon(points2[1:3, :], style=Style(fill=NC"gray"))
p22 = Polygon(points2[5:7, :], style=Style(fill=NC"gray"))
p23 = Polygon(points2[8:end, :], style=Style(fill=NC"white"))

render(Canvas([p11, p12, p21, p22, p23]))
#TODO: let this be set in the Canvas
gca()[:set_aspect](0.5)
