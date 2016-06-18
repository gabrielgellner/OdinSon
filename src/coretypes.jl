import PyCall: PyObject

type Point
    x::Float64
    y::Float64
end
Base.zero(::Point) = Point(0.0, 0.0)

function Base.convert(::Type{Point}, t::Union{Tuple, AbstractArray})
    if length(t) != 2
        throw(ArgumentError("Only length 2 objects can be converted to Point"))
    end
    Point(t[1], t[2])
end
PyObject(t::Point) = PyObject((t.x, t.y))

function Base.convert{T <: Real}(::Type{Array{Point}}, a::Array{T, 2})
    (na, ma) = size(a)
    #TODO: need to think about a 2x2 array, since it is ambigous, currently I assume
    # column major
    if na == 2
        squeeze(mapslices(x->Point(x), a, 1), 1)
    elseif ma == 2
        squeeze(mapslices(x->Point(x), a, 2), 2)
    else
        throw(DimensionError())
    end
end

##TODO: think about the best name for this ...
abstract Grob
