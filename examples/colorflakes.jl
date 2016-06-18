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
using Distributions
using OdinSon
using PyPlot

function colorflake()
    clr1 = RGB(rand(3)...)
    clr2 = RGB(rand(3)...)
    thick = rand(Uniform(2, 7)) # need to get this better, MM linewidth is based on size of figure
    tm = 1 # this seems needless in the current code

    a = rand(Uniform(0, 1.5))
    b = rand(3:15)
    c = rand(Uniform(0, 1.5))
    # this creates a closure over the parameters, might not be the best way
    # this is also vectorized since sin/cos are, can't wait for f.() syntax!
    x1(t) = sin(0.5*t) - a*sin(b*t).*cos(t) - 0.1*c*sin(10*b*t)
    y1(t) = cos(0.5*t) - a*sin(b*t).*sin(t) - 0.1*c*cos(10*b*t)

    t = linspace(0, tm*4.0*π, 5000)
    plot(x1(t), y1(t), c=clr1, linewidth=thick)
    plot(x1(t), y1(t), c=clr2, linewidth=0.2*thick)
    gca()[:set_aspect]("equal")
    gca()[:set_axis_bgcolor](NC"black")
end

colorflake()
