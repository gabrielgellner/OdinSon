using OdinSon
using AffineTransforms
using Distributions
using PyPlot

# utility I need to think about for adding to the shapes.jl, in general how do I want to
# store points?
function arr2parr(a::AbstractArray)
    if size(a, 1) != 2
        throw(DimensionError("Array{Point} must be collection of 2 values"))
    end
    ps = []
    for i = 1:size(a, 2)
        push!(ps, Point(a[:, i]))
    end
    return ps
end

# extend the algebra of AffineTransform to be more permissive, tform{fwd, inv}
# does type checking
*(a::AffineTransform, v::AbstractArray) = tformfwd(a, v)
\(a::AffineTransform, x::AbstractArray) = tforminv(a, x)
#TODO: implement a real function like Mathematica's ReflectionMatrix
tformreflect = AffineTransform([-1.0 0.0; 0.0 1.0], [0.0, 0.0])

# wow , \theta vs 0 is very hard to see in this font
const rots = map(Θ -> tformrotate(Θ), 0:π/3:(2π - π/3))

function snowflake(pt)
    #TODO: this will be slow do to column major order, which I could easily switch
    mapslices(x->rots[1]*x, pts, 2)

    # to decode: Join[Map[ReflectionMatrix[{1, 0}].# &, #], #] &
    endline = vcat([0.0 0.0], pts)
    startline = mapslices(x->tformreflect*x, endline, 2)
    arg2 = vcat(startline, endline)

    # this recreates the Outer(#1 . #2&, rots, arg2, 1) call in mathematica
    out = []
    for i = 1:length(rots)
        poly = zeros(2, size(arg2, 1))
        for j = 1:size(arg2, 1)
            poly[:, j] = rots[i] * arg2[j, :]'
        end
        push!(out, poly)
    end
    #TODO: need to be able to turn off stroke, not just make it white
    ps = map(p->Polygon(arr2parr(p), style=Style(stroke=NC"white", fill=NC"white", fill_opacity=0.5)), out)

    return Canvas(ps, style=Style(fill=NC"black"))
end

pts = rand(Uniform(-1, 1), (rand(3:9), 2))
flake = snowflake(pts)
render(flake)
