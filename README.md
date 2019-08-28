

The main purpose of this package is to provide a function  `intercepts(ls::LineSegment, obj::T)::Bool` which returns `true/false` depending on whether the line segment intercepts the object.

`LineSegment` is defined by a tuple of 2 vertices. All vertices are specified by the `Point3{T}` type defined in `GeometryTypes`. Note that `GeometryTypes` also defines a `LineSegment` type which differs from ours (tuple of points).

The object can be one of the following:

- `TriangleCell{T}` (a tuple of 3 vertices)
- `RectangleCell{T}` (a tuple of 4 vertices)
- `AxisAlignedBox{T}` (a struct holding the minimal and maximal corner vertices)
