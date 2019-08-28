using LinearAlgebra
using Random
using StatsBase
using Test
using Interception

import GeometryTypes: Point3

Random.seed!(1234)

segment_from_pluss_to_minuz_z(x, y, z) = LineSegment(((x, y, z), (x, y, -z)))
sample_x_y_positive_and_sum_less_than_one() = (x = rand(); y = rand()*(1-x); (x,y))
sample_x_y_positive_and_less_than_one() = (rand(),rand())
random_antipodal() = (a = Point3(rand(3)) - Point3(0.5); (a, -a))

##
@testset "test random intersection LineSegment vs TriangleCell" begin
	standard_2simplex =
		TriangleCell{Float64}(((0.0, 0.0, 1.0),
							   (1.0, 0.0, 0.0),
							   (0.0, 1.0, 0.0)))

	for _ in 1:100
	    x, y = sample_x_y_positive_and_sum_less_than_one()
		s1 = segment_from_pluss_to_minuz_z(x, y, 1.1)
		s2 = segment_from_pluss_to_minuz_z(x, y, -1.1)
	    @test intercepts(s1, standard_2simplex)
	    @test !intercepts(s2, standard_2simplex)
	end
end

@testset "test random intersection LineSegment vs RectangleCell" begin
	unit_xy_rectangle =
		RectangleCell{Float64}(((0.0, 0.0, 0.0),
								(1.0, 0.0, 0.0),
								(1.0, 1.0, 0.0),
								(0.0, 1.0, 0.0)))

	for _ in 1:100
	    x, y = sample_x_y_positive_and_less_than_one()
		s1 = segment_from_pluss_to_minuz_z(x, y, 0.1)
		s2 = segment_from_pluss_to_minuz_z(x, y, -0.1)
	    @test intercepts(s1, unit_xy_rectangle)
	    @test !intercepts(s2, unit_xy_rectangle)
	end
end

@testset "test antipodal endpoint Linesegment vs TriangleCell" begin
	for _ in 1:200
		z1, z2, z3 = 1+0im, exp(2π/3 * 1im),  exp(-2π/3 * 1im)

		t = TriangleCell(((real(z1), imag(z1), 0.0),
						  (real(z2), imag(z2), 0.0),
						  (real(z3), imag(z3), 0.0)))
		a, b = random_antipodal()
		s1 = LineSegment((a, b))
		s2 = LineSegment((b, a))
		@test xor(intercepts(s1, t), intercepts(s2, t))
	end
end

@testset "test antipodal endpoint Linesegment vs AxisAlignedBox both endpoints inside" begin
	box = AxisAlignedBox(Point3(-0.5), Point3(0.5))
	for _ in 1:200
		a = Point3(rand(3)) + Point3(0.55)
		b = - a
		s1 = LineSegment((a, b))
		s2 = LineSegment((b, a))
		@test intercepts(s1, box) && intercepts(s2, box)
	end
end

@testset "test antipodal endpoint Linesegment vs AxisAlignedBox both endpoints outside" begin
	box = AxisAlignedBox(Point3(-1.1), Point3(1.1))
	for _ in 1:200
		a, b = random_antipodal()
		s1 = LineSegment((a, b))
		s2 = LineSegment((b, a))
		@test intercepts(s1, box) && intercepts(s2, box)
	end
end

@testset "test Linesegment vs AxisAlignedBox one endpoint inside one outside" begin
	box = AxisAlignedBox(Point3(-0.5), Point3(0.5))
	for _ in 1:200
		a = Point3(rand(3)) + Point3(0.55)
		b = Point3(0.0)
		s1 = LineSegment((a, b))
		s2 = LineSegment((b, a))
		@test intercepts(s1, box) && intercepts(s2, box)
	end
end
