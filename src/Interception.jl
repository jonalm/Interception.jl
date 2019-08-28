module Interception

using LinearAlgebra
using GeometryTypes: Point3, Face, ZeroIndex

export
    LineSegment, TriangleCell, RectangleCell,
    center, facearea, facenormal, perp

const LineSegment{T}   = NTuple{2, Point3{T}}
const TriangleCell{T}  = NTuple{3, Point3{T}}
const RectangleCell{T} = NTuple{4, Point3{T}}

@inline center(t::TriangleCell{T})  where {T} = (t[1] + t[2] + t[3]) / T(3)
@inline center(t::RectangleCell{T}) where {T} = (t[1] + t[2] + t[3] + t[4]) / T(4)

@inline facearea(t::TriangleCell{T})  where {T} = abs(perp(t)) / T(2)
@inline facearea(t::RectangleCell{T}) where {T} = abs(perp(t))

@inline function facenormal(t::T) where {T <: Union{TriangleCell, RectangleCell}}
    normalize(perp(t))
end

@inline function perp(t::T) where {T <: Union{TriangleCell, RectangleCell}}
    cross(t[2]-t[1], t[3]-t[1])
end

include("axisalignedbox.jl")
include("intercept.jl")

end # module
