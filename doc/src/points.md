# Points
A fundamental necessity for specifying graphics is to describe the range of points
(x, y, or x, y, z pairs). One method is to give an array of `Point` objects
```jl
[Point(x1, y1), Point(x2, y2), ..., Point(xn, yn)]
```
methods that accept `Array{Point}` will also accept the more concise notation
```jl
Array[[x1, y1], [x2, y2], ..., [xn, yn]]
```
Though this description is precise/explicit it is not always the most convenient, or
natural, way to generate such points in Julia. As such two other forms are also accepted.

1. Either an 2 by M, or an N by 2 `Matrix`.
2. Separate vectors of x and y values. It is required that they are the same length.
