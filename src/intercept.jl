
export intercepts

function intercepts(s::LineSegment{T}, cell::TriangleCell{T}, facenormal) where {T}
    dot(facenormal, s[1]-cell[1]) <= zero(T) && return false
    dot(facenormal, s[2]-cell[1]) >= zero(T) && return false
    BA = s[1] - s[2]
    dot(cross(cell[2]-cell[1], s[2]-cell[2]), BA) < zero(T) && return false
    dot(cross(cell[3]-cell[2], s[2]-cell[3]), BA) < zero(T) && return false
    dot(cross(cell[1]-cell[3], s[2]-cell[1]), BA) < zero(T) && return false
    return true
end

function intercepts(s::LineSegment{T}, cell::RectangleCell{T}, facenormal) where {T}
    dot(facenormal, s[1]-cell[1]) <= zero(T) && return false
    dot(facenormal, s[2]-cell[1]) >= zero(T) && return false
    BA = s[1] - s[2]
    dot(cross(cell[2]-cell[1], s[2]-cell[2]), BA) < zero(T) && return false
    dot(cross(cell[3]-cell[2], s[2]-cell[3]), BA) < zero(T) && return false
    dot(cross(cell[4]-cell[3], s[2]-cell[4]), BA) < zero(T) && return false
    dot(cross(cell[1]-cell[4], s[2]-cell[1]), BA) < zero(T) && return false
    return true
end

intercepts(s::LineSegment{T}, cell::S) where {T, S <: Union{TriangleCell{T}, RectangleCell{T}}} = intercepts(s, cell, facenormal(cell))

function intercepts(s::LineSegment{T}, aab::AxisAlignedBox{T}) where {T}
    (inside(s[1], aab) || inside(s[2], aab)) && return true
    ve, fa, no = vertices(aab), faces(aab), facenormals(aab)
    any(intercepts(s, ve[f], n) for (f,n) in zip(fa, no))
end
