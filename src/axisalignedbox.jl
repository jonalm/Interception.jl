import GeometryTypes: vertices, faces, area

export AxisAlignedBox, vertices, faces, facenormals, inside

struct AxisAlignedBox{T}
    min::Point3{T}
    max::Point3{T}
end

function vertices(aab::AxisAlignedBox{T}) where {T}
    a, b = aab.min, aab.max
    Point3{T}[a, (b[1], a[2], a[3]), (a[1], b[2], a[3]), (a[1], a[2], b[3]),
                 (a[1], b[2], b[3]), (b[1], a[2], b[3]), (b[1], b[2], a[3]), b]
end

function faces(::AxisAlignedBox; indextype::Type=ZeroIndex{Cuint})
    Face{4, indextype}[(1,3,7,2), (1,2,6,4), (1,4,5,3),
                       (8,6,2,7), (8,7,3,5), (8,5,4,6)]
end

facenormals(::AxisAlignedBox{T}) where {T} = Point3{T}[(0,0,-1), (0,-1,0), (-1,0,0), (1,0,0), (0,1,0), (0,0,1)]
inside(p::Point3{T}, aab::AxisAlignedBox{T}) where{T} =  all(aab.min .< p .< aab.max)
