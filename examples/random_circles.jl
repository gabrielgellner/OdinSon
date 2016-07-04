using OdinSon
using Distributions

# Graphics[Table[Circle[RandomReal[10, 2]], {100}]]
f1 = Canvas([Circle(rand(Uniform(0, 10), 2), 1, style=Style(fill=nothing)) for i = 1:100])
render(f1) # the render in the Mathematica notebook is implicit
f2 =Canvas(mapslices(p->Circle(p, 1, style=Style(fill=nothing)), rand(Uniform(0, 10), 100, 2), 2))
render(f2)
# So very verbose in comparison. Thow if instead we have like Mathematica implicit defaults
# which is very close, but I don't like the defaults as they don't feel natural to me,
# save for maybe having the style not fill by default
#=
```
Graphics[Table[Circle[RandomReal[10, 2]], {100}]]
Canvas([Circle(rand(Uniform(0, 10), 2)) for i = 1:100])
```
=#
