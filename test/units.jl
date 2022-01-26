using Distributions
using Unitful
using Unitful: mV
using Test

MilliVoltage = Quantity{Float64, dimension(mV), typeof(mV)}

# Two testsets manually written out, to show API usage & behaviour.
# One with implicit units, and one with explicit units.

@testset "Exponential" begin
    d = Exponential(8.0 * mV)
    @test unit(d) == mV
    @test eltype(d) == MilliVoltage
    @test partype(d) == MilliVoltage
    @test extrema(d) == (0mV, Inf*mV)
    @test islowerbounded(d)
    @test !isupperbounded(d)
    @test insupport(d, 3mV)
    @test rate(d) == 1/8mV
    @test mean(d) == 8mV
    @test median(d) ≈ 5.54517744 * mV
    @test mode(d) == 0mV
    @test var(d) == 64mV^2
    @test std(d) == 8mV
    @test kurtosis(d) == 6mV
    @test entropy(d) ≈ 3.07944154
    @test kldivergence(d, Exponential(7mV)) ≈ 0.0085313926
    @test_throws MethodError kldivergence(d, Exponential(7mV^2))
    @test pdf(d, 1mV)  ≈ 0.110312112 / mV
    @test cdf(d, 1mV)  ≈ 0.117503097
    @test ccdf(d, 1mV) ≈ 0.8824969
    @test logpdf(d, 1mV) ≈ -2.20444154
    @test logcdf(d, 1mV) ≈ -2.14129058
    @test logccdf(d, 1mV) ≈ -0.125
    @test quantile(d, 0.6) ≈ 7.33032585 * mV
    @test cquantile(d, 0.4) ≈ 7.33032585 * mV
    @test invlogcdf(d, -1) ≈ 3.66940116 * mV
    @test invlogccdf(d, -1) ≈ 8 * mV
    @test gradlogpdf(d, 1mV) == -0.125/mV
    @test gradlogpdf(d, -1mV) == 0/mV
    @test mgf(d, 1/mV) ≈ -0.142857143
    @test cf(d, 1/mV) ≈ 0.015384615 + 0.123076923im
    @test typeof(rand(d)) == MilliVoltage
    @test typeof(rand(d, (3,3))) == Matrix{MilliVoltage}
    @test fit(Exponential, [3,2,1]mV) == Exponential(2mV)
    @test fit(Exponential, [3,2,1]mV, float([1,1,2])) == Exponential(1.75mV)
end # @testset "Exponential"

@testset "LogNormal" begin
    d = LogNormal(3.0, 2.0, mV)
    @test unit(d) == mV
    @test eltype(d) == MilliVoltage
    @test partype(d) == Float64
    @test extrema(d) == (0mV, Inf*mV)
    @test islowerbounded(d)
    @test !isupperbounded(d)
    @test insupport(d, 3mV)
    @test meanlogx(d) == 3
    @test varlogx(d) == 4
    @test stdlogx(d) == 2
    @test mean(d) ≈ 148.413159 * mV
    @test median(d) ≈ 20.0855369 * mV
    @test mode(d) ≈ 0.367879441 * mV
    @test var(d) ≈ 1.18057782e6 * mV * mV
    @test std(d) ≈ 1086.54398 * mV
    @test kurtosis(d) ≈ 9.22055698e6 * mV
    @test entropy(d) ≈ 5.11208571
    @test pdf(d, 1mV)  ≈ 0.0647587978 / mV
    @test pdf(d, -1mV) == 0 / mV
    @test cdf(d, 1mV)  ≈ 0.0668072013
    @test ccdf(d, 1mV) ≈ 0.933192799
    @test logpdf(d, 1mV) ≈ -2.73708571
    @test logcdf(d, 1mV) ≈ -2.7059444
    @test logccdf(d, 1mV) ≈ -0.0691434556
    @test quantile(d, 0.6) ≈ 33.3378773 * mV
    @test cquantile(d, 0.4) ≈ 33.3378773 * mV
    @test invlogcdf(d, -1) ≈ 10.2271922 * mV
    @test invlogccdf(d, -1) ≈ 39.4466816 * mV
    @test gradlogpdf(d, 1mV) == -0.25/mV
    @test gradlogpdf(d, -1mV) == 0/mV
    @test typeof(rand(d)) == MilliVoltage
    @test typeof(rand(d, (3,3))) == Matrix{MilliVoltage}
    @test fit(LogNormal, Float32.([3,2,1])mV) == LogNormal(0.59725314f0, 0.55554837f0, mV)
end # @testset "LogNormal"
