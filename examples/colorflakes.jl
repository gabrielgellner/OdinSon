# ```math
# x1[a_, b_, c_, t_] :=  Sin[.5 t] - a Sin[b t]*Cos[t] - .1 c Sin[10 b t];
# y1[a_, b_, c_, t_] :=  Cos[.5 t] - a Sin[b t]*Sin[t] - .1 c Cos[10 b t];
#
# GraphicsGrid[Partition[ParallelTable[
#    With[{
#      a = RandomReal[{-1.5, 1.5}],
#      b = RandomInteger[{3, 15}],
#      c = RandomReal[{0, 1.5}],
#      clr1 = Black,
#      clr2 = RGBColor @@ RandomReal[1, 3],
#      clr3 = RGBColor @@ RandomReal[1, 3],
#      thick = RandomReal[{.04, .5}],
#      tm = 1},
#     ParametricPlot[
#      Evaluate[{{x1[a, b, c, t], y1[a, b, c, t]}, {x1[a, b, c, t],
#         y1[a, b, c, t]}}], {t, 0, tm 4 \[Pi]},
#      PlotStyle -> {{clr2, Thickness[0.001` + 0.05` thick]}, {clr3,
#         Thickness[0.001` + 0.01` thick]}}, Axes -> False,
#      PlotPoints -> 200, PlotRange -> All, Background -> clr1]]
#    , {n, 32}], 4], ImageSize -> 600]
# ```
# Can I recreate the above code? I am not sure exactly what is needed for ParametricPlot
# So parameteric plot seems to generate lists of points that depend on a parameter
using Distributions
using OdinSon
using PyPlot
#
# So for example the example ParametricPlot[{Sin[u], Sin[2u]}, {u, 0, 2pi}], generates
# a series of {x, y} pairs given the relationship described, it shuld be the same as
# ListLinePlot[Table[{Sin[u], Sin[2u]}, {u, 0, 2pi, inc}]]
# the benefits just being that the sampling is done adaptivly
u = linspace(0, 2π, 100)
plot(sin(u), sin(2u))
# good that is just what we wanted

# Now the next question is how are nested pairs treated that is if we have
# {{x1, y1}, {x2, y2}, {x3, y3}} instead of just {x, y}, what is done. My guess is that
# you will get the number of pairs as individual plots. That is you could do this as three
# plots ParametricPlot[{x1, y1}], ParametricPlot[{x2, y2}], ParametricPlot[{x3, y3}]
#
# the example
# ParametricPlot[
#   {{2 Cos[t], 2 Sin[t]}, {2 Cos[t], Sin[t]}, {Cos[t], 2 Sin[t]}, {Cos[t], Sin[t]}},
#   {t, 0, 2 Pi},
#   PlotLegends -> "Expressions"]
t = linspace(0, 2π, 100)
plot(2*cos(t), 2*sin(t))
plot(2*cos(t), sin(t))
plot(cos(t), 2*sin(t))
plot(cos(t), sin(t))
# perfect

RGB(rand(3)...)

# So we are ready
function colorflake()
    clr1 = NC"black"
    clr2 = RGB(rand(3)...)
    clr3 = RGB(rand(3)...)
    thick = rand(Uniform(2, 7)) # need to get this better, look into the units of mathematica + matplotlib

    a = rand(Uniform(0, 1.5))
    b = rand(3:15)
    c = rand(Uniform(0, 1.5))
    # this creates a closure over the parameters, might not be the best way
    # this is also vectorized since sin/cos are, can't wait for f.() syntax!
    x1(t) = sin(0.5*t) - a*sin(b*t).*cos(t) - 0.1*c*sin(10*b*t)
    y1(t) = cos(0.5*t) - a*sin(b*t).*sin(t) - 0.1*c*cos(10*b*t)

    t = linspace(0, 4.0*π, 3000)
    plot(x1(t), y1(t), c=clr2, linewidth=thick)
    plot(x1(t), y1(t), c=clr3, linewidth=0.1*thick)
    gca()[:set_aspect]("equal")
    gca()[:set_axis_bgcolor](clr1)
end

colorflake()
