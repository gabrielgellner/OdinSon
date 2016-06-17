# The R Graphics book has a nice example of styling circles with the following code
#```R
# > levels <- round(seq(90, 10, length=25))
# > greys <- paste("grey", c(levels, rev(levels)), sep="")
# > grid.circle(x=seq(0.1, 0.9, length=100),
#               y=0.5 + 0.4*sin(seq(0, 2*pi, length=100)),
#               r=abs(0.1*cos(seq(0, 2*pi, length=100))),
#               gp=gpar(col=greys))
#```
#
# I don't love the vectorization of the circle creation, but I should be able to do
# this effect
using OdinSon
using Colors

# not really the same as getting the grey color names like above, but I should be able to
# tweak this to get a nice version
##TODO: so so ugly, figure out how to cycle values in a nice way
# The key for the R code is that is ramps up for 25 then reverse down for 25 and repeats
ncirc = 100
baseseq = linspace(NC"white", NC"black", 25)
greys = cycle(vcat(baseseq, reverse(baseseq))) # this implicitly gets recycled 4 times in R code
xs = linspace(0.1, 0.9, ncirc)
Θ = linspace(0, 2*π, ncirc)
ys = 0.5 + 0.4*sin(Θ)
rs = abs(0.1*cos(Θ))

circles = Array{Circle}(ncirc)
for (i, col) in enumerate(take(greys, ncirc)) # I do this to get the repeats working, think of cleaner way
    circles[i] = Circle((xs[i], ys[i]), rs[i], style=Style(stroke=col, fill=nothing))
end
render(Canvas(circles))
